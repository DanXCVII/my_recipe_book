import 'dart:io';
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
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Recipe ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "image TEXT,"
          "preperationTime REAL,"
          "cookingTime REAL,"
          "totalTime REAL,"
          "servings REAL,"
          "vegetable TEXT,"
          "notes TEXT,"
          "complexity INTEGER,"
          "isFavorite INTEGER"
          "ON DELETE CASCADE"
          ")");
      await db.execute("CREATE TABLE Steps ("
          "id INTEGER PRIMARY KEY,"
          "number TEXT,"
          "description TEXT,"
          "recipe_id INTEGER,"
          "FOREIGN KEY(recipe_id) REFERENCES Recipe(id)"
          "ON DELETE CASCADE"
          ")");
      await db.execute("CREATE TABLE StepImages ("
          "id INTEGER PRIMARY KEY,"
          "image TEXT,"
          "steps_id INTEGER,"
          "FOREIGN KEY(steps_id) REFERENCES Steps(id)"
          ")");
      await db.execute("CREATE TABLE Sections ("
          "id INTEGER PRIMARY KEY,"
          "number INTEGER,"
          "name TEXT,"
          "recipe_id INTEGER,"
          "FOREIGN KEY(recipe_id) REFERENCES Recipe(id)"
          "ON DELETE CASCADE"
          ")");
      await db.execute("CREATE TABLE Ingredients ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "amount REAL,"
          "unit TEXT,"
          "section_id INTEGER,"
          "FOREIGN KEY(section_id) REFERENCES Section(id)"
          ")");
      await db.execute("CREATE TABLE Categories ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT"
          ")");
      await db.execute("CREATE TABLE RecipeCategories ("
          "recipe_id INTEGER,"
          "categories_id INTEGER,"
          "FOREIGN KEY(recipe_id) REFERENCES Recipe(id)"
          "FOREIGN KEY(categories_id) REFERENCES Categories(id)"
          ")");
      await db.execute("CREATE TABLE ShoppingCart ("
          "item_id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "amount TEXT,"
      );
    });
  }

  Future<int> getNewIDforTable(String tablename) async {
    print('DB.getNewIDforTable');
    final db = await database;
    // var completer = new Completer<int>();
    int output = 0;

    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tablename");
    int id = table.first["id"];
    if (id != null) {
      output = id;
    }

    // completer.complete(output);
    // return completer.future;
    return output;
  }

  newCategory(String name) async {
    final db = await database;
    await db.rawInsert(
        "INSERT Into Categories (id,name)"
        " VALUES (?,?)",
        [await getNewIDforTable("Categories"), name]);
    return;
  }

  newRecipe(Recipe newRecipe) async {
    print('start DB.newRecipe()');
    final db = await database;
    String image = "";
    if (newRecipe.imagePath != null) {
      image = await PathProvider.pP.getRecipePath(newRecipe.id);
    }
    var resRecipe = await db.rawInsert(
        "INSERT Into Recipe ("
        "id,"
        "name,"
        "image,"
        "preperationTime,"
        "cookingTime,"
        "totalTime,"
        "servings,"
        "vegetable,"
        "notes,"
        "complexity,"
        "isFavorite)"
        " VALUES (?,?,?,?,?,?,?,?,?,?,?)",
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
      int _sectionId = await getNewIDforTable("Sections");

      await db.rawInsert(
          "INSERT Into Sections (id,number,name,recipe_id)"
          " VALUES (?,?,?,?)",
          [_sectionId, i, newRecipe.ingredientsGlossary[i], newRecipe.id]);

      for (int j = 0; j < newRecipe.ingredientsList[i].length; j++) {
        await db.rawInsert(
            "INSERT Into Ingredients (id,name,amount,unit,section_id)"
            " VALUES (?,?,?,?,?)",
            [
              await getNewIDforTable("Ingredients"),
              newRecipe.ingredientsList[i][j],
              newRecipe.amount[i][j],
              newRecipe.unit[i][j],
              _sectionId
            ]);
      }
    }
    for (int i = 0; i < newRecipe.steps.length; i++) {
      int stepsId = await getNewIDforTable("Steps");

      await db.rawInsert(
          "INSERT Into Steps (id,number,description,recipe_id)"
          " VALUES (?,?,?,?)",
          [
            stepsId,
            i,
            newRecipe.steps[i],
            newRecipe.id,
          ]);
      if (newRecipe.stepImages.length > i) {
        for (int j = 0; j < newRecipe.stepImages[i].length; j++) {
          await db.rawInsert(
              "INSERT Into StepImages (id,image,steps_id)"
              " VALUES (?,?,?)",
              [
                await getNewIDforTable("StepImages"),
                await PathProvider.pP.getRecipeStepPath(newRecipe.id, i, j),
                stepsId,
              ]);
        }
      }
    }

    List<String> categoryNames = newRecipe.categories;
    for (int i = 0; i < categoryNames.length; i++) {
      var resCategories = await db.query("Categories",
          where: "name = ?", whereArgs: [categoryNames[i]]);
      await db.rawInsert(
          "INSERT Into RecipeCategories (recipe_id,categories_id)"
          " VALUES (?,?)",
          [
            newRecipe.id,
            resCategories[0]["id"],
          ]);
    }

    print('end DB.newRecipe()');
    return resRecipe;
  }

  Future<List<String>> getCategories() async {
    final db = await database;

    var resCategories = await db.rawQuery("SELECT * FROM Categories");
    List<String> categories = new List<String>();
    for (int i = 0; i < resCategories.length; i++) {
      categories.add(resCategories[i]["name"]);
    }
    return categories;
  }

// TODO: check if getRecipeById is working properly
  getRecipeById(int id) async {
    print('getRecipeById(id)');
    final db = await database;
    var resRecipe = await db.query("Recipe", where: "id = ?", whereArgs: [id]);
    if (resRecipe.isEmpty) {
      return Null;
    }
    String name = resRecipe.first["name"];
    String image;
    if (resRecipe.first["image"] != "") {
      image = resRecipe.first["image"];
    }

    double preperationTime = resRecipe.first["preperationTime"];
    double cookingTime = resRecipe.first["cookingTime"];
    double totalTime = resRecipe.first["totalTime"];
    double servings = resRecipe.first["servings"];
    int complexity = resRecipe.first["complexity"];
    bool isFavorite;
    if (resRecipe.first["isFavorite"] == 1) {
      isFavorite = true;
    } else {
      isFavorite = false;
    }
    Vegetable vegetable;

    if (resRecipe.first["vegetable"] == "Vegetable.NON_VEGETARIAN")
      vegetable = Vegetable.NON_VEGETARIAN;
    else if (resRecipe.first["vegetable"] == "Vegetable.VEGETARIAN")
      vegetable = Vegetable.VEGETARIAN;
    else if (resRecipe.first["vegetable"] == "Vegetable.VEGAN")
      vegetable = Vegetable.VEGAN;
    String notes = resRecipe.first["notes"];

    var resSteps = await db.rawQuery(
        "SELECT * FROM Steps WHERE recipe_id=$id ORDER BY number ASC");
    List<String> steps = new List<String>();
    List<List<String>> stepImages = new List<List<String>>();
    for (int i = 0; i < resSteps.length; i++) {
      steps.add(resSteps[i]["description"]);
      var resStepImages = await db.rawQuery(
          "SELECT * FROM StepImages WHERE steps_id=${resSteps[i]["id"]} ORDER BY id ASC");
      stepImages.add(new List<String>());
      for (int j = 0; j < resStepImages.length; j++) {
        stepImages[i].add(resStepImages[j]["image"]);
      }
    }

    var resSections = await db.rawQuery(
        "SELECT * FROM Sections WHERE recipe_id=$id ORDER BY number ASC");
    List<String> ingredientsGlossary = new List<String>();
    List<List<String>> ingredientsList = new List<List<String>>();
    List<List<double>> ingredientsAmount = new List<List<double>>();
    List<List<String>> ingredientsUnit = new List<List<String>>();
    for (int i = 0; i < resSections.length; i++) {
      ingredientsGlossary.add(resSections[i]["name"]);
      var resIngredients = await db.rawQuery(
          "SELECT * FROM Ingredients WHERE section_id=${resSections[i]["id"]}");
      ingredientsList.add(new List<String>());
      ingredientsAmount.add(new List<double>());
      ingredientsUnit.add(new List<String>());
      for (int j = 0; j < resIngredients.length; j++) {
        ingredientsList[i].add(resIngredients[j]["name"]);
        ingredientsAmount[i].add(resIngredients[j]["amount"]);
        ingredientsUnit[i].add(resIngredients[j]["unit"]);
      }
    }

    List<String> categories = new List<String>();
    var resCategories = await db.rawQuery(
        "SELECT * FROM RecipeCategories INNER JOIN Categories ON Categories.id=RecipeCategories.categories_id"
        " WHERE recipe_id=$id");
    for (int i = 0; i < resCategories.length; i++) {
      categories.add(resCategories[i]["name"]);
    }
    return Recipe(
        id: id,
        name: name,
        imagePath: image,
        preperationTime: preperationTime,
        cookingTime: cookingTime,
        totalTime: totalTime,
        servings: servings,
        ingredientsGlossary: ingredientsGlossary,
        ingredientsList: ingredientsList,
        amount: ingredientsAmount,
        unit: ingredientsUnit,
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

    await db.rawDelete("DELETE FROM Recipe WHERE id= ?", [recipe.id]);

    Directory appDir = await getApplicationDocumentsDirectory();
    String imageLocalPathRecipe = "${appDir.path}/${recipe.id}/";
    var dir = new Directory(imageLocalPathRecipe);
    dir.deleteSync(recursive: true);
  }

  Future<void> addToShoppingList(String ingredient, String amountWithUnit) {
    // TODO: Implement
  }

  Future<List<Recipe>> getRecipesOfCategory(String category) async {
    final db = await database;

    var resCategories = await db.rawQuery(
        "SELECT * FROM RecipeCategories INNER JOIN Categories ON Categories.id=RecipeCategories.categories_id "
        "WHERE Categories.name=\"$category\"");
    List<Recipe> output = new List<Recipe>();
    for (int i = 0; i < resCategories.length; i++) {
      var newRecipe = await getRecipeById(resCategories[i]["recipe_id"]);
      output.add(newRecipe as Recipe);
    }
    return output;
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
        "UPDATE Recipe SET isFavorite = $newStatus WHERE id=$recipeId");
  }
}
