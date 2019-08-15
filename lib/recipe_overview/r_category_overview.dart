import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:math';

import '../database.dart';
import '../recipe.dart';
import './recipe_screen.dart';
import './recipe_overview.dart';

class RecipeCategoryOverview extends StatefulWidget {
  RecipeCategoryOverview({Key key}) : super(key: key);

  _RecipeCategoryOverviewState createState() => _RecipeCategoryOverviewState();
}

// Builds the Rows of all the categories

class _RecipeCategoryOverviewState extends State<RecipeCategoryOverview>
    with AutomaticKeepAliveClientMixin<RecipeCategoryOverview> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    print('initState()');
    super.initState();
  }

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
                  return FutureBuilder<List<Recipe>>(
                      future: index != categoryNames.length
                          ? DBProvider.db
                              .getRecipesOfCategory(categoryNames[index].name)
                          : DBProvider.db.getRecipesOfNoCategory(),
                      builder: (context, recipelistF) {
                        if (recipelistF.hasData) {
                          return RecipeRow(
                            recipes: recipelistF.data,
                            category: index == categoryNames.length
                                ? null
                                : categoryNames[index],
                          );
                        }
                        return CircularProgressIndicator();
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
  final List<Recipe> recipes;

  const RecipeRow({this.recipes, this.category, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Random r = new Random();
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
                    randomCategoryImage: recipes.length != 1
                        ? r.nextInt(recipes.length > 0 ? recipes.length : 1)
                        : 0,
                    recipes: recipes,
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
          recipes: recipes,
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
  final List<String> recipeNames;

  RecipeSearch(this.recipeNames);

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
    if (recipeNames.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    final results = recipeNames.where(
        (recipeName) => recipeName.toLowerCase().contains(query.toLowerCase()));
    return ListView.builder(
        itemCount: recipeNames.length * 2,
        itemBuilder: (context, index) {
          if ((index - 1) % 2 == 0 && index != 0) {
            return Divider();
          }
          return ListTile(
            title: Text(recipeNames[index ~/ 2]),
            onTap: () {
              DBProvider.db
                  .getRecipeByName(recipeNames[index ~/ 2])
                  .then((recipe) {
                close(context, null);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => new RecipeScreen(
                      recipe: recipe,
                      primaryColor: getRecipePrimaryColor(recipe),
                      heroImageTag: 'heroTag',
                    ),
                  ),
                );
              });
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
