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

  void deleteRecipeWithName(String name) {
    for (String category in recipes.keys) {
      for (int i = 0; i < recipes[category].length; i++) {
        if (recipes[category][i].name == name) {
          recipes[category].removeAt(i);
        }
      }
    }
    notifyListeners();
  }

  void addRecipe(Recipe recipe) {
    RecipePreview rPreview = convertRecipeToPreview(recipe);

    for (String category in recipe.categories) {
      recipes[category].add(rPreview);
    }

    if (recipe.categories.isEmpty) recipes['no category'].add(rPreview);
    notifyListeners();
  }

  void addFavorite(Recipe recipe) {
    favorites.add(convertRecipeToPreview(recipe));

    for (String category in recipes.keys) {
      for (int i = 0; i < recipes[category].length; i++) {
        if (recipes[category][i].name == recipe.name) {
          recipes[category][i].isFavorite = true;
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
      for (int i = 0; i < recipes[category].length; i++) {
        if (recipes[category][i].name == name) {
          recipes[category][i].isFavorite = false;
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
