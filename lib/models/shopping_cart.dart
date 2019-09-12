import 'package:my_recipe_book/recipe.dart';
import 'package:scoped_model/scoped_model.dart';

class RecipeKeeper extends Model {
  Map<String, List<CheckableIngredient>> shoppingCart;

  void addToCart(String recipeName, Ingredient ingredient) {
    List<String> shoppingCartRecipes = shoppingCart.keys.toList();

    for (int i = 0; i < shoppingCartRecipes.length; i++) {
      String iterateRecipeName = shoppingCartRecipes[i];
      if (shoppingCartRecipes[i] == recipeName) {
        for (int j = 0; j < shoppingCart[iterateRecipeName].length; j++) {
          // If the ingredient to be added is already in the shoppingCart
          if (shoppingCart[iterateRecipeName][j].name == ingredient.name)
            shoppingCart[iterateRecipeName][j].amount += ingredient.amount;
          // If the ingredient is not yet added to the list of ingredients of the recipe
          if (j == shoppingCart[iterateRecipeName].length - 1 &&
              shoppingCart[iterateRecipeName][j].name != ingredient.name) {
            shoppingCart[recipeName].add(CheckableIngredient(ingredient));
          }
        }
      }

      /// If the ingredient to be added and the recipe where it's from both aren't
      /// in the shoppingCart
      if (i == shoppingCartRecipes.length - 1 &&
          iterateRecipeName != recipeName) {
        shoppingCart.addAll({
          recipeName: [CheckableIngredient(ingredient)]
        });
      }
    }

    notifyListeners();
  }

  void removeFromCart(String recipeName, Ingredient ingredient) {
    for (String r in shoppingCart.keys) {
      if (r == recipeName) {
        for (CheckableIngredient i in shoppingCart[r]) {
          if (i.name == ingredient.name) {
            shoppingCart[r].remove(i);
          }
        }
      }
    }

    notifyListeners();
  }

  void checkIngredient(
      String recipeName, Ingredient ingredient, bool checkedStatus) {
    for (String r in shoppingCart.keys) {
      if (r == recipeName) {
        for (CheckableIngredient i in shoppingCart[r]) {
          if (i.name == ingredient.name) {
            i.checked = checkedStatus;
          }
        }
      }
    }

    notifyListeners();
  }
}
