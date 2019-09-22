import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:math';

import '../../database.dart';
import '../../recipe.dart';
import './../recipe_screen.dart';
import './../recipe_overview.dart';

// Builds the Rows of all the categories

class RecipeCategoryOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RecipeKeeper>(
        builder: (context, child, model) {
      List<String> categoryNames = model.categories;
      if (model.isInitialised) {
        return ListView.builder(
            itemCount: categoryNames.length,
            itemBuilder: (context, index) {
              return RecipeRow(
                recipePreviews:
                    model.getRecipesOfCategory(categoryNames[index]),
                category:
                    index == categoryNames.length ? null : categoryNames[index],
              );
            });
      } else {
        return Container(
          height: 110,
          child: Center(child: CircularProgressIndicator()),
        );
      }
    });
  }
}

/// Builds a Row with the CategoryName and underneath a horizontally
/// scrollable "List" of kinda circles with the recipes of that category
class RecipeRow extends StatelessWidget {
  final String category;
  final List<RecipePreview> recipePreviews;

  const RecipeRow({this.recipePreviews, this.category, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recipePreviews.isEmpty) return Container();
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () {
              _pushCategoryRoute(context, category, recipePreviews.length);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 10.0, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    category != null ? category : 'no category',
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
          recipePreviews: recipePreviews,
          categoryName: category == null ? 'no category' : category,
        )
      ],
    );
  }
}

// List of Recipes in a horizontal order with icons as a symbol and unterneath the name
class RecipeHozizontalList extends StatelessWidget {
  final List<RecipePreview> recipePreviews;
  final String categoryName;

  const RecipeHozizontalList(
      {@required this.categoryName, this.recipePreviews, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recipePreviews.isEmpty) {
      return Container();
    }
    int recipeCount;
    if (recipePreviews.length >= 10) {
      recipeCount = 10;
    }
    recipeCount = recipePreviews.length;

    return Container(
      height: 130,
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
                  '$categoryName$index-title',
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
                      Hero(
                        tag: '$categoryName$index-image',
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(35)),
                            child: FadeInImage(
                              // image: AssetImage(recipes[index].imagePath),
                              image: recipePreviews[index].imagePreviewPath ==
                                      'images/randomFood.jpg'
                                  ? AssetImage('images/randomFood.jpg')
                                  : FileImage(File(
                                      recipePreviews[index].imagePreviewPath)),
                              fadeInDuration: const Duration(milliseconds: 250),
                              placeholder: MemoryImage(kTransparentImage),
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4, left: 10, right: 10),
                        child: Text(
                          recipePreviews[index].name,
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
                  _pushCategoryRoute(
                      context, categoryName, recipePreviews.length);
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

  void _pushRecipeRoute(BuildContext context, int index, String heroImageTag,
      String heroTitleTag) {
    DBProvider.db
        .getRecipeByName(recipePreviews[index].name, true)
        .then((recipe) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => new RecipeScreen(
            recipe: recipe,
            primaryColor:
                getRecipePrimaryColor(recipePreviews[index].vegetable),
            heroImageTag: heroImageTag,
            heroTitle: heroTitleTag,
          ),
        ),
      );
    });
  }
}

void _pushCategoryRoute(
    BuildContext context, String categoryName, int recipePreviewAmount) {
  Random randomRecipe = new Random();

  Navigator.push(
    context,
    CupertinoPageRoute(
      builder: (BuildContext context) => new RecipeGridView(
        category: categoryName == null ? 'no category' : categoryName,
        randomCategoryImage: recipePreviewAmount != 1
            ? randomRecipe.nextInt(recipePreviewAmount)
            : 0,
      ),
    ),
  );
}
