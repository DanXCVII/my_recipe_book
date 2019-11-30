import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

import '../blocs/recipe_category_overview/recipe_category_overview.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/recipe_overview/recipe_overview_bloc.dart';
import '../blocs/recipe_overview/recipe_overview_event.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../generated/i18n.dart';
import '../models/recipe.dart';
import '../recipe_overview/recipe_screen.dart';
import '../routes.dart';
import 'recipe_overview.dart';

// Builds the Rows of all the categories

class RecipeCategoryOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeCategoryOverviewBloc, RecipeCategoryOverviewState>(
        builder: (context, state) {
      if (state is LoadingRecipeCategoryOverviewState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is LoadedRecipeCategoryOverview) {
        return ListView.builder(
            itemCount: state.rCategoryOverview.length,
            itemBuilder: (context, index) {
              return RecipeRow(
                category: state.rCategoryOverview[index].item1,
                recipes: state.rCategoryOverview[index].item2,
              );
            });
      }
      return (Text(state.toString()));
    });
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
              _pushCategoryRoute(context, category);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 10.0, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    category != null ? category : S.of(context).no_category,
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
        RecipeHozizontalList(
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
      height: 135,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
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
                      // Hero(
                      //   tag: recipelistF
                      //       .data[index].imagePath,
                      //   child: Material(
                      //     color: Colors.transparent,
                      //     child:
                      Stack(
                        children: <Widget>[
                          Hero(
                            tag: '$categoryName$index-image',
                            placeholderBuilder: (context, size, widget) =>
                                ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(35)),
                              child: FadeInImage(
                                // image: AssetImage(recipes[index].imagePath),
                                image: recipes[index].imagePreviewPath ==
                                        'images/randomFood.jpg'
                                    ? AssetImage('images/randomFood.jpg')
                                    : FileImage(
                                        File(recipes[index].imagePreviewPath)),
                                fadeInDuration:
                                    const Duration(milliseconds: 250),
                                placeholder: MemoryImage(kTransparentImage),
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(35)),
                              child: FadeInImage(
                                // image: AssetImage(recipes[index].imagePath),
                                image: recipes[index].imagePreviewPath ==
                                        'images/randomFood.jpg'
                                    ? AssetImage('images/randomFood.jpg')
                                    : FileImage(
                                        File(recipes[index].imagePreviewPath)),
                                fadeInDuration:
                                    const Duration(milliseconds: 250),
                                placeholder: MemoryImage(kTransparentImage),
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
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
              padding: EdgeInsets.only(left: 10, bottom: 40, right: 20),
              child: GestureDetector(
                onTap: () {
                  _pushCategoryRoute(context, categoryName);
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
    Navigator.pushNamed(
      context,
      RouteNames.recipeScreen,
      arguments: RecipeScreenArguments(
        BlocProvider.of<ShoppingCartBloc>(context),
        recipe,
        getRecipePrimaryColor(recipes[index].vegetable),
        heroImageTag,
      ),
    );
  }
}

void _pushCategoryRoute(
    BuildContext rCategoryOverviewContext, String categoryName) {
  Navigator.push(
      rCategoryOverviewContext,
      CupertinoPageRoute(
        builder: (BuildContext context) => new BlocProvider<RecipeOverviewBloc>(
          builder: (context) => RecipeOverviewBloc(
              recipeManagerBloc:
                  BlocProvider.of<RecipeManagerBloc>(rCategoryOverviewContext))
            ..add(LoadCategoryRecipeOverview(
                categoryName == null ? 'no category' : categoryName)),
          child: RecipeGridView(),
        ),
      ));
}
