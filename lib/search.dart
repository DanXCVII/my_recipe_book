
import 'package:flutter/material.dart';
import 'package:my_recipe_book/recipe.dart';
import 'package:my_recipe_book/recipe_overview/recipe_screen.dart';

import 'database.dart';

class RecipeSearch extends SearchDelegate<SearchRecipe> {
  final List<String> recipeNames;

  RecipeSearch(this.recipeNames);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (recipeNames.isEmpty) {
      return Container(
          height: 70,
          child: Center(child: Text('You have no recipes to search through')));
    }
    recipeNames.where(
        (recipeName) => recipeName.toLowerCase().contains(query.toLowerCase()));
    return ListView.builder(
        itemCount: recipeNames.length * 2,
        itemBuilder: (context, index) {
          if ((index - 1) % 2 == 0 && index != 0) {
            return Divider();
          }
          return ListTile(
            title: Text(recipeNames[index ~/ 2]),
            onTap: () {
              DBProvider.db
                  .getRecipeByName(recipeNames[index ~/ 2])
                  .then((recipe) {
                close(context, null);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => new RecipeScreen(
                      recipe: recipe,
                      primaryColor: getRecipePrimaryColor(recipe),
                      heroImageTag: 'heroTag',
                    ),
                  ),
                );
              });
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
