import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../blocs/favorite_recipes/favorite_recipes_bloc.dart';
import '../generated/i18n.dart';
import '../models/recipe.dart';
import '../widgets/icon_info_message.dart';
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
            return Center(
              child: IconInfoMessage(
                  iconWidget: SpinKitPumpingHeart(
                    color: Colors.pink,
                    size: 70.0,
                  ),
                  description: I18n.of(context).no_added_favorites_yet),
            );
          }
          return FavoriteRecipeCards(
            favoriteRecipes: state.recipes,
          );
        }
        return Text(state.toString());
      })
    ]);
  }
}

class FavoriteRecipeCards extends StatelessWidget {
  final List<Recipe> favoriteRecipes;

  const FavoriteRecipeCards({this.favoriteRecipes, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(12),
        crossAxisCount: ((constraints.maxWidth / 200).round() * 2) < 4
            ? 4
            : (constraints.maxWidth / 200).round() * 2,
        itemCount: favoriteRecipes.length,
        itemBuilder: (BuildContext context, int index) => LayoutBuilder(
          builder: (context, constraints) => RecipeCard(
            recipe: favoriteRecipes[index],
            showAds: false,
            width: constraints.maxWidth,
            shadow: Theme.of(context).backgroundColor == Colors.white
                ? Colors.grey[400]
                : Colors.grey[900],
            heroImageTag:
                "${favoriteRecipes[index].imagePreviewPath}--${favoriteRecipes[index].name}",
          ),
        ),
        staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
      ),
    );
  }
}
