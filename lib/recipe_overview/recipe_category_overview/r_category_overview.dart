import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_recipe_book/blocs/bloc_provider.dart';
import 'package:my_recipe_book/blocs/recipe_category_overview_bloc.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:hive/hive.dart';

import './../recipe_screen.dart';
import './../recipe_overview.dart';

// Builds the Rows of all the categories

class RecipeCategoryOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RecipeCategoryOverviewBloc bloc =
        BlocProvider.of<RecipeCategoryOverviewBloc>(context);

    return StreamBuilder(
        stream: bloc.outCategories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> categoryNames = snapshot.data;
            return ListView.builder(
                itemCount: categoryNames.length,
                itemBuilder: (context, index) {
                  return RecipeRow(
                    index,
                    category: categoryNames[index],
                  );
                });
          } else {
            // TODO: Handle no data
            return (Text('kek'));
          }
        });
  }
}

/// Builds a Row with the CategoryName and underneath a horizontally
/// scrollable "List" of kinda circles with the recipes of that category
class RecipeRow extends StatelessWidget {
  final String category;
  final int index;

  const RecipeRow(this.index, {this.category, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RecipeCategoryOverviewBloc bloc =
        BlocProvider.of<RecipeCategoryOverviewBloc>(context);

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
        StreamBuilder<List<List<Recipe>>>(
            stream: bloc.outCategoryRecipes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return RecipeHozizontalList(
                  categoryName: category,
                  recipes: snapshot.data[index],
                );
              } else {
                return Text(':/');
              }
            }),
      ],
    );
  }

  List<Recipe> _getRecipesOfCategory(
      String categoryName, Box<List<String>> categoriesBox) {
    List<Recipe> recipesOfCategory = [];
    var recipesBox = Hive.box<Recipe>('recipes');

    for (var t in recipesBox.keys) {
      Recipe r = recipesBox.get('$t');
    }

    for (String recipeName in categoriesBox.get(categoryName)) {
      recipesOfCategory.add(recipesBox.get(recipeName));
    }

    return recipesOfCategory;
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
    if (recipes.isEmpty) {
      return Container();
    }
    int recipeCount;
    if (recipes.length >= 8) {
      recipeCount = 8;
    } else {
      recipeCount = recipes.length;
    }

    return Container(
      height: 135,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipeCount + 1,
        itemBuilder: (context, index) {
          double leftPadding = index == 0 ? 5 : 0;

          if (index < recipeCount) {
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => new RecipeScreen(
          recipe: recipe,
          primaryColor: getRecipePrimaryColor(recipes[index].vegetable),
          heroImageTag: heroImageTag,
        ),
      ),
    );
  }
}

void _pushCategoryRoute(BuildContext context, String categoryName) {
  Navigator.push(
    context,
    CupertinoPageRoute(
      builder: (BuildContext context) => new RecipeGridView(
        category: categoryName == null ? 'no category' : categoryName,
      ),
    ),
  );
}
