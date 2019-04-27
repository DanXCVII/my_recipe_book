import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

enum Vegetable { NON_VEGETARIAN, VEGETARIAN, VEGAN }

class Recipe {
  int id;
  String name;
  String image;
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
      this.image,
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
        image: json['image'],
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
        'image': image,
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
  static final PathProvider pathProvider = PathProvider._();

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

  //////////// Paths to the original quality pictures ////////////

  Future<String> getRecipeStepPath(
      int recipeId, int stepNumber, int number) async {
    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/$recipeId/stepImages')
        .create(recursive: true);
    return '$imageLocalPath/$recipeId/stepImages/${recipeId}s${stepNumber}s$number.jpg';
  }

  Future<String> getRecipePath(int recipeId) async {
    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/$recipeId').create(recursive: true);
    return '$imageLocalPath/$recipeId/recipe-$recipeId.jpg';
  }

  Future<String> getCategoryPath(String categoryName) async {
    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/categories').create(recursive: true);
    return '$imageLocalPath/categories/${categoryName.replaceAll(new RegExp(r'[^\w\v]+'), '')}.jpg';
  }

  // TODO: implement getPreview path for category images, recipe and stepImages

  Future<String> getRecipePreviewPath(int recipeId) async {}

  Future<String> getRecipeStepPreviewPath(int recipeId) async {}

  Future<String> getCategoryPreviewPath(int recipeId) async {}

  Future<String> getTmpRecipePath() async {
    String imageLocalPath = await localPath;
    await Directory('$imageLocalPath/tmp').create(recursive: true);
    return '$imageLocalPath/tmp/recipeTmp.jpg';
  }

  static Future<String> getTmpStepPathImage(String name) async {
    Directory imageLocalPath = await getApplicationDocumentsDirectory()
      ..path;
    await Directory('$imageLocalPath/tmp').create(recursive: true);
    return '$imageLocalPath/tmp/$name'; // png is included in the string because it's splitted at the end
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
