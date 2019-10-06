import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:scoped_model/scoped_model.dart';
import '../recipe_card.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        ScopedModelDescendant<RecipeKeeper>(
          builder: (context, child, model) {
            if (model.favorites.length == 0) {
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
                          textScaleFactor: deviceHeight / 800,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontFamily: 'RibeyeMarrow',
                          )),
                    ),
                  ]);
            } else {
              return FavoriteRecipeCards(
                favoriteRecipePreviews: model.favorites,
              );
            }
          },
        ),
      ],
    );
  }
}

class FavoriteRecipeCards extends StatelessWidget {
  final List<RecipePreview> favoriteRecipePreviews;

  const FavoriteRecipeCards({this.favoriteRecipePreviews, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      padding: EdgeInsets.all(12),
      childAspectRatio: 0.75,
      maxCrossAxisExtent: 300,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: getRecipeCards(favoriteRecipePreviews, context),
    );
  }

  List<Widget> getRecipeCards(
      List<RecipePreview> recipes, BuildContext context) {
    List<RecipeCard> recipeCards = [];
    for (int i = 0; i < recipes.length; i++) {
      recipeCards.add(
        RecipeCard(
          recipePreview: recipes[i],
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
