import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_recipe_book/blocs/bloc_provider.dart';
import 'package:my_recipe_book/blocs/category_gridview_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_category_overview_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_overview_bloc.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/models/recipe_preview.dart';
import 'package:my_recipe_book/recipe_overview/recipe_overview.dart';
import 'package:tuple/tuple.dart';

class CategoryGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CategoryGridviewBloc bloc =
        BlocProvider.of<CategoryGridviewBloc>(context);

    return StreamBuilder<List<Tuple2<String, String>>>(
      stream: bloc.outCategories,
      builder: (context, snapshot) => GridView.extent(
          maxCrossAxisExtent: 300,
          padding: const EdgeInsets.all(4),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: getCategories(snapshot.data)),
    );
  }

  List<Widget> getCategories(List<Tuple2<String, String>> categoryNames) {
    List<Widget> gridTiles = [];

    for (final Tuple2<String, String> categoryTuple in categoryNames) {
      gridTiles.add(CategoryGridTile(
        category: categoryTuple.item1,
        randomCategoryImage: categoryTuple.item2,
      ));
    }
    return gridTiles;
  }
}

class CategoryGridTile extends StatelessWidget {
  final String randomCategoryImage;
  final String category;

  const CategoryGridTile({
    this.randomCategoryImage,
    this.category,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  BlocProvider<RecipeOverviewBloc>(
                bloc: RecipeOverviewBloc(category: category),
                child: RecipeGridView(
                  category: category,
                ),
              ),
            ),
          );
        },
        child: GridTile(
          child: randomCategoryImage == 'images/randomFood.jpg'
              ? Image.asset(randomCategoryImage, fit: BoxFit.cover)
              : Image.file(File(randomCategoryImage), fit: BoxFit.cover),
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
