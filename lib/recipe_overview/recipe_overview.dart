import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../database.dart';
import '../recipe.dart';
import './recipe_screen.dart';

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

Map<Vegetable, Color> recipeCardBackgroundColors = {
  Vegetable.NON_VEGETARIAN: Color(0xffE9D0D0),
  Vegetable.VEGAN: Color(0xffD5E2DB),
  Vegetable.VEGETARIAN: Color(0xffDBE4D3)
};

Map<String, List<Color>> colors = {
  "${Vegetable.NON_VEGETARIAN.toString()}1": [
    Color(0xffD10C0C),
    Color(0xffC90505)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}2": [
    Color(0xffC90505),
    Color(0xffB40808)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}3": [
    Color(0xffB40808),
    Color(0xff880000)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}4": [
    Color(0xff880000),
    Color(0xff800101)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}5": [
    Color(0xff800101),
    Color(0xff710101)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}6": [
    Color(0xff710101),
    Color(0xff5F0000)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}7": [
    Color(0xff5F0000),
    Color(0xff540000)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}8": [
    Color(0xff540000),
    Color(0xff430000)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}9": [
    Color(0xff430000),
    Color(0xff380000)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}10": [
    Color(0xff380000),
    Color(0xff280000)
  ],
  "${Vegetable.VEGAN.toString()}1": [Color(0xff216715), Color(0xff1D5F13)],
  "${Vegetable.VEGAN.toString()}2": [Color(0xff1D5F13), Color(0xff19590F)],
  "${Vegetable.VEGAN.toString()}3": [Color(0xff19590F), Color(0xff15520B)],
  "${Vegetable.VEGAN.toString()}4": [Color(0xff15520B), Color(0xff104A07)],
  "${Vegetable.VEGAN.toString()}5": [Color(0xff104A07), Color(0xff0C4403)],
  "${Vegetable.VEGAN.toString()}6": [Color(0xff0C4403), Color(0xff0B4003)],
  "${Vegetable.VEGAN.toString()}7": [Color(0xff0B4003), Color(0xff093802)],
  "${Vegetable.VEGAN.toString()}8": [Color(0xff093802), Color(0xff083201)],
  "${Vegetable.VEGAN.toString()}9": [Color(0xff083201), Color(0xff072F00)],
  "${Vegetable.VEGAN.toString()}10": [Color(0xff072F00), Color(0xff062700)],
  "${Vegetable.VEGETARIAN.toString()}1": [Color(0xff798210), Color(0xff767E0F)],
  "${Vegetable.VEGETARIAN.toString()}2": [Color(0xff767E0F), Color(0xff6E770C)],
  "${Vegetable.VEGETARIAN.toString()}3": [Color(0xff6E770C), Color(0xff666F0A)],
  "${Vegetable.VEGETARIAN.toString()}4": [Color(0xff666F0A), Color(0xff5F6609)],
  "${Vegetable.VEGETARIAN.toString()}5": [Color(0xff5F6609), Color(0xff555B07)],
  "${Vegetable.VEGETARIAN.toString()}6": [Color(0xff555B07), Color(0xff4F5504)],
  "${Vegetable.VEGETARIAN.toString()}7": [Color(0xff4F5504), Color(0xff495002)],
  "${Vegetable.VEGETARIAN.toString()}8": [Color(0xff495002), Color(0xff454A02)],
  "${Vegetable.VEGETARIAN.toString()}9": [Color(0xff454A02), Color(0xff216715)],
  "${Vegetable.VEGETARIAN.toString()}10": [
    Color(0xff3D4202),
    Color(0xff083201)
  ],
};

class RecipeGridView extends StatelessWidget {
  final String category;
  final List<Recipe> recipes;
  final int randomCategoryImage;

  const RecipeGridView(
      {this.category,
      @required this.randomCategoryImage,
      @required this.recipes,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recipes.isNotEmpty) {
      return Container(
        color: Color(0xffFEF3E1),
        child: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(category),
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage(
                        '${recipes[randomCategoryImage].imagePreviewPath}'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(12),
            sliver: SliverGrid.extent(
              childAspectRatio: 0.75,
              maxCrossAxisExtent: 300,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: getRecipeCards(recipes),
            ),
          )
        ]),
      );
    }
    return Scaffold(
      backgroundColor: Color(0xffFEF3E1),
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(0, -0.5),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "No recipes under this category",
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'RibeyeMarrow',
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'images/hatWithSpoonFork.png',
              height: 280,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getRecipeCards(List<Recipe> recipes) {
    List<RecipeCard> recipeCards = [];
    for (int i = 0; i < recipes.length; i++) {
      recipeCards.add(
        RecipeCard(
          recipe: recipes[i],
        ),
      );
    }
    return recipeCards;
  }
}

FontWeight itemsFW = FontWeight.w600;

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
                  SizedBox(height: 7),
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
                            fontWeight: FontWeight.w800,
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

class Favorite extends StatefulWidget {
  final Recipe recipe;
  final double iconSize;

  Favorite(this.recipe, {this.iconSize});

  @override
  State<StatefulWidget> createState() => FavoriteState();
}

class FavoriteState extends State<Favorite> {
  bool isFavorite;

  @override
  void initState() {
    isFavorite = widget.recipe.isFavorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: widget.iconSize == null ? 24 : widget.iconSize,
      color: isFavorite ? Colors.pink : Colors.white,
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      onPressed: () {
        if (isFavorite) {
          DBProvider.db.updateFavorite(false, widget.recipe.id).then((_) {
            setState(() {
              widget.recipe.isFavorite = false;
              isFavorite = false;
            });
          });
        } else {
          DBProvider.db.updateFavorite(true, widget.recipe.id).then((_) {
            setState(() {
              widget.recipe.isFavorite = true;
              isFavorite = true;
            });
          });
        }
      },
    );
  }
}
