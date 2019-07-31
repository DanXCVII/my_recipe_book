import 'package:flutter/material.dart';
import '../recipe_overview/recipe_overview.dart';
import '../recipe.dart';
import '../database.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
        future: DBProvider.db.getFavoriteRecipes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0)
              return Center(
                  child: Text('You have no recipes under this category.'));
            return Container(
              color: Colors.white,
              child: CustomScrollView(slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      background: Image.asset('')),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(12),
                  sliver: SliverGrid.extent(
                    childAspectRatio: 0.75,
                    maxCrossAxisExtent: 300,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: getRecipeCards(snapshot.data),
                  ),
                )
              ]),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
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
