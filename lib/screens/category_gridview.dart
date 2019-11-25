import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/category_overview/category_overview_bloc.dart';
import '../blocs/category_overview/category_overview_state.dart';
import '../models/tuple.dart';

class CategoryGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryOverviewBloc, CategoryOverviewState>(
        builder: (context, state) {
      if (state is LoadingCategoryOverview) {
        return Center(child: CircularProgressIndicator());
      } else if (state is LoadedCategoryOverview) {
        return GridView.extent(
            maxCrossAxisExtent: 300,
            padding: const EdgeInsets.all(4),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: getCategories(state.categories));
      }
    });
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
          // TODO: fix
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (BuildContext context) =>
          //         BlocProvider<RecipeOverviewBloc>(
          //       bloc: RecipeOverviewBloc(category: category),
          //       child: RecipeGridView(
          //         category: category,
          //       ),
          //     ),
          //   ),
          // );
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
