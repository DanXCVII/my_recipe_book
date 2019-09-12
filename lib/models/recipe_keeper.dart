import 'dart:io';

import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/helper.dart';
import 'package:my_recipe_book/recipe.dart';
import 'package:scoped_model/scoped_model.dart';

class RecipeKeeper extends Model {
  Map<String, List<RecipePreview>> recipes = {};
  List<RecipePreview> favorites = [];
  List<String> categories =
      []; // they keep track of the order of the categories
  bool isInitialised = false;

  get rCategories => categories;

  List<RecipePreview> getRecipesOfCategory(String category) =>
      recipes[category];

  Future<void> initData() async {
    categories = await DBProvider.db.getCategories();
    categories.add('no category');
    for (String category in categories) {
      recipes.addAll(
          {category: await DBProvider.db.getRecipePreviewOfCategory(category)});
    }
    recipes.addAll(
        {'no category': await DBProvider.db.getRecipePreviewOfNoCategory()});
    favorites.addAll(await DBProvider.db.getFavoriteRecipePreviews());
    isInitialised = true;
    notifyListeners();
  }

  void addCategory(String categoryName) {
    this.categories.insert(categories.length - 1, categoryName);
    recipes.addAll({categoryName: []});

    notifyListeners();
  }

  void removeCategory(String categoryName) {
    categories.remove(categoryName);
    recipes.remove(categoryName);

    notifyListeners();
  }

  Future<void> deleteRecipeWithName(String name, bool deleteFiles) async {
    for (String category in recipes.keys) {
      for (int i = 0; i < recipes[category].length; i++) {
        if (recipes[category][i].name == name) {
          recipes[category].removeAt(i);
        }
      }
    }
    DBProvider.db.deleteRecipe(name);
    if (deleteFiles)
      Directory(await PathProvider.pP.getRecipeDir(name))
          .deleteSync(recursive: true);
    notifyListeners();
  }

  void changeCategoryName(String oldCatName, String newCatName) async {
    await DBProvider.db.changeCategoryName(oldCatName, newCatName);
    for (String c in categories) {
      if (c == oldCatName) c = newCatName;
    }
    recipes.addAll({newCatName: recipes[oldCatName]});
    recipes.remove(oldCatName);

    notifyListeners();
  }

  /// deletes oldRecipe from database and rKeeper and saves newRecipe to
  /// database and rKeeper
  Future<Recipe> modifyRecipe(Recipe oldRecipe, Recipe newRecipe) async {
    await DBProvider.db.deleteRecipe(oldRecipe.name);

    for (String category in recipes.keys) {
      for (int i = 0; i < recipes[category].length; i++) {
        if (recipes[category][i].name == oldRecipe.name) {
          recipes[category].removeAt(i);
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
      if (!categories.contains(category)) {
        addCategory(category);
      }
      recipes[category].add(rPreview);
    }

    if (recipe.categories.isEmpty) recipes['no category'].add(rPreview);

    notifyListeners();
    return fullImagePathRecipe;
  }

  void addFavorite(Recipe recipe) {
    recipe.isFavorite = true;
    favorites.add(convertRecipeToPreview(recipe));

    for (String category in recipes.keys) {
      for (RecipePreview r in recipes[category]) {
        if (r.name == recipe.name) {
          r.isFavorite = true;
        }
      }
    }

    notifyListeners();
  }

  void removeFromFavorites(String name) {
    for (int i = 0; i < favorites.length; i++) {
      if (favorites[i].name == name) {
        favorites.removeAt(i);
      }
    }

    for (String category in recipes.keys) {
      for (RecipePreview r in recipes[category]) {
        if (r.name == name) {
          r.isFavorite = false;
        }
      }
    }

    notifyListeners();
  }

  void deleteRecipe(RecipePreview recipePreview) {
    for (String category in recipes.keys) {
      recipes[category].remove(recipePreview);
    }
    notifyListeners();
  }

  void updateCategoryOrder(List<String> categories) {
    this.categories = categories;

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
