import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:archive/archive_io.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import './local_paths.dart';
import '../constants/global_constants.dart' as Constants;
import '../helper.dart';
import '../local_storage/hive.dart';
import '../models/recipe.dart';

/// moves the images of the recipe to the correct image paths which is
/// defined by recipe.name
/// Condition:
/// - all paths are the full paths to the images
/// - stepImages include pattern: [...]/$recipeName/stepImages[...]
///
/// also deletes all files in the recipe directory that are not referenced
/// by the recipe
Future<Recipe> fixImagePaths(Recipe recipe) async {
  String _underscoreNewRecipeName = stringReplaceSpaceUnderscore(recipe.name);

  String newRecipeImageDataType = getImageDatatype(recipe.imagePath);

  String newRecipeImagePath = Constants.noRecipeImage;
  String newRecipeImagePreviewPath = Constants.noRecipeImage;

  List<List<String>> recipeStepImages = recipe.stepImages
      .map((list) => list.map((item) => item).toList())
      .toList();

  // if the recipe image has changed
  if (recipe.imagePath != Constants.noRecipeImage) {
    newRecipeImagePath = await PathProvider.pP.getRecipeImagePathFull(
        _underscoreNewRecipeName, newRecipeImageDataType);
    newRecipeImagePreviewPath = await PathProvider.pP
        .getRecipeImagePreviewPathFull(
            _underscoreNewRecipeName, newRecipeImageDataType);

    await File(recipe.imagePath).rename(newRecipeImagePath);
    await File(recipe.imagePreviewPath).rename(newRecipeImagePreviewPath);
  }
  for (int i = 0; i < recipe.stepImages.length; i++) {
    for (int j = 0; j < recipe.stepImages[i].length; j++) {
      String stepImageFileName = recipe.stepImages[i][j].substring(
          recipe.stepImages[i][j].lastIndexOf("/") + 1,
          recipe.stepImages[i][j].length);
      recipeStepImages[i][j] = await PathProvider.pP
              .getRecipeStepNumberDirFull(_underscoreNewRecipeName, i) +
          "/" +
          stepImageFileName;
      if (recipe.stepImages[i][j] != recipeStepImages[i][j]) {
        String _recipeName =
            getRecipeNameOfStepImagePath(recipe.stepImages[i][j]);

        String newStepImagePreviewPath = await PathProvider.pP
                .getRecipeStepPreviewNumberDirFull(
                    _underscoreNewRecipeName, i) +
            "/p-$stepImageFileName";
        String oldStepImagePreviewPath = await PathProvider.pP
                .getRecipeStepPreviewNumberDirFull(_recipeName, i) +
            "/p-$stepImageFileName";

        await File(recipe.stepImages[i][j]).rename(recipeStepImages[i][j]);
        await File(oldStepImagePreviewPath).rename(newStepImagePreviewPath);
      }
    }
  }

  Recipe newRecipe = recipe.copyWith(
    imagePath: newRecipeImagePath,
    imagePreviewPath: newRecipeImagePreviewPath,
    stepImages: recipeStepImages,
  );

  await _cleanRecipeFiles(newRecipe);

  return newRecipe;
}

/// deletes all files in the recipe dir which are not referenced by
/// the recipe anymore
Future<void> _cleanRecipeFiles(Recipe recipe) async {
  Directory recipeDir =
      Directory(await PathProvider.pP.getRecipeDirFull(recipe.name));
  List<String> recipeFiles = await _extractImagePaths(recipe);

  for (FileSystemEntity file in recipeDir.listSync(recursive: true)) {
    if (file is File) {
      if (!recipeFiles.contains(file.path)) {
        await file.delete();
      }
    }
  }
}

Future<List<String>> _extractImagePaths(Recipe recipe) async {
  return []
    ..addAll([recipe.imagePath, recipe.imagePreviewPath])
    ..addAll(recipe.stepImages.expand((i) => i).toList())
    ..addAll((await PathProvider.pP
            .getRecipeStepPreviewPathList(recipe.stepImages, recipe.name))
        .expand((i) => i)
        .toList());
}

/// cuts the recipe name out of the recipeStepImagePath and returns it.
/// stepImagePath must have the pattern:
/// [...]/$recipeName/stepImages[...]
String getRecipeNameOfStepImagePath(String fullImagePath) {
  int cutIndex = fullImagePath.indexOf('/stepImages');
  String cutImagePath = fullImagePath.substring(0, cutIndex);
  String recipeName = cutImagePath.substring(cutImagePath.lastIndexOf('/') + 1);

  return recipeName;
}

/// deletes the directory of the recipe under which the images are stored
Future<void> deleteRecipeData(String recipeName) async {
  Directory recipeDir =
      Directory(await PathProvider.pP.getRecipeDirFull(recipeName));
  if (await recipeDir.exists()) {
    await recipeDir.delete(recursive: true);
  }
}

/// copys the images with the directory structure from the old recipe name path
/// to the new recipe name path. The recipes must be in the local storage.
/// If no directory exists, nothing happens.
Future<void> copyRecipeDataToNewPath(
    String oldRecipeName, String newRecipeName) async {
  print('IO Anfang');
  String _underscoreOldRecipeName = stringReplaceSpaceUnderscore(oldRecipeName);
  String _underscoreNewRecipeName = stringReplaceSpaceUnderscore(newRecipeName);

  Directory recipeDir = Directory(
      await PathProvider.pP.getRecipeDirFull(_underscoreOldRecipeName));

  if (recipeDir.existsSync()) {
    var recipeFiles = recipeDir.listSync(recursive: true);

    for (FileSystemEntity f in recipeFiles) {
      if (f is File && f.path.contains('/stepImages/')) {
        String newFilePath = f.path.replaceAll(
            '/$_underscoreOldRecipeName/', '/$_underscoreNewRecipeName/');
        await Directory(newFilePath.substring(0, newFilePath.lastIndexOf('/')))
            .create(recursive: true);
        await f.copy(newFilePath);
      } else if (f is File) {
        print('Should be a preview image path or image path');
        print(f.path);
        String dataType = getImageDatatype(f.path);

        File oldRecipeImageFile = File(await PathProvider.pP
            .getRecipeImagePathFull(oldRecipeName, dataType));
        await oldRecipeImageFile.copy(await PathProvider.pP
            .getRecipeImagePathFull(newRecipeName, dataType));

        File oldRecipePreviewImageFile = File(await PathProvider.pP
            .getRecipeImagePreviewPathFull(oldRecipeName, dataType));
        await oldRecipePreviewImageFile.copy(await PathProvider.pP
            .getRecipeImagePreviewPathFull(newRecipeName, dataType));
      }
    }
  }
  print('IO Ende');
}

Future<void> renameRecipeData(String oldRecipeName, String newRecipeName,
    {String fileExtension}) async {
  await copyRecipeDataToNewPath(oldRecipeName, newRecipeName);
  await Directory(await PathProvider.pP.getRecipeDirFull(oldRecipeName))
      .delete(recursive: true);

  // Directory oldRecipeDir =
  //     Directory(await PathProvider.pP.getRecipeDir(oldRecipeName));
  // await oldRecipeDir.rename(await PathProvider.pP.getRecipeDir(newRecipeName));

  // if (fileExtension != null) {
  //   File oldRecipeImageFile = File(await PathProvider.pP
  //       .getRecipeOldPathFull(oldRecipeName, newRecipeName, fileExtension));
  //   if (oldRecipeImageFile.existsSync()) {
  //     await oldRecipeImageFile.rename(await PathProvider.pP
  //         .getRecipePathFull(newRecipeName, fileExtension));
  //   }

  //   File oldRecipePreviewImageFile = File(await PathProvider.pP
  //       .getRecipePreviewOldPathFull(
  //           oldRecipeName, newRecipeName, fileExtension));
  //   await oldRecipePreviewImageFile.rename(await PathProvider.pP
  //       .getRecipePreviewPathFull(newRecipeName, fileExtension));
  // }
}

/// saves the image in high and low quality in the local storage under the
/// recipe directory
Future<void> saveRecipeImage(File pictureFile, String recipeName) async {
  String dataType = getImageDatatype(pictureFile.path);

  String recipeImagePathFull =
      await PathProvider.pP.getRecipeImagePathFull(recipeName, dataType);

  await saveImage(pictureFile, recipeImagePathFull, false);
  String recipeImagePreviewPathFull =
      await PathProvider.pP.getRecipeImagePreviewPathFull(recipeName, dataType);
  await saveImage(pictureFile, recipeImagePreviewPathFull, true);
}

/// deletes the image of the recipe in the local storage if it exists ( not the stepImages )
Future<void> deleteRecipeImageIfExists(String recipeName) async {
  Directory recipeDir =
      Directory(await PathProvider.pP.getRecipeDirFull(recipeName));

  if (await recipeDir.exists()) {
    for (FileSystemEntity f in recipeDir.listSync()) {
      if (f is File) {
        await f.delete();
      }
    }

    Directory recipePreviewDir =
        Directory(await PathProvider.pP.getRecipePreviewDirFull(recipeName));

    for (FileSystemEntity f in recipePreviewDir.listSync()) {
      if (f is File) {
        await f.delete();
      }
    }
  }
}

/// deletes the step image of the recipe in the local storage if it exits.
/// Preview image will also be deleted. Throws exeption, when the images do
/// not exist
Future<void> deleteStepImage(
    String recipeName, int stepNumber, String imageFileName) async {
  PathProvider.pP
      .getRecipeStepPreviewNumberDirFull(recipeName, stepNumber)
      .then((path) async {
    await File(path + '/p-$imageFileName').delete();
  });
  PathProvider.pP
      .getRecipeStepNumberDirFull(recipeName, stepNumber)
      .then((path) {
    File(path + "/$imageFileName").deleteSync();
  });
}

/// returns a random filename (+filetype) with the same datafile ending as the selectedImagePath
/// e.g.: 3242.jpg
String getStepImageName(String selectedImagePath) {
  Random random = new Random();
  String dataType = getImageDatatype(selectedImagePath);
  return random.nextInt(10000).toString() + dataType;
}

Future<String> saveRecipeZip(String targetDir, String recipeName) async {
  Recipe recipe = await HiveProvider().getRecipeByName(recipeName);
  Recipe exportRecipe = await PathProvider.pP.removeLocalDirRecipeFiles(recipe);

  Directory recipeDir =
      Directory(await PathProvider.pP.getRecipeDirFull(recipeName));

  File jsonFile = File(PathProvider.pP.getShareJsonPath(recipeName, targetDir));
  Map<String, dynamic> jsonMap = exportRecipe.toMap();
  String json = jsonEncode(jsonMap);
  await jsonFile.writeAsString(json);

  var encoder = ZipFileEncoder();
  String zipFilePath = PathProvider.pP.getShareZipFile(recipeName, targetDir);
  encoder.create(zipFilePath);
  encoder.addFile(jsonFile);
  if (recipeDir.existsSync()) {
    encoder.addDirectory(recipeDir);
  }
  encoder.close();

  jsonFile.deleteSync();
  return zipFilePath;
}

/// saves the stepImage in high and low quality in the local storage under the given
/// recipeName and if nothing is given, "tmp" as recipeName will be used.
Future<String> saveStepImage(File newImage, int stepNumber,
    {String recipeName = 'tmp'}) async {
  String newStepImageName = getStepImageName(newImage.path);
  String newStepImagePreviewName = 'p-' + newStepImageName;

  String stepImagePathFull =
      await PathProvider.pP.getRecipeStepNumberDirFull(recipeName, stepNumber) +
          "/$newStepImageName";

  await saveImage(
    newImage,
    stepImagePathFull,
    false,
  );
  await saveImage(
    newImage,
    await PathProvider.pP
            .getRecipeStepPreviewNumberDirFull(recipeName, stepNumber) +
        "/$newStepImagePreviewName",
    true,
  );
  return stepImagePathFull;
}

/// saves the given image under the given targetPath in the given resolution.
Future<void> saveImage(File image, String targetPath, bool preview) async {
  if (image != null) {
    await image.copy(targetPath);
    print('UUUUUUUUUNNNNNNNNNNNNDDDDDDDDDD');

    await FlutterImageCompress.compressAndGetFile(image.path, targetPath,
        minHeight: preview ? 400 : 1000,
        minWidth: preview ? 400 : 1000,
        quality: preview ? 60 : 70);

    print(image.path);
    print(targetPath);

    print('GGGGGGGOOOOOOOOOOOOOOOOOOOOOOOO');
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
  }
}

/// extracts the given .zip to the tmp directory and if the recipe/s data is valid,
/// returns the name of the .zip with the recipe data, otherwise: name of .zip with
/// null
Future<Map<String, Recipe>> importRecipesToTmp(File recipeZip) async {
  await Directory(await PathProvider.pP.getImportDir()).delete(recursive: true);
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

Future<void> deleteImportFolder() async {
  await Directory(await PathProvider.pP.getImportDir()).delete();
}

/// extracts the given .zip to the tmp directory and if the recipe data is valid,
/// returns the name of the .zip with the recipe data, otherwise: name of .zip with
/// null
/// the json which contains the recipe object will be deleted afterwards
Future<Map<String, Recipe>> importRecipeToTmp(File recipeZip) async {
  Directory importDir = Directory(await PathProvider.pP.getImportDir());
  // extract selected zip and save it to the importDir
  await exstractZip(recipeZip, importDir.path);
  List importFiles = importDir.listSync(recursive: true);

  Recipe importRecipe;
  // loop through the import files
  for (FileSystemEntity file in importFiles) {
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

Future<Recipe> getRecipeFromJson(File jsonFile) async {
  String json = await jsonFile.readAsString();
  Map<String, dynamic> jsonMap = jsonDecode(json);
  Recipe importRecipe = Recipe.fromMap(jsonMap);
  return await PathProvider.pP.addLocalDirRecipeFiles(importRecipe);
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

/////////// DEPRECATED?? /////////////////
