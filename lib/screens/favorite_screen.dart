import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../blocs/favorite_recipes/favorite_recipes.dart';
import '../generated/i18n.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
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
          width: 110,
          height: 110,
          decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.5), shape: BoxShape.circle),
          child: Container(
            height: deviceHeight / 800 * 80,
            child: SpinKitPumpingHeart(
              color: Colors.pink,
              size: 70.0,
            ),
          ),
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
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(12),
      crossAxisCount: 4,
      itemCount: favoriteRecipes.length,
      itemBuilder: (BuildContext context, int index) => RecipeCard(
        recipe: favoriteRecipes[index],
        shadow: Theme.of(context).backgroundColor == Colors.white
            ? Colors.grey[400]
            : Colors.grey[900],
        heroImageTag:
            "${favoriteRecipes[index].imagePreviewPath}--${favoriteRecipes[index].name}",
      ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 12.0,
      crossAxisSpacing: 12.0,
    );
  }
}
