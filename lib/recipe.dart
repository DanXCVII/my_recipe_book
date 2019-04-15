import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

enum Vegetable { NON_VEGETARIAN, VEGETARIAN, VEGAN }

class Recipe {
  int id;
  String name;
  File image;
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
  List<List<File>> stepImages = new List<List<File>>();
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

class ImagePath {
  static String getRecipeStepDir(int recipeId) {
    return '$recipeId/stepImages';
  }

  static String getRecipeDir(int recipeId) {
    return '$recipeId/';
  }

  static Future<String> getRecipeStepPath(
      int recipeId, int stepNumber, int number) async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String imageLocalPath = appDir.path;
    await Directory('$imageLocalPath/$recipeId/stepImages')
        .create(recursive: true);
    return '$imageLocalPath/$recipeId/stepImages/$recipeId' +
        's' +
        '$stepNumber' +
        's' +
        '$number.png';
  }

  static Future<String> getRecipePath(int recipeId) async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String imageLocalPath = appDir.path;
    await Directory('$imageLocalPath/$recipeId').create(recursive: true);
    return '$imageLocalPath/$recipeId/recipe-$recipeId.png';
  }

  static Future<String> getTmpRecipePath() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String imageLocalPath = appDir.path;
    await Directory('$imageLocalPath/tmp').create(recursive: true);
    return '$imageLocalPath/tmp/recipeTmp.png';
  }

  static Future<String> getTmpStepPathImage(String name) async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String imageLocalPath = appDir.path;
    await Directory('$imageLocalPath/tmp').create(recursive: true);
    return '$imageLocalPath/tmp/$name'; // png is included in the string because it's splitted at the end
  }

  static Future<String> getCategoryPath(String categoryName) async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String imageLocalPath = appDir.path;
    await Directory('$imageLocalPath/categories').create(recursive: true);
    return '$imageLocalPath/categories/${categoryName.replaceAll(new RegExp(r'[^\w\v]+'), '')}.png';
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
