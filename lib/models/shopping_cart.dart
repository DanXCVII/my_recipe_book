import 'package:my_recipe_book/recipe.dart';
import 'package:scoped_model/scoped_model.dart';

class RecipeKeeper extends Model {
  Map<String, List<CheckableIngredient>> shoppingCart = {'summary': []};
  List<String> recipes; // keeps track of the order of the recipes

  void addToCart(String recipeName, Ingredient ingredient) {
    List<String> shoppingCartRecipes = shoppingCart.keys.toList();

    for (int i = 0; i < shoppingCartRecipes.length; i++) {
      String iterateRecipeName = shoppingCartRecipes[i];
      if (shoppingCartRecipes[i] == recipeName ||
          iterateRecipeName == 'summary') {
        for (int j = 0; j < shoppingCart[iterateRecipeName].length; j++) {
          // If the ingredient to be added is already in the shoppingCart
          if (shoppingCart[iterateRecipeName][j].name == ingredient.name &&
              shoppingCart[iterateRecipeName][j].unit == ingredient.unit) {
            shoppingCart[iterateRecipeName][j].amount += ingredient.amount;
          }
          // If the ingredient is not yet added to the list of ingredients of the recipe
          else if (j == shoppingCart[iterateRecipeName].length - 1) {
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
        shoppingCart['summary'].add(CheckableIngredient(ingredient));
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
            break;
          }
        }
        break;
      }
    }

    for (CheckableIngredient i in shoppingCart['summary']) {
      if (i.name == ingredient.name && i.unit == ingredient.unit) {
        if (i.amount - ingredient.amount <= 0) {
          shoppingCart['summary'].remove(i);
        } else {
          i.amount -= ingredient.amount;
        }
      }
      break;
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

  get fullShoppingCart => shoppingCart;
}
