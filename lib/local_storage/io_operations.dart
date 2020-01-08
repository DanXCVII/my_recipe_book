import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:archive/archive_io.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import './local_paths.dart';
import '../database.dart';
import '../helper.dart';
import '../models/recipe.dart';

/// moves the images of the recipe to the correct image paths which is
/// defined by recipe.name.
/// Condition:
/// - all paths are the full paths to the images
/// - stepImages include pattern: [...]/$recipeName/stepImages[...]
Future<Recipe> fixImagePaths(Recipe recipe) async {
  String _underscoreNewRecipeName = getUnderscoreName(recipe.name);

  String newRecipeImageDataType = getImageDatatype(recipe.imagePath);

  String newRecipeImagePath = await PathProvider.pP
      .getRecipePathFull(_underscoreNewRecipeName, newRecipeImageDataType);
  String newRecipeImagePreviewPath = await PathProvider.pP
      .getRecipePreviewPathFull(
          _underscoreNewRecipeName, newRecipeImageDataType);

  List<List<String>> recipeStepImages = recipe.stepImages;

  if (recipe.imagePath != 'images/randomFood.jpg' &&
      recipe.imagePath != newRecipeImagePath) {
    await File(recipe.imagePath).rename(newRecipeImagePath);
    await File(recipe.imagePreviewPath).rename(newRecipeImagePreviewPath);
  }
  for (int i = 0; i < recipe.stepImages.length; i++) {
    for (int j = 0; j < recipe.stepImages[i].length; j++) {
      recipeStepImages[i][j] = await PathProvider.pP
              .getRecipeStepNumberDirFull(_underscoreNewRecipeName, i) +
          "/" +
          getStepImageName(recipe.stepImages[i][j]);
      if (recipe.stepImages[i][j] != recipeStepImages[i][j]) {
        String _recipeName =
            getRecipeNameOfStepImagePath(recipe.stepImages[i][j]);

        String newStepImagePreviewPath = await PathProvider.pP
            .getRecipeStepPreviewNumberDirFull(_underscoreNewRecipeName, i);
        String oldStepImagePreviewPath = await PathProvider.pP
            .getRecipeStepPreviewNumberDirFull(_recipeName, i);

        await File(recipe.stepImages[i][j]).rename(recipeStepImages[i][j]);
        await File(oldStepImagePreviewPath).rename(newStepImagePreviewPath);
      }
    }
  }

  return recipe.copyWith(
    imagePath: newRecipeImagePath,
    imagePreviewPath: newRecipeImagePreviewPath,
    stepImages: recipeStepImages,
  );
}

/// cuts the recipe name out of the recipeStepImagePath and returns it.
/// stepImagePath must have the pattern:
/// [...]/$recipeName/stepImages[...]
String getRecipeNameOfStepImagePath(String fullImagePath) {
  int cutIndex = fullImagePath.indexOf('/stepImages');
  String cutImagePath = fullImagePath.substring(0, cutIndex - 1);
  String recipeName = cutImagePath.substring(cutImagePath.lastIndexOf('/') + 1);

  return recipeName;
}

Future<void> deleteRecipeData(String recipeName) async {
  Directory recipeDir =
      Directory(await PathProvider.pP.getRecipeDirFull(recipeName));
  if (await recipeDir.exists()) {
    await recipeDir.delete(recursive: true);
  }
}

Future<void> copyRecipeDataToNewPath(
    String oldRecipeName, String newRecipeName) async {
  print('IO Anfang');
  String _underscoreOldRecipeName = getUnderscoreName(oldRecipeName);
  String _underscoreNewRecipeName = getUnderscoreName(newRecipeName);

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

        File oldRecipeImageFile = File(
            await PathProvider.pP.getRecipePathFull(oldRecipeName, dataType));
        await oldRecipeImageFile.copy(
            await PathProvider.pP.getRecipePathFull(newRecipeName, dataType));

        File oldRecipePreviewImageFile = File(await PathProvider.pP
            .getRecipePreviewPathFull(oldRecipeName, dataType));
        await oldRecipePreviewImageFile.copy(await PathProvider.pP
            .getRecipePreviewPathFull(newRecipeName, dataType));
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

Future<void> saveRecipeImage(File pictureFile, String recipeName) async {
  String dataType = getImageDatatype(pictureFile.path);

  String recipeImagePathFull =
      await PathProvider.pP.getRecipePathFull(recipeName, dataType);

  await saveImage(pictureFile, recipeImagePathFull, 2000);
  String recipeImagePreviewPathFull =
      await PathProvider.pP.getRecipePreviewPathFull(recipeName, dataType);
  await saveImage(pictureFile, recipeImagePreviewPathFull, 300);
}

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

/// returns a random name with the same datafile ending as the selectedImagePath
/// e.g.: 3242.jpg
String getStepImageName(String selectedImagePath) {
  Random random = new Random();
  String dataType = getImageDatatype(selectedImagePath);
  return random.nextInt(10000).toString() + dataType;
}

Future<String> saveRecipeZip(String targetDir, String recipeName) async {
  Recipe exportRecipe = await DBProvider.db.getRecipeByName(recipeName, false);
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
    2000,
  );
  await saveImage(
    newImage,
    await PathProvider.pP
            .getRecipeStepPreviewNumberDirFull(recipeName, stepNumber) +
        "/$newStepImagePreviewName",
    250,
  );
  return stepImagePathFull;
}

Future<void> saveImage(File image, String name, int resolution) async {
  if (image != null) {
    await image.copy(name);
    print('UUUUUUUUUNNNNNNNNNNNNDDDDDDDDDD');
    /*
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(newImage.path);
    double quality = resolution / (properties.height + properties.width) * 100;
    if (quality > 100) quality = 100;
    print(properties.height);
    print(quality);
    File compressedFile = await FlutterNativeImage.compressImage(newImage.path,
        quality: quality.toInt(), percentage: 100);
        */

    await FlutterImageCompress.compressAndGetFile(
      image.path,
      name,
      minHeight: resolution,
      minWidth: resolution,
    );

    print(image.path);
    print(name);

    print('GGGGGGGOOOOOOOOOOOOOOOOOOOOOOOO');
    // compressedFile.copy(name);
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    // print(quality);

    /*
    ImageIO.Image newImage = ImageIO.decodeImage(values[0].readAsBytesSync());
    ImageIO.Image resizedImage =
        ImageIO.copyResize(newImage, height: values[2]);
    new File('${values[1]}')..writeAsBytesSync(ImageIO.encodeJpg(resizedImage));
    */
  }
}
