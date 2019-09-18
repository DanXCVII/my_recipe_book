import 'dart:io';
import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/helper.dart';
import 'package:my_recipe_book/recipe.dart';
import 'package:scoped_model/scoped_model.dart';

class RecipeKeeper extends Model {
  Map<String, List<RecipePreview>> _recipes = {};
  List<RecipePreview> _favorites = [];
  List<String> _categories =
      []; // they keep track of the order of the categories
  bool _isInitialised = false;

  get favorites => _favorites;

  get categories {
    List<String> cats = [];
    cats.addAll(_categories);
    return cats;
  }

  get isInitialised => _isInitialised;

  List<RecipePreview> getRecipesOfCategory(String category) =>
      _recipes[category];

  Future<void> initData() async {
    _categories = await DBProvider.db.getCategories();
    _categories.add('no category');
    for (String category in _categories) {
      _recipes.addAll(
          {category: await DBProvider.db.getRecipePreviewOfCategory(category)});
    }
    _recipes.addAll(
        {'no category': await DBProvider.db.getRecipePreviewOfNoCategory()});
    _favorites.addAll(await DBProvider.db.getFavoriteRecipePreviews());
    _isInitialised = true;
    notifyListeners();
  }

  Future<void> addCategory(String categoryName) async {
    this._categories.insert(_categories.length - 1, categoryName);
    _recipes.addAll({categoryName: []});
    await DBProvider.db.newCategory(categoryName);

    notifyListeners();
  }

  bool doesCategoryExist(String categoryName) {
    if (_categories.contains(categoryName)) {
      return true;
    } else {
      return false;
    }
  }

  String getRandomRecipeImageFromCategory(String categoryName) {
    Random r = Random();
    if (_recipes[categoryName].length == 0) {
      throw ArgumentError('no recipes in this category');
    }
    int randomRecipe = _recipes[categoryName].length == 1
        ? 0
        : r.nextInt(_recipes[categoryName].length);
    return _recipes[categoryName][randomRecipe].imagePreviewPath;
  }

  void removeCategory(String categoryName) {
    _categories.remove(categoryName);
    _recipes.remove(categoryName);

    notifyListeners();
  }

  Future<void> deleteRecipeWithName(String recipeName, bool deleteFiles) async {
    imageCache.clear();
    removeFromFavorites(recipeName);
    for (String category in _recipes.keys) {
      for (int i = 0; i < _recipes[category].length; i++) {
        if (_recipes[category][i].name == recipeName) {
          _recipes[category].removeAt(i);
        }
      }
    }
    await DBProvider.db.deleteRecipe(recipeName);
    Directory recipeDir =
        Directory(await PathProvider.pP.getRecipeDir(recipeName));
    if (deleteFiles) if (recipeDir.existsSync())
      recipeDir.deleteSync(recursive: true);
    notifyListeners();
  }

  void changeCategoryName(String oldCatName, String newCatName) async {
    await DBProvider.db.changeCategoryName(oldCatName, newCatName);
    for (int i = 0; i < _categories.length; i++) {
      if (_categories[i] == oldCatName) _categories[i] = newCatName;
    }

    _recipes.addAll({newCatName: _recipes[oldCatName]});
    _recipes.remove(oldCatName);

    notifyListeners();
  }

  /// deletes oldRecipe from database and rKeeper and saves newRecipe to
  /// database and rKeeper
  Future<Recipe> modifyRecipe(Recipe oldRecipe, Recipe newRecipe) async {
    await DBProvider.db.deleteRecipe(oldRecipe.name);

    for (String category in _recipes.keys) {
      for (int i = 0; i < _recipes[category].length; i++) {
        if (_recipes[category][i].name == oldRecipe.name) {
          _recipes[category].removeAt(i);
        }
      }
    }

    Recipe r = await addRecipe(
        newRecipe); // addRecipe() already calls notifyListeners()
    return r;
  }

  /// Adds recipe to the database and previewRecipe to the rKeeper
  /// given recipe doesn't contain the full image paths
  Future<Recipe> addRecipe(Recipe recipe) async {
    await DBProvider.db.newRecipe(recipe);

    Recipe fullImagePathRecipe =
        await DBProvider.db.getRecipeByName(recipe.name, true);

    RecipePreview rPreview = convertRecipeToPreview(fullImagePathRecipe);

    for (String category in recipe.categories) {
      if (!_categories.contains(category)) {
        addCategory(category);
      }
      _recipes[category].add(rPreview);
    }

    if (recipe.categories.isEmpty) _recipes['no category'].add(rPreview);

    notifyListeners();
    return fullImagePathRecipe;
  }

  void addFavorite(Recipe recipe) {
    recipe.isFavorite = true;
    _favorites.add(convertRecipeToPreview(recipe));

    for (String category in _recipes.keys) {
      for (RecipePreview r in _recipes[category]) {
        if (r.name == recipe.name) {
          r.isFavorite = true;
        }
      }
    }

    notifyListeners();
  }

  void removeFromFavorites(String name) {
    for (int i = 0; i < _favorites.length; i++) {
      if (_favorites[i].name == name) {
        _favorites.removeAt(i);
      }
    }

    for (String category in _recipes.keys) {
      for (RecipePreview r in _recipes[category]) {
        if (r.name == name) {
          r.isFavorite = false;
        }
      }
    }

    notifyListeners();
  }

  void deleteRecipe(RecipePreview recipePreview) {
    for (String category in _recipes.keys) {
      _recipes[category].remove(recipePreview);
    }
    notifyListeners();
  }

  Future<void> updateCategoryOrder(List<String> categories) async {
    await DBProvider.db.updateCategoryOrder(categories);
    this._categories = categories;

    notifyListeners();
  }

  RecipePreview convertRecipeToPreview(Recipe recipe) {
    int ingredientsAmount = 0;
    for (List<Ingredient> l in recipe.ingredients) {
      ingredientsAmount += l.length;
    }

    return RecipePreview(
      name: recipe.name,
      totalTime: getTimeHoursMinutes(recipe.totalTime),
      imagePreviewPath: recipe.imagePreviewPath,
      effort: recipe.effort,
      ingredientsAmount: ingredientsAmount,
      vegetable: recipe.vegetable,
      isFavorite: recipe.isFavorite,
      categories: recipe.categories,
    );
  }
}
