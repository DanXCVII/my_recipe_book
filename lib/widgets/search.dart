import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock/wakelock.dart';

import '../ad_related/ad.dart';
import '../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_settings.dart';
import '../constants/routes.dart';
import '../generated/l10n.dart';
import '../local_storage/hive.dart';
import '../models/recipe.dart';
import '../models/string_int_tuple.dart';
import '../screens/recipe_overview.dart';
import '../screens/recipe_screen.dart';

class RecipeSearch extends SearchDelegate<SearchRecipe?> {
  final List<String> recipeNames;
  final List<StringIntTuple> recipeTags;
  final List<String> categories;
  final ShoppingCartBloc shoppingCartBloc;
  final RecipeCalendarBloc recipeCalendarBloc;

  RecipeSearch(
    this.recipeNames,
    this.shoppingCartBloc,
    this.recipeCalendarBloc,
    this.recipeTags,
    this.categories,
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (theme.brightness != Brightness.dark) {
      return theme.copyWith(
        primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        brightness: Brightness.light,
        primaryTextTheme: theme.textTheme,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.grey[800]),
        ),
      );
    } else {
      return theme.copyWith(
        primaryIconTheme:
            theme.primaryIconTheme.copyWith(color: Colors.grey[200]),
        brightness: Brightness.dark,
        primaryTextTheme: theme.textTheme,
        appBarTheme: AppBarTheme(
          color: Colors.grey[800],
          iconTheme: IconThemeData(color: Colors.grey[200]),
        ),
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
    if (recipeNames.isEmpty && recipeTags.isEmpty && categories.isEmpty) {
      return Container(
          height: 70,
          child: Center(child: Text(S.of(context).nothing_to_search_through)));
    }
    List<String> resultCategories = categories
        .where(
            (category) => category.toLowerCase().contains(query.toLowerCase()))
        .toList();

    List<StringIntTuple> resultRecipeTags = recipeTags
        .where((recipeTag) =>
            recipeTag.text.toLowerCase().contains(query.toLowerCase()))
        .toList();

    List<String> resultRecipeNames = recipeNames
        .where((recipeName) =>
            recipeName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
        itemCount: (resultRecipeNames.length +
                resultCategories.length +
                resultRecipeTags.length) *
            2,
        itemBuilder: (context, index) {
          if ((index - 1) % 2 == 0 && index != 0) {
            return Divider();
          }
          if (index ~/ 2 < resultRecipeNames.length) {
            return ListTile(
              title: Text(resultRecipeNames[index ~/ 2]),
              onTap: () {
                HiveProvider()
                    .getRecipeByName(resultRecipeNames[index ~/ 2])
                    .then((recipe) {
                  close(context, null);
                  if (GlobalSettings().standbyDisabled()) {
                    Wakelock.enable();
                  }
                  Navigator.pushNamed(
                    context,
                    RouteNames.recipeScreen,
                    arguments: RecipeScreenArguments(
                      shoppingCartBloc,
                      recipeCalendarBloc,
                      recipe,
                      'heroTag',
                      BlocProvider.of<RecipeManagerBloc>(context),
                    ),
                  ).then((_) => Wakelock.disable());
                });
              },
            );
          } else if (index ~/ 2 - resultRecipeNames.length <
              resultCategories.length) {
            int categoryIndex = index ~/ 2 - resultRecipeNames.length;
            return ListTile(
                leading: Icon(Icons.apps),
                title: Text(resultCategories[categoryIndex]),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RouteNames.recipeCategories,
                    arguments: RecipeGridViewArguments(
                      category: resultCategories[categoryIndex],
                      shoppingCartBloc: shoppingCartBloc,
                      recipeCalendarBloc: recipeCalendarBloc,
                    ),
                  ).then((_) => Ads.hideBottomBannerAd());
                });
          } else {
            int recipeTagIndex =
                index ~/ 2 - resultRecipeNames.length - resultCategories.length;
            return ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(resultRecipeTags[recipeTagIndex].number),
                  ),
                  height: 25,
                  width: 25,
                ),
                title: Text(resultRecipeTags[recipeTagIndex].text),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RouteNames.recipeTagOverview,
                    arguments: RecipeGridViewArguments(
                      recipeTag: resultRecipeTags[recipeTagIndex],
                      shoppingCartBloc: shoppingCartBloc,
                      recipeCalendarBloc: recipeCalendarBloc,
                    ),
                  ).then((_) => Ads.hideBottomBannerAd());
                });
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
