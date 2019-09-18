import 'package:flutter/material.dart';
import 'package:my_recipe_book/models/random_recipe.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/random_recipe/recipe_engine.dart';
import 'package:scoped_model/scoped_model.dart';

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
  String _selectedCategory = 'all categories';

  ListView _getCategorySelector(List<String> categoryNames) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: (categoryNames.length + 1) * 2 + 1,
      itemBuilder: (context, index) {
        if (index == 0) return VerticalDivider();
        index--;
        if (index % 2 == 0) {
          String currentCategory = (index / 2).floor() == 0
              ? 'all categories'
              : categoryNames[(index / 2).floor() - 1];
          return ScopedModelDescendant<RandomRecipeKeeper>(
            builder: (context, child, rrKeeper) => FlatButton(
                color:
                    currentCategory == _selectedCategory ? Colors.brown : null,
                textColor:
                    currentCategory == _selectedCategory ? Colors.amber : null,
                onPressed: () {
                  _selectedCategory = currentCategory;
                  rrKeeper.changeCategory(currentCategory);
                },
                child: Text(currentCategory)),
          );
        } else {
          return VerticalDivider();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: ScopedModelDescendant<RecipeKeeper>(
              builder: (context, child, rrKeeper) =>
                  _getCategorySelector(rrKeeper.categories),
            ),
          ),
        ),
        Divider(),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 200,
          child: ScopedModelDescendant<RecipeKeeper>(
            builder: (context, child, rKeeper) =>
                ScopedModelDescendant<RandomRecipeKeeper>(
              builder: (context, child, rrKeeper) => CardStack(
                    recipeEngine: RecipeEngine(
                  recipeDecisions: rrKeeper.currentlyVisibleRecipes,
                )),
            ),
          ),
        ),
      ],
    );
  }
}
