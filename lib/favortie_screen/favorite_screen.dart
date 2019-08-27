import 'package:flutter/material.dart';
import '../recipe_card.dart';
import '../recipe.dart';
import '../database.dart';

class FavoriteScreen extends StatefulWidget {
  FavoriteScreen({Key key}) : super(key: key);

  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
        future: DBProvider.db.getFavoriteRecipes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0)
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 80,
                      child: Image.asset('images/bigHeart.png'),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('You have no recipes under this category.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 26, fontFamily: 'RibeyeMarrow')),
                    ),
                  ]);
            return FavoriteRecipeCards(
              favoriteRecipes: snapshot.data,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
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
      children: getRecipeCards(favoriteRecipes),
    );
  }

  List<Widget> getRecipeCards(List<Recipe> recipes) {
    List<RecipeCard> recipeCards = [];
    for (int i = 0; i < recipes.length; i++) {
      recipeCards.add(
        RecipeCard(
          recipe: recipes[i],
        ),
      );
    }
    return recipeCards;
  }
}
