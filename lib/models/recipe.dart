import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'enums.dart';
import 'ingredient.dart';
import 'nutrition.dart';

part './typeAdapter/recipe.g.dart';

@HiveType()
class Recipe extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String imagePath;
  @HiveField(2)
  String imagePreviewPath;
  @HiveField(3)
  double preperationTime;
  @HiveField(4)
  double cookingTime;
  @HiveField(5)
  double totalTime;
  @HiveField(6)
  double servings;
  @HiveField(7)
  List<String> categories;
  @HiveField(8)
  List<String> ingredientsGlossary = new List<String>();
  @HiveField(9)
  List<List<Ingredient>> ingredients = new List<List<Ingredient>>();
  @HiveField(10)
  Vegetable vegetable;
  @HiveField(11)
  List<String> steps = new List<String>();
  @HiveField(12)
  List<List<String>> stepImages = new List<List<String>>();
  @HiveField(13)
  String notes;
  @HiveField(14)
  List<Nutrition> nutritions;
  @HiveField(15)
  bool isFavorite;
  @HiveField(16)
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
      this.nutritions,
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
        'nutritions : ${nutritions.toString()}\n'
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
      nutritions: List<dynamic>.from(json['nutritions'])
          .map((n) => Nutrition.fromMap(n))
          .toList(),
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
        'notes': notes,
        'nutritions': nutritions.map((n) => n.toMap()).toList()
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
    this.nutritions = r.nutritions;
  }
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

class SearchRecipe {
  String name;
  int id;

  SearchRecipe({this.name, this.id});
}
