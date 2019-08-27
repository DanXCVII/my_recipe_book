import 'package:flutter/material.dart';
import 'package:my_recipe_book/recipe.dart';
import 'package:my_recipe_book/recipe_overview/recipe_screen.dart';
import 'package:transparent_image/transparent_image.dart';

Map<Vegetable, Color> recipeCardBackgroundColors = {
  Vegetable.NON_VEGETARIAN: Color(0xffE9D0D0),
  Vegetable.VEGAN: Color(0xffD5E2DB),
  Vegetable.VEGETARIAN: Color(0xffDBE4D3)
};

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

FontWeight itemsFW = FontWeight.w500;

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({this.recipe, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(recipe.vegetable.toString());
    final String heroImageTag = "${recipe.imagePath}-${recipe.id}";
    double deviceWidth = MediaQuery.of(context).size.width;
    double gridTileWidth = deviceWidth / (deviceWidth / 300.floor() + 1);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => new RecipeScreen(
              recipe: recipe,
              primaryColor: getRecipePrimaryColor(recipe),
              heroImageTag: heroImageTag,
            ),
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              color: recipeCardBackgroundColors[recipe.vegetable],
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
                  SizedBox(height: gridTileWidth / 1.25 + 7),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 12),
                    child: Hero(
                      tag: "recipe-${recipe.id}",
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          "${recipe.name}",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14 + gridTileWidth / 35,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 13),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          getTimeHoursMinutes(recipe.totalTime),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: itemsFW,
                            fontSize: 10 + gridTileWidth / 40,
                          ),
                        ),
                        Text(
                          "${getIngredientCount(recipe.ingredients)} ingredients",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: itemsFW,
                            fontSize: 10 + gridTileWidth / 40,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              height: 14,
                              width: 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: complexityColors[recipe.complexity],
                              ),
                            ),
                            Text(
                              " effort",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: itemsFW,
                                fontSize: 10 + gridTileWidth / 40,
                              ),
                            ),
                          ],
                        )
                      ],
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
                    "images/${getRecipeTypeImage(recipe.vegetable)}.png",
                    height: 35,
                    width: 35,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                height: gridTileWidth / 3,
                width: gridTileWidth / 3,
              )),
          Hero(
              tag: heroImageTag,
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(gridTileWidth / 10),
                    topRight: Radius.circular(gridTileWidth / 10),
                  ),
                  child: FadeInImage(
                    image: AssetImage(recipe.imagePreviewPath),
                    placeholder: MemoryImage(kTransparentImage),
                    fadeInDuration: Duration(milliseconds: 250),
                    fit: BoxFit.cover,
                    height: gridTileWidth / 1.25,
                    width: gridTileWidth + 40,
                  ),
                ),
              )),
          recipe.isFavorite == true
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

  String getTimeHoursMinutes(double min) {
    if (min ~/ 60 > 0) {
      return "${min ~/ 60}h ${min - (min ~/ 60 * 60)}min";
    }
    return "$min min";
  }

  int getIngredientCount(List<List<Ingredient>> ingredients) {
    int ingredientCount = 0;
    for (final List<Ingredient> i in ingredients) {
      if (i != null) ingredientCount += i.length;
    }
    return ingredientCount;
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
}
