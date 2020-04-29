import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../util/helper.dart';
import 'enums.dart';
import 'ingredient.dart';
import 'nutrition.dart';
import 'string_int_tuple.dart';

part 'recipe.g.dart';

@HiveType()
class Recipe extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String imagePath;
  @HiveField(2)
  final String imagePreviewPath;
  @HiveField(3)
  final double preperationTime;
  @HiveField(4)
  final double cookingTime;
  @HiveField(5)
  final double totalTime;
  @HiveField(6)
  final double servings;
  @HiveField(7)
  final List<String> categories;
  @HiveField(8)
  final List<String> ingredientsGlossary;
  @HiveField(9)
  final List<List<Ingredient>> ingredients;
  @HiveField(10)
  final Vegetable vegetable;
  @HiveField(11)
  final List<String> steps;
  @HiveField(12)
  final List<List<String>> stepImages;
  @HiveField(13)
  final String notes;
  @HiveField(14)
  final List<Nutrition> nutritions;
  @HiveField(15)
  final bool isFavorite;
  @HiveField(16)
  final int effort;
  @HiveField(17)
  final String lastModified;
  @HiveField(18)
  final int rating;
  @HiveField(19)
  final List<StringIntTuple> tags;
  @HiveField(20)
  final String source;

  Recipe({
    @required this.name,
    this.imagePath = "images/randomFood.jpg",
    this.imagePreviewPath = "images/randomFood.jpg",
    this.preperationTime = 0,
    this.cookingTime = 0,
    this.totalTime = 0,
    this.servings,
    this.categories = const [],
    this.ingredientsGlossary = const [],
    this.ingredients = const [[]],
    this.vegetable = Vegetable.NON_VEGETARIAN,
    this.steps = const [],
    this.stepImages = const [[]],
    this.notes = "",
    this.nutritions = const [],
    this.isFavorite = false,
    this.effort,
    this.lastModified,
    this.rating,
    this.tags = const [],
    this.source,
  });

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
        'isFavorite : $isFavorite\n'
        'lastModified : $lastModified\n'
        'rating: $rating\n'
        'keywords: $tags\n'
        'source: $source');
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
          .toList(),
      vegetable: vegetable,
      steps: List<String>.from(json['steps']),
      notes: json['notes'],
      nutritions: List<dynamic>.from(json['nutritions'])
          .map((n) => Nutrition.fromMap(n))
          .toList(),
      lastModified: DateTime.now().toString(),
      rating: json.containsKey('rating') ? json['rating'] : null,
      tags: json.containsKey('keywords')
          ? List<dynamic>.from(json['keywords'])
              .map((n) => StringIntTuple.fromMap(n))
              .toList()
          : [],
      source: json['source'],
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
        'nutritions': nutritions.map((n) => n.toMap()).toList(),
        'lastModified': lastModified,
        'rating': rating,
        'keywords': tags.map((t) => t.toMap()).toList(),
        'source': source,
      };

  Recipe copyWith({
    String name,
    String imagePath,
    String imagePreviewPath,
    double preperationTime,
    double cookingTime,
    double totalTime,
    double servings,
    List<String> ingredientsGlossary,
    List<List<Ingredient>> ingredients,
    Vegetable vegetable,
    List<String> steps,
    List<List<String>> stepImages,
    String notes,
    List<Nutrition> nutritions,
    List<String> categories,
    int effort,
    bool isFavorite,
    String lastModified,
    int rating,
    List<StringIntTuple> tags,
    String source,
  }) {
    return Recipe(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      imagePreviewPath: imagePreviewPath ?? this.imagePreviewPath,
      preperationTime: preperationTime ?? this.preperationTime,
      cookingTime: cookingTime ?? this.cookingTime,
      totalTime: totalTime ?? this.totalTime,
      servings: servings ?? this.servings,
      ingredientsGlossary: ingredientsGlossary ?? this.ingredientsGlossary,
      ingredients: ingredients ?? this.ingredients,
      vegetable: vegetable ?? this.vegetable,
      steps: steps ?? this.steps,
      stepImages: stepImages ?? this.stepImages,
      notes: notes ?? this.notes,
      nutritions: nutritions ?? this.nutritions,
      categories: categories ?? this.categories,
      effort: effort ?? this.effort,
      isFavorite: isFavorite ?? this.isFavorite,
      lastModified: lastModified ?? this.lastModified,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      source: source ?? this.source,
    );
  }

  @override
  List<Object> get props => [
        name,
        imagePath,
        imagePreviewPath,
        preperationTime,
        cookingTime,
        totalTime,
        servings,
        ingredientsGlossary,
        ingredients,
        vegetable,
        steps,
        stepImages,
        notes,
        nutritions,
        categories,
        effort,
        isFavorite,
        lastModified,
        rating,
        tags,
        source,
      ];
}

class SearchRecipe {
  String name;
  int id;

  SearchRecipe({this.name, this.id});
}
