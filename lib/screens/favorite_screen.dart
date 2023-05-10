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
      Opacity(
        opacity:
            Theme.of(context).colorScheme.background == Colors.white ? 0.3 : 1,
        child: Container(
          height: MediaQuery.of(context).size.height - kToolbarHeight,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            "images/hearts.png",
            repeat: ImageRepeat.repeat,
          ),
        ),
      ),
      BlocBuilder<FavoriteRecipesBloc, FavoriteRecipesState>(
          builder: (context, state) {
        if (state is LoadingFavorites) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadedFavorites) {
          if (state.recipes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: IconInfoMessage(
                  iconWidget: SpinKitPumpingHeart(
                    color: Colors.pink,
                    size: 70.0,
                  ),
                  description: I18n.of(context)!.no_added_favorites_yet,
                ),
              ),
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

  const FavoriteRecipeCards({required this.favoriteRecipes, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => MasonryGridView.count(
        padding: EdgeInsets.all(12),
        crossAxisCount: (constraints.maxWidth / 300).round() * 2,
        itemCount: favoriteRecipes.length,
        itemBuilder: (BuildContext context, int index) => LayoutBuilder(
          builder: (context, constraints) => RecipeCard(
            recipe: favoriteRecipes[index],
            width: constraints.maxWidth,
            heroImageTag:
                "${favoriteRecipes[index].imagePreviewPath}--${favoriteRecipes[index].name}",
          ),
        ),
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
      ),
    );
  }
}
