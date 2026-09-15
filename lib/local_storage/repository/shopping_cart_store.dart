import 'package:drift/drift.dart';

import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../models/shopping_cart_data.dart';
import '../../models/shopping_cart_recipe_addition.dart';
import '../database.dart';
import 'drift_repository_context.dart';
import 'local_repository_contract.dart';

class ShoppingCartStore {
  ShoppingCartStore(this._context, this._recipeByName);

  final DriftRepositoryContext _context;
  final Future<Recipe?> Function(String name) _recipeByName;
  Map<String, ShoppingCartSource> _cart = {};

  Future<Map<Recipe, List<CheckableIngredient>>> getShoppingCart() async {
    return (await getShoppingCartData()).toLegacyMap();
  }

  Future<ShoppingCartData> getShoppingCartData() async {
    final result = <ShoppingCartSourceData>[];
    final sources = _cart.values.toList()
      ..sort((a, b) => a.position.compareTo(b.position));
    for (final source in sources) {
      final recipe = source.isSummary
          ? null
          : await _recipeByName(source.displayName);
      result.add(
        ShoppingCartSourceData(
          key: source.key,
          displayName: source.displayName,
          items: List<CheckableIngredient>.from(source.items),
          isSummary: source.isSummary,
          position: source.position,
          recipe: recipe,
          currentServings: source.currentServings,
        ),
      );
    }
    return ShoppingCartData(result);
  }

  Future<void> addMultipleIngredientsToCart(
    String recipeName,
    List<Ingredient> ingredients, {
    double? servings,
  }) async {
    for (final ingredient in ingredients) {
      _addCartIngredient(shoppingSummaryName, ingredient);
      if (recipeName != shoppingSummaryName) {
        _addCartIngredient(recipeName, ingredient, currentServings: servings);
      }
    }
    await _persistCartCache();
  }

  Future<void> mergeRecipeIngredientsToCart(
    List<ShoppingCartRecipeAddition> additions,
  ) async {
    final before = _copyCart();
    try {
      for (final addition in additions.where(
        (addition) => addition.ingredients.isNotEmpty,
      )) {
        final existing = _cart[addition.recipeName];
        double? existingServings = existing?.currentServings;
        if (existing != null && existingServings == null) {
          existingServings = (await _recipeByName(addition.recipeName))
              ?.servings;
        }
        for (final ingredient in addition.ingredients) {
          _addCartIngredient(shoppingSummaryName, ingredient);
          _addCartIngredient(addition.recipeName, ingredient);
        }
        final source = _cart[addition.recipeName]!;
        if (existing == null) {
          source.currentServings = addition.servings;
        } else if (existingServings != null && addition.servings != null) {
          source.currentServings = existingServings + addition.servings!;
        } else {
          source.currentServings = null;
        }
      }
      await _persistCartCache();
    } catch (_) {
      _cart = before;
      rethrow;
    }
  }

  Map<String, ShoppingCartSource> _copyCart() => {
    for (final entry in _cart.entries)
      entry.key: ShoppingCartSource(
        entry.value.key,
        entry.value.displayName,
        List<CheckableIngredient>.from(entry.value.items),
        isSummary: entry.value.isSummary,
        position: entry.value.position,
        currentServings: entry.value.currentServings,
      ),
  };

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

  void _addCartIngredient(
    String sourceName,
    Ingredient ingredient, {
    double? currentServings,
  }) {
    final source = _cart.putIfAbsent(
      sourceName,
      () => ShoppingCartSource(
        sourceName,
        sourceName,
        [],
        isSummary: sourceName == shoppingSummaryName,
        position: _cart.length,
        currentServings: currentServings,
      ),
    );
    if (!source.isSummary && currentServings != null) {
      source.currentServings = currentServings;
    }
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
    } else if (!_hasRemainingSourceContribution(ingredient)) {
      summary.items.removeAt(index);
    }
  }

  bool _hasRemainingSourceContribution(Ingredient ingredient) {
    return _cart.values
        .where((source) => !source.isSummary)
        .any(
          (source) =>
              _matchingIngredientIndex(ingredient, source.items) != null,
        );
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

  Future<void> updateSourceServings(
    String sourceName,
    double newServings,
  ) async {
    if (!newServings.isFinite || newServings <= 0) {
      throw ArgumentError.value(newServings, 'newServings');
    }
    final source = _cart[sourceName];
    if (source == null || source.isSummary) {
      throw StateError('Shopping cart source is not adjustable');
    }
    final recipe = await _recipeByName(source.displayName);
    final oldServings = source.currentServings ?? recipe?.servings;
    if (oldServings == null || !oldServings.isFinite || oldServings <= 0) {
      throw StateError('Shopping cart source has no serving baseline');
    }

    final factor = newServings / oldServings;
    final summary = _cart[shoppingSummaryName];
    for (var index = 0; index < source.items.length; index++) {
      final oldItem = source.items[index];
      if (oldItem.amount == null) continue;
      final newAmount = oldItem.amount! * factor;
      source.items[index] = oldItem.copyWith(amount: newAmount);

      if (summary == null) continue;
      final summaryIndex = _matchingIngredientIndex(
        oldItem.getIngredient(),
        summary.items,
      );
      if (summaryIndex == null || summary.items[summaryIndex].amount == null) {
        continue;
      }
      final summaryItem = summary.items[summaryIndex];
      summary.items[summaryIndex] = summaryItem.copyWith(
        amount: summaryItem.amount! + newAmount - oldItem.amount!,
      );
    }
    source.currentServings = newServings;
    await _persistCartCache();
  }

  Future<ShoppingCartData?> removeCheckedItems() async {
    final before = (await getShoppingCartData()).snapshot();
    final summary = _cart[shoppingSummaryName];
    final checkedCount = _cart.values
        .expand((source) => source.items)
        .where((item) => item.checked)
        .length;
    if (checkedCount == 0) return null;

    final nonSummarySources = _cart.values
        .where((source) => !source.isSummary)
        .toList(growable: false);
    for (final source in nonSummarySources) {
      final removed = source.items
          .where((item) => item.checked)
          .toList(growable: false);
      source.items.removeWhere((item) => item.checked);
      for (final item in removed) {
        _subtractFromSummary(item.getIngredient());
      }
      if (source.items.isEmpty) _cart.remove(source.key);
    }

    summary?.items.removeWhere((item) => item.checked);
    await _persistCartCache();
    return before;
  }

  Future<void> restore(ShoppingCartData snapshot) async {
    _cart = {
      for (final source in snapshot.sources)
        source.key: ShoppingCartSource(
          source.key,
          source.displayName,
          List<CheckableIngredient>.from(source.items),
          isSummary: source.isSummary,
          position: source.position,
          currentServings: source.currentServings,
        ),
    };
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
              currentServings: Value(source.currentServings),
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
        currentServings: source.currentServings,
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
    this.currentServings,
  });

  final String key;
  final String displayName;
  final List<CheckableIngredient> items;
  final bool isSummary;
  final int position;
  double? currentServings;
}
