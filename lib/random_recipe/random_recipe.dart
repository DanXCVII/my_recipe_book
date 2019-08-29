import 'package:flutter/material.dart';
import 'package:fluttery/layout.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/recipe.dart';

class RandomRecipe extends StatefulWidget {
  RandomRecipe({Key key}) : super(key: key);

  _RandomRecipeState createState() => _RandomRecipeState();
}

class _RandomRecipeState extends State<RandomRecipe> {
  Widget _buildCardStack(Recipe temporaryRecipe) {
    return AnchoredOverlay(
        showOverlay: true,
        child: Center(),
        overlayBuilder: (context, anchorBounds, anchor) {
          return CenterAbout(
            position: anchor,
            child: Container(
                width: anchorBounds.width,
                height: anchorBounds.height,
                padding: EdgeInsets.all(16),
                child: RecipeCardBig(
                  recipe: temporaryRecipe,
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Recipe>(
      future: DBProvider.db.getRecipeById(0, true),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _buildCardStack(snapshot.data);
        }
        return (Center(
          child: CircularProgressIndicator(),
        ));
      },
    );
  }
}

class RecipeCardBig extends StatelessWidget {
  final Recipe recipe;

  const RecipeCardBig({this.recipe, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
          BoxShadow(
            blurRadius: 5,
            spreadRadius: 2,
          )
        ]),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(12),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(recipe.imagePath),
                ],
              ),
            )
          ],
        ));
  }
}
