import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';

import '../database.dart';
import '../recipe.dart';

Future<void> importSingleMultipleRecipes(
    RecipeKeeper rKeeper, File recipeZipPath, BuildContext context) async {
  Directory importDir = Directory(await PathProvider.pP.getImportDir());
  // extract selected zip and save it to the importDir
  await exstractZip(recipeZipPath, importDir.path);
  List importFiles = importDir.listSync(recursive: true);

  bool importMulitiple = false;

  for (FileSystemEntity f in importFiles) {
    if (f.path.endsWith('.zip')) {
      importMulitiple = true;
    }
  }
  if (importMulitiple) {
    importRecipes(rKeeper, importDir, context);
  } else {
    importRecipe(rKeeper, recipeZipPath, context);
  }
}

Future<void> importRecipes(
    RecipeKeeper rKeeper, Directory importDir, BuildContext context) async {
  List importZips = importDir.listSync(recursive: true);

  for (FileSystemEntity f in importZips) {
    if (f.path.endsWith('.zip')) {
      await importRecipe(rKeeper, File(f.path), context);
    }
  }
  await importDir.delete(recursive: true);
}

Future<void> importRecipe(
    RecipeKeeper rKeeper, File recipeZip, BuildContext context) async {
  Directory importDir = Directory(await PathProvider.pP.getImportDir());
  // extract selected zip and save it to the importDir
  await exstractZip(recipeZip, importDir.path);
  List importFiles = importDir.listSync(recursive: true);

  Recipe importRecipe;
  bool doesValidJsonFileExist = false;
  for (File file in importFiles) {
    if (file.path.endsWith('.json')) {
      doesValidJsonFileExist = true;
      try {
        importRecipe = await getRecipeFromJson(file);
      } catch (e) {
        doesValidJsonFileExist = false;
      }
      await file.delete();
      break;
    }
  }
  if (!doesValidJsonFileExist) {
    _showImportedRecipeToast(null, false, context);
  }

  if (await DBProvider.db.doesRecipeExist(importRecipe.name)) {
    await Directory(
            await PathProvider.pP.getRecipeImportDirFolder(importRecipe.name))
        .delete(recursive: true);
    _showImportedRecipeToast(importRecipe.name, false, context);
    return;
  }

  Directory importRecipeDir = Directory(
      await PathProvider.pP.getRecipeImportDirFolder(importRecipe.name));
  String recipeDir = await PathProvider.pP.getRecipeDir(importRecipe.name);
  if (Directory(recipeDir).existsSync()) {
    await Directory(recipeDir).delete(recursive: true);
  }
  await importRecipeDir
      .rename(await PathProvider.pP.getRecipeDir(importRecipe.name));

  rKeeper.addRecipe(importRecipe, true);
  await Directory(
          await PathProvider.pP.getRecipeImportDirFolder(importRecipe.name))
      .delete(recursive: true);
  _showImportedRecipeToast(importRecipe.name, true, context);
}

_showImportedRecipeToast(
    String recipeName, bool importSuccessfull, BuildContext context) {
  final scaffold = Scaffold.of(context);
  scaffold.hideCurrentSnackBar();

  String snackbarMessage;
  if (recipeName == null) {
    snackbarMessage = S.of(context).no_valid_import_file;
  } else if (!importSuccessfull) {
    snackbarMessage = "${S.of(context).you_already_have}: $recipeName";
  } else {
    snackbarMessage = "${S.of(context).imported}: $recipeName";
  }
  scaffold.showSnackBar(
    SnackBar(
      content: Text(snackbarMessage),
      action: SnackBarAction(
          label: S.of(context).hide, onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
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
