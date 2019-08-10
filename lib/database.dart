import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import './recipe.dart';
import 'dart:async';

// singleton DBProvider to ensure, that we only use one object
class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    await _onConfigure(_database);
    return _database;
  }

  _onConfigure(Database db) async {
    // Add support for cascade delete
    await db.execute('PRAGMA foreign_keys = ON');
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'TestDB.db');
    return await openDatabase(
      path,
      onConfigure: _onConfigure,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Recipe ('
            'id INTEGER PRIMARY KEY,'
            'recipeName TEXT,'
            'image TEXT,'
            'preperationTime REAL,'
            'cookingTime REAL,'
            'totalTime REAL,'
            'servings REAL,'
            'vegetable TEXT,'
            'notes TEXT,'
            'complexity INTEGER,'
            'isFavorite INTEGER'
            ')');
        await db.execute('CREATE TABLE Steps ('
            'id INTEGER PRIMARY KEY,'
            'number TEXT,'
            'description TEXT,'
            'recipe_id INTEGER,'
            'FOREIGN KEY(recipe_id) REFERENCES Recipe(id) ON DELETE CASCADE'
            ')');
        await db.execute('CREATE TABLE StepImages ('
            'id INTEGER PRIMARY KEY,'
            'image TEXT,'
            'steps_id INTEGER,'
            'FOREIGN KEY(steps_id) REFERENCES Steps(id) ON DELETE CASCADE'
            ')');
        await db.execute('CREATE TABLE Sections ('
            'id INTEGER PRIMARY KEY,'
            'number INTEGER,'
            'sectionName TEXT,'
            'recipe_id INTEGER,'
            'FOREIGN KEY(recipe_id) REFERENCES Recipe(id) ON DELETE CASCADE'
            ')');
        await db.execute('CREATE TABLE Ingredients ('
            'id INTEGER PRIMARY KEY,'
            'ingredientName TEXT,'
            'amount REAL,'
            'unit TEXT,'
            'section_id INTEGER,'
            'FOREIGN KEY(section_id) REFERENCES Sections(id) ON DELETE CASCADE'
            ')');
        await db.execute('CREATE TABLE Categories ('
            'id INTEGER PRIMARY KEY,'
            'categoryName TEXT,'
            'image TEXT'
            ')');
        await db.execute('CREATE TABLE RecipeCategories ('
            'recipe_id INTEGER,'
            'categories_id INTEGER,'
            'FOREIGN KEY(recipe_id) REFERENCES Recipe(id) ON DELETE CASCADE,'
            'FOREIGN KEY(categories_id) REFERENCES Categories(id) ON DELETE CASCADE'
            ')');
        await db.execute('CREATE TABLE ShoppingCart ('
            'item_id INTEGER PRIMARY KEY,'
            'name TEXT,'
            'amount REAL,'
            'unit,'
            'checked INTEGER'
            ')');
      },
    );
  }

  Future<int> getNewIDforTable(String tablename, String idName) async {
    print('DB.getNewIDforTable');
    final db = await database;
    // var completer = new Completer<int>();
    int output = 0;

    var table =
        await db.rawQuery('SELECT MAX($idName)+1 as id FROM $tablename');
    int id = table.first['id'];
    if (id != null) {
      output = id;
    }

    // completer.complete(output);
    // return completer.future;
    return output;
  }

  /// add new category to database with categoryname and
  /// picture if the user selected a picture
  newCategory(String name, String picture) async {
    final db = await database;

    await db.rawInsert(
        'INSERT Into Categories (id,categoryName,image)'
        ' VALUES (?,?,?)',
        [await getNewIDforTable('Categories', 'id'), name, picture]);
    return;
  }

  newRecipe(Recipe newRecipe) async {
    print('start DB.newRecipe()');
    final db = await database;

    String image = '';
    if (newRecipe.imagePath != null &&
        newRecipe.imagePath != 'images/radnomFood.png') {
      image = await PathProvider.pP.getRecipePath(newRecipe.id);
    } else {
      image = 'images/randomFood.png';
    }
    var resRecipe = await db.rawInsert(
        'INSERT Into Recipe ('
        'id,'
        'recipeName,'
        'image,'
        'preperationTime,'
        'cookingTime,'
        'totalTime,'
        'servings,'
        'vegetable,'
        'notes,'
        'complexity,'
        'isFavorite)'
        ' VALUES (?,?,?,?,?,?,?,?,?,?,?)',
        [
          newRecipe.id,
          newRecipe.name,
          image,
          newRecipe.preperationTime,
          newRecipe.cookingTime,
          newRecipe.totalTime,
          newRecipe.servings,
          newRecipe.vegetable.toString(),
          newRecipe.notes,
          newRecipe.complexity,
          0
        ]);
    for (int i = 0; i < newRecipe.ingredientsGlossary.length; i++) {
      int _sectionId = await getNewIDforTable('Sections', 'id');

      await db.rawInsert(
          'INSERT Into Sections (id,number,sectionName,recipe_id)'
          ' VALUES (?,?,?,?)',
          [_sectionId, i, newRecipe.ingredientsGlossary[i], newRecipe.id]);

      for (int j = 0; j < newRecipe.ingredients[i].length; j++) {
        await db.rawInsert(
            'INSERT Into Ingredients (id,ingredientName,amount,unit,section_id)'
            ' VALUES (?,?,?,?,?)',
            [
              await getNewIDforTable('Ingredients', 'id'),
              newRecipe.ingredients[i][j].name,
              newRecipe.ingredients[i][j].amount,
              newRecipe.ingredients[i][j].unit,
              _sectionId
            ]);
      }
    }
    for (int i = 0; i < newRecipe.steps.length; i++) {
      int stepsId = await getNewIDforTable('Steps', 'id');

      await db.rawInsert(
          'INSERT Into Steps (id,number,description,recipe_id)'
          ' VALUES (?,?,?,?)',
          [
            stepsId,
            i,
            newRecipe.steps[i],
            newRecipe.id,
          ]);
      if (newRecipe.stepImages.length > i) {
        for (int j = 0; j < newRecipe.stepImages[i].length; j++) {
          await db.rawInsert(
              'INSERT Into StepImages (id,image,steps_id)'
              ' VALUES (?,?,?)',
              [
                await getNewIDforTable('StepImages', 'id'),
                await PathProvider.pP.getRecipeStepPath(newRecipe.id, i, j),
                stepsId,
              ]);
        }
      }
    }

    List<String> categoryNames = newRecipe.categories;
    for (int i = 0; i < categoryNames.length; i++) {
      var resCategories = await db.query('Categories',
          where: 'categoryName = ?', whereArgs: [categoryNames[i]]);
      await db.rawInsert(
          'INSERT Into RecipeCategories (recipe_id,categories_id)'
          ' VALUES (?,?)',
          [
            newRecipe.id,
            resCategories[0]['id'],
          ]);
    }

    MainScreenRecipes singleton = MainScreenRecipes();
    for (int i = 0; i < newRecipe.categories.length; i++) {
      if (singleton.getRecipesOfCategory(newRecipe.categories[i]) != null) {
        singleton.addRecipeToCategory(newRecipe.categories[i], newRecipe);
      }
    }

    print('end DB.newRecipe()');
    return resRecipe;
  }

  Future<List<RecipeCategory>> getCategories() async {
    final db = await database;

    var resCategories = await db.rawQuery('SELECT * FROM Categories');
    List<RecipeCategory> categories = new List<RecipeCategory>();
    for (int i = 0; i < resCategories.length; i++) {
      categories.add(RecipeCategory(
          name: resCategories[i]['categoryName'],
          imagePath: resCategories[i]['image']));
    }
    return categories;
  }

  getRecipeById(int id) async {
    print('getRecipeById(id)');
    final db = await database;
    var resRecipe = await db.query('Recipe', where: 'id = ?', whereArgs: [id]);
    if (resRecipe.isEmpty) {
      return Null;
    }
    String name = resRecipe.first['recipeName'];
    String image;
    if (resRecipe.first['image'] != '') {
      image = resRecipe.first['image'];
    }

    double preperationTime = resRecipe.first['preperationTime'];
    double cookingTime = resRecipe.first['cookingTime'];
    double totalTime = resRecipe.first['totalTime'];
    double servings = resRecipe.first['servings'];
    int complexity = resRecipe.first['complexity'];
    bool isFavorite;
    if (resRecipe.first['isFavorite'] == 1) {
      isFavorite = true;
    } else {
      isFavorite = false;
    }
    Vegetable vegetable;

    if (resRecipe.first['vegetable'] == 'Vegetable.NON_VEGETARIAN')
      vegetable = Vegetable.NON_VEGETARIAN;
    else if (resRecipe.first['vegetable'] == 'Vegetable.VEGETARIAN')
      vegetable = Vegetable.VEGETARIAN;
    else if (resRecipe.first['vegetable'] == 'Vegetable.VEGAN')
      vegetable = Vegetable.VEGAN;
    String notes = resRecipe.first['notes'];

    var resSteps = await db.rawQuery(
        'SELECT * FROM Steps WHERE recipe_id=$id ORDER BY number ASC');
    List<String> steps = new List<String>();
    List<List<String>> stepImages = new List<List<String>>();
    for (int i = 0; i < resSteps.length; i++) {
      steps.add(resSteps[i]['description']);
      var resStepImages = await db.rawQuery(
          'SELECT * FROM StepImages WHERE steps_id=${resSteps[i]['id']} ORDER BY id ASC');
      stepImages.add(new List<String>());
      for (int j = 0; j < resStepImages.length; j++) {
        stepImages[i].add(resStepImages[j]['image']);
      }
    }

    var resSections = await db.rawQuery(
        'SELECT * FROM Sections WHERE recipe_id=$id ORDER BY number ASC');
    List<String> ingredientsGlossary = new List<String>();
    List<List<Ingredient>> ingredients = [[]];
    for (int i = 0; i < resSections.length; i++) {
      ingredientsGlossary.add(resSections[i]['sectionName']);
      var resIngredients = await db.rawQuery(
          'SELECT * FROM Ingredients WHERE section_id=${resSections[i]['id']}');
      ingredients.add([]);
      for (int j = 0; j < resIngredients.length; j++) {
        ingredients[i].add(Ingredient(resIngredients[j]['ingredientName'],
            resIngredients[j]['amount'], resIngredients[j]['unit']));
      }
    }

    List<String> categories = new List<String>();
    var resCategories = await db.rawQuery(
        'SELECT * FROM RecipeCategories INNER JOIN Categories ON Categories.id=RecipeCategories.categories_id'
        ' WHERE recipe_id=$id');
    for (int i = 0; i < resCategories.length; i++) {
      categories.add(resCategories[i]['categoryName']);
    }

    return Recipe(
        id: id,
        name: name,
        imagePath: image,
        imagePreviewPath: image == "images/randomFood.png"
            ? 'images/randomFood.png'
            : await PathProvider.pP.getRecipePreviewPath(id),
        preperationTime: preperationTime,
        cookingTime: cookingTime,
        totalTime: totalTime,
        servings: servings,
        ingredientsGlossary: ingredientsGlossary,
        ingredients: ingredients,
        vegetable: vegetable,
        stepImages: stepImages,
        steps: steps,
        notes: notes,
        categories: categories,
        complexity: complexity,
        isFavorite: isFavorite);
  }

  Future<void> deleteRecipe(Recipe recipe) async {
    final db = await database;

    MainScreenRecipes singleton = MainScreenRecipes();
    for (int i = 0; i < recipe.categories.length; i++) {
      if (singleton.getRecipesOfCategory(recipe.categories[i]) != null) {
        singleton.removeRecipeFromCategory(recipe.categories[i], recipe);
      }
    }

    await db.rawDelete('DELETE FROM Recipe WHERE id= ?', [recipe.id]);

    Directory appDir = await getApplicationDocumentsDirectory();
    String imageLocalPathRecipe = '${appDir.path}/${recipe.id}/';
    var dir = new Directory(imageLocalPathRecipe);
    dir.deleteSync(recursive: true);
  }

  Future<String> getRandomRecipeImageFromCategory(String categoryName) async {
    var db = await database;

    var resRecipes = await db.rawQuery(
        'SELECT Recipe.id, Recipe.image FROM RecipeCategories '
        'INNER JOIN Categories ON RecipeCategories.categories_id=Categories.id '
        'INNER JOIN Recipe ON RecipeCategories.recipe_id=Recipe.id '
        "WHERE categoryName = '$categoryName'");

    Random r = Random();
    if (resRecipes.length == 0) return '';
    int randomRecipe =
        resRecipes.length == 1 ? 0 : r.nextInt(resRecipes.length);

    return resRecipes[randomRecipe]['image'] != 'images/randomFood.png'
        ? await PathProvider.pP
            .getRecipePreviewPath(resRecipes[randomRecipe]['id'])
        : 'images/randomFood.png';
  }

  Future<void> addToShoppingList(List<Ingredient> ingredients) async {
    final db = await database;
    Batch batch = db.batch();

    int _shoppingCartId = await getNewIDforTable('ShoppingCart', 'item_id');
    for (int i = 0; i < ingredients.length; i++) {
      // Check if there is already one of the ingredients in the ShoppinCart table
      var resShoppingCart = await db.rawQuery('SELECT * FROM ShoppingCart '
          "WHERE name = '${ingredients[i].name}' AND "
          "unit = '${ingredients[i].unit}' AND "
          'checked = 0');
      // If not, insert new one
      if (resShoppingCart.isEmpty) {
        batch.insert('ShoppingCart', {
          'item_id': '${_shoppingCartId + i}',
          'name': '${ingredients[i].name}',
          'amount': '${ingredients[i].amount}',
          'unit': '${ingredients[i].unit}',
          'checked': '0'
        });
        // Else, update the amount
      } else {
        await db.rawUpdate(
            'UPDATE ShoppingCart SET amount = (amount + ${ingredients[i].amount}) '
            "WHERE name = '${ingredients[i].name}'");
      }
    }
    await batch.commit();
  }

  Future<void> checkIngredient(Ingredient ingredient, bool checked) async {
    final db = await database;
    int checkedInt = 0;
    if (checked) checkedInt = 1;
    await db.rawUpdate('UPDATE ShoppingCart SET checked = $checkedInt '
        'WHERE name = \'${ingredient.name}\' AND amount = ${ingredient.amount} AND unit = \'${ingredient.unit}\'');
  }

  Future<void> deleteFromShoppingCart(Ingredient ingredient) async {
    final db = await database;
    await db.rawDelete(
        'DELETE FROM ShoppingCart WHERE name = \'${ingredient.name}\' AND '
        'amount = ${ingredient.amount} AND unit = \'${ingredient.unit}\'');
  }

  Future<void> removeFromShoppingCart(List<Ingredient> ingredients) async {
    final db = await database;
    Batch batch = db.batch();

    for (int i = 0; i < ingredients.length; i++) {
      // Select the amount of the ingredient in the shoppingCart
      var resShoppingCart =
          await db.rawQuery('SELECT amount FROM ShoppingCart WHERE '
              'name = \'${ingredients[i].name}\' '
              'AND unit = \'${ingredients[i].unit}\' '
              'AND checked = 0');
      // if the updated amount is 0, delete the ingredient from the shoppingCart
      if (resShoppingCart[0]['amount'] - ingredients[i].amount <= 0) {
        await deleteFromShoppingCart(ingredients[i]);
      } // else, update the amount
      else {
        double newAmount = resShoppingCart[0]['amount'] - ingredients[i].amount;
        batch.update('ShoppingCart', {'amount': '$newAmount'},
            where: 'name = ? AND amount = ? AND unit = ?',
            whereArgs: [
              '${ingredients[i].name}',
              '${resShoppingCart[0]['amount']}',
              '${ingredients[i].unit}'
            ]);
      }
    }
    await batch.commit();
  }

  Future<ShoppingCart> getShoppingCartIngredients() async {
    final db = await database;
    List<Ingredient> ingredients = [];
    List<bool> checked = [];
    var resShoppingCart = await db.rawQuery('SELECT * FROM ShoppingCart');
    for (int i = 0; i < resShoppingCart.length; i++) {
      ingredients.add(Ingredient(resShoppingCart[i]['name'],
          resShoppingCart[i]['amount'], resShoppingCart[i]['unit']));
      resShoppingCart[i]['checked'] == 0
          ? checked.add(false)
          : checked.add(true);
    }
    return (ShoppingCart(
      ingredients: ingredients,
      checked: checked,
    ));
  }

  Future<List<Recipe>> getRecpiesOfCategori(String categoryName) async {
    final db = await database;
    // alle daten von recipe
    var resRecipes = await db.rawQuery('SELECT * FROM RecipeCategories '
        'INNER JOIN Categories ON Categories.id=RecipeCategories.categories_id '
        'INNER JOIN Recipe ON Recipe.id=RecipeCategories.recipe_id '
        "WHERE categoryName=\'$categoryName\' "
        'ORDER BY recipe_id ASC');

    // ingredients
    var resIngredients = await db.rawQuery('SELECT * FROM Ingredients '
        'NATURAL INNER JOIN Sections '
        'WHERE recipe_id IN (SELECT recipe_id FROM RecipeCategories '
        'INNER JOIN Categories ON Categories.id=RecipeCategories.categories_id '
        "WHERE categoryName=\'$categoryName\') "
        'ORDER BY recipe_id ASC, '
        'number ASC');
    print(resIngredients.toString());

    var resSteps = await db.rawQuery('SELECT * FROM StepImages '
        'NATURAL INNER JOIN Steps '
        'WHERE recipe_id IN (SELECT recipe_id FROM RecipeCategories '
        'INNER JOIN Categories ON Categories.id=RecipeCategories.categories_id '
        "WHERE categoryName=\'$categoryName\') "
        'ORDER BY recipe_id ASC, '
        'number ASC');
    print(resSteps);

    var resCategories = await db.rawQuery('SELECT * FROM RecipeCategories '
        'NATURAL INNER JOIN Recipe '
        'NATURAL INNER JOIN Categories '
        "WHERE categoryName=\'$categoryName\'"
        'ORDER BY recipe_id ASC');

    List<Recipe> recipes = [];
    int j = 0; // index der ingredients
    int l = 0; // index der steps
    int k = 0; // index der sections
    int m = 0; // index der categories
    List<List<Ingredient>> ingredients = [[]];
    List<String> ingredientsGlossary = [];
    List<List<String>> stepImages = [[]];
    List<String> steps = [];
    List<String> categories = [];

    for (int i = 0; i < resRecipes.length; i++) {
      if (resIngredients.length > j &&
          resIngredients[j]['recipe_id'] == resRecipes[i]['id']) {
        k = 0;
        ingredients = [[]];
        ingredientsGlossary = [];
        ingredientsGlossary.add(resIngredients[j]['sectionName']);
        ingredients.add([]);
        k = 0;
        ingredients[k].add(Ingredient(
          resIngredients[j]['Ingredients.name'],
          resIngredients[j]['amount'],
          resIngredients[j]['unit'],
        ));
        while (resIngredients.length > j + 1 &&
            resIngredients[j]['recipe_id'] == resRecipes[i]['id'] &&
            resIngredients[j + 1]['recipe_id'] ==
                resIngredients[j]['recipe_id']) {
          if (resIngredients[j]['number'] < resIngredients[j + 1]['number']) {
            k++;
            ingredientsGlossary.add(resIngredients[j + 1]['sectionName']);
            ingredients.add([]);
          }
          ingredients[k].add(Ingredient(
            resIngredients[j + 1]['Ingredients.name'],
            resIngredients[j + 1]['amount'],
            resIngredients[j + 1]['unit'],
          ));
          j++;
        }
        j++;
      } // Steps

      if (resSteps.length > l &&
          resSteps[l]['recipe_id'] == resRecipes[i]['id']) {
        k = 0;
        stepImages = [[]];
        steps = [];
        steps.add(resSteps[l]['description']);
        stepImages.add([]);
        k = 0;
        stepImages[k].add(resSteps[l]['image']);
        while (resSteps.length > l + 1 &&
            resSteps[l]['recipe_id'] == resRecipes[i]['id'] &&
            resSteps[l + 1]['recipe_id'] == resSteps[l]['recipe_id']) {
          if (resSteps[l]['number'] < resSteps[l + 1]['number']) {
            k++;
            ingredientsGlossary.add(resSteps[l + 1]['description']);
            ingredients.add([]);
          }
          stepImages[k].add(resSteps[l + 1]['image']);

          l++;
        }
        l++;
      }
      categories = [];

      while (resCategories.length > m &&
          resCategories[m]['recipe_id'] == resRecipes[i]['id']) {
        categories.add(resCategories[m]['name']);
        m++;
      }

      String imagePath = resRecipes[i]['image'];

      Vegetable vegetable;

      if (resRecipes[i]['vegetable'] == 'Vegetable.NON_VEGETARIAN')
        vegetable = Vegetable.NON_VEGETARIAN;
      else if (resRecipes[i]['vegetable'] == 'Vegetable.VEGETARIAN')
        vegetable = Vegetable.VEGETARIAN;
      else if (resRecipes[i]['vegetable'] == 'Vegetable.VEGAN')
        vegetable = Vegetable.VEGAN;

      bool isFavorite;
      if (resRecipes[i]['isFavorite'] == 1) {
        isFavorite = true;
      } else {
        isFavorite = false;
      }

      recipes.add(Recipe(
          id: resRecipes[i]['id'],
          name: resRecipes[i]['recipeName'],
          imagePath: resRecipes[i]['image'],
          imagePreviewPath: imagePath == "images/randomFood.png"
              ? 'images/randomFood.png'
              : await PathProvider.pP.getRecipePreviewPath(resRecipes[i]['id']),
          preperationTime: resRecipes[i]['preperationTime'],
          cookingTime: resRecipes[i]['cookingTime'],
          totalTime: resRecipes[i]['totalTime'],
          servings: resRecipes[i]['servings'],
          ingredientsGlossary: ingredientsGlossary,
          ingredients: ingredients,
          vegetable: vegetable,
          notes: resRecipes[i]['notes'],
          complexity: resRecipes[i]['complexity'],
          isFavorite: isFavorite,
          stepImages: stepImages,
          steps: steps,
          categories: categories));
    }
    return recipes;
  }

  Future<List<Recipe>> getRecipesOfCategory(String categoryName) async {
    MainScreenRecipes singleton = MainScreenRecipes();
    if (singleton.recipes[categoryName] != null)
      return singleton.recipes[categoryName];

    final db = await database;

    var resCategories = await db.rawQuery('SELECT * FROM RecipeCategories '
        'INNER JOIN Categories ON Categories.id=RecipeCategories.categories_id '
        'WHERE categoryName=\'$categoryName\'');
    List<Recipe> output = new List<Recipe>();
    for (int i = 0; i < resCategories.length; i++) {
      print('#####################');
      print(resCategories[i]['recipe_id']);
      print('#####################');
      Recipe newRecipe = await getRecipeById(resCategories[i]['recipe_id']);
      output.add(newRecipe);
    }
    return output;
  }

  Future<List<Recipe>> getRecipesOfNoCategory() async {
    final db = await database;

    List<Recipe> recipes = [];
    var resRecipe = await db.rawQuery('SELECT id FROM Recipe '
        'WHERE id NOT IN (SELECT recipe_id FROM RecipeCategories)');

    for (int i = 0; i < resRecipe.length; i++) {
      recipes.add(await getRecipeById(resRecipe[i]['id']));
    }

    return recipes;
  }

  Future<List<Recipe>> getFavoriteRecipes() async {
    var db = await database;

    List<Recipe> favorites = [];

    var resFavorites =
        await db.query('Recipe', where: 'isFavorite = ?', whereArgs: ['1']);

    for (int i = 0; i < resFavorites.length; i++) {
      favorites.add(await getRecipeById(resFavorites[i]['id']));
    }
    return favorites;
  }

  Future<void> updateFavorite(bool status, int recipeId) async {
    final db = await database;
    int newStatus;
    if (status) {
      newStatus = 1;
    } else {
      newStatus = 0;
    }
    await db.rawUpdate(
        'UPDATE Recipe SET isFavorite = $newStatus WHERE id=$recipeId');
  }
}

class MainScreenRecipes {
  MainScreenRecipes._privateConstructor();
  Map<String, List<Recipe>> recipes = {};

  static final MainScreenRecipes _instance =
      MainScreenRecipes._privateConstructor();

  factory MainScreenRecipes() {
    return _instance;
  }

  void addRecipes(String category, List<Recipe> recipes) {
    this.recipes.addAll({category: recipes});
  }

  void addRecipeToCategory(String category, Recipe recipe) {
    List<Recipe> newRecipes = recipes[category];
    newRecipes.add(recipe);
    recipes[category] = newRecipes;
  }

  void removeRecipeFromCategory(String category, Recipe recipe) {
    List<Recipe> newRecipes = recipes[category];
    newRecipes.remove(recipe);
    recipes[category] = newRecipes;
  }

  List<Recipe> getRecipesOfCategory(String categoryName) {
    return recipes[categoryName];
  }
}
