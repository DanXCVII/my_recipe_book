import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:my_recipe_book/models/nutrition.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:tuple/tuple.dart';

import 'models/enums.dart';
import 'models/ingredient.dart';
import 'models/shopping_cart_tuple.dart';

// TODO: Check for mistakes
Future<void> deleteRecipe(String recipeName) async {
  Box<List<String>> boxRecipeCategories = Hive.box('recipeCategories');
  LazyBox lazyBoxRecipes = Hive.box('recipes') as LazyBox;

  String hiveRecipeKey = getHiveKey(recipeName);
  Recipe removeRecipe = await lazyBoxRecipes.get(hiveRecipeKey);

  // delete recipe from categories
  if (removeRecipe.categories.isNotEmpty) {
    for (String categoryName in removeRecipe.categories) {
      if (boxRecipeCategories.get(categoryName).contains(hiveRecipeKey)) {
        boxRecipeCategories.put(categoryName,
            boxRecipeCategories.get(categoryName)..remove(hiveRecipeKey));
      }
    }
  } else {
    boxRecipeCategories.put('no category',
        boxRecipeCategories.get('no category')..remove(hiveRecipeKey));
  }

  // delete recipe from vegetable
  Box<String> boxVegetable =
      Hive.box<String>(removeRecipe.vegetable.toString());

  for (var key in boxVegetable.keys) {
    if (boxVegetable.get(key) == hiveRecipeKey) boxVegetable.delete(key);
  }

  // delete recipe from recipes
  lazyBoxRecipes.delete(hiveRecipeKey);
}

Future<void> changeSortOrder(RecipeSort recipeSort) async {
  if (recipeSort == RecipeSort.BY_NAME) {}
}

void saveRecipe(Recipe newRecipe) {
  LazyBox lazyBoxRecipes = Hive.box('recipes') as LazyBox;
  Box<List<String>> boxRecipeCategories =
      Hive.box<List<String>>('recipeCategories');

  // add recipe to recipes
  String hiveRecipeKey = getHiveKey(newRecipe.name);

  lazyBoxRecipes.put(hiveRecipeKey, newRecipe);

  // add recipe to categories
  for (String categoryName in newRecipe.categories) {
    String hiveCategoryKey = getHiveKey(categoryName);
    boxRecipeCategories.put(hiveCategoryKey,
        boxRecipeCategories.get(hiveCategoryKey)..add(hiveRecipeKey));
  }
  if (newRecipe.categories.isEmpty) {
    List<String> recipeNames = boxRecipeCategories.get('no category');
    boxRecipeCategories.put('no category', recipeNames..add(hiveRecipeKey));
  }
  print(lazyBoxRecipes.get(hiveRecipeKey));

  // add recipe to vegetable
  Box<String> boxVegetable = Hive.box<String>(newRecipe.vegetable.toString());
  boxVegetable.add(hiveRecipeKey);

  // add ingredients to ingredientNames
  Box<String> boxIngredientNames = Hive.box<String>('ingredientNames');
  for (List<Ingredient> l in newRecipe.ingredients) {
    for (Ingredient i in l) {
      bool addIngred = true;
      for (var key in boxIngredientNames.keys) {
        if (boxIngredientNames.get(key).compareTo(i.name) == 0) {
          addIngred = false;
        }
      }
      if (addIngred) boxIngredientNames.add(i.name);
    }
  }
}

Future<void> modifyRecipe(String oldRecipeName, Recipe newRecipe) async {
  LazyBox lazyBoxRecipes = Hive.box<Recipe>('recipes') as LazyBox;
  Box<List<String>> boxRecipeCategories =
      Hive.box<List<String>>('recipeCategories');

  String hiveOldRecipeKey = getHiveKey(oldRecipeName);
  String hiveNewRecipeKey = getHiveKey(newRecipe.name);

  Recipe editRecipe = await lazyBoxRecipes.get(hiveOldRecipeKey);

  // DELETE OLD RECIPE FROM HIVE

  for (String category in editRecipe.categories) {
    boxRecipeCategories.put(
        getHiveKey(category),
        boxRecipeCategories.get(category)
          ..removeWhere((hiveRecipeKey) =>
              hiveRecipeKey.compareTo(hiveOldRecipeKey) == 0));
  }
  if (editRecipe.categories.isEmpty) {
    boxRecipeCategories.put(
        'no category',
        boxRecipeCategories.get('no category')
          ..removeWhere((hiveRecipeKey) =>
              hiveRecipeKey.compareTo(hiveOldRecipeKey) == 0));
  }

  lazyBoxRecipes.delete(hiveOldRecipeKey);

  // ADD NEW RECIPE TO HIVE

  saveRecipe(newRecipe);
  print(lazyBoxRecipes.get(hiveNewRecipeKey));
}

Future<void> renameNutrition(String oldName, String newName) async {
  Box<List<String>> boxNutritions = Hive.box('nutritions');
  LazyBox lazyBoxRecipes = Hive.box('recipes') as LazyBox;

  List<String> nutritions = boxNutritions.get('order');

  boxNutritions.put(
      'order',
      nutritions
        ..remove(oldName)
        ..add(newName));

  // TODO: Verify if working
  for (var key in lazyBoxRecipes.keys) {
    Recipe recipe = await lazyBoxRecipes.get(key);

    for (Nutrition n in recipe.nutritions) {
      if (n.name.compareTo(oldName) == 0) {
        n.name = newName;
        lazyBoxRecipes.put(recipe.name, recipe);
        break;
      }
    }
  }
}

Future<void> renameCategory(String oldName, String newName) async {
  Box<List<String>> boxCategories = Hive.box('categories');
  Box<List<String>> boxOrder = Hive.box('order');
  LazyBox lazyBoxRecipes = Hive.box('recipes') as LazyBox;

  String hiveNewKey = getHiveKey(newName);
  String hiveOldKey = getHiveKey(oldName);

  List<String> recipes = boxCategories.get(hiveOldKey);
  boxCategories.delete(hiveOldKey);
  boxCategories.put(hiveNewKey, recipes);

  // TODO: Verify if working
  for (var key in lazyBoxRecipes.keys) {
    Recipe recipe = await lazyBoxRecipes.get(key);

    for (int i = 0; i < recipe.categories.length; i++) {
      if (recipe.categories[i].compareTo(oldName) == 0) {
        recipe.categories[i] = newName;
        lazyBoxRecipes.put(key, recipe);
        break;
      }
    }
  }

  List<String> categories = boxOrder.get('categories');
  boxOrder.put(
      'categories',
      categories
        ..remove(oldName)
        ..add(newName));
}

void addCategory(String categoryName) {
  Box<String> boxCategories = Hive.box<String>('categories');
  Box<List<String>> boxCategoryOrder = Hive.box('order');
  Box<List<String>> boxRecipeCategories = Hive.box('recipeCategories');

  // TODO: Verify if working

  String hiveCategoryKey = getHiveKey(categoryName);

  boxCategories.put(hiveCategoryKey, categoryName);

  List<String> categories = boxCategoryOrder.get('categories');
  boxCategoryOrder.put(
      'categories', categories..insert(categories.length - 1, categoryName));

  boxRecipeCategories.put(hiveCategoryKey, []);
}

void addNutrition(String nutritionName) {
  Box<List<String>> boxNutritions = Hive.box('nutritions');
  List<String> nutritions = boxNutritions.get('order');

  nutritions.add(nutritionName);

  boxNutritions.put('order', nutritions);
}

bool doesNutritionExist(String nutritionName) {
  Box<List<String>> boxNutritions = Hive.box('nutritions');
  List<String> nutritions = boxNutritions.get('order');

  if (nutritions.contains('$nutritionName')) {
    return true;
  }

  return false;
}

void moveNutrition(int oldIndex, newIndex) {
  Box<List<String>> boxNutritions = Hive.box('nutritions');

  List<String> nutritions = boxNutritions.get('order');

  String moveNutrition = nutritions[oldIndex];

  if (newIndex > oldIndex) newIndex -= 1;
  nutritions[oldIndex] = nutritions[newIndex];
  nutritions[newIndex] = moveNutrition;

  boxNutritions.put('order', nutritions);
}

void moveCategory(int oldIndex, newIndex) {
  Box<List<String>> boxOrder = Hive.box('order');
  List<String> categories = boxOrder.get('categories');

  String moveNutrition = categories[oldIndex];

  if (newIndex > oldIndex) newIndex -= 1;
  categories[oldIndex] = categories[newIndex];
  categories[newIndex] = moveNutrition;

  boxOrder.put('categories', categories);
}

Future<void> deleteCategory(String categoryName) async {
  LazyBox lazyBoxRecipes = Hive.box('recipes') as LazyBox;
  Box<List<String>> boxCategories = Hive.box('categories');
  Box<List<String>> boxOrder = Hive.box('order');
  List<String> categories = boxOrder.get('order');

  categories.remove('$categoryName');

  boxOrder.put('categories', categories);
  boxCategories.delete(getHiveKey(categoryName));

  for (var key in lazyBoxRecipes.keys) {
    Recipe currentRecipe = await lazyBoxRecipes.get(key);
    for (String category in currentRecipe.categories) {
      if (currentRecipe.categories.contains(category)) {
        currentRecipe.categories.remove(category);

        lazyBoxRecipes.put(key, currentRecipe);
        if (currentRecipe.categories.isEmpty) {
          boxCategories.put(
              'no category',
              boxCategories.get('no category')
                ..add(getHiveKey(currentRecipe.name)));
        }
      }
    }
  }
}

void deleteNutrition(String nutritionName) {
  Box<List<String>> boxNutritions = Hive.box('nutritions');
  List<String> nutritions = boxNutritions.get('order');

  nutritions.remove('$nutritionName');

  boxNutritions.put('order', nutritions);
}

Future<Map<String, Recipe>> getVegetableRecipes(Vegetable vegetable) async {
  Box<String> boxVegetable = Hive.box(vegetable.toString());
  LazyBox lazyBoxRecipes = Hive.box('recipes') as LazyBox;

  Map<String, Recipe> recipes = {};
  for (String key in boxVegetable.keys) {
    recipes.addAll({key: await lazyBoxRecipes.get(boxVegetable.get(key))});
  }
  return recipes;
}

Future<List<Recipe>> getCategoryRecipes(String category) async {
  String categoryKey = getHiveKey(category);

  Box<List<String>> boxRecipeCategories = Hive.box('recipeCategories');
  LazyBox lazyBoxRecipes = Hive.box('recipes') as LazyBox;

  List<Recipe> recipes = [];
  for (var key in boxRecipeCategories.get(categoryKey)) {
    recipes.add(await lazyBoxRecipes.get(key));
  }
  return recipes;
}

String getHiveKey(String name) {
  if (name.contains(RegExp(r"[^\x00-\x7F]+"))) {
    List<int> bytes = utf8.encode(name).toList();
    for (int i = 0; i < bytes.length; i++) {
      if (bytes[i] > 127) {
        bytes.insert(i + 1, bytes[i] - 127);
        bytes[i] = 127;
      }
    }

    return String.fromCharCodes(bytes);
  }
  return name;
}

void _addMulitpleIngredientsToCart(
    String recipeName, List<Ingredient> ingredients) {
  for (Ingredient i in ingredients) {
    addSingleIngredientToCart(recipeName, i);
  }
}

/// adds the ingredient with checked = false status to the list
/// and updates the summary
void addSingleIngredientToCart(String recipeName, Ingredient ingredient) {
  _addIngredientToRecipe('summary', ingredient);
  _addIngredientToRecipe(recipeName, ingredient);
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
  Box<StringListTuple> boxShoppingCart =
      Hive.box<StringListTuple>('shoppingCart');

  String hiveRecipeKey = getHiveKey(recipeName);

  if (boxShoppingCart.get(hiveRecipeKey) != null) {
    for (CheckableIngredient i in boxShoppingCart.get(hiveRecipeKey).item2) {
      if (i.amount == null &&
          ingredient.amount == null &&
          i.name.compareTo(ingredient.name) == 0) {
        return true;
      }
      if (i.name.compareTo(ingredient.name) == 0 &&
          ((i.unit != null &&
                  ingredient.unit != null &&
                  i.unit.compareTo(ingredient.unit) == 0) ||
              (i.unit == null && ingredient.unit == null)) &&
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
  Box<StringListTuple> boxShoppingCart =
      Hive.box<StringListTuple>('shoppingCart');

  String hiveRecipeKey = getHiveKey(recipeName);
  boxShoppingCart.delete(getHiveKey(recipeName));
  List<Ingredient> toBeRemoved = [];

  for (CheckableIngredient i in boxShoppingCart.get(hiveRecipeKey).item2) {
    toBeRemoved.add(Ingredient(
      name: i.name,
      amount: i.amount,
      unit: i.unit,
    ));
  }
  for (Ingredient i in toBeRemoved) {
    await removeIngredientFromCart(recipeName, i);
  }
}

// see removeRecipeFromCart()
Future<void> removeIngredientFromCart(
    String recipeName, Ingredient ingredient) async {
  Box<StringListTuple> boxShoppingCart =
      Hive.box<StringListTuple>('shoppingCart');

  String hiveRecipeKey = getHiveKey(recipeName);
  if (boxShoppingCart.get(hiveRecipeKey) == null) return;

  if (recipeName == 'summary') {
    for (var key in boxShoppingCart.keys) {
      for (CheckableIngredient i in boxShoppingCart.get(key).item2) {
        if (i.name.compareTo(ingredient.name) == 0 &&
            i.unit.compareTo(ingredient.unit) == 0) {
          boxShoppingCart.get(key).item2.remove(i);
          break;
        }
      }
    }
  } else {
    var removeIngred = _getSuitingIngredientRecipe(ingredient, recipeName);
    if (removeIngred == null) return;
    double removeAmount = removeIngred.amount;
    boxShoppingCart.get(hiveRecipeKey).item2.remove(removeIngred);

    var summaryIngred = _getSuitingIngredientRecipe(ingredient, 'summary');
    if (summaryIngred.amount != null && removeAmount != null) {
      if (summaryIngred.amount - removeAmount <= 0) {
        boxShoppingCart.get('summary').item2.remove(summaryIngred);
      } else {
        summaryIngred.amount -= removeAmount;
        summaryIngred.save();
      }
    } else {
      boxShoppingCart.get('summary').item2.remove(summaryIngred);
    }
  }

  _cleanUpEmptyRecipes();
}

/// checks/unchecks the given ingredient with the value of the given
/// CheckableIngredient.checked and also updates the summary checked
/// if necessary
Future<void> checkIngredient(
    String recipeName, CheckableIngredient ingredient) async {
  Ingredient passedIngredient = ingredient.getIngredient();

  CheckableIngredient i =
      _getSuitingIngredientRecipe(passedIngredient, recipeName);
  i.checked = ingredient.checked;
  i.save();

  if (recipeName.compareTo('summary') == 0) {
    _getAllSuitingIngredients(passedIngredient).forEach((i) {
      i.checked = ingredient.checked;
      i.save();
    });
  } else {
    if (ingredient.checked == false) {
      CheckableIngredient i =
          _getSuitingIngredientRecipe(passedIngredient, 'summary');
      i.checked = false;
      i.save();
    } // checked == true
    else {
      var uncheckedIngredients =
          _getAllSuitingIngredients(passedIngredient, checked: false);
      if (uncheckedIngredients.length == 1) {
        CheckableIngredient i = uncheckedIngredients[0];
        i.checked = true;
        i.save();
      }
    }
  }
}

void _cleanUpEmptyRecipes() {
  Box<StringListTuple> boxShoppingCart =
      Hive.box<StringListTuple>('shoppingCart');

  for (var key in boxShoppingCart.keys) {
    if (key != 'summary' && boxShoppingCart.get(key).item2.isEmpty) {
      boxShoppingCart.delete(key);
    }
  }
}

/// adds the ingredient to the given recipe only or updates the amount
/// and sets checked = false (does not look for incorrect summary)
void _addIngredientToRecipe(String recipeName, Ingredient ingredient) {
  Box<StringListTuple> boxShoppingCart =
      Hive.box<StringListTuple>('shoppingCart');

  String hiveRecipeKey = getHiveKey(recipeName);

  // if we already have the recipe in our shoppingCard
  if (boxShoppingCart.keys.contains(hiveRecipeKey)) {
    CheckableIngredient modifyIngred =
        _getSuitingIngredientRecipe(ingredient, recipeName);
    if (modifyIngred != null) {
      if (modifyIngred.amount != null) {
        modifyIngred.amount += ingredient.amount;
      }
      modifyIngred.checked = false;
      modifyIngred.save();
    } else {
      boxShoppingCart.get(hiveRecipeKey).item2.add(CheckableIngredient(
          ingredient.name, ingredient.amount, ingredient.unit, false));
    }
  } // if we have to add the recipe with the ingredient to cart
  else {
    boxShoppingCart.put(
        hiveRecipeKey,
        StringListTuple(recipeName, [
          CheckableIngredient(
              ingredient.name, ingredient.amount, ingredient.unit, false)
        ]));
  }
}

/// returns the ingredient of the recipe with the same name and unit if
/// existing and otherwise null
CheckableIngredient _getSuitingIngredientRecipe(
    Ingredient ingredient, String recipeName) {
  Box<StringListTuple> boxShoppingCart = Hive.box('shoppingCart');

  for (CheckableIngredient i
      in boxShoppingCart.get(getHiveKey(recipeName)).item2) {
    if (isSameIngredient(ingredient, i.getIngredient())) return i;
  }
  return null;
}

// see _getSuitingIngredientRecipe()
List<CheckableIngredient> _getAllSuitingIngredients(Ingredient ingredient,
    {bool checked}) {
  Box<StringListTuple> boxShoppingCart = Hive.box('shoppingCart');

  List<CheckableIngredient> suitedIngredients = [];

  for (var key in boxShoppingCart.keys) {
    for (CheckableIngredient i in boxShoppingCart.get(key).item2) {
      if (checked == null) {
        if (isSameIngredient(ingredient, i.getIngredient())) {
          suitedIngredients.add(i);
        }
      } else {
        if (isSameIngredient(ingredient, i.getIngredient()) &&
            checked == i.checked) {
          suitedIngredients.add(i);
        }
      }
    }
  }
  return suitedIngredients;
}

bool isSameIngredient(Ingredient ingredientOne, Ingredient ingredientTwo) {
  return (ingredientOne.name.compareTo(ingredientTwo.name) == 0 &&
      ((ingredientOne.amount != null && ingredientTwo.amount != null) ||
          (ingredientOne.amount == null && ingredientTwo.amount == null)) &&
      ((ingredientOne.unit == null && ingredientTwo.unit == null) ||
          (ingredientOne.unit != null &&
              ingredientTwo.unit != null &&
              ingredientOne.unit.compareTo(ingredientTwo.unit) == 0)));
}
