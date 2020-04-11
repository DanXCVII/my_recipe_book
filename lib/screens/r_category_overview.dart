import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_recipe_book/constants/global_settings.dart';
import 'package:my_recipe_book/models/tuple.dart';
import 'package:my_recipe_book/screens/recipe_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wakelock/wakelock.dart';

import '../blocs/recipe_category_overview/recipe_category_overview_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as Constants;
import '../constants/routes.dart';
import '../generated/i18n.dart';
import '../models/recipe.dart';
import 'recipe_overview.dart';
import 'recipe_screen.dart';

// Builds the Rows of all the categories

class RecipeCategoryOverview extends StatelessWidget {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final RefreshController _refreshControllerTwo =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCategoryOverviewBloc, RecipeCategoryOverviewState>(
        builder: (context, state) {
      if (state is LoadingRecipeCategoryOverviewState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is LoadedRecipeCategoryOverview) {
        return MediaQuery.of(context).size.width > 1000
            ? Row(
                children: <Widget>[
                  Expanded(
                    child: _getRecipeCategoryOverviewList(
                        context,
                        state.rCategoryOverview.sublist(0,
                            (state.rCategoryOverview.length / 2).floor() + 1),
                        _refreshController),
                  ),
                  Container(
                    height: double.infinity,
                    width: 10,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: _getRecipeCategoryOverviewList(
                        context,
                        state.rCategoryOverview.sublist(
                            (state.rCategoryOverview.length / 2).floor() + 1,
                            state.rCategoryOverview.length),
                        _refreshControllerTwo),
                  ),
                ],
              )
            : _getRecipeCategoryOverviewList(
                context,
                state.rCategoryOverview,
                _refreshController,
              );
      }
      return (Text(state.toString()));
    });
  }

  Widget _getRecipeCategoryOverviewList(
    BuildContext context,
    List<Tuple2<String, List<Recipe>>> recipeCategories,
    RefreshController refreshController,
  ) {
    return AnimationLimiter(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropMaterialHeader(),
        controller: refreshController,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 200));
          BlocProvider.of<RecipeCategoryOverviewBloc>(context).add(
              RCOLoadRecipeCategoryOverview(
                  reopenBoxes: true, categoryOverviewContext: context));
          refreshController.refreshCompleted();
        },
        child: ListView.builder(
          itemCount: MediaQuery.of(context).size.width > 1000
              ? (recipeCategories.length / 2).round()
              : recipeCategories.length,
          itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              horizontalOffset: MediaQuery.of(context).size.width / 2,
              child: FadeInAnimation(
                child: RecipeRow(
                  category: recipeCategories[index].item1,
                  recipes: recipeCategories[index].item2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Builds a Row with the CategoryName and underneath a horizontally
/// scrollable "List" of kinda circles with the recipes of that category
class RecipeRow extends StatelessWidget {
  final String category;
  final List<Recipe> recipes;

  const RecipeRow({@required this.category, @required this.recipes, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteNames.recipeCategories,
                arguments: RecipeGridViewArguments(
                  shoppingCartBloc: BlocProvider.of<ShoppingCartBloc>(context),
                  category: category,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 10.0, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    category == "no category"
                        ? I18n.of(context).no_category
                        : category,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Theme.of(context).backgroundColor == Colors.white
                            ? Colors.black
                            : Colors.grey[200]),
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        ),
        recipes.isEmpty
            ? Container()
            : RecipeHozizontalList(
                categoryName: category,
                recipes: recipes,
              )
      ],
    );
  }
}

// List of Recipes in a horizontal order with icons as a symbol and unterneath the name
class RecipeHozizontalList extends StatelessWidget {
  final List<Recipe> recipes;
  final String categoryName;

  const RecipeHozizontalList({
    @required this.categoryName,
    this.recipes,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length + 1,
        itemBuilder: (context, index) {
          double leftPadding = index == 0 ? 5 : 0;

          if (index < recipes.length) {
            return GestureDetector(
              onTap: () {
                _pushRecipeRoute(
                  context,
                  index,
                  '$categoryName$index-image',
                  recipes[index],
                );
              },
              child: Padding(
                padding: EdgeInsets.only(left: leftPadding),
                child: Container(
                  // color: Colors.pink,
                  height: 110,
                  width: 110,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Hero(
                            tag: GlobalSettings().animationsEnabled()
                                ? '$categoryName$index-image'
                                : '$categoryName$index-image1',
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(35),
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(35)),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                      spreadRadius: 1,
                                      color:
                                          Theme.of(context).backgroundColor ==
                                                  Colors.white
                                              ? Colors.grey[400]
                                              : Colors.black,
                                    ),
                                  ]),
                              height: 90,
                              width: 90,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(35),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(35)),
                                child: FadeInImage(
                                  image: recipes[index].imagePreviewPath ==
                                          Constants.noRecipeImage
                                      ? AssetImage(Constants.noRecipeImage)
                                      : FileImage(File(
                                          recipes[index].imagePreviewPath)),
                                  fadeInDuration:
                                      const Duration(milliseconds: 250),
                                  placeholder: MemoryImage(kTransparentImage),
                                  height: 90,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4, left: 10, right: 10),
                        child: Text(
                          recipes[index].name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).backgroundColor ==
                                      Colors.white
                                  ? Colors.grey[800]
                                  : Colors.grey[300]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(left: 10, bottom: 35, right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RouteNames.recipeCategories,
                    arguments: RecipeGridViewArguments(
                      shoppingCartBloc:
                          BlocProvider.of<ShoppingCartBloc>(context),
                      category: categoryName == null
                          ? Constants.noCategory
                          : categoryName,
                    ),
                  );
                },
                child: Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(35),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/rightArrow.png',
                      fit: BoxFit.contain,
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _pushRecipeRoute(
      BuildContext context, int index, String heroImageTag, Recipe recipe) {
    if (GlobalSettings().standbyDisabled()) {
      Wakelock.enable();
    }
    Navigator.pushNamed(
      context,
      RouteNames.recipeScreen,
      arguments: RecipeScreenArguments(
        BlocProvider.of<ShoppingCartBloc>(context),
        recipe,
        heroImageTag,
        BlocProvider.of<RecipeManagerBloc>(context),
      ),
    ).then((_) => Wakelock.disable());
  }
}
