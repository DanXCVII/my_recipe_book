import 'package:flutter/material.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/random_recipe/recipe_engine.dart';

import '../recipe.dart';
import 'draggable_card.dart';

final RecipeEngine recipeEngine = RecipeEngine(
    recipeDecisions: [
  Recipe(
    name: '1. Steack mit Bratsauce',
    imagePath: 'images/breakfast.jpg',
    totalTime: 20,
    preperationTime: 5,
    cookingTime: 10,
    imagePreviewPath: 'images/breakfast.jpg',
    servings: 3,
    ingredientsGlossary: ['Steacksauce', 'Steack'],
    ingredients: [
      [
        Ingredient(name: 'Rosmarin', amount: 5, unit: 'Zweige'),
        Ingredient(name: 'Mehl', amount: 300, unit: 'g'),
        Ingredient(name: 'Curry', amount: 1, unit: 'EL'),
        Ingredient(name: 'Gewürze', amount: 3, unit: 'Priesen')
      ],
      [
        Ingredient(name: 'Rohrzucker', amount: 50, unit: 'g'),
        Ingredient(name: 'Steak', amount: 700, unit: 'g')
      ],
    ],
    effort: 4,
    vegetable: Vegetable.NON_VEGETARIAN,
    steps: [
      'step1',
      'step2 kek',
    ],
    stepImages: [
      [], [],
      // ['/storage/emulated/0/Download/recipeData/meat1.jpg'],
      // [
      //   '/storage/emulated/0/Download/recipeData/meat2.jpg',
      // ],
    ],
    notes: 'Steak gegen die Faser in feine Tranchen schneiden.',
    isFavorite: false,
    categories: ['Hauptspeisen'],
  ),
  Recipe(
    name: '2. LAAAST',
    imagePath: 'images/meat.jpg',
    imagePreviewPath: 'images/meat.jpg',
    servings: 3,
    totalTime: 20,
    preperationTime: 5,
    cookingTime: 10,
    ingredientsGlossary: ['Steacksauce', 'Steack'],
    ingredients: [
      [
        Ingredient(name: 'Rosmarin', amount: 5, unit: 'Zweige'),
        Ingredient(name: 'Mehl', amount: 300, unit: 'g'),
        Ingredient(name: 'Curry', amount: 1, unit: 'EL'),
        Ingredient(name: 'Gewürze', amount: 3, unit: 'Priesen')
      ],
      [
        Ingredient(name: 'Rohrzucker', amount: 50, unit: 'g'),
        Ingredient(name: 'Steak', amount: 700, unit: 'g')
      ],
    ],
    effort: 4,
    vegetable: Vegetable.NON_VEGETARIAN,
    steps: [
      'step1',
      'step2 kek',
    ],
    stepImages: [
      [], [],
      // ['/storage/emulated/0/Download/recipeData/meat1.jpg'],
      // [
      //   '/storage/emulated/0/Download/recipeData/meat2.jpg',
      // ],
    ],
    notes: 'Steak gegen die Faser in feine Tranchen schneiden.',
    isFavorite: false,
    categories: ['Hauptspeisen'],
  ),
  Recipe(
    name: '3. Spaghetti',
    imagePath: 'images/meat.jpg',
    imagePreviewPath: 'images/meat.jpg',
    servings: 3,
    totalTime: 20,
    preperationTime: 5,
    cookingTime: 10,
    ingredientsGlossary: ['Steacksauce', 'Steack'],
    ingredients: [
      [
        Ingredient(name: 'Rosmarin', amount: 5, unit: 'Zweige'),
        Ingredient(name: 'Mehl', amount: 300, unit: 'g'),
        Ingredient(name: 'Curry', amount: 1, unit: 'EL'),
        Ingredient(name: 'Gewürze', amount: 3, unit: 'Priesen')
      ],
      [
        Ingredient(name: 'Rohrzucker', amount: 50, unit: 'g'),
        Ingredient(name: 'Steak', amount: 700, unit: 'g')
      ],
    ],
    effort: 4,
    vegetable: Vegetable.NON_VEGETARIAN,
    steps: [
      'step1',
      'step2 kek',
    ],
    stepImages: [
      [], [],
      // ['/storage/emulated/0/Download/recipeData/meat1.jpg'],
      // [
      //   '/storage/emulated/0/Download/recipeData/meat2.jpg',
      // ],
    ],
    notes: 'Steak gegen die Faser in feine Tranchen schneiden.',
    isFavorite: false,
    categories: ['Hauptspeisen'],
  ),
  Recipe(
    name: '4. Spaghetti',
    imagePath: 'images/meat.jpg',
    imagePreviewPath: 'images/meat.jpg',
    servings: 3,
    totalTime: 20,
    preperationTime: 5,
    cookingTime: 10,
    ingredientsGlossary: ['Steacksauce', 'Steack'],
    ingredients: [
      [
        Ingredient(name: 'Rosmarin', amount: 5, unit: 'Zweige'),
        Ingredient(name: 'Mehl', amount: 300, unit: 'g'),
        Ingredient(name: 'Curry', amount: 1, unit: 'EL'),
        Ingredient(name: 'Gewürze', amount: 3, unit: 'Priesen')
      ],
      [
        Ingredient(name: 'Rohrzucker', amount: 50, unit: 'g'),
        Ingredient(name: 'Steak', amount: 700, unit: 'g')
      ],
    ],
    effort: 4,
    vegetable: Vegetable.NON_VEGETARIAN,
    steps: [
      'step1',
      'step2 kek',
    ],
    stepImages: [
      [], [],
      // ['/storage/emulated/0/Download/recipeData/meat1.jpg'],
      // [
      //   '/storage/emulated/0/Download/recipeData/meat2.jpg',
      // ],
    ],
    notes: 'Steak gegen die Faser in feine Tranchen schneiden.',
    isFavorite: false,
    categories: ['Hauptspeisen'],
  ),
  Recipe(
    name: '5. Spaghetti',
    imagePath: 'images/meat.jpg',
    imagePreviewPath: 'images/meat.jpg',
    servings: 3,
    totalTime: 20,
    preperationTime: 5,
    cookingTime: 10,
    ingredientsGlossary: ['Steacksauce', 'Steack'],
    ingredients: [
      [
        Ingredient(name: 'Rosmarin', amount: 5, unit: 'Zweige'),
        Ingredient(name: 'Mehl', amount: 300, unit: 'g'),
        Ingredient(name: 'Curry', amount: 1, unit: 'EL'),
        Ingredient(name: 'Gewürze', amount: 3, unit: 'Priesen')
      ],
      [
        Ingredient(name: 'Rohrzucker', amount: 50, unit: 'g'),
        Ingredient(name: 'Steak', amount: 700, unit: 'g')
      ],
    ],
    effort: 4,
    vegetable: Vegetable.NON_VEGETARIAN,
    steps: [
      'step1',
      'step2 kek',
    ],
    stepImages: [
      [], [],
      // ['/storage/emulated/0/Download/recipeData/meat1.jpg'],
      // [
      //   '/storage/emulated/0/Download/recipeData/meat2.jpg',
      // ],
    ],
    notes: 'Steak gegen die Faser in feine Tranchen schneiden.',
    isFavorite: false,
    categories: ['Hauptspeisen'],
  ),
].map((recipe) => RecipeDecision(recipe: recipe)).toList());

class RandomRecipe extends StatefulWidget {
  RandomRecipe({Key key}) : super(key: key);

  _RandomRecipeState createState() => _RandomRecipeState();
}

class _RandomRecipeState extends State<RandomRecipe> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: DBProvider.db.getRecipeByName('', true),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CardStack(
            // TODO: Pass in the recipes here
            recipeEngine: recipeEngine,
          );
        }
        return (Center(
          child: CircularProgressIndicator(),
        ));
      },
    );
  }
}
