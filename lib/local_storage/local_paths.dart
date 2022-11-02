import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/recipe.dart';
import '../util/helper.dart';

/// Path to::
/// recipe image
/// /$recipeId/recipe-$recipeId.jpg
/// recipe step image
/// /$recipeId/stepImages/${recipeId}s${stepNumber}s$number.jpg
///
/// category image
/// /categories/${categoryName.replaceAll(new RegExp(r'[^\w\v]+'), '')}.jpg'
///
/// recipe image preview
/// /$recipeId/preview/recipe-$recipeId.jpg
/// recipe step image preview
/// /$recipeId/stepImages/preview/${recipeId}s${stepNumber}s$number.jpg

class PathProvider {
  PathProvider._();
  static final PathProvider pP = PathProvider._();

  static String? _localPath;

  Future<String?> get localPath async {
    if (_localPath != null) return _localPath;

    // if _database is null we instantiate it
    Directory localDirectory = await getApplicationDocumentsDirectory();
    return localDirectory.path;
  }

  String getRecipeStepDir(String recipeName) {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);

    return '$cRecipeName/stepImages/';
  }

  String getRecipeDirName(String recipeName) {
    return stringReplaceSpaceUnderscore(recipeName);
  }

  Future<String> getRecipeDirFull(String recipeName) async {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);

    String? imageLocalPath = await localPath;
    return '$imageLocalPath/$cRecipeName';
  }

  Future<String> getRecipeStepNumberDirFull(
      String recipeName, int stepNumber) async {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);

    String? imageLocalPath = await localPath;
    await Directory('$imageLocalPath/$cRecipeName/stepImages/$stepNumber')
        .create(recursive: true);
    return '$imageLocalPath/$cRecipeName/stepImages/$stepNumber';
  }

  String getRecipeStepNumberDir(String recipeName, int stepNumber) {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);

    return '/$cRecipeName/stepImages/$stepNumber';
  }

  Future<String> getTmpRecipeDir() async {
    String? imageLocalPath = await localPath;
    await Directory('$imageLocalPath/tmp/').create(recursive: true);
    return '$imageLocalPath/tmp/';
  }

  Future<String> getRecipeStepPreviewNumberDirFull(
      String recipeName, int stepNumber) async {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);

    String? imageLocalPath = await localPath;
    await Directory(
            '$imageLocalPath/$cRecipeName/preview/stepImages/p-$stepNumber')
        .create(recursive: true);
    return '$imageLocalPath/$cRecipeName/preview/stepImages/p-$stepNumber';
  }

  String getRecipeStepPreviewNumberDir(String recipeName, int stepNumber) {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);

    return '/$cRecipeName/preview/stepImages/p-$stepNumber';
  }

  Future<Directory> getExternalAppDir() async {
    String externalPath = (await getExternalStorageDirectory())!.path;
    return await Directory(
            externalPath.substring(0, externalPath.lastIndexOf("/") + 1) +
                "backup")
        .create(recursive: true);
  }

  //////////// Paths to the ORIGINAL quality pictures ////////////

  Future<String> getRecipeOldPathFull(
      String oldRecipeName, String newRecipeName, String ending) async {
    String cOldRecipeName = stringReplaceSpaceUnderscore(oldRecipeName);
    String cNewRecipeName = stringReplaceSpaceUnderscore(newRecipeName);

    String? imageLocalPath = await localPath;
    return '$imageLocalPath/$cNewRecipeName/$cOldRecipeName' + ending;
  }

  Future<String> getRecipePreviewOldPathFull(
      String oldRecipeName, String newRecipeName, String ending) async {
    String cOldRecipeName = stringReplaceSpaceUnderscore(oldRecipeName);
    String cNewRecipeName = stringReplaceSpaceUnderscore(newRecipeName);

    String? imageLocalPath = await localPath;
    return '$imageLocalPath/$cNewRecipeName/preview/p-$cOldRecipeName' + ending;
  }

  Future<String> getRecipeImagePathFull(String recipeName, String ending,
      {String? targetDir}) async {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);

    String? imageLocalPath = await localPath;
    await Directory(
            '${targetDir == null ? imageLocalPath : targetDir}/$cRecipeName')
        .create(recursive: true);
    return '${targetDir == null ? imageLocalPath : targetDir}/$cRecipeName/$cRecipeName' +
        ending;
  }

  String getRecipePath(String recipeName, String ending) {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);

    return '/$cRecipeName/$cRecipeName' + ending;
  }

  //////////// Paths to the PREVIEW quality pictures ////////////

  Future<String> getRecipeImagePreviewPathFull(String recipeName, String ending,
      {String? targetDir}) async {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);

    String? imageLocalPath = await localPath;
    await Directory(
            '${targetDir == null ? imageLocalPath : targetDir}/$cRecipeName/preview')
        .create(recursive: true);
    return '${targetDir == null ? imageLocalPath : targetDir}/$cRecipeName/preview/p-$cRecipeName' +
        ending;
  }

  String getRecipePreviewPath(String recipeName, String ending) {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);

    return '/$cRecipeName/preview/p-recipe-$cRecipeName' + ending;
  }

  Future<String> getRecipePreviewDirFull(String recipeName) async {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);

    String? imageLocalPath = await localPath;
    return '$imageLocalPath/$cRecipeName/preview';
  }

  // returns a list of the paths to the preview stepimages of the recipe
  Future<List<List<String>>> getRecipeStepPreviewPathList(
      List<List<String>> stepImages, String recipeName) async {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);

    if (!Directory(await getRecipeDirFull(recipeName)).existsSync())
      return [[]];

    List<List<String>> output = [];
    for (int i = 0; i < stepImages.length; i++) {
      String dir = await getRecipeStepPreviewNumberDirFull(cRecipeName, i);
      output.add([]);
      for (int j = 0; j < stepImages[i].length; j++) {
        String currentImage = stepImages[i][j];
        output[i].add(dir +
            '/p-' +
            currentImage.substring(
                currentImage.lastIndexOf('/') + 1, currentImage.length));
      }
    }

    return output;
  }

  //////////// Paths to importDir ////////////
  Future<String> getImportDir() async {
    var tmpDir = await getTemporaryDirectory();
    await Directory('${tmpDir.path}/import').create(recursive: true);
    return '${tmpDir.path}/import/';
  }

  Future<String> getRecipeImportDir(String recipeName) async {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);

    var tmpDir = await getTemporaryDirectory();
    await Directory('${tmpDir.path}/import/$cRecipeName/$cRecipeName')
        .create(recursive: true);
    return '${tmpDir.path}/import/$cRecipeName/$cRecipeName';
  }

  Future<String> getRecipeImportDirFolder(String recipeName) async {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);

    var tmpDir = await getTemporaryDirectory();
    await Directory('${tmpDir.path}/import/$cRecipeName')
        .create(recursive: true);
    return '${tmpDir.path}/import/$cRecipeName';
  }

  //////////// Paths to shareDir ////////////
  Future<String> getShareDir() async {
    Directory tmpDir = await getTemporaryDirectory();
    await Directory('${tmpDir.path}/share').create(recursive: true);
    return '${tmpDir.path}/share';
  }

  /// Path to Directory for sharing multiple recipes
  Future<String> getShareMultiDir() async {
    Directory tmpDir = await getTemporaryDirectory();
    await Directory('${tmpDir.path}/share/multi').create(recursive: true);
    return '${tmpDir.path}/share/multi';
  }

  String getZipFilePath(String recipeName, String fullTargetDir) {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);

    return '$fullTargetDir/$cRecipeName.zip';
  }

  String getJsonPath(String recipeName, String fullTargetDir) {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);

    return '$fullTargetDir/$cRecipeName.json';
  }

  ////////////// Import recipe related //////////////////

  /// returns the recipe at which the AppDocDir is removed from all files
  Future<Recipe> removeLocalDirRecipeFiles(Recipe recipe) async {
    String imagePath = "images/randomFood.jpg";
    String imagePreviewPath = "images/randomFood.jpg";
    List<List<String>> stepImages = [[]];

    String removeString = (await getApplicationDocumentsDirectory()).path;
    if (recipe.imagePath != "images/randomFood.jpg") {
      imagePath = recipe.imagePath.replaceFirst(removeString, '');
      imagePreviewPath = recipe.imagePreviewPath.replaceFirst(removeString, '');
    }
    for (int i = 0; i < recipe.stepImages.length; i++) {
      if (i > 0) {
        stepImages.add([]);
      }
      for (int j = 0; j < recipe.stepImages[i].length; j++) {
        stepImages[i]
            .add(recipe.stepImages[i][j].replaceFirst(removeString, ''));
      }
    }

    return recipe.copyWith(
      imagePath: imagePath,
      imagePreviewPath: imagePreviewPath,
      stepImages: stepImages,
    );
  }

  Future<Recipe> addLocalDirRecipeFiles(Recipe recipe) async {
    String imagePath = "images/randomFood.jpg";
    String imagePreviewPath = "images/randomFood.jpg";
    List<List<String>> stepImages = [[]];

    String appDocDir = (await getApplicationDocumentsDirectory()).path;
    if (recipe.imagePath != "images/randomFood.jpg") {
      imagePath = "$appDocDir${recipe.imagePath}";
      imagePreviewPath = "$appDocDir${recipe.imagePreviewPath}";
    }
    for (int i = 0; i < recipe.stepImages.length; i++) {
      if (i > 0) {
        stepImages.add([]);
      }
      for (int j = 0; j < recipe.stepImages[i].length; j++) {
        stepImages[i].add("$appDocDir${recipe.stepImages[i][j]}");
      }
    }

    return recipe.copyWith(
      imagePath: imagePath,
      imagePreviewPath: imagePreviewPath,
      stepImages: stepImages,
    );
  }
}
