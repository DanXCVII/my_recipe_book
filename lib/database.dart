import 'dart:io';
import 'package:my_recipe_book/helper.dart';
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
            'recipe_name TEXT PRIMARY KEY,'
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
            'recipe_name INTEGER,'
            'FOREIGN KEY(recipe_name) REFERENCES Recipe(recipe_name) ON DELETE CASCADE'
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
            'recipe_name INTEGER,'
            'FOREIGN KEY(recipe_name) REFERENCES Recipe(recipe_name) ON DELETE CASCADE'
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
            'categoryName TEXT PRIMARY KEY,'
            'number TEXT'
            ')');
        await db.execute('CREATE TABLE RecipeCategories ('
            'recipe_name INTEGER,'
            'categories_name TEXT,'
            'FOREIGN KEY(recipe_name) REFERENCES Recipe(recipe_name) ON DELETE CASCADE,'
            'FOREIGN KEY(categories_name) REFERENCES Categories(categoryName) ON DELETE CASCADE'
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
  newCategory(String name) async {
    final db = await database;
    try {
      await db.rawInsert(
          'INSERT Into Categories (categoryName,number)'
          ' VALUES (?,?)',
          [
            name,
            await getNewIDforTable('Categories', 'number'),
          ]);
    } catch (e) {
      print('Error adding recipe\n'
          '${e.toString()}');
    }

    return;
  }

  removeCategory(String name) async {
    final db = await database;

    await db.rawDelete('DELETE FROM Categories WHERE categoryName= ?', [name]);
    return;
  }

  /// the path to the imageFiles must be specified like the the following:
  /// path from appDir to imageFile:
  /// example: /4/recipe-4.jpg
  newRecipe(Recipe newRecipe) async {
    final db = await database;
    Batch batch = db.batch();

    batch.insert('Recipe', {
      'recipe_name': newRecipe.name,
      'image': newRecipe.imagePath,
      'preperationTime': newRecipe.preperationTime,
      'cookingTime': newRecipe.cookingTime,
      'totalTime': newRecipe.totalTime,
      'servings': newRecipe.servings,
      'vegetable': newRecipe.vegetable.toString(),
      'notes': newRecipe.notes,
      'complexity': newRecipe.effort,
      'isFavorite': 0
    });

    int uniqueIdSections = await getNewIDforTable('Sections', 'id');
    int uniqueIdIngredients = await getNewIDforTable('Ingredients', 'id');

    for (int i = 0; i < newRecipe.ingredientsGlossary.length; i++) {
      batch.insert('Sections', {
        'id': uniqueIdSections + i,
        'number': i,
        'sectionName': newRecipe.ingredientsGlossary[i],
        'recipe_name': newRecipe.name
      });

      for (int j = 0; j < newRecipe.ingredients[i].length; j++) {
        batch.insert('Ingredients', {
          'id': uniqueIdIngredients + j,
          'ingredientName': newRecipe.ingredients[i][j].name,
          'amount': newRecipe.ingredients[i][j].amount,
          'unit': newRecipe.ingredients[i][j].unit,
          'section_id': uniqueIdSections + i
        });
      }
      uniqueIdIngredients += newRecipe.ingredients[i].length;
    }

    int uniqueIdSteps = await getNewIDforTable('Steps', 'id');
    int uniqueIdStepImages = await getNewIDforTable('StepImages', 'id');

    for (int i = 0; i < newRecipe.steps.length; i++) {
      batch.insert('Steps', {
        'id': uniqueIdSteps + i,
        'number': i,
        'description': newRecipe.steps[i],
        'recipe_name': newRecipe.name
      });

      if (newRecipe.stepImages.length > i) {
        for (int j = 0; j < newRecipe.stepImages[i].length; j++) {
          batch.insert('StepImages', {
            'id': uniqueIdStepImages + j,
            'image': newRecipe.stepImages[i][j],
            'steps_id': uniqueIdSteps + i
          });
        }
        uniqueIdStepImages += newRecipe.stepImages[i].length;
      }
    }

    List<String> categoryNames = newRecipe.categories;
    for (int i = 0; i < categoryNames.length; i++) {
      var resCategories = await db.query('Categories',
          where: 'categoryName = ?', whereArgs: [categoryNames[i]]);
      batch.insert('RecipeCategories', {
        'recipe_name': newRecipe.name,
        'categories_name': resCategories[0]['categoryName'],
      });

/*
    MainScreenRecipes singleton = MainScreenRecipes();
    for (int i = 0; i < newRecipe.categories.length; i++) {
      if (singleton.getRecipesOfCategory(newRecipe.categories[i]) != null) {
        singleton.addRecipeToCategory(newRecipe.categories[i], newRecipe);
      }
    }
*/
    }
    await batch.commit();
  }

  Future<void> updateCategoryOrder(List<String> categories) async {
    final db = await database;
    Batch b = db.batch();

    for (int i = 0; i < categories.length; i++) {
      b.update('Categories', {'number': i},
          where: 'categoryName = ?', whereArgs: ['${categories[i]}']);
    }
    await b.commit();
  }

  Future<List<String>> getCategoriesWithRecipes() async {
    final db = await database;

    var resCategories = await db.rawQuery(
      'SELECT categoryName, count(recipe_name) FROM Categories '
      'INNER JOIN RecipeCategories ON Categories.categoryName = RecipeCategories.categories_name '
      'GROUP BY categoryName '
      'HAVING COUNT(*) > 0 '
      'ORDER BY number',
    );

    List<String> categories = [];
    for (int i = 0; i < resCategories.length; i++) {
      categories.add(resCategories[i]['categoryName']);
    }
    return categories;
  }

  Future<List<String>> getCategories() async {
    final db = await database;

    var resCategories =
        await db.rawQuery('SELECT * FROM Categories ORDER BY number');
    List<String> categories = [];
    for (int i = 0; i < resCategories.length; i++) {
      categories.add(resCategories[i]['categoryName']);
    }
    return categories;
  }

  getRecipeByName(String recipeName, bool fullImagePaths) async {
    final db = await database;
    final appDir = await getApplicationDocumentsDirectory();
    String preString;
    fullImagePaths ? preString = appDir.path : preString = '';

    var resRecipe = await db
        .query('Recipe', where: 'recipe_name = ?', whereArgs: [recipeName]);
    if (resRecipe.isEmpty) {
      return Null;
    }
    String name = resRecipe.first['recipe_name'];
    String image;
    if (resRecipe.first['image'] != 'images/randomFood.png') {
      image = preString + resRecipe.first['image'];
    } else {
      image = resRecipe.first['image'];
    }
    String previewPath;
    image == "images/randomFood.png"
        ? previewPath = 'images/randomFood.png'
        : previewPath = await PathProvider.pP.getRecipePreviewPathFull(
            name, image.substring(image.length - 4, image.length));

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
        'SELECT * FROM Steps WHERE recipe_name=$recipeName ORDER BY number ASC');
    List<String> steps = [];
    List<List<String>> stepImages = [];
    for (int i = 0; i < resSteps.length; i++) {
      steps.add(resSteps[i]['description']);
      var resStepImages = await db.rawQuery(
          'SELECT * FROM StepImages WHERE steps_id=${resSteps[i]['id']} ORDER BY id ASC');
      stepImages.add([]);
      for (int j = 0; j < resStepImages.length; j++) {
        stepImages[i].add(preString + resStepImages[j]['image']);
      }
    }

    var resSections = await db.rawQuery(
        'SELECT * FROM Sections WHERE recipe_name=$recipeName ORDER BY number ASC');
    List<String> ingredientsGlossary = new List<String>();
    List<List<Ingredient>> ingredients = [[]];
    for (int i = 0; i < resSections.length; i++) {
      ingredientsGlossary.add(resSections[i]['sectionName']);
      var resIngredients = await db.rawQuery(
          'SELECT * FROM Ingredients WHERE section_id=${resSections[i]['id']}');
      ingredients.add([]);
      for (int j = 0; j < resIngredients.length; j++) {
        ingredients[i].add(Ingredient(
          name: resIngredients[j]['ingredientName'],
          amount: resIngredients[j]['amount'],
          unit: resIngredients[j]['unit'],
        ));
      }
    }

    List<String> categories = new List<String>();
    var resCategories = await db.rawQuery('SELECT * FROM RecipeCategories '
        'INNER JOIN Categories ON Categories.categoryName=RecipeCategories.categories_name '
        'WHERE recipe_name=$recipeName');
    for (int i = 0; i < resCategories.length; i++) {
      categories.add(resCategories[i]['categoryName']);
    }

    return Recipe(
        name: name,
        imagePath: image,
        imagePreviewPath: previewPath,
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
        effort: complexity,
        isFavorite: isFavorite);
  }

  Future<dynamic> getRecipePreviewByName(
      String recipeName, bool fullImagePaths) async {
    final db = await database;
    final appDir = await getApplicationDocumentsDirectory();
    String preString;
    fullImagePaths ? preString = appDir.path : preString = '';

    var resRecipe = await db
        .query('Recipe', where: 'recipe_name = ?', whereArgs: [recipeName]);
    if (resRecipe.isEmpty) {
      return Null;
    }
    String name = resRecipe.first['recipe_name'];
    String image;
    if (resRecipe.first['image'] != 'images/randomFood.png') {
      image = preString + resRecipe.first['image'];
    } else {
      image = resRecipe.first['image'];
    }
    String previewPath;
    image == "images/randomFood.png"
        ? previewPath = 'images/randomFood.png'
        : previewPath = await PathProvider.pP.getRecipePreviewPathFull(
            name, image.substring(image.length - 4, image.length));

    double rTotalTime = resRecipe.first['totalTime'];

    String totalTime = getTimeHoursMinutes(rTotalTime);

    int effort = resRecipe.first['complexity'];
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

    var resSections = await db.rawQuery(
        'SELECT * FROM Sections WHERE recipe_name=$recipeName ORDER BY number ASC');
    int ingredientAmount = 0;
    for (int i = 0; i < resSections.length; i++) {
      var resIngredients = await db.rawQuery(
          'SELECT * FROM Ingredients WHERE section_id=${resSections[i]['id']}');
      ingredientAmount += resIngredients.length;
    }

    List<String> categories = new List<String>();
    var resCategories = await db.rawQuery('SELECT * FROM RecipeCategories '
        'INNER JOIN Categories ON Categories.categoryName=RecipeCategories.categories_name '
        'WHERE recipe_name=$recipeName');
    for (int i = 0; i < resCategories.length; i++) {
      categories.add(resCategories[i]['categoryName']);
    }

    return RecipePreview(
        name: name,
        imagePreviewPath: previewPath,
        totalTime: totalTime,
        ingredientsAmount: ingredientAmount,
        vegetable: vegetable,
        categories: categories,
        effort: effort,
        isFavorite: isFavorite);
  }

  Future<List<String>> getRecipeNames() async {
    var db = await database;

    var resRecipes = await db.rawQuery('SELECT recipeName FROM recipe');

    List<String> recipeNames = [];

    for (int i = 0; i < resRecipes.length; i++) {
      recipeNames.add(resRecipes[i]['recipeName']);
    }
    return recipeNames;
  }

  Future<void> deleteRecipeFromDatabase(Recipe recipe) async {
    final db = await database;

    await db.rawDelete('DELETE FROM Recipe WHERE recipe_name= ?', [recipe.name]);
  }

  Future<void> deleteRecipe(Recipe recipe) async {
    final db = await database;
    /*
    MainScreenRecipes singleton = MainScreenRecipes();
    for (int i = 0; i < recipe.categories.length; i++) {
      if (singleton.getRecipesOfCategory(recipe.categories[i]) != null) {
        singleton.removeRecipeFromCategory(recipe.categories[i], recipe);
      }
    }
*/
    await db.rawDelete('DELETE FROM Recipe WHERE recipe_name= ?', [recipe.name]);

    Directory appDir = await getApplicationDocumentsDirectory();
    String imageLocalPathRecipe = '${appDir.path}/.${recipe.name}/';
    var dir = new Directory(imageLocalPathRecipe);
    if (await dir.exists()) dir.deleteSync(recursive: true);
  }

  Future<String> getRandomRecipeImageFromCategory(String categoryName) async {
    var db = await database;

    var resRecipes = await db.rawQuery(
        'SELECT Recipe.id, Recipe.image FROM RecipeCategories '
        'INNER JOIN Categories ON RecipeCategories.categories_name=Categories.categoryName '
        'INNER JOIN Recipe ON RecipeCategories.recipe_name=Recipe.recipe_name '
        "WHERE categoryName = '$categoryName'");

    Random r = Random();
    if (resRecipes.length == 0) return '';
    int randomRecipe =
        resRecipes.length == 1 ? 0 : r.nextInt(resRecipes.length);

    return resRecipes[randomRecipe]['image'] != 'images/randomFood.png'
        ? await PathProvider.pP.getRecipePreviewPathFull(
            resRecipes[randomRecipe]['id'],
            // dataType
            resRecipes[randomRecipe]['image'].substring(
                resRecipes[randomRecipe]['image'].length - 4,
                resRecipes[randomRecipe]['image'].length))
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
      ingredients.add(Ingredient(
        name: resShoppingCart[i]['name'],
        amount: resShoppingCart[i]['amount'],
        unit: resShoppingCart[i]['unit'],
      ));
      resShoppingCart[i]['checked'] == 0
          ? checked.add(false)
          : checked.add(true);
    }
    return (ShoppingCart(
      ingredients: ingredients,
      checked: checked,
    ));
  }

/*
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
*/
  Future<List<RecipePreview>> getRecipePreviewOfCategory(
      String categoryName) async {
    final db = await database;

    var resCategories = await db.rawQuery('SELECT * FROM RecipeCategories '
        'INNER JOIN Categories ON Categories.categoryName=RecipeCategories.categories_name '
        'WHERE categoryName=\'$categoryName\'');
    List<RecipePreview> output = new List<RecipePreview>();
    for (int i = 0; i < resCategories.length; i++) {
      RecipePreview newRecipe =
          await getRecipePreviewByName(resCategories[i]['recipe_name'], true);
      output.add(newRecipe);
    }
    return output;
  }

/*
  Future<List<Recipe>> getRecipesOfCategory(String categoryName) async {
    final db = await database;

    var resCategories = await db.rawQuery('SELECT * FROM RecipeCategories '
        'INNER JOIN Categories ON Categories.categoryName=RecipeCategories.categories_name '
        'WHERE categoryName=\'$categoryName\'');
    List<Recipe> output = new List<Recipe>();
    for (int i = 0; i < resCategories.length; i++) {
      Recipe newRecipe =
          await getRecipeById(resCategories[i]['recipe_id'], true);
      output.add(newRecipe);
    }
    return output;
  }
*/
/*
  Future<List<Recipe>> getRecipesOfNoCategory() async {
    final db = await database;

    List<Recipe> recipes = [];
    var resRecipe = await db.rawQuery('SELECT id FROM Recipe '
        'WHERE id NOT IN (SELECT recipe_id FROM RecipeCategories)');

    for (int i = 0; i < resRecipe.length; i++) {
      recipes.add(await getRecipeById(resRecipe[i]['id'], true));
    }

    return recipes;
  }
*/
  Future<List<RecipePreview>> getRecipePreviewOfNoCategory() async {
    final db = await database;

    List<RecipePreview> recipes = [];
    var resRecipe = await db.rawQuery('SELECT recipe_name FROM Recipe '
        'WHERE recipe_name NOT IN (SELECT recipe_name FROM RecipeCategories)');

    for (int i = 0; i < resRecipe.length; i++) {
      recipes.add(await getRecipePreviewByName(resRecipe[i]['recipe_name'], true));
    }

    return recipes;
  }

  Future<List<RecipePreview>> getFavoriteRecipePreviews() async {
    var db = await database;

    List<RecipePreview> favorites = [];

    var resFavorites =
        await db.query('Recipe', where: 'isFavorite = ?', whereArgs: ['1']);

    for (int i = 0; i < resFavorites.length; i++) {
      favorites.add(await getRecipePreviewByName(resFavorites[i]['recipe_name'], true));
    }
    return favorites;
  }

/*
  Future<List<Recipe>> getFavoriteRecipes() async {
    var db = await database;

    List<Recipe> favorites = [];

    var resFavorites =
        await db.query('Recipe', where: 'isFavorite = ?', whereArgs: ['1']);

    for (int i = 0; i < resFavorites.length; i++) {
      favorites.add(await getRecipeById(resFavorites[i]['id'], true));
    }
    return favorites;
  }
*/
  Future<void> updateFavorite(bool status, String recipeName) async {
    final db = await database;
    int newStatus;
    if (status) {
      newStatus = 1;
    } else {
      newStatus = 0;
    }
    await db.rawUpdate(
        'UPDATE Recipe SET isFavorite = $newStatus WHERE recipe_name=$recipeName');
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
