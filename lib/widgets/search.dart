import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_book/ad_related/ad.dart';

import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/routes.dart';
import '../generated/i18n.dart';
import '../local_storage/hive.dart';
import '../models/recipe.dart';
import '../screens/recipe_screen.dart';

class RecipeSearch extends SearchDelegate<SearchRecipe> {
  final List<String> recipeNames;
  final ShoppingCartBloc shoppingCartBloc;

  RecipeSearch(this.recipeNames, this.shoppingCartBloc);

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
          child: Center(
              child: Text(I18n.of(context).no_recipes_to_search_through)));
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
              HiveProvider()
                  .getRecipeByName(resultRecipeNames[index ~/ 2])
                  .then((recipe) {
                close(context, null);
                Navigator.pushNamed(
                  context,
                  RouteNames.recipeScreen,
                  arguments: RecipeScreenArguments(
                    shoppingCartBloc,
                    recipe,
                    'heroTag',
                    BlocProvider.of<RecipeManagerBloc>(context),
                  ),
                ).then((_) => Ads.hideBottomBannerAd());
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
