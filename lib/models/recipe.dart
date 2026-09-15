import 'package:equatable/equatable.dart';

import 'enums.dart';
import 'ingredient.dart';
import 'nutrition.dart';
import 'string_int_tuple.dart';

const String firstModified = "2000-01-01 00:00:00.000";

class Recipe extends Equatable {
  final String name;
  final String imagePath;
  final String imagePreviewPath;
  final double preperationTime;
  final double cookingTime;
  final double totalTime;
  final double? servings;
  final List<String> categories;
  final List<String> ingredientsGlossary;
  final List<List<Ingredient>> ingredients;
  final Vegetable vegetable;
  final List<String> steps;
  final List<List<String>> stepImages;
  final String notes;
  final List<Nutrition> nutritions;
  final bool isFavorite;
  final int? effort;
  final String lastModified;
  final int? rating;
  final List<StringIntTuple> tags;
  final String? source;
  final String? servingName;
  final List<String>? stepTitles;
  final List<List<String>> stepIngredientIds;

  Recipe({
    required this.name,
    this.imagePath = "images/randomFood.jpg",
    this.imagePreviewPath = "images/randomFood.jpg",
    this.preperationTime = 0,
    this.cookingTime = 0,
    this.totalTime = 0,
    this.servings,
    this.servingName,
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
    this.lastModified = firstModified,
    this.rating,
    this.tags = const [],
    this.source,
    this.stepTitles,
    this.stepIngredientIds = const [],
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
        'servingName: $servingName\n'
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
        // these are actually the recipeTags but renaming could cause problems
        'keywords: $tags\n'
        'source: $source\n'
        'stepTitles: $stepTitles');
  }

  factory Recipe.fromMap(Map<String, dynamic> json, {bool? keepDateTime}) {
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
      preperationTime: double.tryParse(json['preperationTime'].toString())!,
      cookingTime: double.tryParse(json['cookingTime'].toString())!,
      totalTime: double.tryParse(json['totalTime'].toString())!,
      effort: json['complexity'],
      servings: double.tryParse(json['servings'].toString()),
      servingName: json.containsKey('servingName') ? json['servingName'] : null,
      categories: List<String>.from(json['categories']),
      ingredientsGlossary: List<String>.from(json['ingredientsGlossary']),
      stepImages: List<List<dynamic>>.from(json['stepImages'])
          .map((i) => List<String>.from(i).toList())
          .toList(),
      ingredients: List<List<dynamic>>.from(json['ingredients'])
          .map(
            (l) =>
                List<Map<String, dynamic>>.from(l)
                    .map((i) => Ingredient.fromMap(i))
                    .toList(),
          )
          .toList(),
      vegetable: vegetable,
      steps: List<String>.from(json['steps']),
      notes: json['notes'],
      nutritions: List<dynamic>.from(json['nutritions'])
          .map((n) => Nutrition.fromMap(n))
          .toList(),
      lastModified: keepDateTime == null
          ? DateTime.now().toString()
          : json['lastModified'],
      rating: json.containsKey('rating') ? json['rating'] : null,
      tags: json.containsKey('keywords')
          ? List<dynamic>.from(json['keywords'])
                .map((n) => StringIntTuple.fromMap(n))
                .toList()
          : [],
      source: json['source'],
      stepTitles: json['_stepTitlesWasNull'] == true
          ? null
          : json.containsKey('stepTitles')
          ? List<String>.from(json['stepTitles'])
          : (List<String>.from(json['steps'])).map((e) => "").toList(),
      stepIngredientIds: json.containsKey('stepIngredientIds')
          ? List<List<dynamic>>.from(json['stepIngredientIds'])
                .map((ids) => List<String>.from(ids))
                .toList()
          : const [],
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
    'servingName': servingName,
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
    'stepTitles': stepTitles ?? steps.map((e) => "").toList(),
    'stepIngredientIds': stepIngredientIds,
  };

  Recipe copyWith({
    String? name,
    String? imagePath,
    String? imagePreviewPath,
    double? preperationTime,
    double? cookingTime,
    double? totalTime,
    double? servings,
    String? servingName,
    bool clearServings = false,
    bool clearServingName = false,
    List<String>? ingredientsGlossary,
    List<List<Ingredient>>? ingredients,
    Vegetable? vegetable,
    List<String>? steps,
    List<List<String>>? stepImages,
    String? notes,
    List<Nutrition>? nutritions,
    List<String>? categories,
    int? effort,
    bool? isFavorite,
    String? lastModified,
    int? rating,
    List<StringIntTuple>? tags,
    String? source,
    bool clearSource = false,
    List<String>? stepTitles,
    List<List<String>>? stepIngredientIds,
  }) {
    return Recipe(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      imagePreviewPath: imagePreviewPath ?? this.imagePreviewPath,
      preperationTime: preperationTime ?? this.preperationTime,
      cookingTime: cookingTime ?? this.cookingTime,
      totalTime: totalTime ?? this.totalTime,
      servings: clearServings ? null : servings ?? this.servings,
      servingName: clearServingName ? null : servingName ?? this.servingName,
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
      source: clearSource ? null : source ?? this.source,
      stepTitles: stepTitles ?? this.stepTitles,
      stepIngredientIds: stepIngredientIds ?? this.stepIngredientIds,
    );
  }

  @override
  List<Object?> get props => [
    name,
    imagePath,
    imagePreviewPath,
    preperationTime,
    cookingTime,
    totalTime,
    servings,
    servingName,
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
    stepTitles,
    stepIngredientIds,
  ];

  /// Adds opaque IDs to ingredients that predate step assignments and prunes
  /// links that no longer point at an ingredient in this recipe.
  Recipe ensureIngredientIds() {
    var next = 0;
    final seed = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final seen = <String>{};
    final normalized = ingredients
        .map(
          (group) => group.map((ingredient) {
            var id = ingredient.id;
            if (id == null || id.isEmpty || seen.contains(id)) {
              id = 'ing-$seed-${next++}';
            }
            seen.add(id);
            return ingredient.copyWith(id: id);
          }).toList(),
        )
        .toList();
    final links = List<List<String>>.generate(
      steps.length,
      (index) => index < stepIngredientIds.length
          ? stepIngredientIds[index].where(seen.contains).toSet().toList()
          : <String>[],
    );
    return copyWith(ingredients: normalized, stepIngredientIds: links);
  }
}

class SearchRecipe {
  String? name;
  int? id;

  SearchRecipe({this.name, this.id});
}
