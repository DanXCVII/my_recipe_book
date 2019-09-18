import 'package:my_recipe_book/random_recipe/recipe_engine.dart';
import 'package:scoped_model/scoped_model.dart';

import '../database.dart';
import '../recipe.dart';

class RandomRecipeKeeper extends Model {
  List<RecipeDecision> _currentlyVisibleRecipes = [];

  get currentlyVisibleRecipes => _currentlyVisibleRecipes;

  Future<void> changeCategory(String categoryName) async {
    _currentlyVisibleRecipes = [];
    for (int i = 0; i < 5; i++) {
      Recipe randomRecipe = await DBProvider.db.getNewRandomRecipe(
        i == 0 ? '' : _currentlyVisibleRecipes.last.recipe.name,
        categoryName: categoryName == 'all categories' ? null : categoryName,
      );

      if (randomRecipe != null) {
        _currentlyVisibleRecipes.add(RecipeDecision(recipe: randomRecipe));
      } else {
        break;
      }
    }

    notifyListeners();
  }

  Future<void> initRecipes() async {
    changeCategory('all categories');
  }
}
