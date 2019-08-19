import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_recipe_book/recipe_overview/recipe_overview.dart';

import '../../database.dart';
import '../../recipe.dart';

class CategoryGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: DBProvider.db.getCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.extent(
              maxCrossAxisExtent: 300,
              padding: const EdgeInsets.all(4),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: getCategories(snapshot.data));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  List<Widget> getCategories(List<String> categoryNames) {
    List<Widget> gridTiles = [];

    for (final String category in categoryNames) {
      gridTiles.add(FutureBuilder<List<Recipe>>(
        future: DBProvider.db.getRecipesOfCategory(category),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CategoryGridTile(
              recipes: snapshot.data,
              category: category,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ));
    }
    gridTiles.add(
      FutureBuilder<List<Recipe>>(
        future: DBProvider.db.getRecipesOfNoCategory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CategoryGridTile(
              recipes: snapshot.data,
              category: 'no category',
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
    return gridTiles;
  }
}

class CategoryGridTile extends StatelessWidget {
  final List<Recipe> recipes;
  final String category;

  const CategoryGridTile({this.recipes, this.category, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageAsset;
    Random r = new Random();
    int rand;
    if (recipes.isNotEmpty) {
      rand = r.nextInt(recipes.length);
      imageAsset = recipes[rand].imagePath;
    } else {
      imageAsset = "images/randomFood.png";
    }
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => RecipeGridView(
                        category: category,
                        recipes: recipes,
                        randomCategoryImage: rand,
                      )));
        },
        child: GridTile(
          child: Image.asset(imageAsset, fit: BoxFit.cover),
          footer: GridTileBar(
            title: Text(
              category,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black45,
          ),
        ));
  }
}

List<Widget> createDummyCategoryCards() {
  return [
    GridTile(
      child: Image.asset(
        'images/noodle.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("noodles"),
        backgroundColor: Colors.black45,
      ),
    ),
    GridTile(
      child: Image.asset(
        'images/salat.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("salat"),
        backgroundColor: Colors.black45,
      ),
    ),
    GridTile(
      child: Image.asset(
        'images/breakfast.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("breakfast"),
        backgroundColor: Colors.black45,
      ),
    ),
    GridTile(
      child: Image.asset(
        'images/meat.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("meat"),
        backgroundColor: Colors.black45,
      ),
    ),
    GridTile(
      child: Image.asset(
        'images/vegetables.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("vegan"),
        backgroundColor: Colors.black45,
      ),
    ),
    GridTile(
      child: Image.asset(
        'images/rice.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("rice"),
        backgroundColor: Colors.black45,
      ),
    )
  ];
}
