import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/recipe_overview/recipe_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:my_recipe_book/generated/i18n.dart';

import '../helper.dart';
import '../recipe_card.dart';

TextStyle smallHeading = TextStyle(
    fontSize: 16, color: Color(0xffC75F00), fontWeight: FontWeight.w600);
TextStyle timeStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w900);
TextStyle ingredientsStyle =
    TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
TextStyle stepNumberStyle =
    TextStyle(fontSize: 32, fontWeight: FontWeight.w700);
TextStyle complexityNumberStyle =
    TextStyle(fontSize: 32, fontWeight: FontWeight.w900);

class RecipeCardBig extends StatelessWidget {
  final Recipe recipe;
  final int index;

  const RecipeCardBig({
    this.index,
    this.recipe,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String heroImageTag = '${recipe.name}$index';
    return ScopedModelDescendant<RecipeKeeper>(
      builder: (context, child, model) => Material(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => new RecipeScreen(
                  recipe: recipe,
                  primaryColor: getRecipePrimaryColor(recipe.vegetable),
                  heroImageTag: heroImageTag,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    spreadRadius: 2,
                    color: Theme.of(context).backgroundColor == Colors.white
                        ? Colors.grey[400]
                        : Colors.black,
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Hero(
                          tag: heroImageTag,
                          placeholderBuilder: (context, size, widget) => recipe
                                      .imagePath ==
                                  'images/randomFood.jpg'
                              ? Image.asset(recipe.imagePath, fit: BoxFit.cover)
                              : Image.file(File(recipe.imagePath),
                                  fit: BoxFit.cover),
                          child: FadeInImage(
                            image: recipe.imagePath == 'images/randomFood.jpg'
                                ? AssetImage(recipe.imagePath)
                                : FileImage(File(recipe.imagePath)),
                            placeholder: MemoryImage(kTransparentImage),
                            fadeInDuration: Duration(milliseconds: 250),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              color:
                                  Theme.of(context).cardColor.withOpacity(0.6),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                              1.8 -
                                          20,
                                      child: Text(
                                        recipe.name,
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(
                                      "images/${getRecipeTypeImage(recipe.vegetable)}.png",
                                      height: 35,
                                      width: 35,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                recipe.preperationTime != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(S.of(context).prep_time,
                                              style: smallHeading),
                                          SizedBox(height: 5),
                                          Text(
                                              getTimeHoursMinutes(
                                                  recipe.preperationTime),
                                              style: timeStyle),
                                        ],
                                      )
                                    : Container(),
                                recipe.cookingTime != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(S.of(context).cook_time,
                                              style: smallHeading),
                                          SizedBox(height: 5),
                                          Text(
                                              getTimeHoursMinutes(
                                                  recipe.cookingTime),
                                              style: timeStyle),
                                        ],
                                      )
                                    : Container(),
                                recipe.totalTime != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(S.of(context).total_time,
                                              style: smallHeading),
                                          SizedBox(height: 5),
                                          Text(
                                              getTimeHoursMinutes(
                                                  recipe.totalTime),
                                              style: timeStyle),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${getIngredientCount(recipe.ingredients)} ${S.of(context).ingredients}:',
                                  style: smallHeading,
                                ),
                                buildIngredients(recipe.ingredients),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 65,
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(S.of(context).steps,
                                            style: smallHeading),
                                        Text(
                                          recipe.steps.length.toString(),
                                          style: stepNumberStyle,
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(S.of(context).categories,
                                                style: smallHeading),
                                            Text(
                                              _getRecipeCategoriesString(
                                                  recipe.categories),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(S.of(context).complexity,
                                            style: smallHeading),
                                        Text(
                                          recipe.effort.toString(),
                                          style: complexityNumberStyle,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getRecipeCategoriesString(List<String> categories) {
    String categoryString = '';
    if (categories.isEmpty) {
      return 'none';
    }
    for (String c in categories) {
      if (categories.last != c) {
        categoryString += '$c, ';
      } else {
        categoryString += c;
      }
    }
    return categoryString;
  }

  Widget buildIngredients(List<List<Ingredient>> ingredients) {
    List<Ingredient> flatIngredients = flattenIngredients(ingredients);

    Column leftIngredientColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    );
    Column rightIngredientColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    );
    Column leftIngredAmountColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[],
    );
    Column rightIngredAmountColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[],
    );

    int displayAmount = flatIngredients.length > 6 ? 6 : flatIngredients.length;
    if (flatIngredients.length > 3) {
      for (int i = 0; i < displayAmount / 2.floor(); i++) {
        leftIngredientColumn.children
            .add(Text(flatIngredients[i].name, style: ingredientsStyle));
        leftIngredAmountColumn.children.add(Text(
          flatIngredients[i].amount.toString() + ' ' + flatIngredients[i].unit,
          style: ingredientsStyle,
        ));
      }
      for (int i = (displayAmount / 2).floor(); i < displayAmount; i++) {
        rightIngredientColumn.children
            .add(Text(flatIngredients[i].name, style: ingredientsStyle));
        rightIngredAmountColumn.children.add(Text(
          flatIngredients[i].amount.toString() + ' ' + flatIngredients[i].unit,
          style: ingredientsStyle,
        ));
      }
      return Row(
        children: <Widget>[
          leftIngredientColumn,
          Spacer(),
          leftIngredAmountColumn,
          SizedBox(width: 5),
          rightIngredientColumn,
          Spacer(),
          rightIngredAmountColumn,
        ],
      );
    } else {
      for (int i = 0; i < displayAmount; i++) {
        leftIngredientColumn.children
            .add(Text(flatIngredients[i].name, style: ingredientsStyle));
        leftIngredAmountColumn.children.add(Text(
          flatIngredients[i].amount.toString() + ' ' + flatIngredients[i].unit,
          style: ingredientsStyle,
        ));
      }
      return Row(children: <Widget>[
        leftIngredientColumn,
        Spacer(),
        leftIngredAmountColumn
      ]);
    }
  }
}
