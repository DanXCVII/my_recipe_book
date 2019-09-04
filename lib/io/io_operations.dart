import 'dart:io';
import 'dart:math';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../recipe.dart';

Future<void> saveRecipeImage(File pictureFile, String recipeName) async {
  String dataType =
      pictureFile.path.substring(pictureFile.path.lastIndexOf('.'));
  String recipeImagePathFull =
      await PathProvider.pP.getRecipePathFull(recipeName, dataType);

  saveImage(pictureFile, recipeImagePathFull, 2000);
  String recipeImagePreviewPath =
      await PathProvider.pP.getRecipePreviewPathFull(recipeName, dataType);
  saveImage(pictureFile, recipeImagePreviewPath, 300);
}

Future<void> deleteStepImage(
    String recipeName, int stepNumber, String imageFileName) async {
  PathProvider.pP
      .getRecipeStepPreviewNumberDirFull(recipeName, stepNumber - 1)
      .then((path) {
    File(path + imageFileName).deleteSync();
  });
  PathProvider.pP
      .getRecipeStepNumberDirFull(recipeName, stepNumber - 1)
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

  // TODO: Decide later if it's nicer to instantly save the image or do it at the end..

  String stepImagePathFull = await PathProvider.pP
          .getRecipeStepNumberDirFull(recipeName, stepNumber + 1) +
      newStepImageName;
  String stepImagePath =
      PathProvider.pP.getRecipeStepNumberDir(recipeName, stepNumber + 1);

  saveImage(
    newImage,
    stepImagePathFull,
    2000,
  );
  saveImage(
    newImage,
    await PathProvider.pP
            .getRecipeStepPreviewNumberDirFull(recipeName, stepNumber + 1) +
        newStepImagePreviewName,
    250,
  );
  return stepImagePath + newStepImageName;
}

Future<void> saveImage(File image, String name, int resolution) async {
  if (image != null) {
    final File newImage = await image.copy(name);
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
      quality: 95,
    );

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
