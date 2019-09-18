import 'dart:io';
import 'dart:math';
import 'package:my_recipe_book/helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
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
        await db.execute('CREATE TABLE ShoppingCartRecipe ('
            'recipe TEXT PRIMARY KEY'
            ')');
        await db.execute('CREATE TABLE ShoppingCartIngredient ('
            'item_id INTEGER PRIMARY KEY,'
            'name TEXT,'
            'amount REAL,'
            'unit,'
            'checked INTEGER,'
            'recipe TEXT,'
            'FOREIGN KEY(recipe) REFERENCES ShoppingCartRecipe(recipe) ON DELETE CASCADE'
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

    var resCategories = await db.query('Categories', orderBy: 'number');
    List<String> categories = [];
    for (int i = 0; i < resCategories.length; i++) {
      categories.add(resCategories[i]['categoryName']);
    }
    return categories;
  }

  getRecipeByName(String recipeName, bool fullImagePath) async {
    final db = await database;
    final appDir = await getApplicationDocumentsDirectory();
    String preString;
    fullImagePath ? preString = appDir.path : preString = '';

    var resRecipe = await db
        .query('Recipe', where: 'recipe_name = ?', whereArgs: [recipeName]);
    if (resRecipe.isEmpty) {
      return Null;
    }
    String name = resRecipe.first['recipe_name'];
    String image;
    if (resRecipe.first['image'] != 'images/randomFood.jpg') {
      image = preString + resRecipe.first['image'];
    } else {
      image = resRecipe.first['image'];
    }
    String previewPath;
    String dataType = image.substring(image.lastIndexOf('.'));
    image == "images/randomFood.jpg"
        ? previewPath = 'images/randomFood.jpg'
        : previewPath =
            await PathProvider.pP.getRecipePreviewPathFull(name, dataType);

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

    var resSteps = await db.query('Steps',
        where: 'recipe_name = ?',
        whereArgs: [recipeName],
        orderBy: 'number ASC');

    List<String> steps = [];
    List<List<String>> stepImages = [];
    for (int i = 0; i < resSteps.length; i++) {
      steps.add(resSteps[i]['description']);
      var resStepImages = await db.query(
        'StepImages',
        where: 'steps_id = ?',
        whereArgs: [resSteps[i]['id']],
        orderBy: 'id ASC',
      );
      stepImages.add([]);
      for (int j = 0; j < resStepImages.length; j++) {
        stepImages[i].add(preString + resStepImages[j]['image']);
      }
    }

    var resSections = await db.query('Sections',
        where: 'recipe_name = ?',
        whereArgs: [recipeName],
        orderBy: 'number ASC');
    List<String> ingredientsGlossary = new List<String>();
    List<List<Ingredient>> ingredients = [[]];
    for (int i = 0; i < resSections.length; i++) {
      ingredientsGlossary.add(resSections[i]['sectionName']);
      var resIngredients = await db.query('Ingredients',
          where: 'section_id = ?', whereArgs: [resSections[i]['id']]);
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
        'WHERE recipe_name=\'$recipeName\'');
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

  getNewRandomRecipe(String excludedRecipe, {String categoryName}) async {
    final db = await database;
    var resCat;
    if (categoryName != null) {
      resCat = await db.rawQuery(
          'SELECT * FROM RecipeCategories '
          'INNER JOIN Categories ON Categories.categoryName=RecipeCategories.categories_name '
          'WHERE categoryName= ?',
          [categoryName]);
    } else {
      resCat = await db.query('Recipe', columns: ['recipe_name']);
    }

    if (resCat.isEmpty) {
      return null;
    }

    Random r = new Random();
    int randomRecipe;
    randomRecipe = resCat.length > 1 ? r.nextInt(resCat.length) : 0;
    while (resCat[randomRecipe]['recipe_name'].compareTo(excludedRecipe) == 0 &&
        resCat.length > 1) {
      randomRecipe = r.nextInt(resCat.length);
    }

    return await getRecipeByName(resCat[randomRecipe]['recipe_name'], true);
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
    if (resRecipe.first['image'] != 'images/randomFood.jpg') {
      image = preString + resRecipe.first['image'];
    } else {
      image = resRecipe.first['image'];
    }
    String previewPath;
    String dataType = image.substring(image.lastIndexOf('.'));
    image == "images/randomFood.jpg"
        ? previewPath = 'images/randomFood.jpg'
        : previewPath =
            await PathProvider.pP.getRecipePreviewPathFull(name, dataType);

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

    var resSections = await db.query('Sections',
        where: 'recipe_name = ?',
        whereArgs: [recipeName],
        orderBy: 'number ASC');
    int ingredientAmount = 0;
    for (int i = 0; i < resSections.length; i++) {
      var resIngredients = await db.query('Ingredients',
          where: 'section_id = ?', whereArgs: [resSections[i]['id']]);
      ingredientAmount += resIngredients.length;
    }

    List<String> categories = new List<String>();
    var resCategories = await db.rawQuery('SELECT * FROM RecipeCategories '
        'INNER JOIN Categories ON Categories.categoryName=RecipeCategories.categories_name '
        'WHERE recipe_name=\'$recipeName\'');
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

  Future<bool> doesRecipeExist(String recipeName) async {
    var db = await database;
    var resRecipe = await db
        .query('Recipe', where: 'recipe_name = ?', whereArgs: [recipeName]);
    if (resRecipe.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<String>> getRecipeNames() async {
    var db = await database;

    var resRecipes = await db.query('recipe', columns: ['recipe_name']);

    List<String> recipeNames = [];

    for (int i = 0; i < resRecipes.length; i++) {
      recipeNames.add(resRecipes[i]['recipe_name']);
    }
    return recipeNames;
  }

  Future<void> deleteRecipeFromDatabase(Recipe recipe) async {
    final db = await database;

    await db.delete(
      'Recipe',
      where: 'recipe_name = ?',
      whereArgs: [recipe.name],
    );
  }

  Future<void> deleteRecipe(String recipeName) async {
    final db = await database;

    await db.delete(
      'Recipe',
      where: 'recipe_name = ?',
      whereArgs: [recipeName],
    );
  }

  Future<void> addToShoppingList(
      String recipeName, Ingredient ingredient) async {
    await _addIngredientToRecipe('summary', ingredient);
    await _addIngredientToRecipe(recipeName, ingredient);
  }

  Future<void> _addIngredientToRecipe(
      String recipeName, Ingredient ingredient) async {
    final db = await database;
    var batch = db.batch();

    await db.execute(
        'INSERT OR IGNORE INTO ShoppingCartRecipe (recipe) VALUES (?)',
        [recipeName]);

    var resultIngredient = await db.query('ShoppingCartIngredient',
        where: 'recipe = ? AND name = ? AND unit = ?',
        whereArgs: [recipeName, ingredient.name, ingredient.unit]);

    if (resultIngredient.isEmpty) {
      batch.insert('ShoppingCartIngredient', {
        'recipe': recipeName,
        'name': ingredient.name,
        'amount': ingredient.amount,
        'unit': ingredient.unit,
        'checked': 0,
      });
    } else {
      batch.update(
          'ShoppingCartIngredient',
          {
            'amount': resultIngredient[0]['amount'] + ingredient.amount,
            'checked': 0,
          },
          where: 'recipe = ? AND name = ? AND unit = ?',
          whereArgs: [recipeName, ingredient.name, ingredient.unit]);
    }

    await batch.commit();
  }

  Future<void> checkIngredient(String recipe, CheckableIngredient i) async {
    final db = await database;
    var batch = db.batch();

    int checkedInt = 0;
    if (i.checked) checkedInt = 1;
    batch.update('ShoppingCartIngredient', {'checked': checkedInt},
        where: 'recipe = ? AND name = ? AND unit = ?',
        whereArgs: [recipe, i.name, i.unit]);
    if (recipe.compareTo('summary') != 0) {
      if (checkedInt == 0) {
        batch.update('ShoppingCartIngredient', {'checked': 0},
            where: 'recipe = ? AND name = ? AND unit = ?',
            whereArgs: ['summary', i.name, i.unit]);
      } else {
        var resSummaryNotChecked = await db.query('ShoppingCartIngredient',
            where: 'name = ? AND unit = ? AND checked = ?',
            whereArgs: [i.name, i.unit, 0]);

        /// Check for length to be 2 because the ingredient is still unchecked because batch
        /// commit is not yet called and at the summary it is also not checked
        if (resSummaryNotChecked.length == 2 ||
            resSummaryNotChecked.length == 1) {
          batch.update('ShoppingCartIngredient', {'checked': 1},
              where: 'recipe = ? AND name = ? AND unit = ?',
              whereArgs: ['summary', i.name, i.unit]);
        }
      }
    } else {
      batch.update('ShoppingCartIngredient', {'checked': checkedInt},
          where: 'name = ? AND unit = ?', whereArgs: [i.name, i.unit]);
    }

    await batch.commit();
  }

  Future<void> deleteRecipeFromeShoppingCart(String recipeName) async {
    final db = await database;

    await db.delete('ShoppingCartRecipe',
        where: 'recipe = ?', whereArgs: [recipeName]);
  }

  Future<void> deleteFromShoppingCart(
      String recipeName, Ingredient ingredient) async {
    final db = await database;
    var batch = db.batch();

    var resToBeRemoved = await db.query('ShoppingCartIngredient',
        where: 'recipe = ? AND name = ? AND unit = ?',
        whereArgs: [
          recipeName,
          ingredient.name,
          ingredient.unit,
        ]);
    double removeAmount = resToBeRemoved.first['amount'];

    var resSummary = await db.query('ShoppingCartIngredient',
        where: 'recipe = ? AND name = ? AND unit = ?',
        whereArgs: [
          'summary',
          ingredient.name,
          ingredient.unit,
        ]);

    batch.delete('ShoppingCartIngredient',
        where: 'name = ? AND recipe = ? AND unit = ?',
        whereArgs: [
          ingredient.name,
          recipeName,
          ingredient.unit,
        ]);
    if (recipeName.compareTo('summary') != 0) {
      if (resSummary[0]['amount'] - removeAmount <= 0) {
        /// if we don't want to delete at the summary and summary - deletedAmount
        /// is less equal 0 we delete at the summary
        batch.delete('ShoppingCartIngredient',
            where: 'recipe = ? AND name = ? AND unit = ?',
            whereArgs: [
              'summary',
              ingredient.name,
              ingredient.unit,
            ]);
      } else {
        /// if we don't want to delete at the summary and summary - deletedAmount
        /// is greater than 0 we update the summary
        batch.update('ShoppingCartIngredient',
            {'amount': resSummary[0]['amount'] - removeAmount},
            where: 'recipe = ? AND name = ? AND unit = ?',
            whereArgs: [
              'summary',
              ingredient.name,
              ingredient.unit,
            ]);
      }
    } else {
      /// if we deleted at the summary we want to delete every ingredient
      /// which fits the pattern of the deleted one
      batch.delete('ShoppingCartIngredient',
          where: 'name = ? AND unit = ?',
          whereArgs: [
            ingredient.name,
            ingredient.unit,
          ]);
    }

    await batch.commit();
  }

  Future<Map<String, List<CheckableIngredient>>>
      getShoppingCartIngredients() async {
    final db = await database;

    Map<String, List<CheckableIngredient>> shoppingCartIngredients = {};
    var resShoppingCart = await db.query('ShoppingCartIngredient');

    for (int i = 0; i < resShoppingCart.length; i++) {
      String ingredientName = resShoppingCart[i]['name'];
      double ingredientAmount = resShoppingCart[i]['amount'];
      String ingredientUnit = resShoppingCart[i]['unit'];
      String recipeName = resShoppingCart[i]['recipe'];
      int checked = resShoppingCart[i]['checked'];

      bool alreadyAdded = false;
      for (String r in shoppingCartIngredients.keys) {
        if (r.compareTo(recipeName) == 0) {
          alreadyAdded = true;
          break;
        }
      }
      if (!alreadyAdded) {
        shoppingCartIngredients.addAll({recipeName: []});
      }
      shoppingCartIngredients[recipeName].add(CheckableIngredient(
        Ingredient(
          name: ingredientName,
          amount: ingredientAmount,
          unit: ingredientUnit,
        ),
        checked: checked == 1 ? true : false,
      ));
    }
    if (shoppingCartIngredients.keys.isEmpty) {
      shoppingCartIngredients.addAll({'summary': []});
    }
    return shoppingCartIngredients;
  }

// TODO: Validate if working
  Future<void> changeCategoryName(String oldCatName, String newCatName) async {
    var db = await database;

    await db.update('Categories', {'categoryName': newCatName},
        where: 'categoryName = ?', whereArgs: [oldCatName]);
  }

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
      recipes
          .add(await getRecipePreviewByName(resRecipe[i]['recipe_name'], true));
    }

    return recipes;
  }

  Future<List<RecipePreview>> getFavoriteRecipePreviews() async {
    var db = await database;

    List<RecipePreview> favorites = [];

    var resFavorites =
        await db.query('Recipe', where: 'isFavorite = ?', whereArgs: ['1']);

    for (int i = 0; i < resFavorites.length; i++) {
      favorites.add(
          await getRecipePreviewByName(resFavorites[i]['recipe_name'], true));
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
        'UPDATE Recipe SET isFavorite = $newStatus WHERE recipe_name=\'$recipeName\'');
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
