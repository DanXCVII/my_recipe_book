import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/recipe.dart';
import 'package:path_provider/path_provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              importRecipe().then((_) {});
            },
            child: ListTile(
              title: Text('import Recipe'),
            ),
          ),
          SwitchListTile(
            title: Text('Switch Theme'),
            onChanged: (value) {},
            value: true,
          ),
          Divider(),
          ListTile(title: Text('About me')),
          Divider(),
          ListTile(title: Text('Rate this app')),
          Divider(),
        ],
      ),
    );
  }

  Future<void> importRecipe() async {
    // TODO: error importing empty recipe
    var tmpDir = await getTemporaryDirectory();
    var newRecipeId = await DBProvider.db.getNewIDforTable('recipe', 'id');
    var newRecipeDir =
        Directory(await PathProvider.pP.getRecipeDir(newRecipeId));

    String _path = await FilePicker.getFilePath(
        type: FileType.CUSTOM, fileExtension: 'zip');

    if (_path == null) return;

    Directory importDir = Directory('${tmpDir.path}/import/');
    if (importDir.existsSync()) {
      Directory('${tmpDir.path}/import/').deleteSync(recursive: true);
    }

    if (newRecipeDir.existsSync()) await newRecipeDir.delete(recursive: true);

    await exstractZip(File(_path), importDir.path);
    Directory newTmpRecipeDir = replaceFileNames(importDir, newRecipeId);
    newRecipeDir.createSync(recursive: true);
    if (newTmpRecipeDir != null)
      newTmpRecipeDir.renameSync(newRecipeDir.path)
        ..createSync(recursive: true);
    await importRecipeToDatabase(importDir, newRecipeId);
    importDir.deleteSync(recursive: true);
  }

  // Saves the recipe, read from the json file, in the local database
  Future<void> importRecipeToDatabase(
      Directory importDir, int newRecipeId) async {
    List files = importDir.listSync(recursive: true);

    for (File file in files) {
      if (file.path.endsWith('.json')) {
        String json = await file.readAsString();
        Map<String, dynamic> jsonMap = jsonDecode(json);
        Recipe rr = Recipe.fromMap(jsonMap);
        Recipe newRecipe = await updateRecipe(rr, newRecipeId);

        await DBProvider.db.newRecipe(newRecipe);

        for (String c in newRecipe.categories) {
          await DBProvider.db.newCategory(c);
        }
      }

      break;
    }
  }

  Future<Recipe> updateRecipe(Recipe recipe, int newRecipeId) async {
    recipe.id = newRecipeId;

    if (recipe.imagePath.lastIndexOf(RegExp(r'\/[0-9]\/')) != -1) {
      String recipeImagePath = changeIdInPath(
          recipe.imagePath.substring(
              recipe.imagePath.lastIndexOf(RegExp(r'\/[0-9]\/')),
              recipe.imagePath.length),
          newRecipeId);
      String recipeImagePreviewPath = changeIdInPath(
          recipe.imagePreviewPath.substring(
              recipe.imagePreviewPath.lastIndexOf(RegExp(r'\/[0-9]\/')),
              recipe.imagePreviewPath.length),
          newRecipeId);

      recipe.imagePath = recipeImagePath;
      recipe.imagePreviewPath = recipeImagePreviewPath;
    }

    for (int i = 0; i < recipe.stepImages.length; i++)
      for (int j = 0; j < recipe.stepImages[i].length; j++) {
        recipe.stepImages[i][j] =
            PathProvider.pP.getRecipeStepNumberDir(newRecipeId, i + 1) +
                recipe.stepImages[i][j]
                    .substring(recipe.stepImages[i][j].lastIndexOf('/') + 1);
      }
    return recipe;
  }

  // exstracts the zip to the destination directory
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

  String changeIdInPath(String rPath, int newId) {
    String stringWithId = rPath;
    String beginning = '';
    if (rPath.lastIndexOf(RegExp(r'\/[0-9]\/')) - 1 > 0) {
      stringWithId = rPath.substring(
          rPath.lastIndexOf(RegExp(r'\/[0-9]\/')), rPath.length);
      beginning =
          rPath.substring(0, rPath.lastIndexOf(RegExp(r'\/[0-9]\/')) - 1);
    }

    stringWithId =
        stringWithId.replaceAll(RegExp(r'[0-9]{1,}'), newId.toString());
    return beginning + stringWithId;
  }

  /// changes the names of the files and directory to the names with the new
  /// recipeId as path
  Directory replaceFileNames(Directory directory, int newId) {
    List files = directory.listSync(recursive: true);

    for (var file in files) {
      if (file is File && file.path.contains('recipe-')) {
        file.rename(file.path
                .substring(0, file.path.lastIndexOf(RegExp(r'\/[0-9]\/')) + 3) +
            changeIdInPath(
                file.path.substring(
                    file.path.lastIndexOf(RegExp(r'\/[0-9]\/')) + 3,
                    file.path.length),
                newId));
      }
    }

    /// renaming the folder (eg. rename tmpDir/0 zu tmpDir/4)
    /// mit der neuen id
    List importDir = directory.listSync();
    Directory newRecipeDir;

    for (var file in importDir) {
      if (file is Directory) {
        newRecipeDir = Directory(
            file.path.substring(0, file.path.lastIndexOf('/') + 1) +
                newId.toString());
        file.rename(newRecipeDir.path);
      }
    }
    return newRecipeDir;
  }
}
