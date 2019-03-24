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
          "notes TEXT"
          ")");
      await db.execute("CREATE TABLE Steps ("
          "id INTEGER PRIMARY KEY,"
          "number TEXT,"
          "description TEXT,"
          "recipe_id INTEGER,"
          "FOREIGN KEY(recipe_id) REFERENCES Recipe(id)"
          ")");
      await db.execute("CREATE TABLE Sections ("
          "id INTEGER PRIMARY KEY,"
          "number INTEGER,"
          "name TEXT,"
          "recipe_id INTEGER,"
          "FOREIGN KEY(recipe_id) REFERENCES Recipe(id)"
          ")");
      await db.execute("CREATE TABLE Ingredients ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "amount REAL,"
          "unit TEXT,"
          "section_id INTEGER,"
          "FOREIGN KEY(section_id) REFERENCES Section(id)"
          ")");
    });
  }

  Future<int> getNewIDforTable(String tablename) async {
    final db = await database;
    var completer = new Completer<int>();
    int output = 0;

    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tablename");
    int id = table.first["id"];
    if (id != null) {
      output = id;
    }

    completer.complete(output);
    return completer.future;
  }

  newRecipe(Recipe newRecipe) async {
    final db = await database;
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
        "notes)"
        " VALUES (?,?,?,?,?,?,?,?,?)",
        [
          newRecipe.id,
          newRecipe.name,
          newRecipe.image,
          newRecipe.preperationTime,
          newRecipe.cookingTime,
          newRecipe.totalTime,
          newRecipe.servings,
          newRecipe.vegetable.toString(),
          newRecipe.notes
        ]);
    for (int i = 0; i < newRecipe.ingredientsGlossary.length; i++) {
      int _sectionId = await getNewIDforTable("Sections");

      var resSections = await db.rawInsert(
          "INSERT Into Sections (id,number,name,recipe_id)"
          " VALUES (?,?,?,?)",
          [_sectionId, i, newRecipe.ingredientsGlossary[i], newRecipe.id]);

      for (int j = 0; j < newRecipe.ingredientsList[i].length; j++) {
        var resSections = await db.rawInsert(
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
      var resSections = await db.rawInsert(
          "INSERT Into Steps (id,number,description,recipe_id)"
          " VALUES (?,?,?,?)",
          [
            await getNewIDforTable("Steps"),
            i,
            newRecipe.steps[i],
            newRecipe.id
          ]);
    }

    return resRecipe;
  }

// TODO: check if getRecipeById is working properly
  getRecipeById(int id) async {
    final db = await database;
    var resRecipe = await db.query("Recipe", where: "id = ?", whereArgs: [id]);
    if (resRecipe.isEmpty) {
      return Null;
    }
    String name = resRecipe.first["name"];
    String image = resRecipe.first["image"];
    double preperationTime = resRecipe.first["preperationTime"];
    double cookingTime = resRecipe.first["cookingTime"];
    double totalTime = resRecipe.first["totalTime"];
    double servings = resRecipe.first["servings"];
    Vegetable vegetable;
    if (resRecipe.first["vegetable"] == "Vegetable.NON_VEGETARIAN")
      vegetable = Vegetable.NON_VEGETARIAN;
    if (resRecipe.first["vegan"] == "Vegetable.VEGETARIAN")
      vegetable = Vegetable.VEGETARIAN;
    if (resRecipe.first["vegan"] == "Vegetable.VEGAN")
      vegetable = Vegetable.VEGAN;
    String notes = resRecipe.first["notes"];

    var resSteps = await db
        .rawQuery("SELECT * FROM Steps WHERE id=$id ORDER BY number ASC");
    List<String> steps = new List<String>();
    for (int i = 0; i < resSteps.length; i++) {
      steps.add(resSteps[i]["description"]);
    }

    var resSections = await db
        .rawQuery("SELECT * FROM Sections WHERE id=$id ORDER BY number ASC");
    List<String> ingredientsGlossary = new List<String>();
    List<List<String>> ingredientsList = new List<List<String>>();
    List<List<double>> ingredientsAmount = new List<List<double>>();
    List<List<String>> ingredientsUnit = new List<List<String>>();
    for (int i = 0; i < resSections.length; i++) {
      ingredientsGlossary.add(resSections[i]["name"]);
      var resIngredients =
          await db.rawQuery("SELECT * FROM Ingredients WHERE section_id=$id");
      for (int j = 0; j < resIngredients.length; j++) {
        ingredientsList[i].add(resIngredients[j]["name"]);
        ingredientsAmount[i].add(resIngredients[j]["amount"]);
        ingredientsUnit[i].add(resIngredients[j]["unit"]);
      }
    }
    return Recipe(
        id: id,
        name: name,
        image: image,
        preperationTime: preperationTime,
        cookingTime: cookingTime,
        totalTime: totalTime,
        servings: servings,
        ingredientsGlossary: ingredientsGlossary,
        ingredientsList: ingredientsList,
        amount: ingredientsAmount,
        unit: ingredientsUnit,
        vegetable: vegetable,
        steps: steps,
        notes: notes);
  }
}
