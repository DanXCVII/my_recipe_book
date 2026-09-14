import 'package:drift/drift.dart';

import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../database.dart';
import 'drift_repository_context.dart';
import 'local_repository_contract.dart';

class ShoppingCartStore {
  ShoppingCartStore(this._context, this._recipeByName);

  final DriftRepositoryContext _context;
  final Future<Recipe?> Function(String name) _recipeByName;
  Map<String, ShoppingCartSource> _cart = {};

  Future<Map<Recipe, List<CheckableIngredient>>> getShoppingCart() async {
    final result = <Recipe, List<CheckableIngredient>>{};
    final sources = _cart.values.toList()
      ..sort((a, b) => a.position.compareTo(b.position));
    for (final source in sources) {
      Recipe? recipe;
      if (source.isSummary) {
        recipe = Recipe(name: shoppingSummaryName);
      } else {
        recipe =
            await _recipeByName(source.displayName) ??
            Recipe(name: source.displayName, notes: 'noLink');
      }
      result[recipe] = List<CheckableIngredient>.from(source.items);
    }
    return result;
  }

  Future<void> addMultipleIngredientsToCart(
    String recipeName,
    List<Ingredient> ingredients,
  ) async {
    for (final ingredient in ingredients) {
      _addCartIngredient(shoppingSummaryName, ingredient);
      if (recipeName != shoppingSummaryName) {
        _addCartIngredient(recipeName, ingredient);
      }
    }
    await _persistCartCache();
  }

  Future<void> addSingleIngredientToCart(
    String recipeName,
    Ingredient ingredient,
  ) async {
    _addCartIngredient(shoppingSummaryName, ingredient);
    if (recipeName != shoppingSummaryName) {
      _addCartIngredient(recipeName, ingredient);
    }
    await _persistCartCache();
  }

  void _addCartIngredient(String sourceName, Ingredient ingredient) {
    final source = _cart.putIfAbsent(
      sourceName,
      () => ShoppingCartSource(
        sourceName,
        sourceName,
        [],
        isSummary: sourceName == shoppingSummaryName,
        position: _cart.length,
      ),
    );
    final index = _matchingIngredientIndex(ingredient, source.items);
    if (index == null) {
      source.items.add(
        CheckableIngredient(
          ingredient.name,
          ingredient.amount,
          ingredient.unit,
          false,
        ),
      );
      return;
    }
    final old = source.items[index];
    final amount = old.amount != null && ingredient.amount != null
        ? old.amount! + ingredient.amount!
        : old.amount ?? ingredient.amount;
    source.items[index] = old.copyWith(amount: amount, checked: false);
  }

  Future<void> removeAndAddIngredient(
    String recipeName,
    Ingredient ingredient,
  ) async {
    await removeIngredientFromCart(recipeName, ingredient);
    await addSingleIngredientToCart(recipeName, ingredient);
  }

  Future<void> removeAndAddIngredients(
    String recipeName,
    List<Ingredient> ingredients,
  ) async {
    for (final ingredient in ingredients) {
      await removeAndAddIngredient(recipeName, ingredient);
    }
  }

  Future<void> removeIngredientsFromCart(
    String recipeName,
    List<Ingredient> ingredients,
  ) async {
    for (final ingredient in ingredients) {
      await removeIngredientFromCart(recipeName, ingredient);
    }
  }

  bool checkForRecipeIngredient(String recipeName, Ingredient ingredient) {
    final source = _cart[recipeName];
    if (source == null) return false;
    for (final item in source.items) {
      if (item.name != ingredient.name || item.unit != ingredient.unit)
        continue;
      if (item.amount == null && ingredient.amount == null) return true;
      if (item.amount != null &&
          ingredient.amount != null &&
          item.amount! >= ingredient.amount!)
        return true;
    }
    return false;
  }

  bool checkForRecipeIngredients(
    String recipeName,
    List<Ingredient> ingredients,
  ) => ingredients.every(
    (ingredient) => checkForRecipeIngredient(recipeName, ingredient),
  );

  Future<void> removeRecipeFromCart(String recipeName) async {
    final removed = _cart.remove(recipeName);
    if (removed == null) return;
    for (final item in removed.items) {
      _subtractFromSummary(item.getIngredient());
    }
    await _persistCartCache();
  }

  Future<void> removeIngredientFromCart(
    String recipeName,
    Ingredient ingredient,
  ) async {
    if (recipeName == shoppingSummaryName) {
      for (final source in _cart.values) {
        source.items.removeWhere(
          (item) =>
              item.name == ingredient.name && item.unit == ingredient.unit,
        );
      }
    } else {
      final source = _cart[recipeName];
      if (source == null) return;
      final index = _matchingIngredientIndex(ingredient, source.items);
      if (index == null) return;
      final removed = source.items.removeAt(index);
      _subtractFromSummary(removed.getIngredient());
      if (source.items.isEmpty) _cart.remove(recipeName);
    }
    await _persistCartCache();
  }

  void _subtractFromSummary(Ingredient ingredient) {
    final summary = _cart[shoppingSummaryName];
    if (summary == null) return;
    final index = _matchingIngredientIndex(ingredient, summary.items);
    if (index == null) return;
    final old = summary.items[index];
    if (old.amount != null &&
        ingredient.amount != null &&
        old.amount! - ingredient.amount! > 0) {
      summary.items[index] = old.copyWith(
        amount: old.amount! - ingredient.amount!,
      );
    } else {
      summary.items.removeAt(index);
    }
  }

  int? _matchingIngredientIndex(
    Ingredient ingredient,
    List<CheckableIngredient> ingredients,
  ) {
    final index = ingredients.indexWhere(
      (item) => item.name == ingredient.name && item.unit == ingredient.unit,
    );
    return index < 0 ? null : index;
  }

  Future<void> checkIngredient(
    String recipeName,
    CheckableIngredient ingredient,
  ) async {
    final source = _cart[recipeName];
    if (source == null) return;
    final index = _matchingIngredientIndex(
      ingredient.getIngredient(),
      source.items,
    );
    if (index == null) return;
    source.items[index] = ingredient;
    if (recipeName == shoppingSummaryName || _allMatchingChecked(ingredient)) {
      for (final cartSource in _cart.values) {
        final matching = _matchingIngredientIndex(
          ingredient.getIngredient(),
          cartSource.items,
        );
        if (matching != null) {
          cartSource.items[matching] = cartSource.items[matching].copyWith(
            checked: ingredient.checked,
          );
        }
      }
    }
    await _persistCartCache();
  }

  bool _allMatchingChecked(CheckableIngredient ingredient) {
    if (!ingredient.checked) return true;
    for (final source in _cart.values.where((source) => !source.isSummary)) {
      final index = _matchingIngredientIndex(
        ingredient.getIngredient(),
        source.items,
      );
      if (index != null && !source.items[index].checked) return false;
    }
    return true;
  }

  Future<void> _persistCartCache() async {
    await _context.db.transaction(() => writeCart(_cart.values.toList()));
    await reload();
  }

  Future<void> writeCart(List<ShoppingCartSource> sources) async {
    await _context.db.delete(_context.db.shoppingItems).go();
    await _context.db.delete(_context.db.shoppingSources).go();
    if (!sources.any((source) => source.isSummary)) {
      sources.insert(
        0,
        ShoppingCartSource(
          shoppingSummaryName,
          shoppingSummaryName,
          [],
          isSummary: true,
          position: 0,
        ),
      );
    }
    for (var sourceIndex = 0; sourceIndex < sources.length; sourceIndex++) {
      final source = sources[sourceIndex];
      final sourceId = await _context.db
          .into(_context.db.shoppingSources)
          .insert(
            ShoppingSourcesCompanion.insert(
              sourceKey: source.key,
              displayName: source.displayName,
              isSummary: Value(source.isSummary),
              position: sourceIndex,
            ),
          );
      for (var itemIndex = 0; itemIndex < source.items.length; itemIndex++) {
        final item = source.items[itemIndex];
        await _context.db
            .into(_context.db.shoppingItems)
            .insert(
              ShoppingItemsCompanion.insert(
                sourceId: sourceId,
                position: itemIndex,
                name: item.name,
                amount: Value(item.amount),
                unit: Value(item.unit),
                checked: item.checked,
              ),
            );
      }
    }
  }

  Future<void> reload() async {
    _cart = {};
    final sources = await (_context.db.select(
      _context.db.shoppingSources,
    )..orderBy([(row) => OrderingTerm.asc(row.position)])).get();
    for (final source in sources) {
      final items =
          await (_context.db.select(_context.db.shoppingItems)
                ..where((row) => row.sourceId.equals(source.id))
                ..orderBy([(row) => OrderingTerm.asc(row.position)]))
              .get();
      _cart[source.sourceKey] = ShoppingCartSource(
        source.sourceKey,
        source.displayName,
        items
            .map(
              (item) => CheckableIngredient(
                item.name,
                item.amount,
                item.unit,
                item.checked,
              ),
            )
            .toList(),
        isSummary: source.isSummary,
        position: source.position,
      );
    }
  }
}

class ShoppingCartSource {
  ShoppingCartSource(
    this.key,
    this.displayName,
    this.items, {
    this.isSummary = false,
    this.position = 0,
  });

  final String key;
  final String displayName;
  final List<CheckableIngredient> items;
  final bool isSummary;
  final int position;
}
