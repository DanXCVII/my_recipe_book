import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_recipe_book/blocs/bloc_provider.dart';
import 'package:my_recipe_book/blocs/favorite_recipes_bloc.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/models/recipe_preview.dart';
import 'package:scoped_model/scoped_model.dart';
import '../recipe_card.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FavoriteRecipesBloc bloc =
        BlocProvider.of<FavoriteRecipesBloc>(context);

    double deviceHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
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
        StreamBuilder<List<Recipe>>(
          stream: bloc.outRecipeList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
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
                    ]);
              } else {
                return FavoriteRecipeCards(
                  favoriteRecipes: snapshot.data,
                );
              }
            }
            // add suitable widget
            return Text('kek');
          },
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
