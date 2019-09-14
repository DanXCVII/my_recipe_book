import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/recipe.dart';
import 'package:scoped_model/scoped_model.dart';

class ShoppingCartKeeper extends Model {
  Map<String, List<CheckableIngredient>> shoppingCart = {'summary': []};
  List<String> recipes = []; // keeps track of the order of the recipes

  Future<void> initCart() async {
    shoppingCart = await DBProvider.db.getShoppingCartIngredients();

    List<String> recipeNames = shoppingCart.keys.toList();

    recipes.add('summary');
    shoppingCart.addAll({'summary': []});
    for (int i = 0; i < recipeNames.length; i++) {
      if (recipeNames[i] != 'summary') {
        recipes.add(recipeNames[i]);
        shoppingCart.addAll({recipeNames[i]: []});
      }
    }
  }

  void addMulitpleIngredientsToCart(
      String recipeName, List<Ingredient> ingredients) {
    for (Ingredient i in ingredients) {
      addSingleIngredientToCart(recipeName, i);
    }
  }

  Future<void> addSingleIngredientToCart(
      String recipeName, Ingredient ingredient) async {
    _addToCartIngredient(recipeName, ingredient);
    _addToCartIngredient('summary', ingredient);
    await DBProvider.db.addToShoppingList(recipeName, [ingredient]);
    print(shoppingCart.toString());
    print('9999999999999999999');
    Map<String, List<CheckableIngredient>> s =
        await DBProvider.db.getShoppingCartIngredients();
    print('1111111111');
    print(s);
    for (String i in s.keys.toList()) {
      for (CheckableIngredient i in s[i])
        print('${i.name}${i.amount}${i.unit}');
    }
    print('11111111111');

    notifyListeners();
  }

  void _addToCartIngredient(String recipeName, Ingredient ingredient) {
    if (!recipes.contains(recipeName)) {
      recipes.add(recipeName);
      shoppingCart.addAll({
        recipeName: [CheckableIngredient(ingredient)]
      });
    } else {
      for (CheckableIngredient i in shoppingCart[recipeName]) {
        if (i.name == ingredient.name && i.unit == ingredient.unit) {
          i.amount += ingredient.amount;
          return;
        }
      }
      shoppingCart[recipeName].add(CheckableIngredient(ingredient));
    }
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

    _cleanUpEmptyRecipes();

    notifyListeners();
  }

  void _cleanUpEmptyRecipes() {
    for (int i = 0; i < recipes.length; i++) {
      if (shoppingCart[recipes[i]].isEmpty) {
        shoppingCart.remove(recipes[i]);
        recipes.removeAt(i);
      }
    }
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
