import 'package:flutter/material.dart';
import 'package:my_recipe_book/database.dart';

import '../recipe.dart';
import './recipe_overview.dart' show Favorite;
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import './add_recipe_screen/add_recipe.dart' show AddRecipeForm;

const double timeTextsize = 15;
const double timeText = 17;
const double paddingBottomTime = 5;
const double headingSize = 20;
const Color textColor = Colors.white;

class RecipeScreen extends StatelessWidget {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  final Recipe recipe;
  final Color primaryColor;

  RecipeScreen({@required this.recipe, @required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
              backgroundColor: primaryColor,
              actions: <Widget>[
                Favorite(recipe),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new AddRecipeForm(editRecipe: recipe)));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    DBProvider.db.deleteRecipe(recipe).then((_) {
                      Navigator.pop(context);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {},
                ),
              ],
              floating: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                recipe.name,
                style: TextStyle(
                  fontSize: 18.0,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ))),
          SliverList(
              delegate: SliverChildListDelegate(<Widget>[
            GestureDetector(
              onTap: () {
                _showPictureFullView(recipe.imagePath,
                    "${recipe.imagePath}${recipe.id}", context);
              },
              child: Hero(
                tag: "${recipe.imagePath}",
                child: Material(
                  color: Colors.transparent,
                  child: ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                        height: 270,
                        child:
                            Image.asset(recipe.imagePath, fit: BoxFit.cover)),
                  ),
                ),
              ),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.15,
                        0,
                        MediaQuery.of(context).size.width * 0.15,
                        0),
                    child: Hero(
                        tag: "recipe-${recipe.id}",
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            "${recipe.name}",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: textColor, fontSize: 26),
                          ),
                        )))),
            SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      AnimatedCircularChart(
                        key: _chartKey,
                        size: Size(120, 120),
                        initialChartData: <CircularStackEntry>[
                          new CircularStackEntry(
                            <CircularSegmentEntry>[
                              new CircularSegmentEntry(
                                recipe.cookingTime /
                                    (recipe.preperationTime +
                                        recipe.cookingTime),
                                Colors.blue[700],
                                rankKey: 'completed',
                              ),
                              new CircularSegmentEntry(
                                recipe.preperationTime /
                                    (recipe.preperationTime +
                                        recipe.cookingTime),
                                Colors.green[500],
                                rankKey: 'remaining',
                              ),
                            ],
                            rankKey: 'progress',
                          ),
                        ],
                        edgeStyle: SegmentEdgeStyle.round,
                        chartType: CircularChartType.Radial,
                        percentageValues: false,
                        /*holeLabel: '1/3',
                        edgeStyle: SegmentEdgeStyle.round,
                        labelStyle: new TextStyle(
                          color: Colors.blueGrey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),*/
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green[500])),
                                  Text(
                                    " prep. time: ",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue[700])),
                                  Text(
                                    " cooking time: ",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text("${recipe.preperationTime} min",
                                  style: TextStyle(color: Colors.white)),
                              Text(
                                "${recipe.cookingTime} min",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text("complexity:",
                          style: TextStyle(fontSize: 15, color: textColor)),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Container(
                            height: 120,
                            child: Image.asset(
                                "images/${_getImageComplexity(recipe.complexity.round())}.png")),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 30),
            IngredientsScreen(recipe),
            SizedBox(height: 30),
            FutureBuilder<List<List<String>>>(
              future: PathProvider.pP
                  .getRecipeStepPreviewPathList(recipe.steps.length, recipe.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return StepsScreen(recipe, snapshot.data);
                }
                return Container(
                  height: 70,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
            Container(
              height: 20,
              decoration: BoxDecoration(color: Colors.black87),
            ),
            BottomScreen(recipe),
          ]))
        ]));
  }
}

String _getImageComplexity(int complexity) {
  switch (complexity) {
    case 1:
      return "termoOne";
    case 2:
      return "termoTwo";
    case 3:
      return "termoThree";
    case 4:
      return "termoFour";
    case 5:
      return "termoFive";
    case 6:
      return "termoSix";
    case 7:
      return "termoSeven";
    case 8:
      return "termoEight";
    case 9:
      return "termoNine";
    case 10:
      return "termoTen";
  }
  return "";
}

void _showPictureFullView(String image, String tag, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
          appBar: AppBar(),
          backgroundColor: Colors.black54,
          body: Center(
            child: Hero(tag: tag, child: Image.asset(image)),
          ))));
}

class BottomScreen extends StatelessWidget {
  final Recipe currentRecipe;

  BottomScreen(this.currentRecipe);

  Future<Wrap> getCategories() async {
    Wrap output = new Wrap(
      children: <Widget>[],
      runSpacing: 10.0,
      spacing: 10.0,
    );
    for (int i = 0; i < currentRecipe.categories.length; i++) {
      output.children.add(ClipOval(
        child: Stack(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              child: Image.asset(
                await PathProvider.pP
                    .getCategoryPath(currentRecipe.categories[i]),
                fit: BoxFit.cover,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.4)),
                width: 100,
                height: 40,
                child: Center(
                  child: Text(
                    "${currentRecipe.categories[i]}",
                    style: TextStyle(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
          ],
        ),
      ));
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    Column output = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    );
    if (currentRecipe.notes != "") {
      output.children.addAll([
        Text(
          "Notes",
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontFamily: "Questrial-Regular",
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              currentRecipe.notes,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ))
      ]);
    }

    output.children.addAll([
      Text(
        "Categories",
        style: TextStyle(
          color: textColor,
          fontSize: 24,
          fontFamily: "Questrial-Regular",
        ),
      ),
      FutureBuilder<Wrap>(
          future: getCategories(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: snapshot.data,
              );
            }
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(child: CircularProgressIndicator()),
            );
          })
    ]);

    return (Container(
      color: Color(0xff51473b),
      child: Padding(
          padding: const EdgeInsets.only(left: 30, top: 30, bottom: 30),
          child: output),
    ));
  }
}

class StepsScreen extends StatelessWidget {
  final List<List<String>> stepImages;

  final List<Color> stepsColors = [
    Color(0xff28B404),
    Color(0xff009BDE),
    Color(0xffE3B614),
    Color(0xff8600C5),
  ];
  final Recipe currentRecipe;

  StepsScreen(this.currentRecipe, this.stepImages);

  List<Widget> getSteps(BuildContext context) {
    List<Widget> output = new List<Widget>();

    for (int i = 0; i < currentRecipe.steps.length; i++) {
      output.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Stack(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 0, top: 20),
                  child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: stepsColors[i % (stepsColors.length)])),
                ),
                Text("${i + 1}.",
                    style: TextStyle(color: Colors.white, fontSize: 54))
              ]),
            ),
            Container(
              padding: EdgeInsets.only(top: 30),
              width: MediaQuery.of(context).size.width - 100,
              child: Text(
                currentRecipe.steps[i],
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ),
      );
      Wrap stepPics = new Wrap(
        runSpacing: 10,
        spacing: 10,
        children: <Widget>[],
      );
      for (int j = 0; j < stepImages[i].length; j++) {
        stepPics.children.add(GestureDetector(
          onTap: () {
            _showPictureFullView(stepImages[i][j], "Schritt$i:$j", context);
          },
          child: Hero(
            tag: "Schritt$i:$j",
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                  width: 100,
                  height: 80,
                  child: Image.asset(
                    stepImages[i][j],
                    fit: BoxFit.cover,
                  )),
            ),
          ),
        ));

        if (j == stepImages[i].length - 1) {
          output.add(Padding(
            padding: const EdgeInsets.only(left: 80, right: 20, top: 20),
            child: stepPics,
          ));
        }
      }
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    if (currentRecipe.steps.isEmpty) return Container();
    Column output = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            height: 40,
            decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.3)),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Directions",
                        style: TextStyle(
                          color: textColor,
                          fontSize: headingSize,
                          fontFamily: "Questrial-Regular",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        SizedBox(height: 25),
      ],
    );
    output.children.addAll(getSteps(context));
    output.children.add(SizedBox(height: 25));
    return Container(color: Color(0xff432D0D), child: output);
  }
}

class IngredientsScreen extends StatefulWidget {
  final Recipe currentRecipe;

  IngredientsScreen(this.currentRecipe);

  @override
  State<StatefulWidget> createState() =>
      IngredientsScreenState(currentRecipe.servings);
}

class IngredientsScreenState extends State<IngredientsScreen> {
  double servings;
  List<String> saved = new List<String>();

  IngredientsScreenState(this.servings);

  List<Widget> getIngredientsSection(int sectionNumber) {
    List<Widget> output = new List<Widget>();
    output.add(
      SizedBox(
        height: 15,
      ),
    );
    for (int i = 0;
        i < widget.currentRecipe.ingredientsList[sectionNumber].length;
        i++) {
      double ingredientAmount = widget.currentRecipe.amount[sectionNumber][i] /
          widget.currentRecipe.servings *
          servings;
      String ingredientName =
          "${widget.currentRecipe.ingredientsList[sectionNumber][i]}";
      String ingredientUnit = widget.currentRecipe.unit[sectionNumber][i];
      output.add(
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: saved.contains(ingredientName) ||
                          saved.contains('<all>') ||
                          saved.contains('section$sectionNumber')
                      ? Icon(Icons.check_circle)
                      : Icon(Icons.add_circle_outline),
                  onPressed: () {
                    if (!saved.contains(ingredientName) &&
                        !saved.contains('<all>') &&
                        !saved.contains('section$sectionNumber')) {
                      DBProvider.db.addToShoppingList([ingredientName],
                          [ingredientAmount], [ingredientUnit]).then((_) {
                        setState(() {
                          saved = this.saved;
                          saved.add(ingredientName);
                        });
                      });
                    }
                  },
                  color: saved.contains(ingredientName) ||
                          saved.contains('<all>') ||
                          saved.contains('section$sectionNumber')
                      ? Colors.green
                      : Colors.white),
              Text(
                ingredientName,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Spacer(),
              Text(
                "$ingredientAmount $ingredientUnit",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }
    return output;
  }

  List<Widget> getIngredientsData() {
    List<Widget> output = new List<Widget>();

    for (int i = 0; i < widget.currentRecipe.ingredientsGlossary.length; i++) {
      if (widget.currentRecipe.ingredientsGlossary[i] != "") {
        output.add(
          Padding(
            padding: EdgeInsets.only(top: 30, left: 45, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("${widget.currentRecipe.ingredientsGlossary[i]}",
                    style: TextStyle(color: textColor, fontSize: 24)),
                IconButton(
                  icon: saved.contains("section$i") || saved.contains('<all>')
                      ? Icon(Icons.shopping_cart)
                      : Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    if (!saved.contains("section$i") &&
                        !saved.contains('<all>')) {
                      DBProvider.db
                          .addToShoppingList(
                              widget.currentRecipe.ingredientsList[i],
                              widget.currentRecipe.amount[i],
                              widget.currentRecipe.unit[i])
                          .then((_) {
                        setState(() {
                          saved = this.saved;
                          saved.add("section$i");
                        });
                      });
                    }
                  },
                  color: saved.contains("section$i") || saved.contains('<all>')
                      ? Colors.green
                      : textColor,
                )
              ],
            ),
          ),
        );
      }
      output.addAll(getIngredientsSection(i));
    }

    return output;
  }

  List<double> doubleListListToSingleList(List<List<double>> listList) {
    List<double> singleList = [];

    for (int i = 0; i < listList.length; i++) {
      singleList.addAll(listList[i]);
    }
    return singleList;
  }

  List<String> stringListListToSingleList(List<List<String>> listList) {
    List<String> singleList = [];

    for (int i = 0; i < listList.length; i++) {
      singleList.addAll(listList[i]);
    }
    return singleList;
  }

  @override
  void initState() {
    servings = widget.currentRecipe.servings;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentRecipe.ingredientsList.isEmpty) return Container();
    Column output = Column(
      children: <Widget>[
        Container(
            height: 40,
            decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.3)),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Ingredients for $servings servings",
                        style: TextStyle(
                          color: textColor,
                          fontSize: headingSize,
                          fontFamily: "Questrial-Regular",
                        ),
                      ),
                      IconButton(
                        icon: !saved.contains('<all>')
                            ? Icon(Icons.add_shopping_cart)
                            : Icon(Icons.shopping_cart),
                        color:
                            !saved.contains('<all>') ? textColor : Colors.green,
                        onPressed: () {
                          if (!saved.contains('<all>')) {
                            DBProvider.db
                                .addToShoppingList(
                                    stringListListToSingleList(
                                        widget.currentRecipe.ingredientsList),
                                    doubleListListToSingleList(
                                        widget.currentRecipe.amount),
                                    stringListListToSingleList(
                                        widget.currentRecipe.unit))
                                .then((_) {
                              setState(() {
                                saved = this.saved;
                                saved.add('<all>');
                              });
                            });
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
    output.children.addAll(getIngredientsData());
    return output;
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, 200);
    path.quadraticBezierTo(size.width / 4, 250, size.width / 2, 250);
    path.quadraticBezierTo(size.width / 4 * 3, 250, size.width, 200);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
