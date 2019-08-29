import 'package:flutter/material.dart';
import './anchored_widget.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/recipe.dart';
import '../recipe_card.dart';

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
    return Container();
    return FutureBuilder<dynamic>(
      future: DBProvider.db.getRecipeById(0, true),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data.toString());
          return _buildCardStack(snapshot.data);
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
    return Material(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 2,
                color: Colors.grey[400],
              )
            ]),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.asset(
                      recipe.imagePath,
                      fit: BoxFit.cover,
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Colors.white.withOpacity(0.6),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.8 -
                                          20,
                                  child: Text(
                                    recipe.name,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "images/${getRecipeTypeImage(recipe.vegetable)}.png",
                                  height: 35,
                                  width: 35,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[],
              ),
            )
          ],
        ),
      ),
    );
  }
}
