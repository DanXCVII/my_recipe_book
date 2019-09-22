import 'dart:io';
import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/helper.dart';
import 'package:my_recipe_book/io/io_operations.dart' as IO;
import 'package:my_recipe_book/recipe.dart';
import 'package:scoped_model/scoped_model.dart';

class RecipeKeeper extends Model {
  Map<String, List<RecipePreview>> _recipes = {};
  List<RecipePreview> _favorites = [];
  List<String> _categories =
      []; // they keep track of the order of the categories
  bool _isInitialised = false;
  List<Recipe> _swypingCardRecipes = [];
  bool _isLoadingSwypeCards;

  get favorites => _favorites;

  get categories {
    List<String> cats = [];
    cats.addAll(_categories);
    return cats;
  }

  get swypingCardRecipes => _swypingCardRecipes;

  get isLoadingSwypeCards => _isLoadingSwypeCards;

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

    await changeSwypeCardCategory('all categories');
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
    for (RecipePreview r in _recipes[categoryName]) {
      if (r.categories.isEmpty) {
        _recipes['no category'].add(r);
      }
    }
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
          break;
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

  // TODO: Update categories when modifying recipe
  /// deletes oldRecipe from database and rKeeper and saves newRecipe to
  /// database and rKeeper
  Future<Recipe> modifyRecipe(
      Recipe oldRecipe, Recipe newRecipe, String recipeImage) async {
    // modify (delete old save new) recipe in database
    await DBProvider.db.deleteRecipe(oldRecipe.name);
    await DBProvider.db.newRecipe(newRecipe);

    if (oldRecipe.name != newRecipe.name) {
      await IO.copyRecipeDataToNewPath(oldRecipe.name, newRecipe.name);
    }

    Recipe fullImagePathRecipe =
        await DBProvider.db.getRecipeByName(newRecipe.name, true);
    RecipePreview rPreview = convertRecipeToPreview(fullImagePathRecipe);

    // modify recipe object
    for (String c in _recipes.keys) {
      for (int i = 0; i < _recipes[c].length; i++) {
        if (_recipes[c][i].name == oldRecipe.name) {
          _recipes[c][i] = rPreview;
          break;
        }
      }
    }
    for (int i = 0; i < _recipes['no category'].length; i++) {
      if (_recipes['no category'][i].name == oldRecipe.name) {
        _recipes['no category'][i] = rPreview;
        break;
      }
    }

    // check if modified recipe is in swyping cards and if so modify it..
    for (int i = 0; i < _swypingCardRecipes.length; i++) {
      if (_swypingCardRecipes[i] != null &&
          _swypingCardRecipes[i].name == oldRecipe.name) {
        _swypingCardRecipes[i] = fullImagePathRecipe;
      }
    }
    notifyListeners();

    // delete old files
    if (oldRecipe.name != newRecipe.name) {
      await Directory(await PathProvider.pP.getRecipeDir(oldRecipe.name))
          .delete(recursive: true);
    }
    return fullImagePathRecipe;
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

  Future<void> changeSwypeCardCategory(String categoryName) async {
    _isLoadingSwypeCards = true;
    notifyListeners();
    _swypingCardRecipes = [];
    for (int i = 0; i < 5; i++) {
      Recipe randomRecipe = await DBProvider.db.getNewRandomRecipe(
        i == 0 ? '' : _swypingCardRecipes.last.name,
        categoryName: categoryName == 'all categories' ? null : categoryName,
      );

      if (randomRecipe != null) {
        _swypingCardRecipes.add(randomRecipe);
      } else {
        break;
      }
    }

    _isLoadingSwypeCards = false;
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
