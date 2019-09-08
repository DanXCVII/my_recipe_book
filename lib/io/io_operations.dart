import 'dart:io';
import 'dart:math';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../recipe.dart';

Future<void> renameRecipeData(
    String oldRecipeName, String fileExtension, String newRecipeName) async {
  Directory oldRecipeDir =
      Directory(await PathProvider.pP.getRecipeDir(oldRecipeName));
  await oldRecipeDir.rename(await PathProvider.pP.getRecipeDir(newRecipeName));

  File oldRecipeImageFile = File(await PathProvider.pP
      .getRecipeOldPathFull(oldRecipeName, newRecipeName, fileExtension));
  await oldRecipeImageFile.rename(
      await PathProvider.pP.getRecipePathFull(newRecipeName, fileExtension));

  File oldRecipePreviewImageFile = File(await PathProvider.pP
      .getRecipePreviewOldPathFull(
          oldRecipeName, newRecipeName, fileExtension));
  await oldRecipePreviewImageFile.rename(await PathProvider.pP
      .getRecipePreviewPathFull(newRecipeName, fileExtension));
}

Future<void> saveRecipeImage(File pictureFile, String recipeName) async {
  String dataType =
      pictureFile.path.substring(pictureFile.path.lastIndexOf('.'));
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
  String ending = selectedImagePath.substring(
      selectedImagePath.length - 4, selectedImagePath.length);
  return random.nextInt(10000).toString() + ending;
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
