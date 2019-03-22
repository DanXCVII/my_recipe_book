import 'package:sqflite/sqflite.dart';
import './recipe.dart';

// singleton DBProvider to ensure, that we only use one object
class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null)
    return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Client ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "image TEXT,"
          "preperationTime BIT"
          ")");
    });
  }

  newClient(Recipe newRecipe) async {
    final db = await database;
    var res = await db.rawInsert(
      "INSERT Into Client (id,name,this.image,
      preperationTime,
      cookingTime,
      totalTime,
      servings,
      ingredientsGlossary,
      ingredientsList,
      amount,
      unit,
      vegetable,
      steps,
      notes)"
      " VALUES (${newClient.id},${newClient.firstName})");
    return res;
  }
}

