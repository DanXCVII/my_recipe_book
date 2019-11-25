import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/favorite_recipes/favorite_recipes.dart';
import '../generated/i18n.dart';
import '../models/recipe.dart';
import '../recipe_card.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      // Container(
      //     height: MediaQuery.of(context).size.height,
      //     // width: MediaQuery.of(context).size.width,
      //     child: Image.asset(
      //       'images/heartsBackground.jpg',
      //       fit: BoxFit.cover,
      //     )),
      // Container(
      //   // height: MediaQuery.of(context).size.height,
      //   // width: MediaQuery.of(context).size.width,
      //   child: BackdropFilter(
      //     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      //     child: Container(
      //       decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
      //     ),
      //   ),
      // ),
      BlocBuilder<FavoriteRecipesBloc, FavoriteRecipesState>(
          builder: (context, state) {
        if (state is LoadingFavorites) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadedFavorites) {
          if (state.recipes.isEmpty) {
            return getCenterHeart(context);
          }
          return FavoriteRecipeCards(
            favoriteRecipes: state.recipes,
          );
        }
        return Text(state.toString());
      })
    ]);
  }

  Widget getCenterHeart(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: deviceHeight / 800 * 80,
          child: Image.asset('images/bigHeart.png'),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(S.of(context).no_added_favorites_yet,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'RibeyeMarrow',
              )),
        ),
      ],
    );
  }
}

class FavoriteRecipeCards extends StatelessWidget {
  final List<Recipe> favoriteRecipes;

  const FavoriteRecipeCards({this.favoriteRecipes, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      padding: EdgeInsets.all(12),
      childAspectRatio: 0.75,
      maxCrossAxisExtent: 300,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: getRecipeCards(favoriteRecipes, context),
    );
  }

  List<Widget> getRecipeCards(List<Recipe> recipes, BuildContext context) {
    List<RecipeCard> recipeCards = [];
    for (int i = 0; i < recipes.length; i++) {
      recipeCards.add(
        RecipeCard(
          recipe: recipes[i],
          shadow: Theme.of(context).backgroundColor == Colors.white
              ? Colors.grey[400]
              : Colors.grey[900],
          heroImageTag: "${recipes[i].imagePreviewPath}--${recipes[i].name}",
        ),
      );
    }
    return recipeCards;
  }
}
