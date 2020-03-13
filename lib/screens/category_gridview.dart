import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../blocs/category_overview/category_overview_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as Constants;
import '../constants/routes.dart';
import '../generated/i18n.dart';
import '../models/tuple.dart';
import 'recipe_overview.dart';

class CategoryGridView extends StatelessWidget {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryOverviewBloc, CategoryOverviewState>(
        builder: (context, state) {
      if (state is LoadingCategoryOverview) {
        return Center(child: CircularProgressIndicator());
      } else if (state is LoadedCategoryOverview) {
        return AnimationLimiter(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropMaterialHeader(),
            controller: _refreshController,
            onRefresh: () async {
              await Future.delayed(Duration(milliseconds: 200));
              BlocProvider.of<CategoryOverviewBloc>(context).add(
                  COLoadCategoryOverview(
                      reopenBoxes: true, categoryOverviewContext: context));
              _refreshController.refreshCompleted();
            },
            child: GridView.extent(
              maxCrossAxisExtent: 300,
              padding: const EdgeInsets.all(4),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: getCategories(state.categories, context),
            ),
          ),
        );
      } else {
        return Text(state.toString());
      }
    });
  }

  List<Widget> getCategories(
      List<Tuple2<String, String>> categoryNames, BuildContext context) {
    List<Widget> gridTiles = [];

    int index = 0;
    for (final Tuple2<String, String> categoryTuple in categoryNames) {
      gridTiles.add(
        AnimationConfiguration.staggeredGrid(
          position: index,
          duration: const Duration(milliseconds: 200),
          columnCount: 2,
          child: ScaleAnimation(
            scale: 0.8,
            child: FadeInAnimation(
              child: CategoryGridTile(
                category: categoryTuple.item1,
                randomCategoryImage: categoryTuple.item2,
              ),
            ),
          ),
        ),
      );
      index++;
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
        Navigator.pushNamed(
          context,
          RouteNames.recipeCategories,
          arguments: RecipeGridViewArguments(
            shoppingCartBloc: BlocProvider.of<ShoppingCartBloc>(context),
            category: category == null ? Constants.noCategory : category,
          ),
        );
      },
      child: GridTile(
        child: randomCategoryImage == Constants.noRecipeImage
            ? Image.asset(randomCategoryImage, fit: BoxFit.cover)
            : Image.file(File(randomCategoryImage), fit: BoxFit.cover),
        footer: GridTileBar(
          title: Text(
            category == "no category" ? I18n.of(context).no_category : category,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black45,
        ),
      ),
    );
  }
}
