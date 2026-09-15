import 'dart:math';

import 'package:drift/drift.dart';

import '../../models/enums.dart';
import '../../models/ingredient.dart';
import '../../models/nutrition.dart';
import '../../models/recipe.dart';
import '../../models/string_int_tuple.dart';
import '../../models/tuple.dart';
import '../database.dart';
import 'catalog_store.dart';
import 'drift_repository_context.dart';
import 'local_repository_contract.dart';

class RecipeStore {
  RecipeStore(this._context, this._catalogs, this._reloadAll);

  final DriftRepositoryContext _context;
  final CatalogStore _catalogs;
  final Future<void> Function() _reloadAll;
  List<String> _recipeNames = [];
  Set<String> _favorites = {};

  Future<void> reload() async {
    final rows = await _context.db.select(_context.db.storedRecipes).get();
    _recipeNames = rows.map((row) => row.name).toList();
    _favorites = rows
        .where((row) => row.isFavorite)
        .map((row) => row.name)
        .toSet();
  }

  Future<void> saveRecipe(Recipe recipe) async {
    await _context.db.transaction(() async {
      final old = await _storedRecipeByName(recipe.name);
      if (old != null) {
        await (_context.db.delete(
          _context.db.storedRecipes,
        )..where((row) => row.id.equals(old.id))).go();
      }
      await (_context.db.delete(
        _context.db.deletionTombstones,
      )..where((row) => row.recipeName.equals(recipe.name))).go();
      await insertRecipeGraph(recipe);
    });
    await _reloadAll();
  }

  Future<void> modifyRecipe(String oldName, Recipe recipe) async {
    await _context.db.transaction(() async {
      await _deleteRecipe(oldName, DateTime.now().toString());
      final sameName = await _storedRecipeByName(recipe.name);
      if (sameName != null) {
        await (_context.db.delete(
          _context.db.storedRecipes,
        )..where((row) => row.id.equals(sameName.id))).go();
      }
      await (_context.db.delete(
        _context.db.deletionTombstones,
      )..where((row) => row.recipeName.equals(recipe.name))).go();
      await insertRecipeGraph(recipe);
    });
    await _reloadAll();
  }

  Future<int> insertRecipeGraph(Recipe recipe) async {
    final id = await _context.db
        .into(_context.db.storedRecipes)
        .insert(
          StoredRecipesCompanion.insert(
            name: recipe.name,
            imagePath: recipe.imagePath,
            imagePreviewPath: recipe.imagePreviewPath,
            preparationTime: recipe.preperationTime,
            cookingTime: recipe.cookingTime,
            totalTime: recipe.totalTime,
            servings: Value(recipe.servings),
            servingName: Value(recipe.servingName),
            vegetable: _vegetableName(recipe.vegetable),
            notes: recipe.notes,
            isFavorite: Value(recipe.isFavorite),
            effort: Value(recipe.effort),
            lastModified: recipe.lastModified,
            rating: Value(recipe.rating),
            source: Value(recipe.source),
            hasStepTitles: recipe.stepTitles != null,
          ),
        );

    for (var index = 0; index < recipe.categories.length; index++) {
      final category = await _catalogs.ensureCategory(recipe.categories[index]);
      await _context.db
          .into(_context.db.storedRecipeCategories)
          .insert(
            StoredRecipeCategoriesCompanion.insert(
              recipeId: id,
              categoryId: category.id,
              position: index,
            ),
          );
    }
    for (var index = 0; index < recipe.tags.length; index++) {
      final tag = await _catalogs.ensureTag(recipe.tags[index]);
      await _context.db
          .into(_context.db.storedRecipeTags)
          .insert(
            StoredRecipeTagsCompanion.insert(
              recipeId: id,
              tagId: tag.id,
              position: index,
            ),
          );
    }

    final ingredientRowIds = <String, int>{};
    var generatedIngredientId = 0;
    final ingredientIdSeed = DateTime.now().microsecondsSinceEpoch
        .toRadixString(36);
    final groupCount = max(
      recipe.ingredients.length,
      recipe.ingredientsGlossary.length,
    );
    for (var groupIndex = 0; groupIndex < groupCount; groupIndex++) {
      final hasIngredients = groupIndex < recipe.ingredients.length;
      final hasGlossary = groupIndex < recipe.ingredientsGlossary.length;
      final groupId = await _context.db
          .into(_context.db.storedIngredientGroups)
          .insert(
            StoredIngredientGroupsCompanion.insert(
              recipeId: id,
              position: groupIndex,
              hasIngredientGroup: hasIngredients,
              hasGlossary: hasGlossary,
              glossary: Value(
                hasGlossary ? recipe.ingredientsGlossary[groupIndex] : null,
              ),
            ),
          );
      if (hasIngredients) {
        for (
          var itemIndex = 0;
          itemIndex < recipe.ingredients[groupIndex].length;
          itemIndex++
        ) {
          final ingredient = recipe.ingredients[groupIndex][itemIndex];
          var opaqueId = ingredient.id;
          if (opaqueId == null ||
              opaqueId.isEmpty ||
              ingredientRowIds.containsKey(opaqueId)) {
            opaqueId = 'ing-$ingredientIdSeed-${generatedIngredientId++}';
          }
          final ingredientRowId = await _context.db
              .into(_context.db.storedIngredients)
              .insert(
                StoredIngredientsCompanion.insert(
                  groupId: groupId,
                  position: itemIndex,
                  opaqueId: Value(opaqueId),
                  name: ingredient.name,
                  amount: Value(ingredient.amount),
                  unit: Value(ingredient.unit),
                ),
              );
          ingredientRowIds[opaqueId] = ingredientRowId;
          await _catalogs.ensureIngredient(ingredient.name);
        }
      }
    }
    for (var index = 0; index < recipe.nutritions.length; index++) {
      final nutrition = recipe.nutritions[index];
      await _context.db
          .into(_context.db.storedNutritions)
          .insert(
            StoredNutritionsCompanion.insert(
              recipeId: id,
              position: index,
              name: nutrition.name,
              amountUnit: nutrition.amountUnit,
            ),
          );
      await _catalogs.ensureNutrition(nutrition.name);
    }
    final stepCount = max(
      recipe.steps.length,
      max(
        recipe.stepImages.length,
        max(recipe.stepTitles?.length ?? 0, recipe.stepIngredientIds.length),
      ),
    );
    for (var stepIndex = 0; stepIndex < stepCount; stepIndex++) {
      final hasInstruction = stepIndex < recipe.steps.length;
      final hasTitle =
          recipe.stepTitles != null && stepIndex < recipe.stepTitles!.length;
      final hasImages = stepIndex < recipe.stepImages.length;
      final groupId = await _context.db
          .into(_context.db.storedStepGroups)
          .insert(
            StoredStepGroupsCompanion.insert(
              recipeId: id,
              position: stepIndex,
              hasInstruction: hasInstruction,
              instruction: Value(
                hasInstruction ? recipe.steps[stepIndex] : null,
              ),
              hasTitle: hasTitle,
              title: Value(hasTitle ? recipe.stepTitles![stepIndex] : null),
              hasImageGroup: hasImages,
            ),
          );
      if (hasImages) {
        for (
          var imageIndex = 0;
          imageIndex < recipe.stepImages[stepIndex].length;
          imageIndex++
        ) {
          await _context.db
              .into(_context.db.storedStepImages)
              .insert(
                StoredStepImagesCompanion.insert(
                  groupId: groupId,
                  position: imageIndex,
                  path: recipe.stepImages[stepIndex][imageIndex],
                ),
              );
        }
      }
      if (stepIndex < recipe.stepIngredientIds.length) {
        var linkPosition = 0;
        final linkedIngredientIds = <String>{};
        for (final ingredientId in recipe.stepIngredientIds[stepIndex]) {
          final ingredientRowId = ingredientRowIds[ingredientId];
          if (ingredientRowId == null ||
              !linkedIngredientIds.add(ingredientId)) {
            continue;
          }
          await _context.db
              .into(_context.db.storedStepIngredients)
              .insert(
                StoredStepIngredientsCompanion.insert(
                  stepGroupId: groupId,
                  ingredientId: ingredientRowId,
                  position: linkPosition++,
                ),
              );
        }
      }
    }
    return id;
  }

  Future<StoredRecipe?> _storedRecipeByName(String name) => (_context.db.select(
    _context.db.storedRecipes,
  )..where((row) => row.name.equals(name))).getSingleOrNull();

  Future<Recipe> _hydrateRecipe(StoredRecipe row) async {
    final categoryLinks =
        await (_context.db.select(_context.db.storedRecipeCategories)
              ..where((link) => link.recipeId.equals(row.id))
              ..orderBy([(link) => OrderingTerm.asc(link.position)]))
            .get();
    final categories = <String>[];
    for (final link in categoryLinks) {
      final category = await (_context.db.select(
        _context.db.storedCategories,
      )..where((entry) => entry.id.equals(link.categoryId))).getSingle();
      if (!category.isSystem) categories.add(category.name);
    }

    final tagLinks =
        await (_context.db.select(_context.db.storedRecipeTags)
              ..where((link) => link.recipeId.equals(row.id))
              ..orderBy([(link) => OrderingTerm.asc(link.position)]))
            .get();
    final tags = <StringIntTuple>[];
    for (final link in tagLinks) {
      final tag = await (_context.db.select(
        _context.db.storedTags,
      )..where((entry) => entry.id.equals(link.tagId))).getSingle();
      tags.add(StringIntTuple(text: tag.name, number: tag.color));
    }

    final ingredientGroups =
        await (_context.db.select(_context.db.storedIngredientGroups)
              ..where((group) => group.recipeId.equals(row.id))
              ..orderBy([(group) => OrderingTerm.asc(group.position)]))
            .get();
    final ingredients = <List<Ingredient>>[];
    final glossary = <String>[];
    for (final group in ingredientGroups) {
      if (group.hasIngredientGroup) {
        final items =
            await (_context.db.select(_context.db.storedIngredients)
                  ..where((item) => item.groupId.equals(group.id))
                  ..orderBy([(item) => OrderingTerm.asc(item.position)]))
                .get();
        ingredients.add(
          items
              .map(
                (item) => Ingredient(
                  id: item.opaqueId ?? 'stored-${item.id}',
                  name: item.name,
                  amount: item.amount,
                  unit: item.unit,
                ),
              )
              .toList(),
        );
      }
      if (group.hasGlossary) glossary.add(group.glossary ?? '');
    }

    final nutritionRows =
        await (_context.db.select(_context.db.storedNutritions)
              ..where((entry) => entry.recipeId.equals(row.id))
              ..orderBy([(entry) => OrderingTerm.asc(entry.position)]))
            .get();
    final nutritions = nutritionRows
        .map(
          (entry) => Nutrition(name: entry.name, amountUnit: entry.amountUnit),
        )
        .toList();

    final stepGroups =
        await (_context.db.select(_context.db.storedStepGroups)
              ..where((group) => group.recipeId.equals(row.id))
              ..orderBy([(group) => OrderingTerm.asc(group.position)]))
            .get();
    final steps = <String>[];
    final titles = <String>[];
    final images = <List<String>>[];
    final stepIngredientIds = <List<String>>[];
    for (final group in stepGroups) {
      if (group.hasInstruction) steps.add(group.instruction ?? '');
      if (group.hasTitle) {
        titles.add(group.title ?? '');
      }
      if (group.hasImageGroup) {
        final imageRows =
            await (_context.db.select(_context.db.storedStepImages)
                  ..where((image) => image.groupId.equals(group.id))
                  ..orderBy([(image) => OrderingTerm.asc(image.position)]))
                .get();
        images.add(imageRows.map((image) => image.path).toList());
      }
      final linkRows =
          await (_context.db.select(_context.db.storedStepIngredients)
                ..where((link) => link.stepGroupId.equals(group.id))
                ..orderBy([(link) => OrderingTerm.asc(link.position)]))
              .get();
      final linkedIds = <String>[];
      for (final link in linkRows) {
        final ingredient =
            await (_context.db.select(_context.db.storedIngredients)
                  ..where((item) => item.id.equals(link.ingredientId)))
                .getSingleOrNull();
        if (ingredient != null) {
          linkedIds.add(ingredient.opaqueId ?? 'stored-${ingredient.id}');
        }
      }
      if (group.hasInstruction) stepIngredientIds.add(linkedIds);
    }

    return Recipe(
      name: row.name,
      imagePath: row.imagePath,
      imagePreviewPath: row.imagePreviewPath,
      preperationTime: row.preparationTime,
      cookingTime: row.cookingTime,
      totalTime: row.totalTime,
      servings: row.servings,
      servingName: row.servingName,
      categories: categories,
      ingredientsGlossary: glossary,
      ingredients: ingredients,
      vegetable: _parseVegetable(row.vegetable),
      steps: steps,
      stepImages: images,
      notes: row.notes,
      nutritions: nutritions,
      isFavorite: row.isFavorite,
      effort: row.effort,
      lastModified: row.lastModified,
      rating: row.rating,
      tags: tags,
      source: row.source,
      stepTitles: row.hasStepTitles ? titles : null,
      stepIngredientIds: stepIngredientIds.any((ids) => ids.isNotEmpty)
          ? stepIngredientIds
          : const [],
    );
  }

  Future<List<Recipe>> getAllRecipes() async {
    final rows = await _context.db.select(_context.db.storedRecipes).get();
    return Future.wait(rows.map(_hydrateRecipe));
  }

  Future<Recipe?> getRecipeByName(String name) async {
    final row = await _storedRecipeByName(name);
    return row == null ? null : _hydrateRecipe(row);
  }

  Future<bool> doesRecipeExist(String name) async =>
      await _storedRecipeByName(name) != null;

  List<String> getRecipeNames() => List.unmodifiable(_recipeNames);

  Future<List<Tuple2<int, Recipe>>> getRecipesWithIngredients(
    List<String> searchIngredients,
  ) async {
    final result = <Tuple2<int, Recipe>>[];
    final searches = searchIngredients
        .map((value) => value.toLowerCase())
        .toList();
    for (final recipe in await getAllRecipes()) {
      final names = recipe.ingredients
          .expand((group) => group)
          .map((ingredient) => ingredient.name.toLowerCase())
          .toList();
      var matches = 0;
      for (final search in searches) {
        if (names.any((name) => name.contains(search))) matches++;
      }
      if (matches > 0) result.add(Tuple2(matches, recipe));
    }
    return result;
  }

  Future<List<Recipe>> getFavoriteRecipes() async {
    final rows = await (_context.db.select(
      _context.db.storedRecipes,
    )..where((recipe) => recipe.isFavorite.equals(true))).get();
    return Future.wait(rows.map(_hydrateRecipe));
  }

  Future<List<Recipe>> getVegetableRecipes(Vegetable vegetable) async {
    final rows =
        await (_context.db.select(_context.db.storedRecipes)..where(
              (recipe) => recipe.vegetable.equals(_vegetableName(vegetable)),
            ))
            .get();
    return Future.wait(rows.map(_hydrateRecipe));
  }

  Future<List<Recipe>> getRecipeTagRecipes(String tag) async {
    final tagRow = await (_context.db.select(
      _context.db.storedTags,
    )..where((entry) => entry.name.equals(tag))).getSingleOrNull();
    if (tagRow == null) return [];
    final links = await (_context.db.select(
      _context.db.storedRecipeTags,
    )..where((link) => link.tagId.equals(tagRow.id))).get();
    return _recipesForIds(links.map((link) => link.recipeId));
  }

  Future<List<Recipe>> getCategoryRecipes(String category) async {
    if (category == noCategoryName) {
      final linkedIds =
          (await _context.db.select(_context.db.storedRecipeCategories).get())
              .map((link) => link.recipeId)
              .toSet();
      final rows = await _context.db.select(_context.db.storedRecipes).get();
      return Future.wait(
        rows.where((row) => !linkedIds.contains(row.id)).map(_hydrateRecipe),
      );
    }
    final categoryRow = await (_context.db.select(
      _context.db.storedCategories,
    )..where((entry) => entry.name.equals(category))).getSingleOrNull();
    if (categoryRow == null) return [];
    final links = await (_context.db.select(
      _context.db.storedRecipeCategories,
    )..where((link) => link.categoryId.equals(categoryRow.id))).get();
    return _recipesForIds(links.map((link) => link.recipeId));
  }

  Future<List<Recipe>> _recipesForIds(Iterable<int> ids) async {
    final uniqueIds = ids.toSet();
    if (uniqueIds.isEmpty) return [];
    final rows = await (_context.db.select(
      _context.db.storedRecipes,
    )..where((recipe) => recipe.id.isIn(uniqueIds))).get();
    return Future.wait(rows.map(_hydrateRecipe));
  }

  Future<Recipe?> getRandomRecipeOfCategory({
    String? category,
    Recipe? excludedRecipe,
  }) async {
    final recipes = category == null
        ? await getAllRecipes()
        : await getCategoryRecipes(category);
    return _randomRecipe(recipes, excludedRecipe);
  }

  Future<Recipe?> getRandomRecipeOfVegetable(
    Vegetable vegetable, {
    Recipe? excludedRecipe,
  }) async =>
      _randomRecipe(await getVegetableRecipes(vegetable), excludedRecipe);

  Future<Recipe?> getRandomRecipeOfRecipeTag(
    String tag, {
    Recipe? excludedRecipe,
  }) async => _randomRecipe(await getRecipeTagRecipes(tag), excludedRecipe);

  Future<Recipe?> getRandomRecipeFromKeyList(
    List<String> recipeNames, {
    Recipe? excludedRecipe,
  }) async {
    final recipes = <Recipe>[];
    for (final name in recipeNames) {
      final recipe = await getRecipeByName(name);
      if (recipe != null) recipes.add(recipe);
    }
    return _randomRecipe(recipes, excludedRecipe);
  }

  Recipe? _randomRecipe(List<Recipe> recipes, Recipe? excluded) {
    final candidates = List<Recipe>.from(recipes);
    if (excluded != null && candidates.length > 1) {
      candidates.removeWhere((recipe) => recipe.name == excluded.name);
    }
    return candidates.isEmpty
        ? null
        : candidates[Random().nextInt(candidates.length)];
  }

  Future<void> addToFavorites(Recipe recipe) async {
    await (_context.db.update(_context.db.storedRecipes)
          ..where((row) => row.name.equals(recipe.name)))
        .write(const StoredRecipesCompanion(isFavorite: Value(true)));
    await _reloadAll();
  }

  bool isRecipeFavorite(String recipeName) => _favorites.contains(recipeName);

  Future<void> removeFromFavorites(Recipe recipe) async {
    await (_context.db.update(_context.db.storedRecipes)
          ..where((row) => row.name.equals(recipe.name)))
        .write(const StoredRecipesCompanion(isFavorite: Value(false)));
    await _reloadAll();
  }

  Future<void> deleteRecipe(String name, {String? deletionDate}) async {
    await _context.db.transaction(
      () => _deleteRecipe(name, deletionDate ?? DateTime.now().toString()),
    );
    await _reloadAll();
  }

  Future<void> _deleteRecipe(String name, String deletionDate) async {
    await (_context.db.delete(
      _context.db.storedRecipes,
    )..where((row) => row.name.equals(name))).go();
    await _context.db
        .into(_context.db.deletionTombstones)
        .insertOnConflictUpdate(
          DeletionTombstonesCompanion.insert(
            recipeName: name,
            deletedAt: deletionDate,
          ),
        );
  }

  Vegetable _parseVegetable(String value) {
    for (final candidate in Vegetable.values) {
      if (candidate.name == value) return candidate;
    }
    return Vegetable.VEGAN;
  }

  String _vegetableName(Vegetable value) => value.name;
}
