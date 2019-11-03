import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'helper.dart';

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

// TODO: Continue

class PathProvider {
  PathProvider._();
  static final PathProvider pP = PathProvider._();

  static String _localPath;

  Future<String> get localPath async {
    if (_localPath != null) return _localPath;

    // if _database is null we instantiate it
    Directory localDirectory = await getApplicationDocumentsDirectory();
    return localDirectory.path;
  }

  String getRecipeStepDir(String recipeName) {
    String cRecipeName = getUnderscoreName(recipeName);

    return '$cRecipeName/stepImages/';
  }

  Future<String> getRecipeDir(String recipeName) async {
    String cRecipeName = getUnderscoreName(recipeName);

    String imageLocalPath = await localPath;
    return '$imageLocalPath/$cRecipeName';
  }

  Future<String> getRecipeStepNumberDirFull(
      String recipeName, int stepNumber) async {
    String cRecipeName = getUnderscoreName(recipeName);

    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/$cRecipeName/stepImages/$stepNumber/')
        .create(recursive: true);
    return '$imageLocalPath/$cRecipeName/stepImages/$stepNumber/';
  }

  String getRecipeStepNumberDir(String recipeName, int stepNumber) {
    String cRecipeName = getUnderscoreName(recipeName);

    return '/$cRecipeName/stepImages/$stepNumber/';
  }

  Future<String> getTmpRecipeDir() async {
    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/tmp/').create(recursive: true);
    return '$imageLocalPath/tmp/';
  }

  Future<String> getRecipeStepPreviewNumberDirFull(
      String recipeName, int stepNumber) async {
    String cRecipeName = getUnderscoreName(recipeName);

    String imageLocalPath = await localPath;
    await Directory(
            '$imageLocalPath/$cRecipeName/preview/stepImages/p-$stepNumber')
        .create(recursive: true);
    return '$imageLocalPath/$cRecipeName/preview/stepImages/p-$stepNumber/';
  }

  String getRecipeStepPreviewNumberDir(String recipeName, int stepNumber) {
    String cRecipeName = getUnderscoreName(recipeName);

    return '/$cRecipeName/preview/stepImages/p-$stepNumber/';
  }

  //////////// Paths to the ORIGINAL quality pictures ////////////

  Future<String> getRecipeOldPathFull(
      String oldRecipeName, String newRecipeName, String ending) async {
    String cOldRecipeName = getUnderscoreName(oldRecipeName);
    String cNewRecipeName = getUnderscoreName(newRecipeName);

    String imageLocalPath = await localPath;
    return '$imageLocalPath/$cNewRecipeName/$cOldRecipeName' + ending;
  }

  Future<String> getRecipePreviewOldPathFull(
      String oldRecipeName, String newRecipeName, String ending) async {
    String cOldRecipeName = getUnderscoreName(oldRecipeName);
    String cNewRecipeName = getUnderscoreName(newRecipeName);

    String imageLocalPath = await localPath;
    return '$imageLocalPath/$cNewRecipeName/preview/p-$cOldRecipeName' + ending;
  }

  Future<String> getRecipePathFull(String recipeName, String ending) async {
    String cRecipeName = getUnderscoreName(recipeName);

    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/$cRecipeName').create(recursive: true);
    return '$imageLocalPath/$cRecipeName/$cRecipeName' + ending;
  }

  String getRecipePath(String recipeName, String ending) {
    String cRecipeName = getUnderscoreName(recipeName);

    return '/$cRecipeName/$cRecipeName' + ending;
  }

  //////////// Paths to the PREVIEW quality pictures ////////////

  Future<String> getRecipePreviewPathFull(
      String recipeName, String ending) async {
    String cRecipeName = getUnderscoreName(recipeName);

    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/$cRecipeName/preview')
        .create(recursive: true);
    return '$imageLocalPath/$cRecipeName/preview/p-$cRecipeName' + ending;
  }

  String getRecipePreviewPath(String recipeName, String ending) {
    String cRecipeName = getUnderscoreName(recipeName);

    return '/$cRecipeName/preview/p-recipe-$cRecipeName' + ending;
  }

  // returns a list of the paths to the preview stepimages of the recipe
  Future<List<List<String>>> getRecipeStepPreviewPathList(
      List<List<String>> stepImages, String recipeName) async {
    String cRecipeName = getUnderscoreName(recipeName);

    if (!Directory(await getRecipeDir(recipeName)).existsSync()) return [[]];

    List<List<String>> output = [];
    for (int i = 0; i < stepImages.length; i++) {
      String dir = await getRecipeStepPreviewNumberDirFull(cRecipeName, i);
      output.add([]);
      for (int j = 0; j < stepImages[i].length; j++) {
        String currentImage = stepImages[i][j];
        output[i].add(dir +
            'p-' +
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
    String cRecipeName = getUnderscoreName(recipeName);

    var tmpDir = await getTemporaryDirectory();
    await Directory('${tmpDir.path}/import/$cRecipeName/$cRecipeName')
        .create(recursive: true);
    return '${tmpDir.path}/import/$cRecipeName/$cRecipeName';
  }

  Future<String> getRecipeImportDirFolder(String recipeName) async {
    String cRecipeName = getUnderscoreName(recipeName);

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

  String getShareZipFile(String recipeName, String fullTargetDir) {
    String cRecipeName = getUnderscoreName(recipeName);

    return '$fullTargetDir/$cRecipeName.zip';
  }

  String getShareJsonPath(String recipeName, String fullTargetDir) {
    String cRecipeName = getUnderscoreName(recipeName);

    return '$fullTargetDir/$cRecipeName.json';
  }
}
