import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

import './recipe_card.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../generated/i18n.dart';
import '../helper.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../routes.dart';
import '../screens/recipe_screen.dart';

class RecipeCardBig extends StatelessWidget {
  final Recipe recipe;
  final int index;
  final double cardWidth;
  final double cardHeight;

  const RecipeCardBig({
    this.index,
    this.cardWidth,
    this.cardHeight,
    this.recipe,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double scaleFactor = deviceHeight / 800;

    TextStyle smallHeading = TextStyle(
        fontSize: 16, color: Color(0xffC75F00), fontWeight: FontWeight.w600);
    TextStyle timeStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w900);
    TextStyle ingredientsStyle =
        TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
    TextStyle stepNumberStyle =
        TextStyle(fontSize: 32, fontWeight: FontWeight.w700);
    TextStyle complexityNumberStyle =
        TextStyle(fontSize: 32, fontWeight: FontWeight.w900);

    final String heroImageTag = '${recipe.name}$index';
    return Material(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteNames.recipeScreen,
            arguments: RecipeScreenArguments(
              BlocProvider.of<ShoppingCartBloc>(context),
              recipe,
              getRecipePrimaryColor(recipe.vegetable),
              heroImageTag,
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
            padding: EdgeInsets.all(scaleFactor * 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 10,
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
                            color: Theme.of(context).cardColor.withOpacity(0.6),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  width: cardWidth - 130,
                                  padding: EdgeInsets.all(scaleFactor * 12.0),
                                  child: Text(
                                    recipe.name,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textScaleFactor: scaleFactor,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(scaleFactor * 12.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      pushVegetableRoute(
                                          context, recipe.vegetable);
                                    },
                                    child: Image.asset(
                                      "images/${getRecipeTypeImage(recipe.vegetable)}.png",
                                      height: scaleFactor * 35,
                                      width: scaleFactor * 35,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              recipe.preperationTime != null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(S.of(context).prep_time,
                                            textScaleFactor: scaleFactor,
                                            style: smallHeading),
                                        SizedBox(height: 5),
                                        Text(
                                            getTimeHoursMinutes(
                                                recipe.preperationTime),
                                            textScaleFactor: scaleFactor,
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
                                            textScaleFactor: scaleFactor,
                                            style: smallHeading),
                                        SizedBox(height: 5),
                                        Text(
                                            getTimeHoursMinutes(
                                                recipe.cookingTime),
                                            textScaleFactor: scaleFactor,
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
                                            textScaleFactor: scaleFactor,
                                            style: smallHeading),
                                        SizedBox(height: 5),
                                        Text(
                                            getTimeHoursMinutes(
                                                recipe.totalTime),
                                            textScaleFactor: scaleFactor,
                                            style: timeStyle),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${getIngredientCount(recipe.ingredients)} ${S.of(context).ingredients}:',
                                textScaleFactor: scaleFactor,
                                style: smallHeading,
                              ),
                              buildIngredients(
                                recipe.ingredients,
                                ingredientsStyle,
                                scaleFactor,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Wrap(
                              alignment: WrapAlignment.start,
                              direction: Axis.vertical,
                              children: <Widget>[
                                Text(S.of(context).steps,
                                    textScaleFactor: scaleFactor,
                                    style: smallHeading),
                                Text(
                                  recipe.steps.length.toString(),
                                  textScaleFactor: scaleFactor,
                                  style: stepNumberStyle,
                                ),
                              ],
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(S.of(context).categories,
                                        textScaleFactor: scaleFactor,
                                        style: smallHeading),
                                    Text(
                                      _getRecipeCategoriesString(
                                          recipe.categories),
                                      textScaleFactor: scaleFactor,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(S.of(context).complexity,
                                    textScaleFactor: scaleFactor,
                                    style: smallHeading),
                                Text(
                                  recipe.effort.toString(),
                                  textScaleFactor: scaleFactor,
                                  style: complexityNumberStyle,
                                ),
                              ],
                            ),
                          ],
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

  Widget buildIngredients(List<List<Ingredient>> ingredients,
      TextStyle ingredientsStyle, double scaleFactor) {
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
        leftIngredientColumn.children.add(Text(
          flatIngredients[i].name,
          maxLines: 1,
          textScaleFactor: scaleFactor,
          style: ingredientsStyle,
        ));
        if (flatIngredients[i].amount != null) {
          leftIngredAmountColumn.children.add(Text(
            cutDouble(flatIngredients[i].amount) +
                ' ' +
                (flatIngredients[i].unit != null
                    ? flatIngredients[i].unit
                    : ''),
            maxLines: 1,
            textScaleFactor: scaleFactor,
            style: ingredientsStyle,
          ));
        } else {
          leftIngredAmountColumn.children.add(Text(""));
        }
      }
      for (int i = (displayAmount / 2).floor(); i < displayAmount; i++) {
        rightIngredientColumn.children.add(Text(
          flatIngredients[i].name,
          maxLines: 1,
          textScaleFactor: scaleFactor,
          style: ingredientsStyle,
        ));
        if (flatIngredients[i].amount != null) {
          rightIngredAmountColumn.children.add(Text(
            cutDouble(flatIngredients[i].amount) +
                ' ' +
                (flatIngredients[i].unit != null
                    ? flatIngredients[i].unit
                    : ''),
            maxLines: 1,
            textScaleFactor: scaleFactor,
            style: ingredientsStyle,
          ));
        } else {
          rightIngredAmountColumn.children.add(Text(""));
        }
      }
      return Row(
        children: <Widget>[
          Expanded(child: leftIngredientColumn),
          leftIngredAmountColumn,
          SizedBox(width: 5),
          Expanded(child: rightIngredientColumn),
          rightIngredAmountColumn,
        ],
      );
    } else {
      for (int i = 0; i < displayAmount; i++) {
        leftIngredientColumn.children.add(Text(
          flatIngredients[i].name,
          maxLines: 1,
          textScaleFactor: scaleFactor,
          style: ingredientsStyle,
        ));
        if (flatIngredients[i].amount != null) {
          leftIngredAmountColumn.children.add(Text(
            cutDouble(flatIngredients[i].amount) +
                ' ' +
                (flatIngredients[i].unit != null
                    ? flatIngredients[i].unit
                    : ''),
            maxLines: 1,
            textScaleFactor: scaleFactor,
            style: ingredientsStyle,
          ));
        } else {
          leftIngredAmountColumn.children.add(Text(""));
        }
      }
      return Row(children: <Widget>[
        Expanded(child: leftIngredientColumn),
        leftIngredAmountColumn
      ]);
    }
  }
}
