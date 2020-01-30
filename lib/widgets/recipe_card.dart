import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:transparent_image/transparent_image.dart';

import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/recipe_overview/recipe_overview_bloc.dart';
import '../blocs/recipe_overview/recipe_overview_event.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../generated/i18n.dart';
import '../helper.dart';
import '../models/enums.dart';
import '../models/recipe.dart';
import '../routes.dart';
import '../screens/recipe_overview.dart';
import '../screens/recipe_screen.dart';

const Map<int, Color> complexityColors = {
  1: Color(0xff28E424),
  2: Color(0xff4ED220),
  3: Color(0xff33B51E),
  4: Color(0xff188E24),
  5: Color(0xff135B12),
  6: Color(0xff691A1A),
  7: Color(0xff892020),
  8: Color(0xffB51E1E),
  9: Color(0xffDC1818),
  10: Color(0xffFD0000)
};

FontWeight itemsFW = FontWeight.w400;

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final Color shadow;
  final String heroImageTag;
  final bool activateVegetableHero;

  const RecipeCard({
    this.recipe,
    @required this.shadow,
    @required this.heroImageTag,
    this.activateVegetableHero = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double gridTileWidth = deviceWidth / (deviceWidth / 300.floor() + 1);
    return GestureDetector(
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
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  offset: Offset(2, 2),
                  blurRadius: 3,
                  spreadRadius: 1,
                  color: shadow,
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(gridTileWidth / 10),
                topRight: Radius.circular(gridTileWidth / 10),
                bottomRight: Radius.circular(gridTileWidth / 10),
                bottomLeft: Radius.circular(gridTileWidth / 10),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: heroImageTag,
                      placeholderBuilder: (context, size, widget) => ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(gridTileWidth / 10),
                          topRight: Radius.circular(gridTileWidth / 10),
                        ),
                        child: FadeInImage(
                          image:
                              recipe.imagePreviewPath == 'images/randomFood.jpg'
                                  ? AssetImage(recipe.imagePreviewPath)
                                  : FileImage(File(recipe.imagePreviewPath)),
                          placeholder: MemoryImage(kTransparentImage),
                          fadeInDuration: Duration(milliseconds: 250),
                          fit: BoxFit.cover,
                          height: gridTileWidth / 1.25,
                          width: gridTileWidth + 40,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(gridTileWidth / 10),
                            topRight: Radius.circular(gridTileWidth / 10),
                          ),
                          child: FadeInImage(
                            image: recipe.imagePreviewPath ==
                                    'images/randomFood.jpg'
                                ? AssetImage(recipe.imagePreviewPath)
                                : FileImage(File(recipe.imagePreviewPath)),
                            placeholder: MemoryImage(kTransparentImage),
                            fadeInDuration: Duration(milliseconds: 250),
                            fit: BoxFit.cover,
                            height: gridTileWidth / 1.25,
                            width: gridTileWidth + 40,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 7, 12, 12),
                      child: Column(children: <Widget>[
                        Container(
                          width: gridTileWidth - 12,
                          child: Text(
                            "${recipe.name}",
                            textScaleFactor: deviceWidth / 400,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14 + gridTileWidth / 35,
                                fontFamily: 'Righteous'),
                          ),
                        ),
                        SizedBox(height: 7),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  getTimeHoursMinutes(recipe.totalTime),
                                  textScaleFactor: deviceWidth / 400,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontWeight: itemsFW,
                                    fontSize: 10 + gridTileWidth / 40,
                                    fontFamily: 'Questrial',
                                  ),
                                ),
                                Text(
                                  "${getIngredientCount(recipe.ingredients)} ${S.of(context).ingredients}",
                                  textScaleFactor: deviceWidth / 400,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontWeight: itemsFW,
                                    fontSize: 10 + gridTileWidth / 40,
                                    fontFamily: 'Questrial',
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 14,
                                      width: 14,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: complexityColors[recipe.effort],
                                      ),
                                    ),
                                    Text(
                                      ' ' + S.of(context).effort,
                                      textScaleFactor: deviceWidth / 400,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontWeight: itemsFW,
                                        fontSize: 10 + gridTileWidth / 40,
                                        fontFamily: 'Questrial',
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                if (activateVegetableHero)
                                  pushVegetableRoute(context, recipe.vegetable);
                              },
                              child: Container(
                                child: Center(
                                  child: Image.asset(
                                    "images/${getRecipeTypeImage(recipe.vegetable)}.png",
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                height: deviceWidth / 400 * 35,
                                width: deviceWidth / 400 * 35,
                              ),
                            )
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),

          recipe.isFavorite == true
              ? Align(
                  alignment: Alignment(0.95, -0.95),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3.0, right: 2),
                    child: Container(
                      height: deviceWidth / 400 * 40,
                      width: deviceWidth / 400 * 40,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(50, 50, 50, 0.7),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          )),
                      child: Center(
                        child: SpinKitPumpingHeart(
                          color: Colors.pink,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          //Padding(
          // padding: EdgeInsets.only(
          //      left: gridTileWidth / 1.4, top: gridTileWidth / 40),
          //  child: Favorite(
          //    recipes[i],
          //    iconSize: 22,
          //  ),
          //)
        ],
      ),
    );
  }

  Color getRecipeTypeColor(Vegetable vegetable) {
    switch (vegetable) {
      case Vegetable.NON_VEGETARIAN:
        return Color(0xff9C2F00);
      case Vegetable.VEGAN:
        return Color(0xff487D1F);
      case Vegetable.VEGETARIAN:
        return Color(0xff78B000);
      default:
        return Color(0x00000000);
    }
  }

  /// returns the image for the icon which is displayed at the bottom left corner
  /// of the recipe depending on whether recipe is vegetarian, vegan, etc.

}

void pushVegetableRoute(BuildContext recipeCardContext, Vegetable vegetable) {
  Navigator.push(
      recipeCardContext,
      CupertinoPageRoute(
        builder: (BuildContext context) => new BlocProvider<RecipeOverviewBloc>(
          create: (context) => RecipeOverviewBloc(
              recipeManagerBloc:
                  BlocProvider.of<RecipeManagerBloc>(recipeCardContext))
            ..add(LoadVegetableRecipeOverview(vegetable)),
          child: RecipeGridView(),
        ),
      ));
}

String getRecipeTypeImage(Vegetable vegetable) {
  switch (vegetable) {
    case Vegetable.NON_VEGETARIAN:
      return "meat";
    case Vegetable.VEGETARIAN:
      return "milk";
    case Vegetable.VEGAN:
      return "tomato";
    default:
      return "no valid input at getRecipeTypeImage()";
  }
}