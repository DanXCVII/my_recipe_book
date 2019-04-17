import 'package:flutter/material.dart';

import '../database.dart';
import '../recipe.dart';
import './recipe_screen.dart';

class RecipeGridView extends StatelessWidget {
  final String category;

  final Map<String, List<Color>> colors = new Map<String, List<Color>>();

  RecipeGridView({@required this.category}) {
    // TODO: Add colors....
    colors.addAll({
      "${Vegetable.NON_VEGETARIAN.toString()}1": [
        Color(0xffef6c00),
        Color(0xffA40101)
      ],
      "${Vegetable.NON_VEGETARIAN.toString()}2": [
        Colors.deepOrange[450],
        Color(0xffA40101)
      ],
      "${Vegetable.NON_VEGETARIAN.toString()}3": [
        Colors.deepOrange[500],
        Color(0xffC13C3C)
      ],
      "${Vegetable.NON_VEGETARIAN.toString()}4": [
        Colors.deepOrange[550],
        Color(0xffD44444)
      ],
      "${Vegetable.NON_VEGETARIAN.toString()}5": [
        Colors.deepOrange[600],
        Color(0xffE14D4D)
      ],
      "${Vegetable.NON_VEGETARIAN.toString()}6": [
        Colors.deepOrange[650],
        Color(0xffEA5050)
      ],
      "${Vegetable.NON_VEGETARIAN.toString()}7": [
        Colors.deepOrange[700],
        Color(0xffF05252)
      ],
      "${Vegetable.NON_VEGETARIAN.toString()}8": [
        Colors.deepOrange[750],
        Color(0xffF65A5A)
      ],
      "${Vegetable.NON_VEGETARIAN.toString()}9": [
        Color(0xffd84315),
        Color(0xffFC6161)
      ],
      "${Vegetable.NON_VEGETARIAN.toString()}10": [
        Color(0xffbf360c),
        Color(0xffFB6A6A)
      ],
      "${Vegetable.VEGETARIAN.toString()}1": [
        Colors.deepOrange[400],
        Colors.red[450]
      ],
      "${Vegetable.VEGETARIAN.toString()}2": [
        Colors.deepOrange[450],
        Colors.red[500]
      ],
      "${Vegetable.VEGETARIAN.toString()}3": [
        Colors.deepOrange[500],
        Colors.red[550]
      ],
      "${Vegetable.VEGETARIAN.toString()}4": [
        Colors.deepOrange[550],
        Colors.red[600]
      ],
      "${Vegetable.VEGETARIAN.toString()}5": [
        Colors.deepOrange[600],
        Colors.red[650]
      ],
      "${Vegetable.VEGETARIAN.toString()}6": [
        Colors.deepOrange[650],
        Colors.red[700]
      ],
      "${Vegetable.VEGETARIAN.toString()}7": [
        Colors.deepOrange[700],
        Colors.red[750]
      ],
      "${Vegetable.VEGETARIAN.toString()}8": [
        Colors.deepOrange[750],
        Colors.red[800]
      ],
      "${Vegetable.VEGETARIAN.toString()}9": [
        Colors.deepOrange[800],
        Colors.red[850]
      ],
      "${Vegetable.VEGETARIAN.toString()}10": [
        Colors.deepOrange[850],
        Colors.red[900]
      ],
      "${Vegetable.VEGAN.toString()}1": [
        Colors.deepOrange[400],
        Colors.red[450]
      ],
      "${Vegetable.VEGAN.toString()}2": [
        Colors.deepOrange[450],
        Colors.red[500]
      ],
      "${Vegetable.VEGAN.toString()}3": [
        Colors.deepOrange[500],
        Colors.red[550]
      ],
      "${Vegetable.VEGAN.toString()}4": [
        Colors.deepOrange[550],
        Colors.red[600]
      ],
      "${Vegetable.VEGAN.toString()}5": [
        Colors.deepOrange[600],
        Colors.red[650]
      ],
      "${Vegetable.VEGAN.toString()}6": [
        Colors.deepOrange[650],
        Colors.red[700]
      ],
      "${Vegetable.VEGAN.toString()}7": [
        Colors.deepOrange[700],
        Colors.red[750]
      ],
      "${Vegetable.VEGAN.toString()}8": [
        Colors.deepOrange[750],
        Colors.red[800]
      ],
      "${Vegetable.VEGAN.toString()}9": [
        Colors.deepOrange[800],
        Colors.red[850]
      ],
      "${Vegetable.VEGAN.toString()}10": [
        Colors.deepOrange[850],
        Colors.red[900]
      ],
    });
  }

  List<Color> getGradientReciptColors(Recipe recipe) {
    return colors["${recipe.vegetable.toString()}${recipe.complexity}"];
  }

  Future<List<Widget>> getRecipeCards(BuildContext context) async {
    List<Recipe> recipes = await DBProvider.db.getRecipesOfCategory(category);

    List<Widget> output = new List<Widget>();
    for (int i = 0; i < recipes.length; i++) {
      output.add(GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new RecipeScreen(recipe: recipes[i])));
        },
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 32),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepOrange[600],
                      Colors.red[600]
                    ], // 400, 500
                    begin: FractionalOffset.topLeft,
                    end: FractionalOffset.bottomRight,
                    stops: [0.0, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      // Shadow of the RecipeCard
                      color: Colors.red[900],
                      blurRadius: 5.0, // default 20.0
                      spreadRadius: 1.5, // default 5.0
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(22, 32, 22, 0),
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
                                      color: Colors.white),
                                ),
                              ),
                            )),
                        SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 4),
                          child: Divider(color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: 75,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text("total time:",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    Expanded(
                                      child: Text("ingredients:",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    Expanded(
                                      child: Text("complexity:",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    )
                                  ]),
                            ),
                            Container(
                              height: 75,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    child: Text("120",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  Expanded(
                                      child: Text("8",
                                          style:
                                              TextStyle(color: Colors.white))),
                                  Expanded(
                                      child: Text("7",
                                          style:
                                              TextStyle(color: Colors.white))),
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
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2.0),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Align(
              alignment: Alignment(1.05, -0.6),
              child: Favorite(recipes[i], iconSize: 22,),
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
    return Scaffold(
      // backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Hero(
            tag: "$category",
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
        future: getRecipeCards(context),
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
