import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/recipe.dart';
import 'package:scoped_model/scoped_model.dart';

class ShoppingCartKeeper extends Model {
  Map<String, List<CheckableIngredient>> _shoppingCart;
  List<String> _recipes = []; // keeps track of the order of the recipes

  Future<void> initCart() async {
    _shoppingCart = await DBProvider.db.getShoppingCartIngredients();

    List<String> recipeNames = _shoppingCart.keys.toList();

    _recipes.add('summary');
    for (int i = 0; i < recipeNames.length; i++) {
      if (recipeNames[i].compareTo('summary') != 0) {
        _recipes.add(recipeNames[i]);
      }
    }
  }

  Future<void> addMulitpleIngredientsToCart(
      String recipeName, List<Ingredient> ingredients) async {
    for (Ingredient i in ingredients) {
      await addSingleIngredientToCart(recipeName, i);
    }
  }

  /// adds the ingredient with checked = false status to the list
  /// and updates the summary
  Future<void> addSingleIngredientToCart(
      String recipeName, Ingredient ingredient) async {
    _addIngredientToRecipe('summary', ingredient);
    _addIngredientToRecipe(recipeName, ingredient);
    await DBProvider.db.addToShoppingList(recipeName, ingredient);

    notifyListeners();
  }

  /// removes the ingredient from recipe and then adds it again
  /// with the new amount
  /// e.g.: 2 eggs in Pizza, 4 in summary
  /// call removeAndAddIngredient(Pizza, 3 eggs)
  /// => afterwards on the list: 3 eggs in Pizza, 4 in summary
  Future<void> removeAndAddIngredient(
      String recipeName, Ingredient ingredient) async {
    await removeIngredientFromCart(recipeName, ingredient);
    await addSingleIngredientToCart(recipeName, ingredient);
  }

  // see removeAndAddIngredient
  Future<void> removeAndAddIngredients(
      String recipeName, List<Ingredient> ingredients) async {
    for (Ingredient i in ingredients) {
      await removeAndAddIngredient(recipeName, i);
    }
  }

  Future<void> removeIngredientsFromCart(
      String recipeName, List<Ingredient> ingredients) async {
    for (Ingredient i in ingredients) {
      await removeIngredientFromCart(recipeName, i);
    }
  }

  /// Checks if the given ingredient is in the list of the given
  /// recipe with a greater or equal amount
  bool checkForRecipeIngredient(String recipeName, Ingredient ingredient) {
    for (String r in _recipes) {
      for (CheckableIngredient i in _shoppingCart[r]) {
        if (i.name.compareTo(ingredient.name) == 0 &&
            i.unit.compareTo(ingredient.unit) == 0 &&
            i.amount >= ingredient.amount) {
          return true;
        }
      }
    }
    return false;
  }

  // see checkForRecipeIngredient()
  bool checkForRecipeIngredients(
      String recipeName, List<Ingredient> ingredients) {
    for (Ingredient i in ingredients) {
      if (!checkForRecipeIngredient(recipeName, i)) return false;
    }
    return true;
  }

  /// removes the ingrdients of the given recipe from the list and
  /// also updates the summary
  Future<void> removeRecipeFromCart(String recipeName) async {
    List<Ingredient> toBeRemoved = [];
    for (CheckableIngredient i in _shoppingCart[recipeName]) {
      toBeRemoved.add(Ingredient(
        name: i.name,
        amount: i.amount,
        unit: i.unit,
      ));
    }
    for (Ingredient i in toBeRemoved) {
      await removeIngredientFromCart(recipeName, i);
    }

    notifyListeners();
    await DBProvider.db.deleteRecipeFromeShoppingCart(recipeName);
  }

  // see removeRecipeFromCart()
  Future<void> removeIngredientFromCart(
      String recipeName, Ingredient ingredient) async {
    if (_shoppingCart[recipeName] == null) return;
    
    if (recipeName.compareTo('summary') != 0) {
      var removeIngred = _getSuitingIngredientRecipe(ingredient, recipeName);
      if (removeIngred == null) return;
      double removeAmount = removeIngred.amount;
      _shoppingCart[recipeName].remove(removeIngred);

      var summaryIngred = _getSuitingIngredientRecipe(ingredient, 'summary');
      if (summaryIngred.amount - removeAmount <= 0) {
        _shoppingCart['summary'].remove(summaryIngred);
      } else {
        summaryIngred.amount -= removeAmount;
      }
    } else {
      for (String r in _shoppingCart.keys) {
        for (int i = 0; i < _shoppingCart[r].length; i++) {
          if (_shoppingCart[r][i].name.compareTo(ingredient.name) == 0 &&
              _shoppingCart[r][i].unit.compareTo(ingredient.unit) == 0) {
            _shoppingCart[r].remove(_shoppingCart[r][i]);
            break;
          }
        }
      }
    }
    _cleanUpEmptyRecipes();

    notifyListeners();
    await DBProvider.db.deleteFromShoppingCart(recipeName, ingredient);
  }

  /// checks/unchecks the given ingredient with the value of the given
  /// CheckableIngredient.checked and also updates the summary checked
  /// if necessary
  Future<void> checkIngredient(
      String recipeName, CheckableIngredient ingredient) async {
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
        if (uncheckedIngredients.length == 1) {
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
    await DBProvider.db.checkIngredient(recipeName, ingredient);

    notifyListeners();
  }

  void _cleanUpEmptyRecipes() {
    for (int i = 0; i < _recipes.length; i++) {
      if (_shoppingCart[_recipes[i]].isEmpty &&
          _recipes[i].compareTo('summary') != 0) {
        _shoppingCart.remove(_recipes[i]);
        _recipes.removeAt(i);
      }
    }
  }

  /// adds the ingredient to the given recipe only or updates the amount
  /// and sets checked = false (does not look for incorrect summary)
  Future<void> _addIngredientToRecipe(
      String recipeName, Ingredient ingredient) async {
    bool alreadyExisting = false;
    for (String i in _recipes) {
      if (i.compareTo(recipeName) == 0) {
        alreadyExisting = true;
        break;
      }
    }

    if (!alreadyExisting) {
      _recipes.add(recipeName);
      _shoppingCart.addAll({
        recipeName: [CheckableIngredient(ingredient)]
      });
    } else {
      if (_getSuitingIngredientRecipe(ingredient, recipeName) != null) {
        _getSuitingIngredientRecipe(ingredient, recipeName)
          ..amount += ingredient.amount
          ..checked = false;
      } else {
        _shoppingCart[recipeName].add(CheckableIngredient(ingredient));
      }
    }

    notifyListeners();
  }

  /// returns the ingredient of the recipe with the same name and unit if
  /// existing and otherwise null
  CheckableIngredient _getSuitingIngredientRecipe(
      Ingredient ingredient, String recipeName) {
    for (CheckableIngredient i in _shoppingCart[recipeName]) {
      if (i.name.compareTo(ingredient.name) == 0 &&
          i.unit.compareTo(ingredient.unit) == 0) {
        return i;
      }
    }
    return null;
  }

  // see _getSuitingIngredientRecipe()
  List<CheckableIngredient> _getAllSuitingIngredients(Ingredient ingredient,
      {bool checked}) {
    List<CheckableIngredient> suitedIngredients = [];

    for (String r in _recipes) {
      for (CheckableIngredient i in _shoppingCart[r]) {
        if (checked == null) {
          if (i.name.compareTo(ingredient.name) == 0 &&
              i.unit.compareTo(ingredient.unit) == 0) {
            suitedIngredients.add(i);
          }
        } else {
          if (i.name.compareTo(ingredient.name) == 0 &&
              i.unit.compareTo(ingredient.unit) == 0 &&
              i.checked == checked) {
            suitedIngredients.add(i);
          }
        }
      }
    }
    return suitedIngredients;
  }

  get recipes => _recipes;

  get shoppingCart => _shoppingCart;
}
