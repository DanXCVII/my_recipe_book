import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:archive/archive_io.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:my_recipe_book/models/recipe.dart';

import '../database.dart';
import '../helper.dart';
import '../recipe.dart';

Future<void> copyRecipeDataToNewPath(
    String oldRecipeName, String newRecipeName) async {
  String _underscoreOldRecipeName = getUnderscoreName(oldRecipeName);
  String _underscoreNewRecipeName = getUnderscoreName(newRecipeName);

  Directory recipeDir =
      Directory(await PathProvider.pP.getRecipeDir(_underscoreOldRecipeName));

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
}

Future<void> renameRecipeData(String oldRecipeName, String newRecipeName,
    {String fileExtension}) async {
  Directory oldRecipeDir =
      Directory(await PathProvider.pP.getRecipeDir(oldRecipeName));
  await oldRecipeDir.rename(await PathProvider.pP.getRecipeDir(newRecipeName));

  if (fileExtension != null) {
    File oldRecipeImageFile = File(await PathProvider.pP
        .getRecipeOldPathFull(oldRecipeName, newRecipeName, fileExtension));
    if (oldRecipeImageFile.existsSync()) {
      await oldRecipeImageFile.rename(await PathProvider.pP
          .getRecipePathFull(newRecipeName, fileExtension));
    }

    File oldRecipePreviewImageFile = File(await PathProvider.pP
        .getRecipePreviewOldPathFull(
            oldRecipeName, newRecipeName, fileExtension));
    await oldRecipePreviewImageFile.rename(await PathProvider.pP
        .getRecipePreviewPathFull(newRecipeName, fileExtension));
  }
}

Future<void> saveRecipeImage(File pictureFile, String recipeName) async {
  String dataType = getImageDatatype(pictureFile.path);

  String recipeImagePathFull =
      await PathProvider.pP.getRecipePathFull(recipeName, dataType);

  saveImage(pictureFile, recipeImagePathFull, 2000);
  String recipeImagePreviewPathFull =
      await PathProvider.pP.getRecipePreviewPathFull(recipeName, dataType);
  saveImage(pictureFile, recipeImagePreviewPathFull, 300);
}

Future<void> deleteStepImage(
    String recipeName, int stepNumber, String imageFileName) async {
  PathProvider.pP
      .getRecipeStepPreviewNumberDirFull(recipeName, stepNumber)
      .then((path) {
    File(path + 'p-' + imageFileName).deleteSync();
  });
  PathProvider.pP
      .getRecipeStepNumberDirFull(recipeName, stepNumber)
      .then((path) {
    File(path + imageFileName).deleteSync();
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
      Directory(await PathProvider.pP.getRecipeDir(recipeName));

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
          newStepImageName;
  String stepImagePath =
      PathProvider.pP.getRecipeStepNumberDir(recipeName, stepNumber);

  saveImage(
    newImage,
    stepImagePathFull,
    2000,
  );
  saveImage(
    newImage,
    await PathProvider.pP
            .getRecipeStepPreviewNumberDirFull(recipeName, stepNumber) +
        newStepImagePreviewName,
    250,
  );
  return stepImagePath + newStepImageName;
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
