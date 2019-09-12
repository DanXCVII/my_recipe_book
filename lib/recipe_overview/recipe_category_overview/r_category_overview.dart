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
      List<String> categoryNames = model.rCategories;
      if (model.isInitialised) {
        print(model.isInitialised);
        print(model.rCategories);
        print(model.recipes.toString());
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
    Random r = new Random();
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeGridView(
                    category: category == null ? 'no category' : category,
                    randomCategoryImage: recipePreviews.length != 1
                        ? r.nextInt(recipePreviews.length > 0
                            ? recipePreviews.length
                            : 1)
                        : 0,
                  ),
                ),
              );
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
    Random randomRecipe = new Random();
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
          double leftPadding;
          if (index == 0) {
            leftPadding = 5;
          } else {
            leftPadding = 0;
          }
          if (index < recipeCount) {
            final String heroTag =
                '${recipePreviews[index].name}$categoryName--${recipePreviews[index].imagePreviewPath}';

            return GestureDetector(
              onTap: () {
                DBProvider.db
                    .getRecipeByName(recipePreviews[index].name, true)
                    .then((recipe) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => new RecipeScreen(
                        recipe: recipe,
                        primaryColor: getRecipePrimaryColor(
                            recipePreviews[index].vegetable),
                        heroImageTag: heroTag,
                        heroTitle:
                            '${recipePreviews[index].name}-${recipePreviews[index].name}',
                      ),
                    ),
                  );
                });
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
                        tag: heroTag,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(35)),
                          child: FadeInImage(
                            // image: AssetImage(recipes[index].imagePath),
                            image: AssetImage(
                                recipePreviews[index].imagePreviewPath),
                            fadeInDuration: const Duration(milliseconds: 250),
                            placeholder: MemoryImage(kTransparentImage),
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4, left: 10, right: 10),
                        child: Text(recipePreviews[index].name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).backgroundColor ==
                                        Colors.white
                                    ? Colors.grey[800]
                                    : Colors.grey[300])),
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
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (BuildContext context) => new RecipeGridView(
                        category:
                            categoryName == null ? 'no category' : categoryName,
                        randomCategoryImage: recipePreviews.length != 1
                            ? randomRecipe.nextInt(recipePreviews.length)
                            : 0,
                      ),
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
}