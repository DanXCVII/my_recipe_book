import 'dart:convert';
import 'dart:math';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'models/enums.dart';
import 'models/ingredient.dart';
import 'models/nutrition.dart';
import 'models/recipe.dart';
import 'models/recipe_sort.dart';
import 'models/shopping_cart_tuple.dart';

const String tmpRecipeKey = '000';

class BoxNames {
  static final recipes = "recipes";
  static final categories = "categories";
  static final recipeName = "recipeName";
  static final tmpRecipe = "tmpRecipe";
  static final favorites = "favorites";
  static final ingredientNames = "ingredientNames";
  static final order = "order";
  static final recipeSort = "recipeSort";
  static final shoppingCart = "shoppingCart";
  static final recipeCategories = "recipeCategories";
  static final vegetarian = Vegetable.VEGETARIAN.toString();
  static final vegan = Vegetable.VEGAN.toString();
  static final nonVegetarain = Vegetable.NON_VEGETARIAN.toString();
}

class HiveProvider {
  static final HiveProvider _singleton = HiveProvider._internal(
    Hive.box(BoxNames.recipes) as LazyBox,
    Hive.box<String>(BoxNames.vegetarian),
    Hive.box<String>(BoxNames.nonVegetarain),
    Hive.box<String>(BoxNames.vegan),
    Hive.box<String>(BoxNames.categories),
    Hive.box<String>(BoxNames.recipeName),
    Hive.box<Recipe>(BoxNames.tmpRecipe),
    Hive.box<String>(BoxNames.favorites),
    Hive.box<String>(BoxNames.ingredientNames),
    Hive.box<List<String>>(BoxNames.order),
    Hive.box<RSort>(BoxNames.recipeSort),
    Hive.box<List<CheckableIngredient>>(BoxNames.shoppingCart),
    Hive.box<List<String>>(BoxNames.recipeCategories),
  );

  LazyBox lazyBoxRecipes;
  Box<String> boxVegetarian;
  Box<String> boxNonVegetarian;
  Box<String> boxVegan;
  Box<String> boxCategories;
  Box<String> boxRecipeNames;
  Box<Recipe> boxTmpRecipe;

  Box<String> boxFavorites;
  Box<String> boxIngredientNames;

  Box<List<String>> boxOrder;
  Box<RSort> boxRecipeSort;
  Box<List<CheckableIngredient>> boxShoppingCart;
  Box<List<String>> boxRecipeCategories;

  factory HiveProvider() {
    return _singleton;
  }

  HiveProvider._internal(
    this.lazyBoxRecipes,
    this.boxVegetarian,
    this.boxNonVegetarian,
    this.boxVegan,
    this.boxCategories,
    this.boxRecipeNames,
    this.boxTmpRecipe,
    this.boxFavorites,
    this.boxIngredientNames,
    this.boxOrder,
    this.boxRecipeSort,
    this.boxShoppingCart,
    this.boxRecipeCategories,
  );

  ////////////// single recipe related //////////////
  Future<void> saveRecipe(Recipe newRecipe) async {
    // add recipe to recipes
    String hiveRecipeKey = getHiveKey(newRecipe.name);

    await lazyBoxRecipes.put(hiveRecipeKey, newRecipe);

    // add recipe to categories
    for (String categoryName in newRecipe.categories) {
      String hiveCategoryKey = getHiveKey(categoryName);
      await boxRecipeCategories.put(hiveCategoryKey,
          boxRecipeCategories.get(hiveCategoryKey)..add(hiveRecipeKey));
    }
    if (newRecipe.categories.isEmpty) {
      List<String> recipeNames = boxRecipeCategories.get('no category');
      await boxRecipeCategories.put(
          'no category', recipeNames..add(hiveRecipeKey));
    }
    print(lazyBoxRecipes.get(hiveRecipeKey));

    // add recipe to vegetable
    Box<String> boxVegetable = _getBoxVegetable(newRecipe.vegetable);
    boxVegetable.add(hiveRecipeKey);

    // add ingredients to ingredientNames
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
    String hiveOldRecipeKey = getHiveKey(oldRecipeName);
    String hiveNewRecipeKey = getHiveKey(newRecipe.name);

    Recipe editRecipe = await lazyBoxRecipes.get(hiveOldRecipeKey);

    // DELETE OLD RECIPE FROM HIVE

    for (String category in editRecipe.categories) {
      await boxRecipeCategories.put(
          getHiveKey(category),
          boxRecipeCategories.get(category)
            ..removeWhere((hiveRecipeKey) =>
                hiveRecipeKey.compareTo(hiveOldRecipeKey) == 0));
    }
    if (editRecipe.categories.isEmpty) {
      await boxRecipeCategories.put(
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

  Future<void> saveTmpRecipe(Recipe recipe) async {
    await boxTmpRecipe.put(tmpRecipeKey, recipe);
  }

// TODO: Check for mistakes
  Future<void> deleteRecipe(String recipeName) async {
    String hiveRecipeKey = getHiveKey(recipeName);
    Recipe removeRecipe = await lazyBoxRecipes.get(hiveRecipeKey);

    // delete recipe from categories
    if (removeRecipe.categories.isNotEmpty) {
      for (String categoryName in removeRecipe.categories) {
        if (boxRecipeCategories.get(categoryName).contains(hiveRecipeKey)) {
          await boxRecipeCategories.put(categoryName,
              boxRecipeCategories.get(categoryName)..remove(hiveRecipeKey));
        }
      }
    } else {
      await boxRecipeCategories.put('no category',
          boxRecipeCategories.get('no category')..remove(hiveRecipeKey));
    }

    // delete recipe from vegetable
    Box<String> boxVegetable = _getBoxVegetable(removeRecipe.vegetable);

    for (var key in boxVegetable.keys) {
      if (boxVegetable.get(key) == hiveRecipeKey) boxVegetable.delete(key);
    }

    // delete recipe from recipes
    lazyBoxRecipes.delete(hiveRecipeKey);
  }

  ////////////// category related //////////////
  Future<void> addCategory(String categoryName) async {
    // TODO: Verify if working

    String hiveCategoryKey = getHiveKey(categoryName);

    await boxCategories.put(hiveCategoryKey, categoryName);

    List<String> categories = boxOrder.get('categories');
    boxOrder.put(
        'categories', categories..insert(categories.length - 1, categoryName));

    await boxRecipeCategories.put(hiveCategoryKey, []);

    boxRecipeSort.add(RSort(RecipeSort.BY_NAME, true));
  }

  Future<void> renameCategory(String oldName, String newName) async {
    String hiveNewKey = getHiveKey(newName);
    String hiveOldKey = getHiveKey(oldName);

    List<String> recipes = boxRecipeCategories.get(hiveOldKey);
    boxRecipeCategories.delete(hiveOldKey);
    await boxRecipeCategories.put(hiveNewKey, recipes);

    boxCategories.delete(hiveOldKey);
    boxCategories.add(hiveNewKey);

    // TODO: Verify if working
    for (var key in lazyBoxRecipes.keys) {
      Recipe recipe = await lazyBoxRecipes.get(key);

      for (int i = 0; i < recipe.categories.length; i++) {
        if (recipe.categories[i].compareTo(oldName) == 0) {
          recipe.categories[i] = newName;
          await lazyBoxRecipes.put(key, recipe);
          break;
        }
      }
    }

    List<String> categories = boxOrder.get('categories');
    await boxOrder.put(
        'categories',
        categories
          ..remove(oldName)
          ..add(newName));
  }

  Future<void> deleteCategory(String categoryName) async {
    String hiveCategoryKey = getHiveKey(categoryName);
    await boxOrder.put(
        'categories', boxOrder.get('categories')..remove(categoryName));
    boxRecipeCategories.delete(hiveCategoryKey);
    boxRecipeSort.delete(hiveCategoryKey);

    for (var key in lazyBoxRecipes.keys) {
      Recipe currentRecipe = await lazyBoxRecipes.get(key);
      for (String category in currentRecipe.categories) {
        if (currentRecipe.categories.contains(category)) {
          currentRecipe.categories.remove(category);

          lazyBoxRecipes.put(key, currentRecipe);
          if (currentRecipe.categories.isEmpty) {
            boxRecipeCategories.put(
                'no category',
                boxRecipeCategories.get('no category')
                  ..add(getHiveKey(currentRecipe.name)));
          }
        }
      }
    }
  }

  /// returns the categories with "no category" included, in the user defined order
  List<String> getCategoryNames() {
    List<String> categories = [];
    for (String key in boxOrder.get('categories')) {
      categories.add(boxCategories.get(key));
    }
    return categories;
  }

  Future<void> moveCategory(int oldIndex, newIndex) async {
    List<String> categories = boxOrder.get('categories');

    String moveNutrition = categories[oldIndex];

    if (newIndex > oldIndex) newIndex -= 1;
    categories[oldIndex] = categories[newIndex];
    categories[newIndex] = moveNutrition;

    await boxOrder.put('categories', categories);
  }

  Future<void> changeSortOrder(RSort recipeSort, String category) async {
    String hiveCategoryKey = getHiveKey(category);
    await boxRecipeSort.put(hiveCategoryKey, recipeSort);
  }

  RSort getSortOrder(String category) {
    String hiveCategoryKey = getHiveKey(category);
    return boxRecipeSort.get(hiveCategoryKey);
  }

  ////////////// condition recipe getters //////////////
  Future<Recipe> getRecipeByName(String name) async {
    return await lazyBoxRecipes.get(getHiveKey(name));
  }

  Future<List<Recipe>> getFavoriteRecipes() async {
    List<Recipe> favoriteRecipes = [];

    for (var key in boxFavorites.keys) {
      favoriteRecipes.add(await lazyBoxRecipes.get(key));
    }

    return favoriteRecipes;
  }

  Future<List<Recipe>> getVegetableRecipes(Vegetable vegetable) async {
    Box<String> boxVegetable = _getBoxVegetable(vegetable);

    List<Recipe> recipes = [];
    for (var key in boxVegetable.keys) {
      recipes.add(await lazyBoxRecipes.get(boxVegetable.get(key)));
    }
    return recipes;
  }

  /// returns the list of recipes under this category and if non
  /// is existing, returns an empty list
  Future<List<Recipe>> getCategoryRecipes(String category) async {
    String categoryKey = getHiveKey(category);

    List<Recipe> recipes = [];
    for (var key in boxRecipeCategories.get(categoryKey)) {
      recipes.add(await lazyBoxRecipes.get(key));
    }
    return recipes;
  }

  Future<Recipe> getRandomRecipeOfCategory(
      {String category, Recipe excludedRecipe}) async {
    List<String> recipeKeys;

    if (category == null) {
      recipeKeys = lazyBoxRecipes.keys.map((key) => key as String).toList();
    } else {
      String categoryKey = getHiveKey(category);

      recipeKeys = boxRecipeCategories.get(categoryKey);
    }

    if (excludedRecipe != null) {
      String hiveRecipeKey = getHiveKey(excludedRecipe.name);
      recipeKeys.remove(hiveRecipeKey);
    }

    Random r = new Random();
    if (recipeKeys.length == 0) return null;

    int randomIndex = recipeKeys.length == 1 ? 0 : r.nextInt(recipeKeys.length);

    String randomRecipeHash = recipeKeys[randomIndex];
    return await lazyBoxRecipes.get(randomRecipeHash);
  }

  Recipe getTmpRecipe() {
    Recipe tmpRecipe = boxTmpRecipe.get(tmpRecipeKey);

    return tmpRecipe;
  }

  int getRecipeAmountCategory(String category) {
    return boxRecipeCategories.get(getHiveKey(category)).length;
  }

  ////////////// nutrition related //////////////
  Future<void> renameNutrition(String oldName, String newName) async {
    List<String> nutritions = boxOrder.get('nutritions');

    await boxOrder.put(
        'nutritions',
        nutritions
          ..remove(oldName)
          ..add(newName));

    // TODO: Verify if working
    for (var key in lazyBoxRecipes.keys) {
      Recipe oldHiveRecipe = await lazyBoxRecipes.get(key);

      for (Nutrition n in oldHiveRecipe.nutritions) {
        if (n.name.compareTo(oldName) == 0) {
          Recipe newHiveRecipe = oldHiveRecipe.copyWith(name: newName);
          await lazyBoxRecipes.put(
              getHiveKey(newHiveRecipe.name), newHiveRecipe);
          break;
        }
      }
    }
  }

  Future<void> addNutrition(String nutritionName) async {
    await boxOrder.put(
        'nutritions', boxOrder.get('nutritions')..add(nutritionName));
  }

  List<String> getNutritions() {
    List<String> nutritions = boxOrder.get('nutritions');

    return nutritions;
  }

  Future<void> moveNutrition(int oldIndex, newIndex) async {
    List<String> nutritions = boxOrder.get('nutritions');

    String moveNutrition = nutritions[oldIndex];

    if (newIndex > oldIndex) newIndex -= 1;
    nutritions[oldIndex] = nutritions[newIndex];
    nutritions[newIndex] = moveNutrition;

    await boxOrder.put('nutritions', nutritions);
  }

  Future<void> deleteNutrition(String nutritionName) async {
    List<String> nutritions = boxOrder.get('nutritions');

    nutritions.remove(nutritionName);

    await boxOrder.put('nutritions', nutritions);
  }

  ////////////// shopping cart related //////////////
  Map<String, List<CheckableIngredient>> getShoppingCart() {
    Map<String, List<CheckableIngredient>> shoppingCart = {};
    for (var key in boxShoppingCart.keys) {
      String recipeName =
          key == "summary" ? "summary" : boxRecipeNames.get(key);
      List<CheckableIngredient> ingredients = boxShoppingCart.get(key);
      shoppingCart.addAll({recipeName: ingredients});
    }
    return shoppingCart;
  }

  void addMulitpleIngredientsToCart(
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
    removeIngredientFromCart(recipeName, ingredient);
    addSingleIngredientToCart(recipeName, ingredient);
  }

// see removeAndAddIngredient
  Future<void> removeAndAddIngredients(
      String recipeName, List<Ingredient> ingredients) async {
    for (Ingredient i in ingredients) {
      await removeAndAddIngredient(recipeName, i);
    }
  }

  void removeIngredientsFromCart(
      String recipeName, List<Ingredient> ingredients) {
    for (Ingredient i in ingredients) {
      removeIngredientFromCart(recipeName, i);
    }
  }

  /// Checks if the given ingredient is in the list of the given
  /// recipe with a greater or equal amount
  bool checkForRecipeIngredient(String recipeName, Ingredient ingredient) {
    String hiveRecipeKey = getHiveKey(recipeName);

    if (boxShoppingCart.get(hiveRecipeKey) != null) {
      for (CheckableIngredient i in boxShoppingCart.get(hiveRecipeKey)) {
        if (i.amount == null &&
            ingredient.amount == null &&
            i.name == ingredient.name) {
          return true;
        }
        if (i.name == ingredient.name &&
            i.unit == ingredient.unit &&
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

  /// removes the ingrdients of the given recipe (if existing) from the list and
  /// also updates the summary
  Future<void> removeRecipeFromCart(String recipeName) async {
    String hiveRecipeKey = getHiveKey(recipeName);
    boxShoppingCart.delete(getHiveKey(recipeName));
    List<Ingredient> toBeRemoved = [];

    for (CheckableIngredient i in boxShoppingCart.get(hiveRecipeKey)) {
      toBeRemoved.add(Ingredient(
        name: i.name,
        amount: i.amount,
        unit: i.unit,
      ));
    }
    for (Ingredient i in toBeRemoved) {
      removeIngredientFromCart(recipeName, i);
    }
  }

  /// removes the ingrdient of the given recipe (if existing) from the list and
  /// also updates the summary
// TODO: Verified 80%, not tested
  void removeIngredientFromCart(
      String recipeName, Ingredient ingredient) async {
    String hiveRecipeKey = getHiveKey(recipeName);
    // check if the ingredient is saved under this recipe
    if (_getSuitingIngredientRecipe(
            ingredient, boxShoppingCart.get(hiveRecipeKey)) ==
        null) return;

    // given: the ingredient is saved under this recipe
    // if we want to remove an ingredient from the summary
    if (recipeName == 'summary') {
      // remove it form every entry in the shoppingCart
      for (var key in boxShoppingCart.keys) {
        for (CheckableIngredient i in boxShoppingCart.get(key)) {
          if (i.name == ingredient.name && i.unit == ingredient.unit) {
            await boxShoppingCart.put(
                key,
                List<CheckableIngredient>.from(boxShoppingCart.get(key))
                  ..remove(i));
            break;
          }
        }
      }
    } else {
      // remove ingredient from given recipe
      List<CheckableIngredient> ingredients =
          List<CheckableIngredient>.from(boxShoppingCart.get(hiveRecipeKey));
      int removeIngred = _getSuitingIngredientRecipe(ingredient, ingredients);
      double removeAmount = ingredients[removeIngred].amount;
      await boxShoppingCart.put(
          hiveRecipeKey, ingredients..remove(ingredients[removeIngred]));

      // get corresponding ingredient from summary
      int summaryIndex = _getSuitingIngredientRecipe(
          ingredient, boxShoppingCart.get("summary"));
      List<CheckableIngredient> summaryIngredients =
          List<CheckableIngredient>.from(boxShoppingCart.get("summary"));
      CheckableIngredient summaryIngred = ingredients[summaryIndex];

      // if the ingredient has an amount
      if (summaryIngred.amount != null && removeAmount != null) {
        // if the amount of the summary is greater than the one of the removed ingredient
        if (summaryIngred.amount - removeAmount > 0) {
          // upate the amount of the summary ingredient
          await boxShoppingCart.put(
              "summary",
              summaryIngredients
                ..replaceRange(summaryIndex, summaryIndex + 1, [
                  summaryIngred.copyWith(
                      amount: summaryIngred.amount - removeAmount)
                ]));
        } // the amount of the summary ingredient is equal to the amount of the removed ingredient
        else {
          // remove the ingredient from the summary
          await boxShoppingCart.put(
              'summary', summaryIngredients..removeAt(summaryIndex));
        }
      } // the to be removed ingredient doesn't have an amount
      else {
        // if the removed ingredient is only present in the summary, remove it from there
        if (_getIngredientCount(ingredient) == 1) {
          boxShoppingCart.get('summary').remove(summaryIngred);
        }
      }
    }

    _cleanUpEmptyRecipes();
  }

  int _getIngredientCount(Ingredient ingredient) {
    int ingredientCount = 0;

    for (var key in boxShoppingCart.keys) {
      for (CheckableIngredient i in boxShoppingCart.get(key)) {
        if (ingredient.name == i.name && ingredient.unit == i.unit) {
          ingredientCount++;
        }
      }
    }

    return ingredientCount;
  }

  /// checks/unchecks the given ingredient with the value of the given
  /// CheckableIngredient.checked and also updates the summary checked
  /// if necessary
// TODO: Verified, not tested
  Future<void> checkIngredient(
      String recipeName, CheckableIngredient ingredient) async {
    String hiveRecipeKey = getHiveKey(recipeName);

    if (recipeName != "summary") {
      List<CheckableIngredient> ingredients =
          List<CheckableIngredient>.from(boxShoppingCart.get(hiveRecipeKey));
      int modifiiedIndex =
          _getSuitingIngredientRecipe(ingredient.getIngredient(), ingredients);
      ingredients[modifiiedIndex] = ingredient;
      await boxShoppingCart.put(hiveRecipeKey, ingredients);

      if (_checkSummary(ingredient)) {
        _updateAll(ingredient);
      }
    } else {
      _updateAll(ingredient);
    }
  }

  /// checks or unchecks the ingredient in the summary depending on whether the ingredient
  /// is checked or not
  bool _checkSummary(CheckableIngredient ingredient) {
    if (ingredient.checked == true) {
      for (var key in boxShoppingCart.keys) {
        if (key != "summary") {
          List<CheckableIngredient> ingredients = boxShoppingCart.get(key);
          int i = _getSuitingIngredientRecipe(
              ingredient.getIngredient(), ingredients);
          if (i != null) {
            if (ingredients[i].checked == false) return false;
          }
        }
      }
      return true;
    } else {
      return false;
    }
  }

  Future<void> _updateAll(CheckableIngredient ingredient) async {
    for (var key in boxShoppingCart.keys) {
      List<CheckableIngredient> ingredients =
          List<CheckableIngredient>.from(boxShoppingCart.get(key));
      int ingredientIndex =
          _getSuitingIngredientRecipe(ingredient.getIngredient(), ingredients);

      if (ingredientIndex != null) {
        if (ingredients[ingredientIndex].checked != ingredient.checked) {
          ingredients[ingredientIndex] = ingredients[ingredientIndex]
              .copyWith(checked: ingredient.checked);
          await boxShoppingCart.put(key, ingredients);
        }
      }
    }
  }

  void _cleanUpEmptyRecipes() {
    for (var key in boxShoppingCart.keys) {
      if (key != 'summary' && boxShoppingCart.get(key).isEmpty) {
        boxShoppingCart.delete(key);
      }
    }
  }

  /// adds the ingredient to the given recipe only or updates the amount
  /// and sets checked = false (does not look for incorrect summary)
  Future<void> _addIngredientToRecipe(
      String recipeName, Ingredient ingredient) async {
    String hiveRecipeKey = getHiveKey(recipeName);

    // if we already have the recipe in our shoppingCard
    if (boxShoppingCart.keys.contains(hiveRecipeKey)) {
      List<CheckableIngredient> newIngredientList =
          List<CheckableIngredient>.from(boxShoppingCart.get(hiveRecipeKey));
      int indexIngred =
          _getSuitingIngredientRecipe(ingredient, newIngredientList);

      if (indexIngred != null) {
        CheckableIngredient modifyIngred = newIngredientList[indexIngred];
        double newAmount = modifyIngred.amount;
        if (modifyIngred.amount != null) {
          newAmount = ingredient.amount + modifyIngred.amount;
        }
        bool checked = false;
        await boxShoppingCart.put(
            hiveRecipeKey,
            newIngredientList
              ..replaceRange(indexIngred, indexIngred + 1, [
                modifyIngred.copyWith(amount: newAmount, checked: checked)
              ]));
      } else {
        // TODO: check if it works like that
        boxShoppingCart.get(hiveRecipeKey).add(CheckableIngredient(
            ingredient.name, ingredient.amount, ingredient.unit, false));
      }
    } // if we have to add the recipe with the ingredient to cart
    else {
      await boxShoppingCart.put(hiveRecipeKey, [
        CheckableIngredient(
            ingredient.name, ingredient.amount, ingredient.unit, false)
      ]);
    }
  }

  /// returns the ingredient of the recipe with the same name and unit if
  /// existing and otherwise null
  int _getSuitingIngredientRecipe(
      Ingredient ingredient, List<CheckableIngredient> ingredients) {
    for (int i = 0; i < ingredients.length; i++) {
      if (ingredient.name == ingredients[i].name &&
          ingredient.unit == ingredients[i].unit) return i;
    }
    return null;
  }

// see _getSuitingIngredientRecipe()
  List<CheckableIngredient> _getAllSuitingIngredients(Ingredient ingredient,
      {bool checked}) {
    List<CheckableIngredient> suitedIngredients = [];

    for (var key in boxShoppingCart.keys) {
      for (CheckableIngredient i in boxShoppingCart.get(key)) {
        if (checked == null) {
          if (ingredient == i.getIngredient()) {
            suitedIngredients.add(i);
          }
        } else {
          if (ingredient == i.getIngredient() && checked == i.checked) {
            suitedIngredients.add(i);
          }
        }
      }
    }
    return suitedIngredients;
  }

// bool isSameIngredient(Ingredient ingredientOne, Ingredient ingredientTwo) {
//   return (ingredientOne.name.compareTo(ingredientTwo.name) == 0 &&
//       ((ingredientOne.amount != null && ingredientTwo.amount != null) ||
//           (ingredientOne.amount == null && ingredientTwo.amount == null)) &&
//       ((ingredientOne.unit == null && ingredientTwo.unit == null) ||
//           (ingredientOne.unit != null &&
//               ingredientTwo.unit != null &&
//               ingredientOne.unit.compareTo(ingredientTwo.unit) == 0)));
// }

  ////////////// hive internal related //////////////
  String getHiveKey(String name) {
    if (name == "no category") return "no category";
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

  Box<String> _getBoxVegetable(Vegetable vegetable) {
    switch (vegetable) {
      case Vegetable.NON_VEGETARIAN:
        return boxNonVegetarian;
      case Vegetable.VEGAN:
        return boxVegan;
      case Vegetable.VEGETARIAN:
        return boxVegetarian;
      default:
        throw (ArgumentError);
    }
  }
}

// must(!) be executed before calling the HiveProvider
Future<void> initHive(bool firstTime) async {
  Hive.init((await getApplicationDocumentsDirectory()).path);
  if (firstTime) {
    Hive.registerAdapter(IngredientAdapter(), 1);
    Hive.registerAdapter(CheckableIngredientAdapter(), 2);
    Hive.registerAdapter(VegetableAdapter(), 3);
    Hive.registerAdapter(NutritionAdapter(), 4);
    Hive.registerAdapter(StringListTupleAdapter(), 5);
    Hive.registerAdapter(RecipeSortAdapter(), 6);
    Hive.registerAdapter(RSortAdapter(), 7);
    Hive.registerAdapter(RecipeAdapter(), 8);
  }

  await Hive.openBox<StringListTuple>("tuple");
  await Hive.openBox<Ingredient>("ingredient");
  await Hive.openBox(BoxNames.recipes, lazy: true);
  await Hive.openBox<String>(Vegetable.NON_VEGETARIAN.toString());
  await Hive.openBox<String>(Vegetable.VEGETARIAN.toString());
  await Hive.openBox<String>(Vegetable.VEGAN.toString());
  await Hive.openBox<String>(BoxNames.categories);
  await Hive.openBox<String>(BoxNames.recipeName);

  await Hive.openBox<String>(BoxNames.favorites);
  await Hive.openBox<String>(BoxNames.ingredientNames);

  await Hive.openBox<List<String>>(BoxNames.order);
  await Hive.openBox<RSort>(BoxNames.recipeSort);

  await Hive.openBox<List<CheckableIngredient>>(BoxNames.shoppingCart);
  await Hive.openBox<List<String>>(BoxNames.recipeCategories);

  await Hive.openBox<Recipe>(BoxNames.tmpRecipe);

  // initializing with the must have values
  if (Hive.box<Recipe>(BoxNames.tmpRecipe).keys.isEmpty) {
    await Hive.box<Recipe>(BoxNames.tmpRecipe)
        .put(tmpRecipeKey, Recipe(name: null, vegetable: null, servings: null));
  }

  if (Hive.box<String>(BoxNames.categories).keys.isEmpty)
    await Hive.box<String>(BoxNames.categories)
        .put('no category', 'no category');

  if (Hive.box<String>(BoxNames.recipeName).keys.isEmpty)
    await Hive.box<String>(BoxNames.recipeName).put('summary', 'summary');

  if (Hive.box<List<CheckableIngredient>>(BoxNames.shoppingCart).keys.isEmpty)
    await Hive.box<List<CheckableIngredient>>(BoxNames.shoppingCart)
        .put('summary', []);

  if (Hive.box<List<String>>(BoxNames.recipeCategories).keys.isEmpty)
    await Hive.box<List<String>>(BoxNames.recipeCategories)
        .put('no category', List<String>());

  if (Hive.box<List<String>>(BoxNames.order).keys.isEmpty) {
    Box<List<String>> boxOrder = Hive.box<List<String>>(BoxNames.order);
    await boxOrder.put('categories', ['no category']);
    await boxOrder.put('nutritions', List<String>());
  }
  // Recipe dummyRecipe = await DummyData().getDummyRecipe();
  // for (String category in dummyRecipe.categories) {
  //   addCategory(category);
  // }
  // saveRecipe(dummyRecipe);
}
