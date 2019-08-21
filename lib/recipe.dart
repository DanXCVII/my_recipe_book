import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

enum Vegetable { NON_VEGETARIAN, VEGETARIAN, VEGAN }

class Recipe {
  int id;
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
  int complexity;

  Recipe(
      {@required this.id,
      @required this.name,
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
        ingredients: json['ingredients'],
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
        'ingredients': ingredients,
        'vegetable': vegetable,
        'steps': steps,
        'notes': notes
      };

  void setEqual(Recipe r) {
    this.id = r.id;
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
    this.complexity = r.complexity;
    this.isFavorite = r.isFavorite;
  }
}

class Ingredient {
  String name;
  double amount;
  String unit;

  Ingredient(this.name, this.amount, this.unit);
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

class ShoppingCart {
  List<Ingredient> ingredients;
  List<bool> checked;

  ShoppingCart({this.ingredients, this.checked}) {
    if (checked == null) checked = [];
    for (int i = 0; i < ingredients.length; i++) {
      checked.add(false);
    }
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

  String getRecipeStepDir(int recipeId) {
    return '$recipeId/stepImages/';
  }

  String getRecipeDir(int recipeId) {
    return '$recipeId/';
  }

  Future<String> getRecipeStepNumberDirFull(
      int recipeId, int stepNumber) async {
    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/$recipeId/stepImages/$stepNumber/')
        .create(recursive: true);
    return '$imageLocalPath/$recipeId/stepImages/$stepNumber/';
  }

  String getRecipeStepNumberDir(int recipeId, int stepNumber) {
    return '/$recipeId/stepImages/$stepNumber/';
  }

  Future<String> getRecipeStepPreviewNumberDirFull(
      int recipeId, int stepNumber) async {
    String imageLocalPath = await localPath;
    await Directory(
            '$imageLocalPath/$recipeId/preview/stepImages/p-$stepNumber')
        .create(recursive: true);
    return '$imageLocalPath/$recipeId/preview/stepImages/p-$stepNumber/';
  }

  String getRecipeStepPreviewNumberDir(int recipeId, int stepNumber) {
    return '/$recipeId/preview/stepImages/p-$stepNumber/';
  }

  //////////// Paths to the ORIGINAL quality pictures ////////////

  Future<String> getRecipePathFull(int recipeId, String ending) async {
    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/$recipeId').create(recursive: true);
    return '$imageLocalPath/$recipeId/recipe-$recipeId' + ending;
  }

  String getRecipePath(int recipeId, String ending) {
    return '/$recipeId/recipe-$recipeId' + ending;
  }

  //////////// Paths to the PREVIEW quality pictures ////////////

  Future<String> getRecipePreviewPathFull(int recipeId, String ending) async {
    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/$recipeId/preview')
        .create(recursive: true);
    return '$imageLocalPath/$recipeId/preview/p-recipe-$recipeId' + ending;
  }

  String getRecipePreviewPath(int recipeId, String ending) {
    return '/$recipeId/preview/p-recipe-$recipeId' + ending;
  }

  // returns a list of the paths to the preview stepimages of the recipe
  // TODO: use this method to get the paths instead of the list to the paths from the sql database
  Future<List<List<String>>> getRecipeStepPreviewPathList(
      List<List<String>> stepImages, int recipeId) async {
    List<List<String>> output = [];
    for (int i = 0; i < stepImages.length; i++) {
      String dir = await getRecipeStepPreviewNumberDirFull(recipeId, i + 1);
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
}
