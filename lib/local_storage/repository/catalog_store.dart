import 'package:drift/drift.dart';

import '../../models/enums.dart';
import '../../models/recipe_sort.dart';
import '../../models/string_int_tuple.dart';
import '../database.dart';
import 'drift_repository_context.dart';
import 'local_repository_contract.dart';

class CatalogStore {
  CatalogStore(this._context, this._reloadAll);

  final DriftRepositoryContext _context;
  final Future<void> Function() _reloadAll;
  List<String> _categoryNames = [];
  Map<String, int> _categoryCounts = {};
  List<StringIntTuple> _tags = [];
  List<String> _ingredients = [];
  List<String> _nutritions = [];

  Future<StoredCategory> ensureCategory(String name) async {
    final existing = await (_context.db.select(
      _context.db.storedCategories,
    )..where((row) => row.name.equals(name))).getSingleOrNull();
    if (existing != null) return existing;
    await addCategory(name, refresh: false);
    return (_context.db.select(
      _context.db.storedCategories,
    )..where((row) => row.name.equals(name))).getSingle();
  }

  Future<StoredTag> ensureTag(StringIntTuple tag) async {
    final existing = await (_context.db.select(
      _context.db.storedTags,
    )..where((row) => row.name.equals(tag.text))).getSingleOrNull();
    if (existing != null) return existing;
    final count = await _context.db
        .select(_context.db.storedTags)
        .get()
        .then((rows) => rows.length);
    final id = await _context.db
        .into(_context.db.storedTags)
        .insert(
          StoredTagsCompanion.insert(
            name: tag.text,
            color: tag.number,
            position: count,
          ),
        );
    return (_context.db.select(
      _context.db.storedTags,
    )..where((row) => row.id.equals(id))).getSingle();
  }

  Future<void> ensureIngredient(String name) async {
    final exists = await (_context.db.select(
      _context.db.ingredientCatalogEntries,
    )..where((row) => row.name.equals(name))).getSingleOrNull();
    if (exists == null) {
      final count = await _context.db
          .select(_context.db.ingredientCatalogEntries)
          .get()
          .then((rows) => rows.length);
      await _context.db
          .into(_context.db.ingredientCatalogEntries)
          .insert(
            IngredientCatalogEntriesCompanion.insert(
              name: name,
              position: count,
            ),
          );
    }
  }

  Future<void> ensureNutrition(String name) async {
    final exists = await (_context.db.select(
      _context.db.nutritionCatalogEntries,
    )..where((row) => row.name.equals(name))).getSingleOrNull();
    if (exists == null) {
      final count = await _context.db
          .select(_context.db.nutritionCatalogEntries)
          .get()
          .then((rows) => rows.length);
      await _context.db
          .into(_context.db.nutritionCatalogEntries)
          .insert(
            NutritionCatalogEntriesCompanion.insert(
              name: name,
              position: count,
            ),
          );
    }
  }

  Future<void> addCategory(String name, {bool refresh = true}) async {
    if (await (_context.db.select(
          _context.db.storedCategories,
        )..where((row) => row.name.equals(name))).getSingleOrNull() !=
        null)
      return;
    final rows = await (_context.db.select(
      _context.db.storedCategories,
    )..orderBy([(row) => OrderingTerm.asc(row.position)])).get();
    final systemIndex = rows.indexWhere((row) => row.isSystem);
    final position = systemIndex < 0 ? rows.length : rows[systemIndex].position;
    for (final row
        in rows.where((row) => row.position >= position).toList().reversed) {
      await (_context.db.update(_context.db.storedCategories)
            ..where((entry) => entry.id.equals(row.id)))
          .write(StoredCategoriesCompanion(position: Value(row.position + 1)));
    }
    await _context.db
        .into(_context.db.storedCategories)
        .insert(
          StoredCategoriesCompanion.insert(
            name: name,
            position: position,
            sortKind: _sortName(RecipeSort.BY_NAME),
          ),
        );
    if (refresh) await _reloadAll();
  }

  Future<void> renameCategory(String oldName, String newName) async {
    await (_context.db.update(_context.db.storedCategories)
          ..where((row) => row.name.equals(oldName)))
        .write(StoredCategoriesCompanion(name: Value(newName)));
    await _reloadAll();
  }

  Future<void> deleteCategory(String name) async {
    final row = await (_context.db.select(
      _context.db.storedCategories,
    )..where((entry) => entry.name.equals(name))).getSingleOrNull();
    if (row == null || row.isSystem) return;
    await _context.db.transaction(() async {
      await (_context.db.delete(
        _context.db.storedCategories,
      )..where((entry) => entry.id.equals(row.id))).go();
      final remaining = await (_context.db.select(
        _context.db.storedCategories,
      )..orderBy([(entry) => OrderingTerm.asc(entry.position)])).get();
      for (var index = 0; index < remaining.length; index++) {
        await (_context.db.update(_context.db.storedCategories)
              ..where((entry) => entry.id.equals(remaining[index].id)))
            .write(StoredCategoriesCompanion(position: Value(index)));
      }
    });
    await _reloadAll();
  }

  Future<void> moveCategory(int oldIndex, int newIndex) async {
    final rows = await (_context.db.select(
      _context.db.storedCategories,
    )..orderBy([(row) => OrderingTerm.asc(row.position)])).get();
    if (oldIndex < 0 ||
        oldIndex >= rows.length ||
        newIndex < 0 ||
        newIndex >= rows.length)
      return;
    final moved = rows.removeAt(oldIndex);
    rows.insert(newIndex, moved);
    await _context.db.transaction(() async {
      for (var index = 0; index < rows.length; index++) {
        await (_context.db.update(_context.db.storedCategories)
              ..where((row) => row.id.equals(rows[index].id)))
            .write(StoredCategoriesCompanion(position: Value(index)));
      }
    });
    await _reloadAll();
  }

  List<String> getCategoryNames() => List.unmodifiable(_categoryNames);

  int getRecipeAmountCategory(String category) =>
      _categoryCounts[category] ?? 0;

  Future<void> changeSortOrder(RSort sort, String category) async {
    await (_context.db.update(
      _context.db.storedCategories,
    )..where((row) => row.name.equals(category))).write(
      StoredCategoriesCompanion(
        sortKind: Value(_sortName(sort.sort)),
        ascending: Value(sort.ascending ?? true),
      ),
    );
  }

  Future<RSort> getSortOrder(String category) async {
    final row = await (_context.db.select(
      _context.db.storedCategories,
    )..where((entry) => entry.name.equals(category))).getSingleOrNull();
    return row == null
        ? RSort(RecipeSort.BY_NAME, true)
        : RSort(_parseSort(row.sortKind), row.ascending);
  }

  Future<void> addRecipeTag(String name, int color) async {
    final exists = await (_context.db.select(
      _context.db.storedTags,
    )..where((row) => row.name.equals(name))).getSingleOrNull();
    if (exists == null) {
      final position = await _context.db
          .select(_context.db.storedTags)
          .get()
          .then((rows) => rows.length);
      await _context.db
          .into(_context.db.storedTags)
          .insert(
            StoredTagsCompanion.insert(
              name: name,
              color: color,
              position: position,
            ),
          );
      await _reloadAll();
    }
  }

  Future<void> deleteRecipeTag(String name) async {
    await (_context.db.delete(
      _context.db.storedTags,
    )..where((row) => row.name.equals(name))).go();
    final rows = await (_context.db.select(
      _context.db.storedTags,
    )..orderBy([(row) => OrderingTerm.asc(row.position)])).get();
    for (var index = 0; index < rows.length; index++) {
      await (_context.db.update(_context.db.storedTags)
            ..where((row) => row.id.equals(rows[index].id)))
          .write(StoredTagsCompanion(position: Value(index)));
    }
    await _reloadAll();
  }

  Future<void> updateRecipeTag(
    String oldName,
    String newName,
    int color,
  ) async {
    await (_context.db.update(_context.db.storedTags)
          ..where((row) => row.name.equals(oldName)))
        .write(StoredTagsCompanion(name: Value(newName), color: Value(color)));
    await _reloadAll();
  }

  List<StringIntTuple> getRecipeTags() => List.unmodifiable(_tags);

  List<String> getIngredientNames() => List.unmodifiable(_ingredients);

  Future<void> addIngredient(String ingredient) async {
    await ensureIngredient(ingredient);
    await _reloadAll();
  }

  Future<void> deleteIngredient(String ingredient) async {
    await (_context.db.delete(
      _context.db.ingredientCatalogEntries,
    )..where((row) => row.name.equals(ingredient))).go();
    await _normalizeIngredientPositions();
    await _reloadAll();
  }

  List<String> getNutritions() => List.unmodifiable(_nutritions);

  Future<void> addNutrition(String name) async {
    await ensureNutrition(name);
    await _reloadAll();
  }

  Future<void> renameNutrition(String oldName, String newName) async {
    await (_context.db.update(_context.db.nutritionCatalogEntries)
          ..where((row) => row.name.equals(oldName)))
        .write(NutritionCatalogEntriesCompanion(name: Value(newName)));
    await _reloadAll();
  }

  Future<void> moveNutrition(int oldIndex, int newIndex) async {
    final rows = await (_context.db.select(
      _context.db.nutritionCatalogEntries,
    )..orderBy([(row) => OrderingTerm.asc(row.position)])).get();
    if (oldIndex < 0 ||
        oldIndex >= rows.length ||
        newIndex < 0 ||
        newIndex >= rows.length)
      return;
    final moved = rows.removeAt(oldIndex);
    rows.insert(newIndex, moved);
    await _context.db.transaction(() async {
      for (var index = 0; index < rows.length; index++) {
        await (_context.db.update(_context.db.nutritionCatalogEntries)
              ..where((row) => row.id.equals(rows[index].id)))
            .write(NutritionCatalogEntriesCompanion(position: Value(index)));
      }
    });
    await _reloadAll();
  }

  Future<void> deleteNutrition(String name) async {
    await (_context.db.delete(
      _context.db.nutritionCatalogEntries,
    )..where((row) => row.name.equals(name))).go();
    final rows = await (_context.db.select(
      _context.db.nutritionCatalogEntries,
    )..orderBy([(row) => OrderingTerm.asc(row.position)])).get();
    for (var index = 0; index < rows.length; index++) {
      await (_context.db.update(_context.db.nutritionCatalogEntries)
            ..where((row) => row.id.equals(rows[index].id)))
          .write(NutritionCatalogEntriesCompanion(position: Value(index)));
    }
    await _reloadAll();
  }

  Future<void> _normalizeIngredientPositions() async {
    final rows = await (_context.db.select(
      _context.db.ingredientCatalogEntries,
    )..orderBy([(row) => OrderingTerm.asc(row.position)])).get();
    for (var index = 0; index < rows.length; index++) {
      await (_context.db.update(_context.db.ingredientCatalogEntries)
            ..where((row) => row.id.equals(rows[index].id)))
          .write(IngredientCatalogEntriesCompanion(position: Value(index)));
    }
  }

  Future<void> reload() async {
    final recipeRows = await _context.db
        .select(_context.db.storedRecipes)
        .get();
    final categories = await (_context.db.select(
      _context.db.storedCategories,
    )..orderBy([(row) => OrderingTerm.asc(row.position)])).get();
    _categoryNames = categories.map((row) => row.name).toList();
    _categoryCounts = {for (final category in _categoryNames) category: 0};
    final links = await _context.db
        .select(_context.db.storedRecipeCategories)
        .get();
    final categoryById = {
      for (final category in categories) category.id: category,
    };
    final recipesWithCategory = <int>{};
    for (final link in links) {
      final category = categoryById[link.categoryId];
      if (category != null && !category.isSystem) {
        _categoryCounts[category.name] =
            (_categoryCounts[category.name] ?? 0) + 1;
        recipesWithCategory.add(link.recipeId);
      }
    }
    _categoryCounts[noCategoryName] = recipeRows
        .where((recipe) => !recipesWithCategory.contains(recipe.id))
        .length;
    final tags = await (_context.db.select(
      _context.db.storedTags,
    )..orderBy([(row) => OrderingTerm.asc(row.position)])).get();
    _tags = tags
        .map((row) => StringIntTuple(text: row.name, number: row.color))
        .toList();
    _ingredients =
        (await (_context.db.select(
              _context.db.ingredientCatalogEntries,
            )..orderBy([(row) => OrderingTerm.asc(row.position)])).get())
            .map((row) => row.name)
            .toList();
    _nutritions =
        (await (_context.db.select(
              _context.db.nutritionCatalogEntries,
            )..orderBy([(row) => OrderingTerm.asc(row.position)])).get())
            .map((row) => row.name)
            .toList();
  }

  String _sortName(RecipeSort value) => value.name;

  RecipeSort _parseSort(String value) {
    for (final candidate in RecipeSort.values) {
      if (candidate.name == value) return candidate;
    }
    return RecipeSort.BY_NAME;
  }
}
