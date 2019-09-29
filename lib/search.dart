import 'package:flutter/material.dart';
import 'package:my_recipe_book/recipe.dart';
import 'package:my_recipe_book/recipe_overview/recipe_screen.dart';
import 'package:my_recipe_book/generated/i18n.dart';

import 'database.dart';

class RecipeSearch extends SearchDelegate<SearchRecipe> {
  final List<String> recipeNames;

  RecipeSearch(this.recipeNames);

  @override
  ThemeData appBarTheme(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (theme.brightness != Brightness.dark) {
      return theme.copyWith(
        primaryColor: Colors.white,
        primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        primaryColorBrightness: Brightness.light,
        primaryTextTheme: theme.textTheme,
      );
    } else {
      return theme.copyWith(
        primaryColor: Colors.grey[800],
        primaryIconTheme:
            theme.primaryIconTheme.copyWith(color: Colors.grey[200]),
        primaryColorBrightness: Brightness.dark,
        primaryTextTheme: theme.textTheme,
      );
    }
  }

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
    List<String> resultRecipeNames = recipeNames
        .where((recipeName) =>
            recipeName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
        itemCount: resultRecipeNames.length * 2,
        itemBuilder: (context, index) {
          if ((index - 1) % 2 == 0 && index != 0) {
            return Divider();
          }
          return ListTile(
            title: Text(resultRecipeNames[index ~/ 2]),
            onTap: () {
              DBProvider.db
                  .getRecipeByName(resultRecipeNames[index ~/ 2], true)
                  .then((recipe) {
                close(context, null);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => new RecipeScreen(
                      recipe: recipe,
                      primaryColor: getRecipePrimaryColor(recipe.vegetable),
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
