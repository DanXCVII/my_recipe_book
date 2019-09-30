import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/recipe_overview/recipe_overview.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoryGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RecipeKeeper>(
      builder: (context, child, model) => GridView.extent(
          maxCrossAxisExtent: 300,
          padding: const EdgeInsets.all(4),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: getCategories(model.categories, model)),
    );
  }

  List<Widget> getCategories(List<String> categoryNames, RecipeKeeper rKeeper) {
    List<Widget> gridTiles = [];

    for (final String category in categoryNames) {
      List<RecipePreview> recipes = rKeeper.getRecipesOfCategory(category);
      if (recipes.isNotEmpty)
        gridTiles.add(CategoryGridTile(
          recipes: recipes,
          category: category,
        ));
    }
    return gridTiles;
  }
}

class CategoryGridTile extends StatelessWidget {
  final List<RecipePreview> recipes;
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
      imageAsset = recipes[rand].rImagePreviewPath;
    } else {
      imageAsset = "images/randomFood.jpg";
    }
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => RecipeGridView(
                        category: category,
                        randomCategoryImage: rand,
                      )));
        },
        child: GridTile(
          child: imageAsset == 'images/randomFood.jpg'
              ? Image.asset(imageAsset, fit: BoxFit.cover)
              : Image.file(File(imageAsset), fit: BoxFit.cover),
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
