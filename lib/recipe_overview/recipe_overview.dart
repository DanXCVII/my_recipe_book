import 'package:flutter/material.dart';

import '../database.dart';
import '../recipe.dart';
import './recipe_screen.dart';

class RecipeGridView extends StatelessWidget {
  final String category;

  final Map<String, List<Color>> colors = new Map<String, List<Color>>();

  RecipeGridView({@required this.category}) {
    // TODO: Validate that colors are nice
    colors.addAll({
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
      "${Vegetable.VEGETARIAN.toString()}1": [
        Color(0xff798210),
        Color(0xff767E0F)
      ],
      "${Vegetable.VEGETARIAN.toString()}2": [
        Color(0xff767E0F),
        Color(0xff6E770C)
      ],
      "${Vegetable.VEGETARIAN.toString()}3": [
        Color(0xff6E770C),
        Color(0xff666F0A)
      ],
      "${Vegetable.VEGETARIAN.toString()}4": [
        Color(0xff666F0A),
        Color(0xff5F6609)
      ],
      "${Vegetable.VEGETARIAN.toString()}5": [
        Color(0xff5F6609),
        Color(0xff555B07)
      ],
      "${Vegetable.VEGETARIAN.toString()}6": [
        Color(0xff555B07),
        Color(0xff4F5504)
      ],
      "${Vegetable.VEGETARIAN.toString()}7": [
        Color(0xff4F5504),
        Color(0xff495002)
      ],
      "${Vegetable.VEGETARIAN.toString()}8": [
        Color(0xff495002),
        Color(0xff454A02)
      ],
      "${Vegetable.VEGETARIAN.toString()}9": [
        Color(0xff454A02),
        Color(0xff216715)
      ],
      "${Vegetable.VEGETARIAN.toString()}10": [
        Color(0xff3D4202),
        Color(0xff083201)
      ],
    });
  }

  List<Color> getGradientReciptColors(Recipe recipe) {
    return colors["${recipe.vegetable.toString()}${recipe.complexity}"];
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
      default: return "no valid input at getRecipeTypeImage()";
    }
  }

  Color getRecipeTypeColor(Vegetable vegetable) {
    switch(vegetable) {
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

  Future<List<Widget>> getRecipeCards(
      BuildContext context, double gridTileWidth) async {
    List<Recipe> recipes = await DBProvider.db.getRecipesOfCategory(category);

    List<Widget> output = new List<Widget>();
    for (int i = 0; i < recipes.length; i++) {
      List<Color> recipeColor = getGradientReciptColors(recipes[i]);
      output.add(GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => new RecipeScreen(
                recipe: recipes[i],
                primaryColor: getRecipePrimaryColor(recipes[i]),
              ),
            ),
          );
        },
        child: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(gridTileWidth / 10),
                    topRight: Radius.circular(gridTileWidth / 10),
                    bottomRight: Radius.circular(gridTileWidth / 10),
                    bottomLeft: Radius.circular(gridTileWidth / 2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                        tag: "${recipes[i].imagePath}",
                        child: Material(
                          color: Colors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(gridTileWidth / 10),
                              topRight: Radius.circular(gridTileWidth / 10),
                            ),
                            child: Image.asset(
                              await PathProvider.pP
                                  .getRecipePath(recipes[i].id),
                              fit: BoxFit.cover,
                              height: gridTileWidth / 1.2,
                              width: gridTileWidth + 40,
                            ),
                          ),
                        )),
                    SizedBox(height: 7),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 12),
                      child: Hero(
                        tag: "recipe-${recipes[i].id}",
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            "${recipes[i].name}",
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
                      padding: EdgeInsets.only(left: gridTileWidth / 3 + 13),
                      child: Text(
                        "1h 20min",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 10 + gridTileWidth / 40,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: gridTileWidth / 3 + 13),
                      child: Text(
                        "10 ingredients",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 10 + gridTileWidth / 40,
                        ),
                      ),
                    )
                  ],
                )),
            Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  child: Center(
                    child: Image.asset(
                      "images/${getRecipeTypeImage(recipes[i].vegetable)}.png",
                      height: 35,
                      width: 35,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  height: gridTileWidth / 3,
                  width: gridTileWidth / 3,
                  decoration: BoxDecoration(
                    color: getRecipeTypeColor(recipes[i].vegetable),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(gridTileWidth / 2),
                      topRight: Radius.circular(gridTileWidth / 4),
                      bottomLeft: Radius.circular(gridTileWidth / 2),
                      bottomRight: Radius.circular(gridTileWidth / 2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 2.0, // default 20.0
                        spreadRadius: 1.0, // default 5.0
                        offset: Offset(0.0, 1.5),
                      ),
                    ],
                  ),
                )),
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
      ));
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double gridTileWidth = deviceWidth / (deviceWidth / 300.floor() + 1);
    return Scaffold(
      // backgroundColor: Color(0xff959595),
      appBar: AppBar(
        title: Hero(
            tag: "category-$category",
            child: Material(
              color: Colors.transparent,
              child: Text(
                "$category",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            )),
      ),
      body: FutureBuilder<List<Widget>>(
        future: getRecipeCards(context, gridTileWidth),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.extent(
              childAspectRatio: 0.75,
              maxCrossAxisExtent: 300,
              padding: const EdgeInsets.all(
                  12), // TODO: maybe remove, also the spacing
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: snapshot.data,
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
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
