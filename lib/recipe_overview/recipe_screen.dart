import 'package:flutter/material.dart';
import '../recipe.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

const double timeTextsize = 15;
const double timeText = 17;
const double paddingBottomTime = 5;
const double headingSize = 20;
const Color textColor = Colors.white;

class RecipeScreen extends StatelessWidget {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  final Recipe recipe;

  RecipeScreen({@required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF4B1313),
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Hero(
                    tag: recipe.name,
                    child: Material(
                        color: Colors.transparent,
                        child: Text(
                          "${recipe.name}",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )))),
          ),
          SliverList(
              delegate: SliverChildListDelegate(<Widget>[
            Hero(
              tag: "${recipe.image}",
              child: Material(
                color: Colors.transparent,
                child: ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                      height: 270,
                      child: Image.file(recipe.image, fit: BoxFit.cover)),
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
                  child: Text(
                    "${recipe.name}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 36,
                        fontFamily: "Questrial-Regular",
                        fontWeight: FontWeight.w400),
                  ),
                )),
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
                                recipe.preperationTime /
                                    (recipe.preperationTime +
                                        recipe.cookingTime),
                                Colors.blue[800],
                                rankKey: 'completed',
                              ),
                              new CircularSegmentEntry(
                                recipe.cookingTime /
                                    (recipe.preperationTime +
                                        recipe.cookingTime),
                                Colors.green[600],
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
                                          color: Colors.green[600])),
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
                                          color: Colors.blue[800])),
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
                                "${recipe.preperationTime} min",
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
                          style: TextStyle(fontSize: 15, color: textColor))
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            IngredientsScreen(recipe),
          ]))
        ]));
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
      output.add(
        Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {},
                color: Colors.white),
            Text(
              "${widget.currentRecipe.ingredientsList[sectionNumber][i]}",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Spacer(),
            Text(
              "${widget.currentRecipe.amount[sectionNumber][i]} ${widget.currentRecipe.unit[sectionNumber][i]}",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      );
    }
    return output;
  }

  List<Widget> getIngredientsData() {
    List<Widget> output = new List<Widget>();

    for (int i = 0; i < widget.currentRecipe.ingredientsGlossary.length; i++) {
      output.add(
        Padding(
          padding: EdgeInsets.only(top: 30, left: 45),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("${widget.currentRecipe.ingredientsGlossary[i]}",
                  style: TextStyle(color: textColor, fontSize: 24)),
              IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {},
                color: textColor,
              )
            ],
          ),
        ),
      );
      output.addAll(getIngredientsSection(i));
    }

    return output;
  }

  @override
  Widget build(BuildContext context) {
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
                        "Ingredients for 4 servings",
                        style: TextStyle(
                          color: textColor,
                          fontSize: headingSize,
                          fontFamily: "Questrial-Regular",
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_shopping_cart,
                          color: textColor,
                        ),
                        onPressed: () {},
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
