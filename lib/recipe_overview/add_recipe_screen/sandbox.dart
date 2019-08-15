import 'package:image/image.dart' as IO;
import 'dart:io';
 import 'package:flutter/material.dart';

 //this is just a class for random testing purposes ;)

void test(File image) {
    IO.Image i = IO.decodeImage(new File('test.webp').readAsBytesSync());

}

/*
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recipe>>(
        future: category != null
            ? DBProvider.db.getRecipesOfCategory(category.name)
            : DBProvider.db.getRecipesOfNoCategory(),
        builder: (context, recipelistF) {
          if (recipelistF.hasData) {
            if (recipelistF.data.isEmpty) {
              return Container();
            }
            Random randomRecipe = new Random();
            return Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (BuildContext context) => new RecipeGridView(
                            category: category == null
                                ? 'no category'
                                : category.name,
                            randomCategoryImage: recipelistF.data.length != 1
                                ? randomRecipe.nextInt(recipelistF.data.length)
                                : 0,
                            recipes: recipelistF.data,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 12.0, bottom: 10.0, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            category != null ? category.name : 'no category',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                ),
                RecipeHozizontalList(
                  recipes: recipelistF.data,
                  categoryName:
                      category == null ? 'no category' : category.name,
                )
              ],
            );
          }
          return Container(
            height: 178,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}


///////////////////
///

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:math';

import '../database.dart';
import '../recipe.dart';
import './recipe_screen.dart';
import './recipe_overview.dart';

// Builds the Rows of all the categories
class RecipeCategoryOverview extends StatefulWidget {
  RecipeCategoryOverview({Key key}) : super(key: key);

  _RecipeCategoryOverviewState createState() => _RecipeCategoryOverviewState();
}

class _RecipeCategoryOverviewState extends State<RecipeCategoryOverview>
    with AutomaticKeepAliveClientMixin {
  bool keepAlive = true;

  @override
  bool get wantKeepAlive => keepAlive;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecipeCategory>>(
        future: DBProvider.db.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<RecipeCategory> categoryNames = snapshot.data;
            return ListView.builder(
                itemCount: categoryNames.length + 1,
                itemBuilder: (context, index) {
                  if (index == categoryNames.length) {
                    return FutureBuilder<List<Recipe>>(
                      future: DBProvider.db.getRecipesOfNoCategory(),
                      builder: (context, recipelistF) {
                        if (recipelistF.hasData) {
                          if (recipelistF.data.isEmpty) {
                            return Container();
                          }return RecipeRow(category: null, recipeList: recipelistF.data,);
                        }
                        return Container(
                          height: 178,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      });
                  }
                  return FutureBuilder<List<Recipe>>(
                      future: categoryNames[index] != null
                          ? DBProvider.db
                              .getRecipesOfCategory(categoryNames[index].name)
                          : DBProvider.db.getRecipesOfNoCategory(),
                      builder: (context, recipelistF) {
                        if (recipelistF.hasData) {
                          if (recipelistF.data.isEmpty) {
                            return Container();
                          }return RecipeRow(category: categoryNames[index], recipeList: recipelistF.data,);
                        }
                        return Container(
                          height: 178,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      });
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

/// Builds a Row with the CategoryName and underneath a horizontally
/// scrollable "List" of kinda circles with the recipes of that category
class RecipeRow extends StatelessWidget {
  final RecipeCategory category;
  final List<Recipe> recipeList;

  const RecipeRow({this.category, this.recipeList, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Random randomRecipe = new Random();
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context) => new RecipeGridView(
                    category: category == null ? 'no category' : category.name,
                    randomCategoryImage: recipeList.length != 1
                        ? randomRecipe.nextInt(recipeList.length)
                        : 0,
                    recipes: recipeList,
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
                    category != null ? category.name : 'no category',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        ),
        RecipeHozizontalList(
          recipes: recipeList,
          categoryName: category == null ? 'no category' : category.name,
        )
      ],
    );
  }
}

// List of Recipes in a horizontal order with icons as a symbol and unterneath the name
class RecipeHozizontalList extends StatelessWidget {
  final List<Recipe> recipes;
  final String categoryName;

  const RecipeHozizontalList(
      {@required this.categoryName, this.recipes, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Random randomRecipe = new Random();
    if (recipes.isEmpty) {
      return Container();
    }
    int recipeCount;
    if (recipes.length >= 10) {
      recipeCount = 10;
    }
    recipeCount = recipes.length;

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
                '${recipes[index].id}$categoryName${recipes[index].imagePath}';
            print(heroTag);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => new RecipeScreen(
                      recipe: recipes[index],
                      primaryColor: getRecipePrimaryColor(recipes[index]),
                      heroImageTag: heroTag,
                    ),
                  ),
                );
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
                              image:
                                  AssetImage(recipes[index].imagePreviewPath),
                              fadeInDuration: const Duration(milliseconds: 250),
                              placeholder: MemoryImage(kTransparentImage),
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4, left: 10, right: 10),
                        child: Text(recipes[index].name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(fontWeight: FontWeight.w700)),
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
                          category: categoryName == null
                              ? 'no category'
                              : categoryName,
                          randomCategoryImage: recipes.length != 1
                              ? randomRecipe.nextInt(recipes.length)
                              : 0,
                          recipes: recipes),
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

class CategoryGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: getCategoryCards(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.extent(
            maxCrossAxisExtent: 300,
            padding: const EdgeInsets.all(4),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: snapshot.data,
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<List<RecipeCategory>> getCategoryNames() async {
    return await DBProvider.db.getCategories();

    // await DBProvider.db.getRecipesOfCategory(category)
  }

  Future<List<Widget>> getCategoryCards(BuildContext context) async {
    List<RecipeCategory> categories = await DBProvider.db.getCategories();

    List<Widget> output = new List<Widget>();
    for (int i = 0; i < categories.length; i++) {
      output.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => new RecipeGridView(
                          category: categories[i].name,
                        )));
          },
          child: GridTile(
            child: Image.asset(
              '${await PathProvider.pP.getCategoryPath(categories[i].name)}',
              fit: BoxFit.cover,
            ),
            footer: GridTileBar(
              title: Hero(
                  tag: "category-${categories[i]}",
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      "${categories[i]}",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              backgroundColor: Colors.black45,
            ),
          ),
        ),
      );
    }
    return output;
  }
}

List<Widget> createDummyCategoryCards() {
  return [
    GridTile(
      child: Image.asset(
        'images/noodle.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("noodles"),
        backgroundColor: Colors.black45,
      ),
    ),
    GridTile(
      child: Image.asset(
        'images/salat.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("salat"),
        backgroundColor: Colors.black45,
      ),
    ),
    GridTile(
      child: Image.asset(
        'images/breakfast.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("breakfast"),
        backgroundColor: Colors.black45,
      ),
    ),
    GridTile(
      child: Image.asset(
        'images/meat.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("meat"),
        backgroundColor: Colors.black45,
      ),
    ),
    GridTile(
      child: Image.asset(
        'images/vegetables.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("vegan"),
        backgroundColor: Colors.black45,
      ),
    ),
    GridTile(
      child: Image.asset(
        'images/rice.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("rice"),
        backgroundColor: Colors.black45,
      ),
    )
  ];
}

class RecipeSearch extends SearchDelegate<SearchRecipe> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return null;
  }
}
*/
    








    //RECIPECARD

    /*
    class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final Color recipeColor;
  const RecipeCard({this.recipe, this.recipeColor, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                color: recipeColor == null ? Color(0xffDFDBD6) : recipeColor,
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
                            height: gridTileWidth / 1.2,
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
                    padding: EdgeInsets.only(left: gridTileWidth / 3 + 13),
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        getTimeHoursMinutes(recipe.totalTime),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 10 + gridTileWidth / 40,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: gridTileWidth / 3 + 13),
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        "${getIngredientCount(recipe.ingredients)} ingredients",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 10 + gridTileWidth / 40,
                        ),
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
                    "images/${getRecipeTypeImage(recipe.vegetable)}.png",
                    height: 35,
                    width: 35,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                height: gridTileWidth / 3,
                width: gridTileWidth / 3,
                decoration: BoxDecoration(
                  color: getRecipeTypeColor(recipe.vegetable),
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
}*/