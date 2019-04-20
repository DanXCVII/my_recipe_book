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

  Color getRecipePrimaryColor(Recipe recipe) {
    switch(recipe.vegetable) {
      case Vegetable.NON_VEGETARIAN:
      return Color(0xff4D0B06);
      case Vegetable.VEGAN:
      return Color(0xff133F12);
      case Vegetable.VEGETARIAN:
      return Color(0xff074505);
    }
  }

  List<Color> getGradientReciptColors(Recipe recipe) {
    return colors["${recipe.vegetable.toString()}${recipe.complexity}"];
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
                      )));
        },
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: gridTileWidth / 5),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: recipeColor, // 400, 500
                    begin: FractionalOffset.topLeft,
                    end: FractionalOffset.bottomRight,
                    stops: [0.0, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(gridTileWidth / 8),
                  boxShadow: [
                    BoxShadow(
                      // Shadow of the RecipeCard
                      color: recipeColor[0],
                      blurRadius: 5.0, // default 20.0
                      spreadRadius: 1.5, // default 5.0
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(22, gridTileWidth / 4, 22, 0),
                    child: Column(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topCenter,
                            child: Hero(
                              tag: "recipe-${recipes[i].id}",
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  "${recipes[i].name}",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14 + gridTileWidth / 50,
                                      color: Colors.white),
                                ),
                              ),
                            )),
                        SizedBox(height: 2),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 4),
                          child: Divider(color: Colors.white),
                        ),
                        SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: gridTileWidth / 3,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text("total time:",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12 + gridTileWidth / 50,
                                          )),
                                    ),
                                    Expanded(
                                      child: Text("ingredients:",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12 + gridTileWidth / 50,
                                          )),
                                    ),
                                    Expanded(
                                      child: Text("complexity:",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12 + gridTileWidth / 50,
                                          )),
                                    )
                                  ]),
                            ),
                            Container(
                              height: gridTileWidth / 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    child: Text("120",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12 + gridTileWidth / 50,
                                        )),
                                  ),
                                  Expanded(
                                      child: Text("8",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12 + gridTileWidth / 50,
                                          ))),
                                  Expanded(
                                      child: Text("7",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12 + gridTileWidth / 50,
                                          ))),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: Hero(
                    tag: "${recipes[i].image}",
                    child: Material(
                      color: Colors.transparent,
                      child: ClipOval(
                        child: Image.file(
                          recipes[i].image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
                width: (gridTileWidth / 5) * 2,
                height: (gridTileWidth / 5) * 2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2.0),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: gridTileWidth / 1.25, top: gridTileWidth / 5.6),
              child: Favorite(
                recipes[i],
                iconSize: 22,
              ),
            )
          ],
        ),
      )

          /*GridTile(
          child: Image.file(
            recipes[i].image,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            title: Text("${recipes[i].name}"),
            subtitle: Text(
                "steps: ${recipes[i].steps.length}, total time: ${recipes[i].totalTime}"),
            trailing: Favorite(recipes[i]),
            backgroundColor: Colors.black45,
          ),
        ),*/
          );
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
