import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/models/shopping_cart.dart';
import 'package:path_provider/path_provider.dart' as pP;
import 'package:scoped_model/scoped_model.dart';
import 'package:share_extend/share_extend.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:ui';
import 'dart:math';
import 'dart:convert';
import 'package:share/share.dart';

import '../recipe.dart';
import './recipe_overview.dart';
import '../gallery_view.dart';
import './recipe_overview.dart' show Favorite;
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import './add_recipe_screen/add_recipe.dart' show AddRecipeForm;
import '../helper.dart';

const double timeTextsize = 15;
const double timeText = 17;
const double paddingBottomTime = 5;
const double headingSize = 20;
const Color textColor = Colors.white;

enum PopupOptions { EXPORT, DELETE }

class RecipeScreen extends StatelessWidget {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  final Recipe recipe;
  final Color primaryColor;
  final String heroImageTag;
  final String heroTitle;

  RecipeScreen(
      {@required this.recipe,
      @required this.primaryColor,
      this.heroImageTag,
      this.heroTitle});

  @override
  Widget build(BuildContext context) {
    print(recipe.imagePath);
    print(recipe.imagePreviewPath);
    double remainingTime =
        recipe.totalTime - recipe.preperationTime - recipe.cookingTime;
    double otherTime;
    remainingTime > 0 ? otherTime = remainingTime : otherTime = 0;
    return Scaffold(
        backgroundColor: primaryColor,
        body: CustomScrollView(slivers: <Widget>[
          ScopedModelDescendant<RecipeKeeper>(
            builder: (context, child, model) => SliverAppBar(
              backgroundColor: primaryColor,
              actions: <Widget>[
                Favorite(recipe, model),
                IconButton(
                  icon: Icon(Icons.edit),
                  tooltip: 'edit',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new AddRecipeForm(
                                  editRecipe: recipe,
                                )));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  tooltip: 'share recipe',
                  onPressed: () {
                    Share.plainText(
                            text: getRecipeAsString(recipe), title: 'Rezept')
                        .share();
                  },
                ),
                PopupMenuButton<PopupOptions>(
                  onSelected: (value) => _choiceAction(value, context, model),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: PopupOptions.EXPORT,
                        child: Text('export as zip'),
                      ),
                      PopupMenuItem(
                        value: PopupOptions.DELETE,
                        child: Text('delete'),
                      )
                    ];
                  },
                ),
              ],
              floating: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate(<Widget>[
            // recipe.imagePath == 'images/randomFood.jpg'
            //     ? Container()
            //     :
            GestureDetector(
              onTap: () {
                _showPictureFullView(recipe.imagePath, heroImageTag, context);
              },
              child: Hero(
                tag: heroImageTag,
                child: Material(
                  color: Colors.transparent,
                  child: ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                        height: 270,
                        child: Image.file(
                          File(recipe.imagePath),
                          fit: BoxFit.cover,
                        )),
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
                        tag: heroTitle,
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
                                recipe.cookingTime / recipe.totalTime,
                                Colors.blue[700],
                                rankKey: 'completed',
                              ),
                              new CircularSegmentEntry(
                                recipe.preperationTime / recipe.totalTime,
                                Colors.green[500],
                                rankKey: 'remaining',
                              ),
                              recipe.cookingTime + recipe.preperationTime ==
                                      recipe.totalTime
                                  ? new CircularSegmentEntry(0, Colors.black)
                                  : new CircularSegmentEntry(
                                      (recipe.totalTime -
                                              recipe.preperationTime -
                                              recipe.cookingTime) /
                                          recipe.totalTime,
                                      Colors.pink)
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
                              recipe.cookingTime + recipe.preperationTime ==
                                      recipe.totalTime
                                  ? Container()
                                  : Row(
                                      children: <Widget>[
                                        Container(
                                            width: 5,
                                            height: 5,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.pink)),
                                        Text(
                                          " rest: ",
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
                              recipe.cookingTime + recipe.preperationTime ==
                                      recipe.totalTime
                                  ? Container()
                                  : Text(
                                      "$otherTime min",
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
                                "images/${_getImageComplexity(recipe.effort.round())}.png")),
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
                  .getRecipeStepPreviewPathList(recipe.stepImages, recipe.name),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return StepsScreen(
                      recipe.steps, snapshot.data, recipe.stepImages);
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
            recipe.notes != ""
                ? NotesSection(notes: recipe.notes)
                : Container(),
            recipe.categories.length > 0
                ? CategoriesSection(categories: recipe.categories)
                : Container(),
          ]))
        ]));
  }

  void _choiceAction(PopupOptions value, context, RecipeKeeper rKeeper) {
    if (value == PopupOptions.DELETE) {
      rKeeper.deleteRecipeWithName(recipe.name, true).then((_) {
        Navigator.pop(context);
      });
    } else if (value == PopupOptions.EXPORT) {
      exportRecipe(recipe).then((_) {});
    }
  }

  Future<bool> exportRecipe(Recipe recipe) async {
    saveRecipeZipToCache(await PathProvider.pP.getShareDir());

    ShareExtend.share(
        await PathProvider.pP.getShareZipFile(recipe.name), "file");

    return true;
  }

  Future<void> saveRecipeZipToCache(String exportPath) async {
    Recipe exportRecipe =
        await DBProvider.db.getRecipeByName(recipe.name, false);
    Directory recipeDir =
        Directory(await PathProvider.pP.getRecipeDir(recipe.name));

    File file = File(await PathProvider.pP.getShareJsonPath(recipe.name));
    Map<String, dynamic> jsonMap = exportRecipe.toMap();
    String json = jsonEncode(jsonMap);
    await file.writeAsString(json);

    var encoder = ZipFileEncoder();
    encoder.create(await PathProvider.pP.getShareJsonPath(recipe.name));
    encoder.addFile(file);
    if (recipeDir.existsSync()) {
      encoder.addDirectory(recipeDir);
    }
    encoder.close();
  }

  String getRecipeAsString(Recipe recipe) {
    String recipeText = 'Recipename: ${recipe.name}\n'
        '====================\n'
        'preperation Time: ${recipe.preperationTime} min\n'
        'cooking Time: ${recipe.cookingTime} min\n'
        'total Time: ${recipe.totalTime} min\n'
        '====================\n'
        'recipe for ${recipe.servings} servings:\n';
    for (int i = 0; i < recipe.ingredientsGlossary.length; i++) {
      recipeText += 'ingredients for ${recipe.ingredientsGlossary[i]}:\n';
      for (int j = 0; j < recipe.ingredients[i].length; j++) {
        recipeText += '${recipe.ingredients[i][j].name} '
            '${recipe.ingredients[i][j].amount} '
            '${recipe.ingredients[i][j].unit}\n';
      }
      recipeText += '====================\n';
    }
    int i = 1;
    for (final String step in recipe.steps) {
      recipeText += '$i. $step\n';
      i++;
    }
    recipeText += '====================\n';
    recipeText += 'notes: ' + recipe.notes;
    // TODO: Continue
    return recipeText;
  }
}

class NotesSection extends StatelessWidget {
  final String notes;

  const NotesSection({this.notes, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
        color: Color(0xff51473b),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                  notes,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ))
          ],
        ));
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

void _showStepFullView(
  List<List<String>> stepImages,
  List<String> description,
  int stepNumber,
  int imageNumber,
  BuildContext context,
) {
  List<String> flatStepImages = [];
  List<String> imageDescription = [];
  List<String> heroTags = [];
  int imageIndex = 0;
  for (int i = 0; i < stepImages.length; i++) {
    if (i < stepNumber) imageIndex += stepImages[i].length;
    for (int j = 0; j < stepImages[i].length; j++) {
      imageDescription.add(description[i]);
      flatStepImages.add(stepImages[i][j]);
      heroTags.add("Schritt$i:$j");
    }
  }
  imageIndex += imageNumber;

  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoView(
          initialIndex: imageIndex,
          galleryItems: flatStepImages,
          descriptions: imageDescription,
          heroTags: heroTags,
        ),
      ));
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

class CategoriesSection extends StatelessWidget {
  final List<String> categories;

  CategoriesSection({this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff51473b),
      child: Padding(
        padding: const EdgeInsets.only(left: 30, top: 30, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Categories",
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontFamily: "Questrial-Regular",
              ),
            ),
            ScopedModelDescendant<RecipeKeeper>(
              builder: (context, child, model) => Wrap(
                children: categories
                    .map(
                      (categoryName) => CategoryCircle(
                        categoryName: categoryName,
                        imageName: model
                            .getRandomRecipeImageFromCategory(categoryName),
                      ),
                    )
                    .toList(),
                runSpacing: 10.0,
                spacing: 10.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CategoryCircle extends StatefulWidget {
  final String categoryName;
  final String imageName;

  CategoryCircle({
    this.categoryName,
    this.imageName,
    Key key,
  }) : super(key: key);

  _CategoryCircleState createState() => _CategoryCircleState();
}

class _CategoryCircleState extends State<CategoryCircle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Random rand = new Random();
          DBProvider.db
              .getRecipePreviewOfCategory(widget.categoryName)
              .then((r) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => new RecipeGridView(
                  category: widget.categoryName == null
                      ? 'no category'
                      : widget.categoryName,
                  randomCategoryImage:
                      r.length != 1 ? rand.nextInt(r.length) : 0,
                ),
              ),
            );
          });
        },
        child: ClipOval(
          child: Stack(
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(widget.imageName)),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 30),
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.4)),
                  width: 100,
                  height: 40,
                  child: Center(
                    child: Text(
                      widget.categoryName,
                      style: TextStyle(color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
            ],
          ),
        ));
  }
}

class StepsScreen extends StatelessWidget {
  final List<List<String>> stepPreviewImages;
  final List<List<String>> stepImages;
  final List<String> steps;

  final List<Color> stepsColors = [
    Color(0xff28B404),
    Color(0xff009BDE),
    Color(0xffE3B614),
    Color(0xff8600C5),
  ];

  StepsScreen(this.steps, this.stepPreviewImages, this.stepImages);

  List<Widget> getSteps(BuildContext context) {
    List<Widget> output = new List<Widget>();

    for (int i = 0; i < steps.length; i++) {
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
                steps[i],
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
      for (int j = 0; j < stepPreviewImages[i].length; j++) {
        stepPics.children.add(GestureDetector(
          onTap: () {
            _showStepFullView(stepImages, steps, i, j, context);
          },
          child: Hero(
            tag: "Schritt$i:$j",
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  width: 100,
                  height: 80,
                  child: FadeInImage(
                    fadeInDuration: Duration(milliseconds: 100),
                    placeholder: MemoryImage(kTransparentImage),
                    image: FileImage(
                      File(stepPreviewImages[i][j]),
                    ),
                    fit: BoxFit.cover,
                  ),
                )),
          ),
        ));

        if (j == stepPreviewImages[i].length - 1) {
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
    if (steps.isEmpty) return Container();
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
  List<Ingredient> saved = [];

  IngredientsScreenState(this.servings);

  List<Widget> getIngredientsSection(int sectionNumber) {
    List<Widget> output = new List<Widget>();
    output.add(
      SizedBox(
        height: 15,
      ),
    );
    for (int i = 0;
        i < widget.currentRecipe.ingredients[sectionNumber].length;
        i++) {
      Ingredient currentIngredient =
          widget.currentRecipe.ingredients[sectionNumber][i];

      output.add(
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: saved.contains(currentIngredient)
                      ? Icon(Icons.check_circle)
                      : Icon(Icons.add_circle_outline),
                  tooltip: 'Add to shopping Cart',
                  onPressed: () {},
                  color: saved.contains(currentIngredient)
                      ? Colors.green
                      : Colors.white),
              Text(
                currentIngredient.name,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Spacer(),
              Text(
                "${cutDouble(currentIngredient.amount)} ${currentIngredient.unit}",
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
      List<Ingredient> sectionIngredients = widget.currentRecipe.ingredients[i];
      if (widget.currentRecipe.ingredientsGlossary[i] != "") {
        output.add(
          ScopedModelDescendant<ShoppingCartKeeper>(
            builder: (context, child, model) => Padding(
              padding: EdgeInsets.only(top: 30, left: 45, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("${widget.currentRecipe.ingredientsGlossary[i]}",
                      style: TextStyle(color: textColor, fontSize: 24)),
                  IconButton(
                    icon: containsList(saved, sectionIngredients)
                        ? Icon(Icons.shopping_cart)
                        : Icon(Icons.add_shopping_cart),
                    tooltip: 'add to shopping cart',
                    onPressed: () {
                      model.addMulitpleIngredientsToCart(
                          widget.currentRecipe.name,
                          widget.currentRecipe.ingredients[i]);
                    },
                    color:
                        containsList(saved, widget.currentRecipe.ingredients[i])
                            ? Colors.green
                            : textColor,
                  )
                ],
              ),
            ),
          ),
        );
      }
      output.addAll(getIngredientsSection(i));
    }

    return output;
  }

  @override
  Widget build(BuildContext context) {
    List<Ingredient> allIngredients =
        flattenIngredients(widget.currentRecipe.ingredients);
    if (allIngredients.isEmpty) return Container();
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
                    children: <Widget>[
                      Text(
                        "Ingredients for",
                        style: TextStyle(
                          color: textColor,
                          fontSize: headingSize,
                          fontFamily: "Questrial-Regular",
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline,
                            color: Colors.white),
                        tooltip: 'decrease servings',
                        onPressed: () {
                          _decreaseServings();
                        },
                      ),
                      Text(
                        '$servings',
                        style: TextStyle(
                          color: textColor,
                          fontSize: headingSize,
                          fontFamily: "Questrial-Regular",
                        ),
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.add_circle_outline, color: Colors.white),
                        tooltip: 'increase servings',
                        onPressed: () {
                          _increaseServings();
                        },
                      ),
                      Text(
                        'servings',
                        style: TextStyle(
                          color: textColor,
                          fontSize: headingSize,
                          fontFamily: "Questrial-Regular",
                        ),
                      ),
                      Spacer(),
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

  void _decreaseServings() {
    if (servings <= 1) return;
    List<List<Ingredient>> ingredients = widget.currentRecipe.ingredients;
    for (int i = 0; i < ingredients.length; i++) {
      for (int j = 0; j < ingredients[i].length; j++) {
        ingredients[i][j].amount =
            ((servings - 1) / servings) * ingredients[i][j].amount;
      }
    }
    setState(() {
      servings = servings - 1;
    });
  }

  void _increaseServings() {
    List<List<Ingredient>> ingredients = widget.currentRecipe.ingredients;
    for (int i = 0; i < ingredients.length; i++) {
      for (int j = 0; j < ingredients[i].length; j++) {
        ingredients[i][j].amount =
            ((servings + 1) / servings) * ingredients[i][j].amount;
      }
    }
    setState(() {
      servings = servings + 1;
    });
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

bool containsList(List<Ingredient> list, List<Ingredient> contains) {
  for (int i = 0; i < contains.length; i++) {
    if (!list.contains(contains[i])) return false;
  }
  return true;
}
