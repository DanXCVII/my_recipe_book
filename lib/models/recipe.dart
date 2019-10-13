import 'package:flutter/material.dart';

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
  List<Nutrition> nutritions;
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

class Nutrition {
  String name;
  String amountUnit;

  Nutrition({this.name, this.amountUnit});

  @override
  String toString() {
    return '$name: $amountUnit';
  }

  factory Nutrition.fromMap(Map<String, dynamic> json) => new Nutrition(
        name: json['name'],
        amountUnit: json['amountUnit'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'amountUnit': amountUnit,
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

  Ingredient getIngredient() {
    return Ingredient(name: name, amount: amount, unit: unit);
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
