import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../generated/i18n.dart';
import '../hive.dart';
import '../local_storage/local_paths.dart';
import '../models/recipe.dart';

Future<List<Recipe>> importSingleMultipleRecipes(
    File recipeZipPath, BuildContext context) async {
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
    return await importRecipes(importDir, context)
      ..removeWhere((item) => item == null);
  } else {
    return [await importRecipe(recipeZipPath, context)]
      ..removeWhere((item) => item == null);
  }
}

/// imports all recipes which are as zip in the passed importDir and deletes
/// the directory with it's content afterwards
Future<List<Recipe>> importRecipes(
    Directory importDir, BuildContext context) async {
  List importZips = importDir.listSync(recursive: true);
  List<Recipe> recipes = [];

  for (FileSystemEntity f in importZips) {
    if (f.path.endsWith('.zip')) {
      recipes.add(await importRecipe(File(f.path), context));
    }
  }
  await importDir.delete(recursive: true);

  return recipes;
}

Future<Recipe> importRecipe(File recipeZip, BuildContext context) async {
  Directory importDir = Directory(await PathProvider.pP.getImportDir());
  // extract selected zip and save it to the importDir
  await exstractZip(recipeZip, importDir.path);
  List importFiles = importDir.listSync(recursive: true);

  Recipe importRecipe;
  // loop through the import files
  for (File file in importFiles) {
    // stop if json found
    if (file.path.endsWith('.json')) {
      try {
        importRecipe = await getRecipeFromJson(file);
      } catch (e) {
        // if json doesn't contain a valid recipe
        _showImportedRecipeToast(null, false, context);
      }
      await file.delete();
      break;
    }
  }

  // if a recipe with the same name is already in the database
  if (await HiveProvider().getRecipeByName(importRecipe.name) != null) {
    // delete the extracted files and do not import it
    await Directory(
            await PathProvider.pP.getRecipeImportDirFolder(importRecipe.name))
        .delete(recursive: true);
    _showImportedRecipeToast(importRecipe.name, false, context);
    return null;
  }

  Directory importRecipeDir = Directory(
      await PathProvider.pP.getRecipeImportDirFolder(importRecipe.name));
  String recipeDir = await PathProvider.pP.getRecipeDirFull(importRecipe.name);
  if (Directory(recipeDir).existsSync()) {
    await Directory(recipeDir).delete(recursive: true);
  }
  await importRecipeDir
      .rename(await PathProvider.pP.getRecipeDirFull(importRecipe.name));

  await Directory(
          await PathProvider.pP.getRecipeImportDirFolder(importRecipe.name))
      .delete(recursive: true);
  _showImportedRecipeToast(importRecipe.name, true, context);

  return importRecipe;
}

//////////////////////////////////////// NEW VERSIONS ////////////////////////////

/// extracts the given .zip to the tmp directory and if the recipe/s data is valid,
/// returns the name of the .zip with the recipe data, otherwise: name of .zip with
/// null
Future<Map<String, Recipe>> importRecipesToTmp(File recipeZip) async {
  Directory importDir = Directory(await PathProvider.pP.getImportDir());
  // extract selected zip and save it to the importDir
  await exstractZip(recipeZip, importDir.path);
  List importFiles = importDir.listSync(recursive: true);

  bool importMulitiple = false;

  for (FileSystemEntity f in importFiles) {
    if (f.path.endsWith('.zip')) {
      importMulitiple = true;
      break;
    }
  }
  if (importMulitiple) {
    List importZips = importDir.listSync(recursive: true);
    Map<String, Recipe> recipes = {};

    for (FileSystemEntity f in importZips) {
      if (f.path.endsWith('.zip')) {
        recipes.addAll(await importRecipeToTmp(File(f.path)));
      }
    }

    return recipes;
  } else {
    return await importRecipeToTmp(recipeZip);
  }
}

/// extracts the given .zip to the tmp directory and if the recipe data is valid,
/// returns the name of the .zip with the recipe data, otherwise: name of .zip with
/// null
Future<Map<String, Recipe>> importRecipeToTmp(File recipeZip) async {
  Directory importDir = Directory(await PathProvider.pP.getImportDir());
  // extract selected zip and save it to the importDir
  await exstractZip(recipeZip, importDir.path);
  List importFiles = importDir.listSync(recursive: true);

  Recipe importRecipe;
  // loop through the import files
  for (File file in importFiles) {
    // stop if json found
    if (file.path.endsWith('.json')) {
      try {
        importRecipe = await getRecipeFromJson(file);
      } catch (e) {
        // if json doesn't contain a valid recipe
        importRecipe = null;
      }
      await file.delete();
      break;
    }
  }
  String recipeZipName = recipeZip.path
    ..substring(recipeZip.path.lastIndexOf('/'));
  return {recipeZipName: importRecipe};
}

/// moves the recipe data from the tmp directory to the app directory
Future<bool> importRecipeFromTmp(Recipe importRecipe) async {
  /// the import folder with the recipe data, which will move to the
  /// new directory
  Directory importRecipeDir = Directory(
      await PathProvider.pP.getRecipeImportDirFolder(importRecipe.name));

  /// the final directory, where the new import recipe should be
  String recipeDir = await PathProvider.pP.getRecipeDirFull(importRecipe.name);
  // if the directory already exists for whatever reason, ..
  if (Directory(recipeDir).existsSync()) {
    // .. delete it
    return false;
  }
  // move the files from the tmp import recipe directory to the app
  await importRecipeDir
      .rename(await PathProvider.pP.getRecipeDirFull(importRecipe.name));
  // delete the import directory of the recipe
  await Directory(
          await PathProvider.pP.getRecipeImportDirFolder(importRecipe.name))
      .delete(recursive: true);
  return true;
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
