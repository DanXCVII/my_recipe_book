import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/recipe_overview/recipe_screen.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:my_recipe_book/generated/i18n.dart';

import 'models/recipe.dart';

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
  final RecipePreview recipePreview;
  final Color shadow;
  final String heroImageTag;

  const RecipeCard({
    this.recipePreview,
    @required this.shadow,
    @required this.heroImageTag,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double gridTileWidth = deviceWidth / (deviceWidth / 300.floor() + 1);
    return GestureDetector(
      onTap: () {
        DBProvider.db.getRecipeByName(recipePreview.name, true).then((recipe) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => new RecipeScreen(
                recipe: recipe,
                primaryColor: getRecipePrimaryColor(recipePreview.vegetable),
                heroImageTag: heroImageTag,
              ),
            ),
          );
        });
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Hero(
                        tag: heroImageTag,
                        placeholderBuilder: (context, size, widget) =>
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(gridTileWidth / 10),
                                topRight: Radius.circular(gridTileWidth / 10),
                              ),
                              child: FadeInImage(
                                image: recipePreview.imagePreviewPath ==
                                        'images/randomFood.jpg'
                                    ? AssetImage(recipePreview.imagePreviewPath)
                                    : FileImage(
                                        File(recipePreview.imagePreviewPath)),
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
                              image: recipePreview.imagePreviewPath ==
                                      'images/randomFood.jpg'
                                  ? AssetImage(recipePreview.imagePreviewPath)
                                  : FileImage(
                                      File(recipePreview.imagePreviewPath)),
                              placeholder: MemoryImage(kTransparentImage),
                              fadeInDuration: Duration(milliseconds: 250),
                              fit: BoxFit.cover,
                              height: gridTileWidth / 1.25,
                              width: gridTileWidth + 40,
                            ),
                          ),
                        )),
                  ),
                  SizedBox(height: 7),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12,left: 15, right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${recipePreview.name}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14 + gridTileWidth / 35,
                                fontFamily: 'Righteous'),
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                recipePreview.totalTime,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontWeight: itemsFW,
                                  fontSize: 10 + gridTileWidth / 40,
                                  fontFamily: 'Questrial',
                                ),
                              ),
                              Text(
                                "${recipePreview.ingredientsAmount} ${S.of(context).ingredients}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontWeight: itemsFW,
                                  fontSize: 10 + gridTileWidth / 40,
                                  fontFamily: 'Questrial',
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: complexityColors[
                                          recipePreview.effort],
                                    ),
                                  ),
                                  Text(
                                    ' ' + S.of(context).effort,
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Container(
                child: Center(
                  child: Image.asset(
                    "images/${getRecipeTypeImage(recipePreview.vegetable)}.png",
                    height: 35,
                    width: 35,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                height: gridTileWidth / 3,
                width: gridTileWidth / 3,
              )),

          recipePreview.isFavorite == true
              ? Align(
                  alignment: Alignment(0.95, -0.95),
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.pink[300],
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          )),
                      child: Center(
                          child: Image.asset(
                        'images/heart.png',
                        height: 25,
                      ))),
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
