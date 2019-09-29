import 'dart:io';
import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:my_recipe_book/helper.dart';
import 'package:my_recipe_book/io/io_operations.dart' as IO;
import 'package:my_recipe_book/recipe.dart';
import 'package:scoped_model/scoped_model.dart';

class RecipeKeeper extends Model {
  Map<String, List<RecipePreview>> _recipes = {};
  List<RecipePreview> _favorites = [];
  // they keep track of the order of the categories
  List<String> _categories = [];
  List<String> _nutritions = [];
  bool _isInitialised = false;
  String _swypingRecipeCategory = 'all categories';
  List<Recipe> _swypingCardRecipes = [];
  bool _isLoadingSwypeCards;

  set swypingCardCategory(String categoryName) {
    _swypingRecipeCategory = categoryName;
  }

  List<RecipePreview> get favorites => _favorites;

  List<String> get categories => _categories;

  List<String> get nutritions => _nutritions;

  List<Recipe> get swypingCardRecipes => _swypingCardRecipes;

  bool get isLoadingSwypeCards => _isLoadingSwypeCards;

  bool get isInitialised => _isInitialised;

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

    _nutritions = await DBProvider.db.getAllNutritions();

    await changeSwypeCardCategory('all categories');
    notifyListeners();
  }

  Future<void> firstStartInitialize() async {
    await addNutrition('fat');
    await addNutrition('sugar');
    await addNutrition('carbohydrates');
  }

  Future<void> addNutrition(String name) async {
    // TODO: Check if list<String> contains string works or if you have to do it with compareTo()
    if (!_nutritions.contains(name)) {
      _nutritions.add(name);
      notifyListeners();

      await DBProvider.db.newNutrition(name, _nutritions.length);
    }
  }

  Future<void> removeNutrition(String name) async {
    _nutritions.remove(name);
    notifyListeners();

    await DBProvider.db.removeNutrition(name);
  }

  Future<void> renameNutrition(String oldName, String newName) async {
    for (int i = 0; i < _nutritions.length; i++) {
      if (_nutritions[i] == oldName) {
        _nutritions[i] = newName;
      }
    }
    notifyListeners();

    await DBProvider.db.renameNutrition(oldName, newName);
  }

  Future<void> updateNutritionOrder(List<String> names) async {
    _nutritions = names;
    notifyListeners();
    print(names);
    await DBProvider.db.updateNutritionOrder(names);
  }

  /// Only when saving the nutritions with the onPress check, the
  /// database takes the changes
  void moveNutrition(int oldIndex, newIndex) {
    String moveNutrition = _nutritions[oldIndex];
    _nutritions.removeAt(oldIndex);
    if (newIndex > oldIndex) newIndex -= 1;
    _nutritions.insert(newIndex, moveNutrition);

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

  Future<void> removeCategory(String categoryName) async {
    _categories.remove(categoryName);
    for (RecipePreview r in _recipes[categoryName]) {
      if (r.categories.isEmpty) {
        _recipes['no category'].add(r);
      }
    }
    _recipes.remove(categoryName);

    notifyListeners();
    await DBProvider.db.removeCategory(categoryName);
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
    await changeSwypeCardCategory(_swypingRecipeCategory);

    notifyListeners();

    Directory recipeDir =
        Directory(await PathProvider.pP.getRecipeDir(recipeName));
    if (deleteFiles) if (recipeDir.existsSync())
      recipeDir.deleteSync(recursive: true);
  }

  void renameCategory(String oldCatName, String newCatName) async {
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
  Future<Recipe> modifyRecipe(Recipe oldRecipe, Recipe newRecipe,
      String recipeImage, bool hasFiles, bool addNutritions) async {
    print(hasFiles);
    // modify (delete old save new) recipe in database
    await DBProvider.db.deleteRecipe(oldRecipe.name);
    await DBProvider.db.newRecipe(newRecipe, addNutritions);

    if (hasFiles && oldRecipe.name != newRecipe.name) {
      await IO.copyRecipeDataToNewPath(oldRecipe.name, newRecipe.name);
    }

    Recipe fullImagePathRecipe =
        await DBProvider.db.getRecipeByName(newRecipe.name, true);
    RecipePreview rPreview = convertRecipeToPreview(fullImagePathRecipe);

    // modify recipe object (delete from every category and then add it to right ones)
    for (String c in _recipes.keys) {
      for (int i = 0; i < _recipes[c].length; i++) {
        if (_recipes[c][i].name == oldRecipe.name) {
          _recipes[c].removeAt(i);
          break;
        }
      }
    }
    for (String category in newRecipe.categories) {
      if (!_categories.contains(category)) {
        await addCategory(category);
      }
      _recipes[category].add(rPreview);
    }
    if (newRecipe.categories.isEmpty) {
      _recipes['no category'].add(rPreview);
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
    if (hasFiles && oldRecipe.name != newRecipe.name) {
      await Directory(await PathProvider.pP.getRecipeDir(oldRecipe.name))
          .delete(recursive: true);
    }
    return fullImagePathRecipe;
  }

  /// Adds recipe to the database and previewRecipe to the rKeeper
  /// given recipe doesn't contain the full image paths. Also updates
  /// the swyping cards, if the new recipe is in the currently selected
  /// category
  Future<Recipe> addRecipe(Recipe recipe, bool addNutritions) async {
    for (String category in recipe.categories) {
      if (!_categories.contains(category)) {
        await addCategory(category);
      }
    }

    await DBProvider.db.newRecipe(recipe, addNutritions);
    Recipe fullImagePathRecipe =
        await DBProvider.db.getRecipeByName(recipe.name, true);
    RecipePreview rPreview = convertRecipeToPreview(fullImagePathRecipe);

    for (String category in recipe.categories) {
      _recipes[category].add(rPreview);
      if (category.compareTo(_swypingRecipeCategory) == 0) {
        await changeSwypeCardCategory(category);
      }
    }

    if (recipe.categories.isEmpty) {
      await changeSwypeCardCategory('no category');
      _recipes['no category'].add(rPreview);
    }
    if (_swypingRecipeCategory == 'all categories') {
      await changeSwypeCardCategory('all categories');
    }

    notifyListeners();
    return fullImagePathRecipe;
  }

  Future<Recipe> addRecipeNutritions(
      String recipeName, List<Nutrition> nutritions) async {
    await changeSwypeCardCategory(_swypingRecipeCategory);
    return await DBProvider.db.addNutritionsToRecipe(recipeName, nutritions);
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
        if (i == 0) {
          _isLoadingSwypeCards = false;
          notifyListeners();
          return [];
        }
        _swypingCardRecipes.add(_swypingCardRecipes[i - 1]);
      }
    }

    _isLoadingSwypeCards = false;
    notifyListeners();
  }

  bool doesNutritionExist(String name) {
    if (_nutritions.contains(name)) return true;
    return false;
  }

  void moveCategory(int oldIndex, newIndex) {
    String moveCategory = _categories[oldIndex];
    _categories.removeAt(oldIndex);
    if (newIndex > oldIndex) newIndex -= 1;
    _categories.insert(newIndex, moveCategory);

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
