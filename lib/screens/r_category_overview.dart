import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wakelock/wakelock.dart';

import '../blocs/recipe_category_overview/recipe_category_overview_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as Constants;
import '../constants/global_settings.dart';
import '../constants/routes.dart';
import '../generated/i18n.dart';
import '../models/recipe.dart';
import '../models/tuple.dart';
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
                        state.rCategoryOverview.sublist(
                            0, (state.rCategoryOverview.length / 2).round()),
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
                            (state.rCategoryOverview.length / 2).round(),
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
          itemCount: recipeCategories.length,
          itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              horizontalOffset: MediaQuery.of(context).size.width / 2,
              child: FadeInAnimation(
                child: RecipeRow(
                  category: recipeCategories[index].item1,
                  recipes: recipeCategories[index].item2,
                  listIndex: index,
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
  final int listIndex;

  const RecipeRow({
    @required this.category,
    @required this.recipes,
    @required this.listIndex,
    Key key,
  }) : super(key: key);

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
                        fontWeight: FontWeight.w500,
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
                listIndex: listIndex,
              )
      ],
    );
  }
}

// List of Recipes in a horizontal order with icons as a symbol and unterneath the name
class RecipeHozizontalList extends StatelessWidget {
  final List<Recipe> recipes;
  final String categoryName;
  final int listIndex;

  const RecipeHozizontalList({
    @required this.categoryName,
    this.recipes,
    this.listIndex,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 113, // 130 small
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recipes.length + 1,
          itemBuilder: (context, index) {
            double leftPadding = index == 0 ? 5 : 0;

            if (index < recipes.length) {
              return Padding(
                padding: EdgeInsets.only(left: leftPadding),
                child: RecipeImageItemBig(
                  recipe: recipes[index],
                  showMore: false,
                  heroImageTag: "$categoryName$index-image",
                ),
              );
            } else {
              return Padding(
                  padding: EdgeInsets.only(
                      left: leftPadding), //10, bottom: 35, right: 20),
                  child: RecipeImageItemBig(
                    showMore: true,
                    categoryName: categoryName == null
                        ? Constants.noCategory
                        : categoryName,
                    index: listIndex,
                  ));
            }
          },
        ),
      ),
    );
  }
}

class RecipeImageItemBig extends StatelessWidget {
  final Recipe recipe;
  final String heroImageTag;

  final bool showMore;

  final String categoryName;
  final int index;

  const RecipeImageItemBig({
    this.recipe,
    this.heroImageTag,
    @required this.showMore,
    this.categoryName,
    this.index,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return showMore
        ? Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 1),
                        blurRadius: 1,
                        spreadRadius: 0.5,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 110,
                          width: 170,
                          child: FadeInImage(
                            image:
                                AssetImage("images/foodBlur${index % 4}.jpg"),
                            fadeInDuration: const Duration(milliseconds: 250),
                            placeholder: MemoryImage(kTransparentImage),
                            height: 110,
                            width: 170,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          height: 110,
                          width: 170,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: Container(
                              width: 170,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              )),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                                child: Container(
                                  color: Colors.black.withOpacity(0.3),
                                  child: Center(
                                    child: Container(
                                      height: 50,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 8, 8, 8),
                                          child: Text(
                                            I18n.of(context).show_overview,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: Colors.grey[300]),
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                _pushRecipeRoute(context, heroImageTag, recipe);
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(1, 1),
                          blurRadius: 1,
                          spreadRadius: 0.5,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      child: Hero(
                        tag: heroImageTag,
                        child: Container(
                          child: FadeInImage(
                            image: recipe.imagePreviewPath ==
                                    Constants.noRecipeImage
                                ? AssetImage(Constants.noRecipeImage)
                                : FileImage(File(recipe.imagePreviewPath)),
                            fadeInDuration: const Duration(milliseconds: 250),
                            placeholder: MemoryImage(kTransparentImage),
                            height: 110,
                            width: 170,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 110,
                    width: 170,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 170,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        )),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 22, 8, 8),
                                child: Text(
                                  recipe.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.grey[300]),
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0, 0.4, 1],
                                colors: [
                                  Colors.transparent,
                                  Colors.black45,
                                  Colors.black54,
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  void _pushRecipeRoute(
      BuildContext context, String heroImageTag, Recipe recipe) {
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

/// either specify recipe and heroImageTag
/// or categoryName
class RecipeImageItemSmall extends StatelessWidget {
  final Recipe recipe;
  final String heroImageTag;

  final bool showMore;

  final String categoryName;

  const RecipeImageItemSmall({
    this.recipe,
    this.heroImageTag,
    @required this.showMore,
    this.categoryName,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return showMore
        ? GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteNames.recipeCategories,
                arguments: RecipeGridViewArguments(
                  shoppingCartBloc: BlocProvider.of<ShoppingCartBloc>(context),
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
          )
        : GestureDetector(
            onTap: () {
              _pushRecipeRoute(
                context,
                heroImageTag,
                recipe,
              );
            },
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
                            ? heroImageTag
                            : '$heroImageTag 1',
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
                                  color: Theme.of(context).backgroundColor ==
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
                              image: recipe.imagePreviewPath ==
                                      Constants.noRecipeImage
                                  ? AssetImage(Constants.noRecipeImage)
                                  : FileImage(File(recipe.imagePreviewPath)),
                              fadeInDuration: const Duration(milliseconds: 250),
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
                      recipe.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              Theme.of(context).backgroundColor == Colors.white
                                  ? Colors.grey[800]
                                  : Colors.grey[300]),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  void _pushRecipeRoute(
      BuildContext context, String heroImageTag, Recipe recipe) {
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

class RoundIconSpaceClipper extends CustomClipper<Path> {
  RoundIconSpaceClipper();

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(size.width / 2 - 15, 0)
      ..arcToPoint(
        Offset(size.width / 2, 15),
        clockwise: false,
        radius: Radius.circular(15),
      )
      ..arcToPoint(
        Offset(size.width / 2 + 15, 0),
        clockwise: false,
        radius: Radius.circular(15),
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(RoundIconSpaceClipper oldClipper) => true;
}
