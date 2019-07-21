import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../database.dart';
import '../recipe.dart';
import './recipe_screen.dart';
import './recipe_overview.dart';

class RCategoryOverview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RCategoryOverviewState();
}

class _RCategoryOverviewState extends State<RCategoryOverview> {
  List<String> categories;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: DBProvider.db.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> categoryNames = snapshot.data;
            return ListView.builder(
              itemCount: snapshot.data.length * 2,
              itemBuilder: (context, index) {
                if (index % 2 == 0) {
                  print("hellooooo");
                  print((index.toDouble() ~/ 2) + 1);
                  print("hellooooo");

                  return Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (BuildContext context) => new RecipeGridView(
                                category:
                                    "${snapshot.data[index.toDouble() ~/ 2]}"),
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
                              snapshot.data[index.toDouble() ~/ 2],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20),
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return FutureBuilder<List<Recipe>>(
                    future: DBProvider.db
                        .getRecipesOfCategory(categoryNames[index ~/ 2]),
                    builder: (context, recipelistF) {
                      if (recipelistF.hasData) {
                        if (recipelistF.data.isEmpty) {
                          return Container();
                        }
                        int recipeCount;
                        if (recipelistF.data.length >= 10) {
                          recipeCount = 10;
                        }
                        recipeCount = recipelistF.data.length;

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
                                print(recipelistF.data[index].imagePath);
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new RecipeScreen(
                                          recipe: recipelistF.data[index],
                                          primaryColor: getRecipePrimaryColor(
                                              recipelistF.data[index]),
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
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(35),
                                                topRight: Radius.circular(15),
                                                bottomLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(35)),
                                            child: Image.asset(
                                              recipelistF.data[index].imagePath,
                                              height: 90,
                                              width: 90,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          //  ),
                                          //),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 4, left: 10, right: 10),
                                              child: Text(
                                                  recipelistF.data[index].name,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: new TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700))),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, bottom: 40, right: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (BuildContext context) =>
                                                  new RecipeGridView(
                                                      category:
                                                          "${snapshot.data[index.toDouble() ~/ 2]}"),
                                            ));
                                      },
                                      child: Container(
                                        height: 90,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 2),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(35),
                                            topRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(35),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 45,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ));
                              }
                            },
                          ),
                        );
                      }
                      return Container(
                        height: 130,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    });
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
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

  Future<List<String>> getCategoryNames() async {
    return await DBProvider.db.getCategories();

    // await DBProvider.db.getRecipesOfCategory(category)
  }

  Future<List<Widget>> getCategoryCards(BuildContext context) async {
    List<String> categories = await DBProvider.db.getCategories();

    List<Widget> output = new List<Widget>();
    for (int i = 0; i < categories.length; i++) {
      output.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new RecipeGridView(category: "${categories[i]}")));
          },
          child: GridTile(
            child: Image.asset(
              '${await PathProvider.pP.getCategoryPath(categories[i])}',
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
