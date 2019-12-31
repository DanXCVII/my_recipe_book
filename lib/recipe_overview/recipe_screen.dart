import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:share/share.dart';
import 'package:share_extend/share_extend.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:transparent_image/transparent_image.dart';

import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_event.dart';
import '../blocs/recipe_overview/recipe_overview_bloc.dart';
import '../blocs/recipe_overview/recipe_overview_event.dart';
import '../blocs/recipe_screen_ingredients/recipe_screen_ingredients_bloc.dart';
import '../blocs/recipe_screen_ingredients/recipe_screen_ingredients_event.dart';
import '../blocs/recipe_screen_ingredients/recipe_screen_ingredients_state.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../database.dart';
import '../gallery_view.dart';
import '../generated/i18n.dart';
import '../helper.dart';
import '../hive.dart';
import '../io/io_operations.dart' as IO;
import '../models/enums.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../recipe.dart';
import '../recipe_card.dart';
import '../screens/recipe_overview.dart';
import 'add_recipe_screen/general_info/general_info_screen.dart';

const double timeTextsize = 15;
const double timeText = 17;
const double paddingBottomTime = 5;
const double headingSize = 20;
const Color textColor = Colors.white;
const String recipeScreenFontFamily = 'Questrial';

const imageComplexity = [
  "termoOne",
  "termoTwo",
  "termoThree",
  "termoFour",
  "termoFive",
  "termoSix",
  "termoSeven",
  "termoEight",
  "termoNine",
  "termoTen",
];

enum PopupOptions { EXPORT_ZIP, EXPORT_TEXT }

class RecipeScreenArguments {
  final ShoppingCartBloc shoppingCartBloc;
  final Recipe recipe;
  final Color primaryColor;
  final String heroImageTag;

  RecipeScreenArguments(
    this.shoppingCartBloc,
    this.recipe,
    this.primaryColor,
    this.heroImageTag,
  );
}

class RecipeScreen extends StatelessWidget {
  final Recipe recipe;
  final Color primaryColor;
  final String heroImageTag;
  final PanelController _pc = PanelController();

  RecipeScreen({
    @required this.recipe,
    @required this.primaryColor,
    this.heroImageTag,
  });

  @override
  Widget build(BuildContext context) {
    return recipe.nutritions.isEmpty
        ? RecipePage(
            recipe: recipe,
            primaryColor: primaryColor,
            heroImageTag: heroImageTag,
          )
        : Scaffold(
            backgroundColor: primaryColor,
            body: SlidingUpPanel(
              controller: _pc,
              backdropColor: Colors.black,
              backdropEnabled: true,
              // margin: EdgeInsets.only(left: 20, right: 20),
              parallaxEnabled: true,
              parallaxOffset: 0.5,
              minHeight: 70,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              panel: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff7E4400),
                      Color(0xffCFAC53),
                    ],
                    begin: FractionalOffset.topLeft,
                    end: FractionalOffset.bottomRight,
                    stops: [0.0, 1.0],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          _pc.animatePanelToPosition(1);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          width: 30,
                          height: 5,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0))),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          _pc.animatePanelToPosition(1);
                        },
                        child: Text(
                          S.of(context).nutritions,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      Container(height: 10),
                      Container(
                        height: 435,
                        child: ListView.builder(
                          itemCount: recipe.nutritions.length * 2,
                          itemBuilder: (context, index) {
                            if ((index - 1) % 2 == 0) {
                              return Divider();
                            } else {
                              int nutritionIndex = (index / 2).round();
                              return ListTile(
                                leading: Icon(GroovinMaterialIcons.gate_or,
                                    color: Colors.white),
                                title: Text(
                                  recipe.nutritions[nutritionIndex].name,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                trailing: Text(
                                  recipe.nutritions[nutritionIndex].amountUnit,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              );
                            }
                          },
                        ),
                      )
                    ]),
              ),
              body: RecipePage(
                recipe: recipe,
                primaryColor: primaryColor,
                heroImageTag: heroImageTag,
              ),
            ),
          );
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
              S.of(context).notes,
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontFamily: recipeScreenFontFamily,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  notes,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: recipeScreenFontFamily,
                  ),
                ))
          ],
        ));
  }
}

class RecipePage extends StatelessWidget {
  final Recipe recipe;
  final Color primaryColor;
  final String heroImageTag;
  final PanelController _pc = PanelController();

  RecipePage({
    @required this.recipe,
    @required this.primaryColor,
    this.heroImageTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: primaryColor,
              actions: <Widget>[
                Favorite(recipe),
                IconButton(
                  icon: Icon(Icons.edit),
                  tooltip: 'edit',
                  onPressed: () {
                    pushEditRecipe(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  tooltip: S.of(context).share_recipe,
                  onPressed: () {
                    _showDeleteDialog(context, recipe.name);
                  },
                ),
                PopupMenuButton<PopupOptions>(
                  icon: Icon(Icons.share),
                  onSelected: (value) => _choiceAction(value, context),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: PopupOptions.EXPORT_ZIP,
                        child: Text(S.of(context).export_zip),
                      ),
                      PopupMenuItem(
                        value: PopupOptions.EXPORT_TEXT,
                        child: Text(S.of(context).export_text),
                      )
                    ];
                  },
                ),
              ],
              floating: true,
            ),
            SliverList(
                delegate: SliverChildListDelegate(<Widget>[
              GestureDetector(
                onTap: () {
                  _showPictureFullView(recipe.imagePath, heroImageTag, context);
                },
                child: Container(
                  height: 270,
                  child: Stack(children: <Widget>[
                    Hero(
                      tag: heroImageTag,
                      placeholderBuilder: (context, size, widget) => ClipPath(
                        clipper: MyClipper(),
                        child: recipe.imagePath == 'images/randomFood.jpg'
                            ? Image.asset('images/randomFood.jpg',
                                width: double.infinity, fit: BoxFit.cover)
                            : Image.file(File(recipe.imagePath),
                                width: double.infinity, fit: BoxFit.cover),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: ClipPath(
                          clipper: MyClipper(),
                          child: Container(
                              height: 270,
                              child: recipe.imagePath == 'images/randomFood.jpg'
                                  ? Image.asset('images/randomFood.jpg',
                                      width: double.infinity, fit: BoxFit.cover)
                                  : Image.file(File(recipe.imagePath),
                                      width: double.infinity,
                                      fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          pushVegetableRoute(context, recipe.vegetable);
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(bottom: 8.0, right: 8.0),
                          child: Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(15),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 3,
                                      spreadRadius: 2,
                                      offset: Offset(1, 1),
                                      color: Colors.grey[800])
                                ],
                                color:
                                    _getVegetableCircleColor(recipe.vegetable)),
                            child: Center(
                              child: Image.asset(
                                "images/${getRecipeTypeImage(recipe.vegetable)}.png",
                                height: 40,
                                width: 40,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ]),
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
                        fontSize: 30,
                        fontFamily: recipeScreenFontFamily,
                      ),
                    ),
                  )),
              SizedBox(height: 30),
              TopSectionRecipe(
                preperationTime: recipe.preperationTime,
                cookingTime: recipe.cookingTime,
                totalTime: recipe.totalTime,
                chartKey: GlobalKey<AnimatedCircularChartState>(),
                effort: recipe.effort,
              ),
              SizedBox(height: 30),
              IngredientsScreen(recipe),
              SizedBox(height: 30),
              FutureBuilder<List<List<String>>>(
                future: PathProvider.pP.getRecipeStepPreviewPathList(
                    recipe.stepImages, recipe.name),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return StepsSection(
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
              recipe.nutritions.isEmpty ? Container() : Container(height: 50),
            ]))
          ],
        ));
  }

  Color _getVegetableCircleColor(Vegetable vegetable) {
    switch (vegetable) {
      case Vegetable.NON_VEGETARIAN:
        return Color(0xffBF8138);
      case Vegetable.VEGETARIAN:
        return Color(0xff8DCF4A);
      case Vegetable.VEGAN:
        return Color(0xff1BC318);
      default:
        return null;
    }
  }

  void pushEditRecipe(BuildContext context) {
    Recipe modifyRecipe = Recipe(name: null, servings: null, vegetable: null);
    // TODO: fix
    // modifyRecipe.setEqual(recipe);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => GeneralInfoScreen(
          modifiedRecipe: recipe,
        ),
      ),
    );
  }

  void _choiceAction(PopupOptions value, context) {
    if (value == PopupOptions.EXPORT_TEXT) {
      Share.plainText(text: _getRecipeAsString(recipe), title: 'recipe')
          .share();
    } else if (value == PopupOptions.EXPORT_ZIP) {
      exportRecipe(recipe).then((_) {});
    }
  }

  _showDeleteDialog(BuildContext context, String recipeName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(S.of(context).delete_recipe),
        content: Text(
            S.of(context).sure_you_want_to_delete_this_recipe + " $recipeName"),
        actions: <Widget>[
          FlatButton(
            child: Text(S.of(context).no),
            textColor: Theme.of(context).textTheme.body1.color,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Text(S.of(context).yes),
            textColor: Theme.of(context).textTheme.body1.color,
            color: Colors.red[600],
            onPressed: () {
              BlocProvider.of<RecipeManagerBloc>(context)
                  .add(RMDeleteRecipe(recipe));
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<bool> exportRecipe(Recipe recipe) async {
    String zipFilePath = await IO.saveRecipeZip(
        await PathProvider.pP.getShareDir(), recipe.name);

    ShareExtend.share(zipFilePath, "file");

    return true;
  }

  String _getRecipeAsString(Recipe recipe) {
    String recipeText = 'recipename: ${recipe.name}\n'
        '====================\n'
        'preperation Time: ${recipe.preperationTime} min\n'
        'cooking Time: ${recipe.cookingTime} min\n'
        'total Time: ${recipe.totalTime} min\n'
        '====================\n'
        'recipe for ${recipe.servings} servings:\n';
    if (recipe.ingredientsGlossary.isNotEmpty) {
      for (int i = 0; i < recipe.ingredientsGlossary.length; i++) {
        recipeText += 'ingredients for ${recipe.ingredientsGlossary[i]}:\n';
        for (int j = 0; j < recipe.ingredients[i].length; j++) {
          recipeText += '${recipe.ingredients[i][j].name} '
              '${recipe.ingredients[i][j].amount} '
              '${recipe.ingredients[i][j].unit}\n';
        }
        recipeText += '====================\n';
      }
    }
    int i = 1;
    for (final String step in recipe.steps) {
      recipeText += '$i. $step\n';
      i++;
    }
    if (recipe.notes != null && recipe.notes != '') {
      recipeText += '====================\n';
      recipeText += 'notes: ${recipe.notes}\n';
    }

    return recipeText;
  }
}

class TopSectionRecipe extends StatelessWidget {
  final double preperationTime;
  final double cookingTime;
  final double totalTime;
  final GlobalKey<AnimatedCircularChartState> chartKey;
  final int effort;

  const TopSectionRecipe({
    this.preperationTime,
    this.cookingTime,
    this.chartKey,
    this.totalTime,
    this.effort,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double remainingTimeChart = 0;
    if (totalTime <= cookingTime + preperationTime)
      remainingTimeChart = 0;
    else
      remainingTimeChart = totalTime - cookingTime - preperationTime;

    double totalTimeChart = 0;
    if (totalTime >= preperationTime + cookingTime)
      totalTimeChart = totalTime;
    else
      totalTimeChart = preperationTime + cookingTime;

    print(totalTimeChart);
    print(remainingTimeChart);
    print(preperationTime);
    print(cookingTime);

    return _showComplexTopArea(preperationTime, cookingTime, totalTime)
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    AnimatedCircularChart(
                      key: chartKey,
                      size: Size(120, 120),
                      initialChartData: <CircularStackEntry>[
                        new CircularStackEntry(
                          <CircularSegmentEntry>[
                            new CircularSegmentEntry(
                              cookingTime / totalTimeChart,
                              Colors.blue[700],
                              rankKey: 'completed',
                            ),
                            new CircularSegmentEntry(
                              preperationTime / totalTimeChart,
                              Colors.green[500],
                              rankKey: 'remaining',
                            ),
                            new CircularSegmentEntry(
                                remainingTimeChart / totalTimeChart,
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
                                  " ${S.of(context).prep_time}: ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: recipeScreenFontFamily,
                                  ),
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
                                  " ${S.of(context).cook_time}: ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: recipeScreenFontFamily,
                                  ),
                                ),
                              ],
                            ),
                            totalTime == 0
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
                                        " ${S.of(context).total_time}: ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: recipeScreenFontFamily,
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              getTimeHoursMinutes(preperationTime),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: recipeScreenFontFamily,
                              ),
                            ),
                            Text(
                              getTimeHoursMinutes(cookingTime),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: recipeScreenFontFamily,
                              ),
                            ),
                            totalTime == 0
                                ? Container()
                                : Text(
                                    getTimeHoursMinutes(remainingTimeChart),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: recipeScreenFontFamily,
                                    ),
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
                    Text(S.of(context).complexity + ':',
                        style: TextStyle(
                          fontSize: 15,
                          color: textColor,
                          fontFamily: recipeScreenFontFamily,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                          height: 120,
                          child: Image.asset(
                              "images/${imageComplexity[effort.round()]}.png")),
                    )
                  ],
                ),
              )
            ],
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Wrap(
              direction: Axis.horizontal,
              runSpacing: 10,
              spacing: 10,
              children: <Widget>[
                (preperationTime != null ||
                        cookingTime != null ||
                        totalTime != null)
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: Colors.grey[800]),
                        child: Padding(
                          padding: EdgeInsets.all(9),
                          child: Text(
                            _getTimeString(
                                preperationTime, cookingTime, totalTime),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: recipeScreenFontFamily,
                            ),
                          ),
                        ),
                      )
                    : null,
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: _getEffortColor(effort)),
                  child: Padding(
                    padding: EdgeInsets.all(9),
                    child: Text(
                      "${S.of(context).complexity}: $effort",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: recipeScreenFontFamily,
                      ),
                    ),
                  ),
                ),
              ]..removeWhere((item) => item == null),
            ),
          );
  }

  Color _getEffortColor(int effort) {
    switch (effort) {
      case 1:
        return Color(0xff10C800);
      case 2:
        return Color(0xff10C800);
      case 3:
        return Color(0xff70C800);
      case 4:
        return Color(0xff70C800);
      case 5:
        return Color(0xffC8C000);
      case 6:
        return Color(0xffC8C000);
      case 7:
        return Color(0xffD27910);
      case 8:
        return Color(0xffE08315);
      case 9:
        return Color(0xffB94F4F);
      case 10:
        return Color(0xffBD4242);
      default:
        return null;
    }
  }

  String _getTimeString(
      double preperationTime, double cookingTime, double totalTime) {
    if (totalTime != 0) return "total time: " + cutDouble(totalTime);
    if (cookingTime != 0) return "cooking time: " + cutDouble(cookingTime);
    return "preperation time: " + cutDouble(preperationTime);
  }

  /// method which determines if the circular chart and complexity termometer should be
  /// shown or only a minimal version
  bool _showComplexTopArea(
      double preperationTime, double cookingTime, double totalTime) {
    int validator = 0;

    if (preperationTime != 0) validator++;
    if (cookingTime != 0) validator++;
    if (totalTime != 0) validator++;
    if (preperationTime == totalTime || cookingTime == totalTime) return false;
    if (validator > 1) return true;
    return false;
  }
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
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoView(
          initialIndex: 0,
          galleryItems: [image],
          descriptions: [''],
          heroTags: [tag],
        ),
      ));
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
              S.of(context).categories,
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontFamily: recipeScreenFontFamily,
              ),
            ),
            SizedBox(height: 25),
            Wrap(
              children: categories.map((categoryName) {
                return FutureBuilder<Recipe>(
                    future: HiveProvider()
                        .getRandomRecipeOfCategory(category: categoryName),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CategoryCircle(
                          categoryName: categoryName,
                          imageName: snapshot.data == null
                              ? 'images/randomFood.jpg'
                              : snapshot.data.imagePath,
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    });
              }).toList(),
              runSpacing: 10.0,
              spacing: 10.0,
            ),
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
          DBProvider.db
              .getRecipePreviewOfCategory(widget.categoryName)
              .then((r) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    BlocProvider<RecipeOverviewBloc>(
                  builder: (context) => RecipeOverviewBloc(
                      recipeManagerBloc:
                          BlocProvider.of<RecipeManagerBloc>(context))
                    ..add(LoadCategoryRecipeOverview(widget.categoryName == null
                        ? 'no category'
                        : widget.categoryName)),
                  child: RecipeGridView(),
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
                    image: widget.imageName != 'images/randomFood.jpg'
                        ? FileImage(File(widget.imageName))
                        : AssetImage('images/randomFood.jpg'),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        widget.categoryName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: recipeScreenFontFamily,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}

class StepsSection extends StatelessWidget {
  final List<List<String>> stepPreviewImages;
  final List<List<String>> stepImages;
  final List<String> steps;

  final List<Color> stepsColors = [
    Color(0xff28B404),
    Color(0xff009BDE),
    Color(0xffE3B614),
    Color(0xff8600C5),
  ];

  StepsSection(this.steps, this.stepPreviewImages, this.stepImages);

  List<Widget> getSteps(BuildContext context) {
    List<Widget> output = new List<Widget>();

    for (int i = 0; i < steps.length; i++) {
      output.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: recipeScreenFontFamily,
                ),
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
            placeholderBuilder: (context, size, widget) => ClipRRect(
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
                        S.of(context).directions,
                        style: TextStyle(
                          color: textColor,
                          fontSize: headingSize,
                          fontFamily: recipeScreenFontFamily,
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
  State<StatefulWidget> createState() => IngredientsScreenState();
}

class IngredientsScreenState extends State<IngredientsScreen> {
  List<Widget> getIngredientsSection(
      List<CheckableIngredient> ingredients, bool oneSection) {
    return [
      SizedBox(
        height: oneSection ? 0 : 15,
      )
    ]..addAll(
        ingredients.map(
          (currentIngredient) => Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: currentIngredient.checked
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.add_circle_outline),
                    tooltip: 'Add to shopping Cart',
                    onPressed: () {
                      _pressIngredient(currentIngredient);
                    },
                    color: currentIngredient.checked
                        ? Colors.green
                        : Colors.white),
                Container(
                  width: MediaQuery.of(context).size.width - 150,
                  child: Text(
                    currentIngredient.name,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: recipeScreenFontFamily,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  width: 80,
                  child: Text(
                    "${currentIngredient.amount == null ? "" : cutDouble(currentIngredient.amount)} "
                    "${currentIngredient.unit == null ? "" : currentIngredient.unit}",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: recipeScreenFontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  /// adds or removes the ingredient to/from the shopping cart and changes its
  /// checked status
  void _pressIngredient(CheckableIngredient ingredient) {
    if (ingredient.checked) {
      BlocProvider.of<RecipeScreenIngredientsBloc>(context).add(RemoveFromCart(
          widget.currentRecipe.name, [ingredient.getIngredient()]));
    } else {
      BlocProvider.of<RecipeScreenIngredientsBloc>(context).add(
          AddToCart(widget.currentRecipe.name, [ingredient.getIngredient()]));
    }
  }

  List<Widget> getIngredientsData(
      List<List<CheckableIngredient>> ingredients, List<bool> sectionCheck) {
    List<Widget> output = [];
    bool oneSection = ingredients.isEmpty;

    for (int i = 0; i < ingredients.length; i++) {
      List<CheckableIngredient> sectionIngredients = ingredients[i];
      output.add(
        Padding(
          padding: EdgeInsets.only(
            top: oneSection ? 5 : 30,
            left: 45,
            right: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                  "${widget.currentRecipe.ingredientsGlossary.isNotEmpty ? widget.currentRecipe.ingredientsGlossary[i] : ''}",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontFamily: recipeScreenFontFamily,
                  )),
              IconButton(
                icon: sectionCheck[i]
                    ? Icon(Icons.shopping_cart)
                    : Icon(Icons.add_shopping_cart),
                tooltip: 'add to shopping cart',
                onPressed: () {
                  _pressAddSection(
                      sectionIngredients
                          .map((ingred) => ingred.getIngredient())
                          .toList(),
                      sectionCheck[i]);
                },
                color: sectionCheck[i] ? Colors.green : textColor,
              )
            ],
          ),
        ),
      );

      output.addAll(getIngredientsSection(ingredients[i], oneSection));
    }

    return output;
  }

  void _pressAddSection(List<Ingredient> ingredients, bool isChecked) {
    if (isChecked) {
      BlocProvider.of<RecipeScreenIngredientsBloc>(context)
          .add(RemoveFromCart(widget.currentRecipe.name, ingredients));
    } else {
      BlocProvider.of<RecipeScreenIngredientsBloc>(context)
          .add(AddToCart(widget.currentRecipe.name, ingredients));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: check how the list of no ingredients looks like
    List<Ingredient> allIngredients =
        flattenIngredients(widget.currentRecipe.ingredients);
    if (allIngredients.isEmpty) return Container();
    return BlocBuilder<RecipeScreenIngredientsBloc,
        RecipeScreenIngredientsState>(
      builder: (context, state) {
        if (state is InitialRecipeScreenIngredientsState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LoadedRecipeIngredients) {
          return Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.3)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Text(
                            S.of(context).ingredients_for,
                            style: TextStyle(
                              color: textColor,
                              fontSize: headingSize,
                              fontFamily: recipeScreenFontFamily,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline,
                                color: Colors.white),
                            tooltip: S.of(context).decrease_servings,
                            onPressed: () {
                              _decreaseServings(state.servings);
                            },
                          ),
                          Text(
                            '${state.servings}',
                            style: TextStyle(
                              color: textColor,
                              fontSize: headingSize,
                              fontFamily: recipeScreenFontFamily,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline,
                                color: Colors.white),
                            tooltip: S.of(context).increase_servings,
                            onPressed: () {
                              _increaseServings(state.servings);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              S.of(context).servings,
                              style: TextStyle(
                                color: textColor,
                                fontSize: headingSize,
                                fontFamily: recipeScreenFontFamily,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]..addAll(
                getIngredientsData(state.ingredients, state.sectionCheck),
              ),
          );
        } else {
          return Text(state.toString());
        }
      },
    );
  }

  void _decreaseServings(double oldServings) {
    if (oldServings <= 1) return;
    BlocProvider.of<RecipeScreenIngredientsBloc>(context)
        .add(IncreaseServings(oldServings - 1));
  }

  void _increaseServings(double oldServings) {
    BlocProvider.of<RecipeScreenIngredientsBloc>(context)
        .add(IncreaseServings(oldServings + 1));
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
