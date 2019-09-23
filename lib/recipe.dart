import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'helper.dart';

enum Vegetable { NON_VEGETARIAN, VEGETARIAN, VEGAN }

class Recipe {
  String name;
  String imagePath;
  String imagePreviewPath;
  double preperationTime;
  double cookingTime;
  double totalTime;
  double servings;
  List<String> categories;
  List<String> ingredientsGlossary = new List<String>();
  List<List<Ingredient>> ingredients = new List<List<Ingredient>>();
  Vegetable vegetable;
  List<String> steps = new List<String>();
  List<List<String>> stepImages = new List<List<String>>();
  String notes;
  bool isFavorite;
  int effort;

  Recipe(
      {@required this.name,
      this.imagePath,
      this.imagePreviewPath,
      this.preperationTime,
      this.cookingTime,
      this.totalTime,
      @required this.servings,
      this.ingredientsGlossary,
      this.ingredients,
      @required this.vegetable,
      this.steps,
      this.stepImages,
      this.notes,
      this.categories,
      this.effort,
      this.isFavorite});

  @override
  String toString() {
    return ('name : $name\n'
        'imagePath : $imagePath\n'
        'imagePreviewPath : $imagePreviewPath\n'
        'preperationTime : $preperationTime\n'
        'cookingTime : $cookingTime\n'
        'totalTime : $totalTime\n'
        'servings : $servings\n'
        'ingredientsGlossary : ${ingredientsGlossary.toString()}\n'
        'ingredients : ${ingredients.toString()}\n'
        'vegetable : ${vegetable.toString()}\n'
        'steps : ${steps.toString()}\n'
        'stepImages : ${stepImages.toString()}\n'
        'notes : $notes\n'
        'categories : ${categories.toString()}\n'
        'complexity : $effort\n'
        'isFavorite : $isFavorite');
  }

  factory Recipe.fromMap(Map<String, dynamic> json) {
    Vegetable vegetable;
    if (json['vegetable'] == Vegetable.NON_VEGETARIAN.toString()) {
      vegetable = Vegetable.NON_VEGETARIAN;
    } else if (json['vegetable'] == Vegetable.VEGETARIAN.toString()) {
      vegetable = Vegetable.VEGETARIAN;
    } else {
      vegetable = Vegetable.VEGAN;
    }

    return new Recipe(
      name: json['name'],
      imagePath: json['image'],
      imagePreviewPath: json['imagePreviewPath'],
      preperationTime: json['preperationTime'],
      cookingTime: json['cookingTime'],
      totalTime: json['totalTime'],
      effort: json['complexity'],
      servings: json['servings'],
      categories: List<String>.from(json['categories']),
      ingredientsGlossary: List<String>.from(json['ingredientsGlossary']),
      stepImages: List<List<dynamic>>.from(json['stepImages'])
          .map((i) => List<String>.from(i).toList())
          .toList(),
      ingredients: List<List<dynamic>>.from(json['ingredients'])
          .map((l) => List<Map<String, dynamic>>.from(l)
              .map((i) => Ingredient.fromMap(i))
              .toList())
          .toList()
            ..removeLast(),
      vegetable: vegetable,
      steps: List<String>.from(json['steps']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'image': imagePath,
        'imagePreviewPath': imagePreviewPath,
        'preperationTime': preperationTime,
        'cookingTime': cookingTime,
        'totalTime': totalTime,
        'servings': servings,
        'complexity': effort,
        'categories': categories,
        'ingredientsGlossary': ingredientsGlossary,
        'ingredients': ingredients
            .map((list) => list.map((ingred) => ingred.toMap()).toList())
            .toList(),
        'vegetable': vegetable.toString(),
        'steps': steps,
        'stepImages': stepImages,
        'notes': notes
      };

  void setEqual(Recipe r) {
    this.name = r.name;
    this.imagePath = r.imagePath;
    this.imagePreviewPath = r.imagePreviewPath;
    this.preperationTime = r.preperationTime;
    this.cookingTime = r.cookingTime;
    this.totalTime = r.totalTime;
    this.servings = r.servings;
    this.ingredientsGlossary = r.ingredientsGlossary;
    this.ingredients = r.ingredients;
    this.vegetable = r.vegetable;
    this.steps = r.steps;
    this.stepImages = r.stepImages;
    this.notes = r.notes;
    this.categories = r.categories;
    this.effort = r.effort;
    this.isFavorite = r.isFavorite;
  }
}

class RecipePreview {
  String name;
  String imagePreviewPath;
  String totalTime;
  int ingredientsAmount;
  int effort;
  bool isFavorite;
  Vegetable vegetable;
  List<String> categories;

  RecipePreview({
    this.name,
    this.totalTime,
    this.imagePreviewPath,
    this.ingredientsAmount,
    this.effort,
    this.vegetable,
    this.isFavorite,
    this.categories,
  });

  get rName => name;
  get rTotalTime => totalTime;
  get rIngredientsAmount => ingredientsAmount;
  get rEffort => effort;
  get rVegetable => vegetable;
  get rIsFavorite => isFavorite;
  get rImagePreviewPath => imagePreviewPath;
  get rCategories => categories;
}

class Ingredient {
  String name;
  double amount;
  String unit;

  Ingredient({this.name, this.amount, this.unit});

  factory Ingredient.fromMap(Map<String, dynamic> json) => new Ingredient(
        name: json['name'],
        amount: json['amount'],
        unit: json['unit'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'amount': amount,
        'unit': unit,
      };
}

Color getRecipePrimaryColor(Vegetable vegetable) {
  switch (vegetable) {
    case Vegetable.NON_VEGETARIAN:
      return Color(0xff4D0B06);
    case Vegetable.VEGAN:
      return Color(0xff133F12);
    case Vegetable.VEGETARIAN:
      return Color(0xff074505);
  }
  return null;
}

class CheckableIngredient {
  String name;
  double amount;
  String unit;
  bool checked;

  CheckableIngredient(Ingredient i, {this.checked = false}) {
    name = i.name;
    amount = i.amount;
    unit = i.unit;
  }
  @override
  String toString() {
    return '$name $amount $unit $checked';
  }
}

class RecipeCategory {
  String name;
  String imagePath;

  RecipeCategory({this.name, this.imagePath});
}

class SearchRecipe {
  String name;
  int id;

  SearchRecipe({this.name, this.id});
}

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
    print('looooooooool');
    print(cRecipeName);

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
