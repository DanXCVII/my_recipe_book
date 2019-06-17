import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

enum Vegetable { NON_VEGETARIAN, VEGETARIAN, VEGAN }

class Recipe {
  int id;
  String name;
  String imagePath;
  double preperationTime;
  double cookingTime;
  double totalTime;
  double servings;
  List<String> categories;
  List<List<String>> ingredientsList;
  List<String> ingredientsGlossary = new List<String>();
  List<List<double>> amount = new List<List<double>>();
  List<List<String>> unit = new List<List<String>>();
  Vegetable vegetable;
  List<String> steps = new List<String>();
  List<List<String>> stepImages = new List<List<String>>();
  String notes;
  bool isFavorite;
  int complexity;
  // TODO: add categories

  Recipe(
      {@required this.id,
      @required this.name,
      this.imagePath,
      this.preperationTime,
      this.cookingTime,
      this.totalTime,
      @required this.servings,
      this.ingredientsGlossary,
      this.ingredientsList,
      @required this.amount,
      this.unit,
      @required this.vegetable,
      this.steps,
      this.stepImages,
      this.notes,
      this.categories,
      this.complexity,
      this.isFavorite});

  factory Recipe.fromMap(Map<String, dynamic> json) => new Recipe(
        id: json['id'],
        name: json['name'],
        imagePath: json['image'],
        preperationTime: json['preperationTime'],
        cookingTime: json['cookingTime'],
        totalTime: json['totalTime'],
        servings: json['servings'],
        ingredientsGlossary: json['ingredientsGlossary'],
        ingredientsList: json['ingredientsList'],
        amount: json['amount'],
        unit: json['unit'],
        vegetable: json['vegetable'],
        steps: json['steps'],
        notes: json['notes'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'image': imagePath,
        'preperationTime': preperationTime,
        'cookingTime': cookingTime,
        'totalTime': totalTime,
        'servings': servings,
        'ingredientsGlossary': ingredientsGlossary,
        'ingredientsList': ingredientsList,
        'amount': amount,
        'unit': unit,
        'vegetable': vegetable,
        'steps': steps,
        'notes': notes
      };
}

Color getRecipePrimaryColor(Recipe recipe) {
  switch (recipe.vegetable) {
    case Vegetable.NON_VEGETARIAN:
      return Color(0xff4D0B06);
    case Vegetable.VEGAN:
      return Color(0xff133F12);
    case Vegetable.VEGETARIAN:
      return Color(0xff074505);
  }
  return null;
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

  String getRecipeStepDir(int recipeId) {
    return '$recipeId/stepImages';
  }

  String getRecipeDir(int recipeId) {
    return '$recipeId/';
  }

  Future<String> getRecipeStepNumberDir(int recipeId, int stepNumber) async {
    String imageLocalPath = await localPath;
    return '$imageLocalPath/$recipeId/stepImages/$stepNumber/';
  }

  //////////// Paths to the ORIGINAL quality pictures ////////////

  Future<String> getRecipePath(int recipeId) async {
    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/$recipeId').create(recursive: true);
    return '$imageLocalPath/$recipeId/recipe-$recipeId.jpg';
  }

  Future<String> getRecipeStepPath(
      int recipeId, int stepNumber, int number) async {
    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/$recipeId/stepImages/$stepNumber')
        .create(recursive: true);
    return '$imageLocalPath/$recipeId/stepImages/$stepNumber/${recipeId}s${stepNumber}s$number.jpg';
  }

  Future<String> getCategoryPath(String categoryName) async {
    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/categories').create(recursive: true);
    return '$imageLocalPath/categories/${categoryName.replaceAll(new RegExp(r'[^\w\v]+'), '')}.jpg';
  }

  //////////// Paths to the PREVIEW quality pictures ////////////

  Future<String> getRecipePreviewPath(int recipeId) async {
    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/$recipeId/preview')
        .create(recursive: true);
    return '$imageLocalPath/$recipeId/preview/p-recipe-$recipeId.jpg';
  }

  Future<String> getRecipeStepPreviewPath(
      int recipeId, int stepNumber, int number) async {
    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/$recipeId/preview/stepImages/$stepNumber')
        .create(recursive: true);
    return '$imageLocalPath/$recipeId/preview/stepImages/p-$stepNumber/${recipeId}s${stepNumber}s$number.jpg';
  }

  Future<String> getCategoryPreviewPath(String categoryName) async {
    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/categories/preview')
        .create(recursive: true);
    return '$imageLocalPath/categories/preview/p-${categoryName.replaceAll(new RegExp(r'[^\w\v]+'), '')}.jpg';
  }

  // returns a list of the paths to the preview stepimages of the recipe
  // TODO: use this method to get the paths instead of the list to the paths in the sql database
  Future<List<List<String>>> getRecipeStepPreviewPathList(
      int stepCount, int recipeId) async {
    List<List<String>> output = [[]];
    for (int i = 0; i < stepCount; i++) {
      String stepImageDirectory = await getRecipeStepNumberDir(recipeId, i);
      if (await Directory(stepImageDirectory).exists()) {
        Directory stepDir = Directory(stepImageDirectory);
        for (int j = 0; j < stepDir.listSync().length; j++) {
          output[i].add(await getRecipeStepPreviewPath(recipeId, i, j));
        }
      }
      output.add([]);
    }
    return output;
  }

  //////////// paths where pictures are stored temporarily ////////////

  /// param uniqueName must have the ending of the dataformat (*.jpg etc.)
  Future<String> getTmpImagePath(String uniqueName) async {
    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/tmp').create(recursive: true);
    return '$imageLocalPath/tmp/uniqueName';
  }
}

class Categories {
  static List<String> _categories;

  Categories({List<String> categories});

  static void setCategories(List<String> categories) {
    _categories = categories;
  }

  static void removeCategory(String name) {
    _categories.remove(name);
  }

  static void addCategory(String name) {
    _categories == null ? _categories = [name] : _categories.add(name);
  }

  static List<String> getCategories() {
    if (_categories == null)
      return new List<String>();
    else
      return _categories;
  }
}
