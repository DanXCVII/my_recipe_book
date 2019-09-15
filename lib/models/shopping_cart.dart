import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/recipe.dart';
import 'package:scoped_model/scoped_model.dart';

class ShoppingCartKeeper extends Model {
  Map<String, List<CheckableIngredient>> shoppingCart;
  List<String> recipes; // keeps track of the order of the recipes

  Future<void> initCart() async {
    shoppingCart = await DBProvider.db.getShoppingCartIngredients();

    List<String> recipeNames = shoppingCart.keys.toList();

    recipes.addAll(recipeNames);
    for (int i = 0; i < recipeNames.length; i++) {
      if (recipeNames[i].compareTo('summary') != 0) {
        recipes.add(recipeNames[i]);
      }
    }
    recipes.add('summary');
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
      if (_getSuitingIngredientRecipe(ingredient, recipeName) != null) {
        _getSuitingIngredientRecipe(ingredient, recipeName).amount +=
            ingredient.amount;

        if (recipeName.compareTo('summary') != 0) {
          _getSuitingIngredientRecipe(ingredient, 'summary').amount +=
              ingredient.amount;
        }
      } else {
        shoppingCart[recipeName].add(CheckableIngredient(ingredient));

        if (recipeName.compareTo('summary') != 0) {
          shoppingCart['summary'].add(CheckableIngredient(ingredient));
        }
      }
    }
  }

  void removeIngredientFromCart(String recipeName, Ingredient ingredient) {
    if (recipeName.compareTo('summary') != 0) {
      var removeIngred = _getSuitingIngredientRecipe(ingredient, recipeName);
      shoppingCart[recipeName].remove(removeIngred);

      var summaryIngred = _getSuitingIngredientRecipe(ingredient, 'summary');
      if (summaryIngred.amount - ingredient.amount <= 0) {
        shoppingCart['summary'].remove(summaryIngred);
      } else {
        summaryIngred.amount -= ingredient.amount;
      }
    } else {
      for (String r in shoppingCart.keys) {
        for (CheckableIngredient i in shoppingCart[r]) {
          if (i.name == ingredient.name && i.unit == ingredient.unit) {
            shoppingCart[r].remove(i);
          }
        }
      }
    }
    _cleanUpEmptyRecipes();

    notifyListeners();
  }

  void _cleanUpEmptyRecipes() {
    for (int i = 0; i < recipes.length; i++) {
      if (shoppingCart[recipes[i]].isEmpty &&
          recipes[i].compareTo('summary') != 0) {
        shoppingCart.remove(recipes[i]);
        recipes.removeAt(i);
      }
    }
  }

  void checkIngredient(String recipeName, CheckableIngredient ingredient) {
    Ingredient passedIngredient = Ingredient(
        name: ingredient.name,
        amount: ingredient.amount,
        unit: ingredient.unit);

    _getSuitingIngredientRecipe(passedIngredient, recipeName).checked =
        ingredient.checked;

    if (recipeName.compareTo('summary') != 0) {
      if (ingredient.checked == false) {
        _getSuitingIngredientRecipe(passedIngredient, 'summary').checked =
            false;
      } // checked == true
      else {
        var uncheckedIngredients =
            _getAllSuitingIngredients(passedIngredient, checked: false);
        if (uncheckedIngredients.isEmpty) {
          _getSuitingIngredientRecipe(passedIngredient, 'summary').checked =
              true;
        }
      }
    } // recipeName = summary
    else {
      _getAllSuitingIngredients(passedIngredient).forEach((i) {
        i.checked = ingredient.checked;
      });
    }

    notifyListeners();
  }

  CheckableIngredient _getSuitingIngredientRecipe(
      Ingredient ingredient, String recipeName) {
    for (CheckableIngredient i in shoppingCart[recipeName]) {
      if (i.name == ingredient.name && i.unit == ingredient.unit) {
        return i;
      }
    }
    return null;
  }

  List<CheckableIngredient> _getAllSuitingIngredients(Ingredient ingredient,
      {bool checked}) {
    List<CheckableIngredient> suitedIngredients = [];

    for (String r in recipes) {
      for (CheckableIngredient i in shoppingCart[r]) {
        if (checked == null) {
          if (i.name == ingredient.name && i.unit == ingredient.unit) {
            suitedIngredients.add(i);
          }
        } else {
          if (i.name == ingredient.name &&
              i.unit == ingredient.unit &&
              i.checked == checked) {
            suitedIngredients.add(i);
          }
        }
      }
    }
    return suitedIngredients;
  }

  get fullShoppingCart => shoppingCart;
}
