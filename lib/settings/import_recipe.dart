import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';

import '../database.dart';
import '../recipe.dart';

Future<void> importRecipe(RecipeKeeper rKeeper, String recipeZipPath) async {
  Directory importDir = Directory(await PathProvider.pP.getImportDir());
  // extract selected zip and save it to the importDir
  await exstractZip(File(recipeZipPath), importDir.path);
  List importFiles = importDir.listSync(recursive: true);

  Recipe importRecipe;
  for (File file in importFiles) {
    if (file.path.endsWith('.json')) {
      importRecipe = await getRecipeFromJson(file);
      await file.delete();
    }
    break;
  }
  if (await DBProvider.db.doesRecipeExist(importRecipe.name)) {
    await Directory(
            await PathProvider.pP.getRecipeImportDirFolder(importRecipe.name))
        .delete(recursive: true);
    return;
  }

  Directory importRecipeDir = Directory(
      await PathProvider.pP.getRecipeImportDirFolder(importRecipe.name));
  await importRecipeDir
      .rename(await PathProvider.pP.getRecipeDir(importRecipe.name));

  rKeeper.addRecipe(importRecipe);
  await Directory(
          await PathProvider.pP.getRecipeImportDirFolder(importRecipe.name))
      .delete(recursive: true);
}

Future<Recipe> getRecipeFromJson(File jsonFile) async {
  String json = await jsonFile.readAsString();
  Map<String, dynamic> jsonMap = jsonDecode(json);
  return Recipe.fromMap(jsonMap);
}

Future<void> exstractZip(File encode, String destination) async {
  List<int> bytes = encode.readAsBytesSync();

  // Decode the Zip file
  Archive archive = ZipDecoder().decodeBytes(bytes);

  // Extract the contents of the Zip archive to disk.
  for (ArchiveFile file in archive) {
    String filename = file.name;
    if (file.isFile) {
      List<int> data = file.content;
      File(destination + filename)
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
    } else {
      Directory(destination + filename)..create(recursive: true);
    }
  }
}
