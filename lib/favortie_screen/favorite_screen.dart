import 'package:flutter/material.dart';
import '../recipe_overview/recipe_overview.dart';
import '../recipe.dart';
import '../database.dart';

class FavoriteScreen extends StatefulWidget {
  FavoriteScreen({Key key}) : super(key: key);

  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with AutomaticKeepAliveClientMixin<FavoriteScreen> {
@override
  bool get wantKeepAlive => true;

  @override
  void initState() { 
    super.initState();
    print('initState');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
        future: DBProvider.db.getFavoriteRecipes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0)
              return Center(
                  child: Text('You have no recipes under this category.'));
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
          recipeColor: Color(0xffE2A1B1),
        ),
      );
    }
    return recipeCards;
  }
}
