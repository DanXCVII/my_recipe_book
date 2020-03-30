import 'dart:io';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';
import 'package:my_recipe_book/widgets/icon_info_message.dart';
import 'package:share/share.dart';
import 'package:share_extend/share_extend.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../ad_related/ad.dart';
import '../blocs/ad_manager/ad_manager_bloc.dart';
import '../blocs/animated_stepper/animated_stepper_bloc.dart';
import '../blocs/recipe_bubble/recipe_bubble_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/recipe_screen/recipe_screen_bloc.dart';
import '../blocs/recipe_screen_ingredients/recipe_screen_ingredients_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as Constants;
import '../constants/routes.dart';
import '../generated/i18n.dart';
import '../helper.dart';
import '../local_storage/hive.dart';
import '../local_storage/io_operations.dart' as IO;
import '../local_storage/local_paths.dart';
import '../models/enums.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/string_int_tuple.dart';
import '../my_wrapper.dart';
import '../screens/recipe_overview.dart';
import '../widgets/animated_stepper.dart';
import '../widgets/category_circle_image.dart';
import '../widgets/gallery_view.dart';
import '../widgets/recipe_card.dart';
import 'add_recipe/general_info_screen/general_info_screen.dart';

const double timeTextsize = 15;
const double timeText = 17;
const double paddingBottomTime = 5;
const double headingSize = 19;
const Color textColor = Colors.white;
const String recipeScreenFontFamily = 'Questrial';

const Map<Vegetable, List<int>> vegetableColor = {
  Vegetable.NON_VEGETARIAN: [0xff520808, 0xff400303],
  Vegetable.VEGETARIAN: [0xff1A490A, 0xff193F0B],
  Vegetable.VEGAN: [0xff144E00, 0xff0F3800]
};

enum PopupOptions { EXPORT_ZIP, EXPORT_TEXT }

class RecipeScreenArguments {
  final ShoppingCartBloc shoppingCartBloc;
  final Recipe recipe;
  final String heroImageTag;
  final RecipeManagerBloc recipeManagerBloc;
  final double initialScrollOffset;
  final int initialSelectedStep;

  RecipeScreenArguments(
    this.shoppingCartBloc,
    this.recipe,
    this.heroImageTag,
    this.recipeManagerBloc, {
    this.initialScrollOffset,
    this.initialSelectedStep,
  });
}

class RecipeScreen extends StatefulWidget {
  final String heroImageTag;
  final double initialScrollOffset;

  RecipeScreen({
    this.heroImageTag,
    this.initialScrollOffset,
  });

  @override
  _RecipeScreenState createState() =>
      _RecipeScreenState(initialScrollOffset: initialScrollOffset);
}

class _RecipeScreenState extends State<RecipeScreen>
    with SingleTickerProviderStateMixin {
  final PanelController _pc = PanelController();
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_pc.isAttached) _pc.close();
    super.dispose();
  }

  _RecipeScreenState({double initialScrollOffset}) {
    _scrollController = ScrollController(
        initialScrollOffset:
            initialScrollOffset == null ? 0 : initialScrollOffset,
        keepScrollOffset: false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeScreenBloc, RecipeScreenState>(
        builder: (context, state) {
      if (state is RecipeScreenInfo) {
        return BlocListener<AdManagerBloc, AdManagerState>(
          listener: (context, adState) {
            if (adState is ShowAds) {
              Navigator.pop(context);
              Future.delayed(Duration(milliseconds: 50))
                  .then((_) => Navigator.pushNamed(
                        context,
                        RouteNames.recipeScreen,
                        arguments: RecipeScreenArguments(
                            BlocProvider.of<ShoppingCartBloc>(context),
                            state.recipe,
                            "",
                            BlocProvider.of<RecipeManagerBloc>(context),
                            initialScrollOffset: _scrollController.offset,
                            initialSelectedStep:
                                (BlocProvider.of<AnimatedStepperBloc>(context)
                                        .state as SelectedStep)
                                    .selectedStep),
                      ).then((_) => Ads.hideBottomBannerAd()));
            }
          },
          child: state.recipe.nutritions.isEmpty || Ads.shouldShowAds()
              ? RecipePage(
                  recipe: state.recipe,
                  heroImageTag: widget.heroImageTag,
                  scrollController: _scrollController,
                  categoriesFiles: state.categoryImages,
                )
              : Scaffold(
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                _pc.animatePanelToPosition(1);
                              },
                              child: Text(
                                I18n.of(context).nutritions,
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
                                itemCount: state.recipe.nutritions.length * 2,
                                itemBuilder: (context, index) {
                                  if ((index - 1) % 2 == 0) {
                                    return Divider();
                                  } else {
                                    int nutritionIndex = (index / 2).round();
                                    return ListTile(
                                      leading: Icon(MdiIcons.gateOr,
                                          color: Colors.white),
                                      title: Text(
                                        state.recipe.nutritions[nutritionIndex]
                                            .name,
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                      trailing: Text(
                                        state.recipe.nutritions[nutritionIndex]
                                            .amountUnit,
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
                      recipe: state.recipe,
                      heroImageTag: widget.heroImageTag,
                      categoriesFiles: state.categoryImages,
                    ),
                  ),
                ),
        );
      } else if (state is RecipeEditedDeleted) {
        return Scaffold(
          appBar: AppBar(
            title: Text(I18n.of(context).recipe_screen),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: IconInfoMessage(
                  iconWidget: Icon(
                    MdiIcons.alertCircle,
                    color: Colors.red,
                    size: 70.0,
                  ),
                  description: I18n.of(context).recipe_edited_or_deleted),
            ),
          ),
        );
      } else {
        return Text("unknown state: " + state.toString());
      }
    });
  }
}

class NotesSection extends StatelessWidget {
  final String notes;

  const NotesSection({this.notes, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              I18n.of(context).notes,
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
  final String heroImageTag;
  final ScrollController scrollController;
  final List<String> categoriesFiles;

  RecipePage({
    @required this.recipe,
    this.heroImageTag,
    this.scrollController,
    this.categoriesFiles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff51473b),
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverAppBar(
            flexibleSpace: GradientAppBar(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  Color(vegetableColor[recipe.vegetable][0]),
                  Color(vegetableColor[recipe.vegetable][1]),
                ],
              ),
              actions: <Widget>[
                BlocBuilder<RecipeBubbleBloc, RecipeBubbleState>(
                  builder: (context, state) {
                    if (state is LoadedRecipeBubbles) {
                      bool isPinned = false;
                      if (state.recipes.contains(recipe)) {
                        isPinned = true;
                      }
                      return IconButton(
                        icon: Icon(
                          isPinned ? MdiIcons.pin : MdiIcons.pinOutline,
                          color: isPinned == false && state.recipes.length == 3
                              ? Colors.grey[400]
                              : null,
                        ),
                        onPressed: () {
                          if (isPinned) {
                            BlocProvider.of<RecipeBubbleBloc>(context)
                                .add(RemoveRecipeBubble(recipe));
                          } else {
                            BlocProvider.of<RecipeBubbleBloc>(context)
                                .add(AddRecipeBubble(recipe));

                            final scaffold = Scaffold.of(context);
                            scaffold.hideCurrentSnackBar();

                            scaffold.showSnackBar(
                              SnackBar(
                                content: Text(
                                    I18n.of(context).recipe_pinned_to_overview),
                                action: SnackBarAction(
                                  label: I18n.of(context).dismiss,
                                  onPressed: scaffold.hideCurrentSnackBar,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      return Text("unknown state");
                    }
                  },
                ),
                Favorite(recipe, addFavorite: () {
                  BlocProvider.of<RecipeManagerBloc>(context)
                      .add(RMAddFavorite(recipe));
                }, removeFavorite: () {
                  BlocProvider.of<RecipeManagerBloc>(context)
                      .add(RMRemoveFavorite(recipe));
                }),
                IconButton(
                  icon: Icon(Icons.edit),
                  tooltip: 'edit',
                  onPressed: () {
                    HiveProvider().saveTmpEditingRecipe(recipe).then(
                          (_) => Navigator.pushNamed(
                            context,
                            RouteNames.addRecipeGeneralInfo,
                            arguments: GeneralInfoArguments(
                              recipe,
                              BlocProvider.of<ShoppingCartBloc>(context),
                              editingRecipeName: recipe.name,
                            ),
                          ).then((_) => Ads.showBottomBannerAd()),
                        );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  tooltip: I18n.of(context).share_recipe,
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
                        child: Text(I18n.of(context).export_zip),
                      ),
                      PopupMenuItem(
                        value: PopupOptions.EXPORT_TEXT,
                        child: Text(I18n.of(context).export_text),
                      )
                    ];
                  },
                ),
              ],
            ),
            floating: true,
          ),
          AnimationLimiter(
            child: SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(vegetableColor[recipe.vegetable][0]),
                        Color(vegetableColor[recipe.vegetable][1]),
                      ],
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _showPictureFullView(
                              recipe.imagePath, heroImageTag, context);
                        },
                        child: Container(
                          height: 270,
                          child: Stack(children: <Widget>[
                            Hero(
                              tag: heroImageTag,
                              child: Material(
                                color: Colors.transparent,
                                child: ClipPath(
                                  clipper: MyClipper(),
                                  child: Container(
                                      height: 270,
                                      child: recipe.imagePath ==
                                              Constants.noRecipeImage
                                          ? Image.asset(Constants.noRecipeImage,
                                              width: double.infinity,
                                              fit: BoxFit.cover)
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
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.vegetableRecipes,
                                    arguments: RecipeGridViewArguments(
                                        shoppingCartBloc:
                                            BlocProvider.of<ShoppingCartBloc>(
                                                context),
                                        vegetable: recipe.vegetable),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, right: 8.0),
                                  child: TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0.1, end: 1),
                                    duration: Duration(milliseconds: 700),
                                    curve: Curves.easeOutQuad,
                                    builder: (_, double size, myChild) =>
                                        Container(
                                      height: size * 65,
                                      width: size * 65,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(40),
                                            topRight: Radius.circular(40),
                                            bottomLeft: Radius.circular(40),
                                            bottomRight: Radius.circular(15),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black45,
                                              blurRadius: 2.0,
                                              spreadRadius: 1.0,
                                              offset: Offset(
                                                0,
                                                1.0,
                                              ),
                                            ),
                                          ],
                                          color: _getVegetableCircleColor(
                                              recipe.vegetable)),
                                      child: Center(
                                        child: Image.asset(
                                          "images/${getRecipeTypeImage(recipe.vegetable)}.png",
                                          height: size * 40,
                                          width: size * 40,
                                          fit: BoxFit.scaleDown,
                                        ),
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
                        effort: recipe.effort,
                        recipeTags: recipe.tags,
                      ),
                      SizedBox(height: 20),
                      IngredientsScreen(
                        currentRecipe: recipe,
                        animationWaitTime: MyIntWrapper(0),
                        addToCartIngredients: [],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
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
                recipe.notes != "" ||
                        recipe.categories.isNotEmpty ||
                        recipe.source != null
                    ? Container(
                        height: 20,
                        decoration: BoxDecoration(color: Colors.black87),
                      )
                    : null,
                recipe.notes != "" ? NotesSection(notes: recipe.notes) : null,
                recipe.source != null && recipe.source != ""
                    ? Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 8, 8, 8),
                                          child: Icon(
                                            Icons.cloud_circle,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  450
                                              ? 350
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                          child: RichText(
                                              text: TextSpan(
                                            text: recipe.source,
                                            style:
                                                TextStyle(color: Colors.blue),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                launch(recipe.source);
                                              },
                                          )),
                                        )
                                      ]),
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xff212121),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                )),
                          ),
                        ),
                      )
                    : null,
                recipe.categories.length > 0
                    ? CategoriesSection(
                        categories: recipe.categories,
                        categoriesFiles: categoriesFiles)
                    : null,
                recipe.nutritions.isEmpty ? Container() : Container(height: 50),
              ]..removeWhere((item) => item == null)),
            ),
          )
        ],
      ),
    );
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

  void _choiceAction(PopupOptions value, context) {
    if (value == PopupOptions.EXPORT_TEXT) {
      Share.share(_getRecipeAsString(recipe, context), subject: 'recipe');
    } else if (value == PopupOptions.EXPORT_ZIP) {
      exportRecipe(recipe).then((_) {});
    }
  }

  _showDeleteDialog(BuildContext context, String recipeName) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(I18n.of(context).delete_recipe),
        content: Text(I18n.of(context).sure_you_want_to_delete_this_recipe +
            " $recipeName"),
        actions: <Widget>[
          FlatButton(
            child: Text(I18n.of(context).no),
            textColor: Theme.of(context).textTheme.body1.color,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text(I18n.of(context).yes),
            textColor: Theme.of(context).textTheme.body1.color,
            color: Colors.red[600],
            onPressed: () {
              if (recipe != null) {
                BlocProvider.of<RecipeManagerBloc>(context)
                    .add(RMDeleteRecipe(recipe.name, deleteFiles: true));
                Future.delayed(Duration(milliseconds: 60)).then((_) async {
                  await IO.deleteRecipeData(recipe.name);
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Future<bool> exportRecipe(Recipe recipe) async {
    String zipFilePath = await IO.saveRecipeZip(
        await PathProvider.pP.getShareDir(), recipe.name);

    ShareExtend.share(zipFilePath, "file",
        subject: stringReplaceSpaceUnderscore(recipe.name) + ".zip");

    return true;
  }

  String _getRecipeAsString(Recipe recipe, BuildContext context) {
    String recipeText = '${I18n.of(context).recipe_name}: ${recipe.name}\n'
            '====================\n'
            '${I18n.of(context).prep_time}: ${getTimeHoursMinutes(recipe.preperationTime)}\n'
            '${I18n.of(context).cook_time}: ${getTimeHoursMinutes(recipe.cookingTime)} min\n'
            '${I18n.of(context).total_time}: ${getTimeHoursMinutes(recipe.totalTime)} min\n'
            '====================\n' +
        (recipe.servings == null
            ? I18n.of(context).ingredients + ":"
            : '${I18n.of(context).ingredients_for} ${recipe.servings} ${I18n.of(context).servings}:\n');
    if (recipe.ingredientsGlossary.isNotEmpty) {
      for (int i = 0; i < recipe.ingredientsGlossary.length; i++) {
        recipeText +=
            '${I18n.of(context).ingredients}: ${recipe.ingredientsGlossary[i]}:\n';
        for (int j = 0; j < recipe.ingredients[i].length; j++) {
          recipeText += '${recipe.ingredients[i][j].name} '
              '${recipe.ingredients[i][j].amount ?? ""} '
              '${recipe.ingredients[i][j].unit ?? ""}\n';
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
      recipeText += '${I18n.of(context).notes}: ${recipe.notes}\n';
    }

    return recipeText;
  }
}

class TopSectionRecipe extends StatelessWidget {
  final double preperationTime;
  final double cookingTime;
  final double totalTime;
  final int effort;
  final List<StringIntTuple> recipeTags;

  const TopSectionRecipe({
    this.preperationTime,
    this.cookingTime,
    this.totalTime,
    this.effort,
    this.recipeTags,
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

    return Column(
      children: <Widget>[
        _showComplexTopArea(preperationTime, cookingTime, totalTime)
            ? Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 10,
                      child: Column(
                        children: <Widget>[
                          preperationTime != 0
                              ? Row(
                                  children: <Widget>[
                                  Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black45,
                                          blurRadius: 2.0,
                                          spreadRadius: 1.0,
                                          offset: Offset(
                                            0,
                                            1.0,
                                          ),
                                        ),
                                      ],
                                      color: Colors.pink,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Icon(
                                      MdiIcons.knife,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "${I18n.of(context).prep_time}:",
                                        style: TextStyle(
                                          color: textColor,
                                          fontFamily: recipeScreenFontFamily,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        getTimeHoursMinutes(preperationTime),
                                        style: TextStyle(
                                          color: textColor,
                                          fontFamily: recipeScreenFontFamily,
                                          fontSize: 16,
                                        ),
                                      )
                                    ],
                                  )
                                ]..removeWhere((item) => item == null))
                              : null,
                          SizedBox(height: 10),
                          cookingTime != 0
                              ? Row(
                                  children: <Widget>[
                                    Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.lightBlue,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black45,
                                            blurRadius: 2.0,
                                            spreadRadius: 1.0,
                                            offset: Offset(
                                              0,
                                              1.0,
                                            ),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Icon(
                                        MdiIcons.stove,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${I18n.of(context).cook_time}:",
                                          style: TextStyle(
                                            color: textColor,
                                            fontFamily: recipeScreenFontFamily,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          getTimeHoursMinutes(cookingTime),
                                          style: TextStyle(
                                            color: textColor,
                                            fontFamily: recipeScreenFontFamily,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              : null,
                          SizedBox(height: 10),
                          remainingTimeChart == 0
                              ? null
                              : Row(
                                  children: <Widget>[
                                  Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black45,
                                          blurRadius: 2.0,
                                          spreadRadius: 1.0,
                                          offset: Offset(
                                            0,
                                            1.0,
                                          ),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Icon(
                                      Icons.hourglass_empty,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  remainingTimeChart != 0
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "${I18n.of(context).remaining_time}:",
                                              style: TextStyle(
                                                color: textColor,
                                                fontFamily:
                                                    recipeScreenFontFamily,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              getTimeHoursMinutes(
                                                  remainingTimeChart),
                                              style: TextStyle(
                                                color: textColor,
                                                fontFamily:
                                                    recipeScreenFontFamily,
                                                fontSize: 16,
                                              ),
                                            )
                                          ],
                                        )
                                      : null
                                ]..removeWhere((item) => item == null))
                        ]..removeWhere((item) => item == null),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${I18n.of(context).total_time}:",
                            style: TextStyle(
                              color: textColor,
                              fontFamily: recipeScreenFontFamily,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            getTimeHoursMinutes(totalTimeChart),
                            style: TextStyle(
                              color: textColor,
                              fontFamily: recipeScreenFontFamily,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 7),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ClipPath(
                              clipper: RoundTopBottomClipper(),
                              child: TweenAnimationBuilder(
                                duration: Duration(milliseconds: 700),
                                curve: Curves.easeInOut,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black45,
                                            blurRadius: 2.0,
                                            spreadRadius: 1.0,
                                            offset: Offset(
                                              0,
                                              1.0,
                                            ),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.yellow,
                                      ),
                                    ),
                                    Container(
                                      height: (cookingTime + preperationTime) /
                                          totalTimeChart *
                                          100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Container(
                                      height: preperationTime /
                                          totalTimeChart *
                                          100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.pink,
                                      ),
                                    )
                                  ],
                                ),
                                tween: Tween<double>(begin: 10, end: 100),
                                builder: (_, double height, myChild) => Column(
                                  children: <Widget>[
                                    Container(height: 100 - height, width: 20),
                                    Container(
                                        width: 20,
                                        height: height,
                                        child: myChild),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: <Widget>[
                          Text(I18n.of(context).complexity + ':',
                              style: TextStyle(
                                fontSize: 15,
                                color: textColor,
                                fontFamily: recipeScreenFontFamily,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 2.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(
                                      0,
                                      1.0,
                                    ),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: WaveWidget(
                                  config: CustomConfig(
                                    gradients: [
                                      [Colors.red, Color(0xEEF44336)],
                                      [Colors.red[800], Color(0x77E57373)],
                                      [Colors.orange, Color(0x66FF9800)],
                                      [Colors.yellow, Color(0x55FFEB3B)]
                                    ],
                                    durations: [35000, 19440, 10800, 6000],
                                    heightPercentages: [
                                      effort == 10 ? 0 : (9 - effort) / 10,
                                      effort == 10 ? 0 : (9 - effort) / 10,
                                      effort == 10 ? 0 : (9 - effort) / 10,
                                      effort == 10 ? 0 : (9 - effort) / 10,
                                    ],
                                    blur: MaskFilter.blur(BlurStyle.solid, 10),
                                    gradientBegin: Alignment.bottomLeft,
                                    gradientEnd: Alignment.topRight,
                                  ),
                                  waveAmplitude: 0,
                                  backgroundColor: Colors.blue,
                                  size: Size(
                                    double.infinity,
                                    double.infinity,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                color: Colors.grey[800]),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
                              child: Text(
                                _getTimeString(
                                  preperationTime,
                                  cookingTime,
                                  totalTime,
                                  context,
                                ),
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
                        padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
                        child: Text(
                          "${I18n.of(context).complexity}: $effort",
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
              ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15.0),
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            runSpacing: 10,
            spacing: 10,
            children: List<Widget>.generate(
              recipeTags.length,
              (index) => InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RouteNames.recipeTagOverview,
                    arguments: RecipeGridViewArguments(
                      recipeTag: recipeTags[index],
                      shoppingCartBloc:
                          BlocProvider.of<ShoppingCartBloc>(context),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Color(recipeTags[index].number)),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
                    child: Text(
                      recipeTags[index].text,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: recipeScreenFontFamily,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
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

  String _getTimeString(double preperationTime, double cookingTime,
      double totalTime, BuildContext context) {
    if (totalTime != 0)
      return "${I18n.of(context).total_time}: " + cutDouble(totalTime);
    if (cookingTime != 0)
      return "${I18n.of(context).cook_time}: " + cutDouble(cookingTime);
    return "${I18n.of(context).prep_time}: " + cutDouble(preperationTime);
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

void _showPictureFullView(String image, String tag, BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoView(
          initialIndex: 0,
          galleryImagePaths: [image],
          descriptions: [''],
          heroTags: [tag],
        ),
      ));
}

class CategoriesSection extends StatelessWidget {
  final List<String> categories;
  final List<String> categoriesFiles;

  CategoriesSection({
    this.categories,
    this.categoriesFiles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 30, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              I18n.of(context).categories,
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontFamily: recipeScreenFontFamily,
              ),
            ),
            SizedBox(height: 25),
            Wrap(
              children: List<Widget>.generate(
                  categories.length,
                  (index) => categoriesFiles.isEmpty
                      ? CircularProgressIndicator()
                      : CategoryCircle(
                          categoryName: categories[index],
                          imageName: categoriesFiles[index],
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.recipeCategories,
                              arguments: RecipeGridViewArguments(
                                category: categories[index] == null
                                    ? Constants.noCategory
                                    : categories[index],
                                shoppingCartBloc:
                                    BlocProvider.of<ShoppingCartBloc>(context),
                              ),
                            );
                          },
                        )),
              runSpacing: 10.0,
              spacing: 10.0,
            ),
          ],
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) return Container();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff672B00),
            Color(0xff3A1900),
          ],
        ),
      ),
      child: Column(
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
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          I18n.of(context).directions,
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
          AnimatedStepper(
            steps,
            stepImages: stepImages,
            fontFamily: recipeScreenFontFamily,
            lowResStepImages: stepPreviewImages,
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}

class IngredientsScreen extends StatelessWidget {
  final Recipe currentRecipe;
  final MyIntWrapper animationWaitTime;
  final List<Ingredient> addToCartIngredients;

  const IngredientsScreen({
    Key key,
    @required this.currentRecipe,
    // needs to be initialized with 0
    @required this.animationWaitTime,
    // needs to be initialized with an empty list
    @required this.addToCartIngredients,
  }) : super(key: key);

  List<Widget> getIngredientsSection(List<CheckableIngredient> ingredients,
      bool oneSection, BuildContext context) {
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LikeButton(
                    circleColor: CircleColor(
                        start: Colors.green[300], end: Colors.green[800]),
                    bubblesColor: BubblesColor(
                        dotPrimaryColor: Colors.green[200],
                        dotSecondaryColor: Colors.green[600],
                        dotLastColor: Colors.green[900]),
                    animationDuration: Duration(milliseconds: 500),
                    isLiked: currentIngredient.checked,
                    likeBuilder: (bool isFavorite) {
                      return Icon(
                        isFavorite
                            ? Icons.check_circle
                            : Icons.add_circle_outline,
                        color: isFavorite ? Colors.green : Colors.white,
                      );
                    },
                    onTap: (bool isFavorite) async {
                      if (!isFavorite) {
                        _pressIngredient(currentIngredient, context);
                        return true;
                      } else {
                        _pressIngredient(
                            currentIngredient.copyWith(checked: true), context);
                        return false;
                      }
                    },
                  ),
                ),
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
  void _pressIngredient(
      CheckableIngredient ingredient, BuildContext context) async {
    if (ingredient.checked) {
      Future.delayed(Duration(milliseconds: animationWaitTime.myInt)).then(
          (_) => BlocProvider.of<RecipeScreenIngredientsBloc>(context).add(
                RemoveFromCart(
                    currentRecipe.name, [ingredient.getIngredient()]),
              ));
    } else {
      addToCartIngredients.add(ingredient.getIngredient());
      animationWaitTime.myInt += 500;
      await Future.delayed(Duration(milliseconds: 500));
      animationWaitTime.myInt -= 500;
      if (animationWaitTime.myInt > 0) {
        return;
      }

      BlocProvider.of<RecipeScreenIngredientsBloc>(context).add(
        AddToCart(currentRecipe.name, addToCartIngredients),
      );
    }
  }

  List<Widget> getIngredientsData(List<List<CheckableIngredient>> ingredients,
      List<bool> sectionCheck, BuildContext context) {
    List<Widget> output = [];
    bool oneSection = ingredients.isEmpty;

    for (int i = 0; i < ingredients.length; i++) {
      // for (int i = 0; i < widget.currentRecipe.ingredientsGlossary.length; i++) {
      List<CheckableIngredient> sectionIngredients = ingredients[i];
      output.add(
        Padding(
          padding: EdgeInsets.only(
            top: oneSection ? 5 : 15,
            left: 45,
            right: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                  "${currentRecipe.ingredientsGlossary.isNotEmpty ? currentRecipe.ingredientsGlossary[i] : ''}",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontFamily: recipeScreenFontFamily,
                  )),
              IconButton(
                icon: sectionCheck[i]
                    ? Icon(Icons.shopping_cart)
                    : Icon(Icons.add_shopping_cart),
                tooltip: I18n.of(context).add_to_cart,
                onPressed: () {
                  _pressAddSection(
                      sectionIngredients
                          .map((ingred) => ingred.getIngredient())
                          .toList(),
                      sectionCheck[i],
                      context);
                },
                color: sectionCheck[i] ? Colors.green : textColor,
              )
            ],
          ),
        ),
      );

      output.addAll(getIngredientsSection(ingredients[i], oneSection, context));
    }

    return output;
  }

  void _pressAddSection(
      List<Ingredient> ingredients, bool isChecked, BuildContext context) {
    if (isChecked) {
      BlocProvider.of<RecipeScreenIngredientsBloc>(context)
          .add(RemoveFromCart(currentRecipe.name, ingredients));
    } else {
      BlocProvider.of<RecipeScreenIngredientsBloc>(context)
          .add(AddToCart(currentRecipe.name, ingredients));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Ingredient> allIngredients =
        flattenIngredients(currentRecipe.ingredients);
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
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: state.servings == null
                            ? [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: Text(
                                    I18n.of(context).ingredients,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: headingSize,
                                      fontFamily: recipeScreenFontFamily,
                                    ),
                                  ),
                                )
                              ]
                            : <Widget>[
                                Text(
                                  I18n.of(context).ingredients_for,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: headingSize,
                                    fontFamily: recipeScreenFontFamily,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline,
                                      color: Colors.white),
                                  tooltip: I18n.of(context).decrease_servings,
                                  onPressed: () {
                                    _decreaseServings(state.servings, context);
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
                                  tooltip: I18n.of(context).increase_servings,
                                  onPressed: () {
                                    _increaseServings(state.servings, context);
                                  },
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    I18n.of(context).servings,
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
                getIngredientsData(
                    state.ingredients, state.sectionCheck, context),
              ),
          );
        } else {
          return Text(state.toString());
        }
      },
    );
  }

  void _decreaseServings(double oldServings, BuildContext context) {
    if (oldServings <= 1) return;
    BlocProvider.of<RecipeScreenIngredientsBloc>(context)
        .add(DecreaseServings(oldServings - 1));
  }

  void _increaseServings(double oldServings, BuildContext context) {
    BlocProvider.of<RecipeScreenIngredientsBloc>(context)
        .add(IncreaseServings(oldServings + 1));
  }
}

class Favorite extends StatelessWidget {
  final Recipe recipe;
  final double iconSize;
  final Function addFavorite;
  final Function removeFavorite;

  Favorite(
    this.recipe, {
    @required this.addFavorite,
    @required this.removeFavorite,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      size: iconSize == null ? 24 : iconSize,
      isLiked: HiveProvider().isRecipeFavorite(recipe.name),
      likeBuilder: (bool isFavorite) {
        return Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.pink : Colors.white,
        );
      },
      onTap: (bool isFavorite) async {
        if (!isFavorite) {
          addFavorite();
          return true;
        } else {
          removeFavorite();
          return false;
        }
      },
    );
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

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}

class RoundEdgeShoppingCartClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0.0, 240)
      ..quadraticBezierTo(10, 200, 50, 200)
      ..lineTo(size.width - 50, 200)
      ..quadraticBezierTo(size.width - 10, 200, size.width, 240)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class RoundTopBottomClipper extends CustomClipper<Path> {
  RoundTopBottomClipper();

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.width / 2)
      ..arcToPoint(
        Offset(size.width, size.width / 2),
        clockwise: true,
        radius: Radius.circular(size.width / 2),
      )
      ..lineTo(size.width, size.height - size.width / 2)
      ..arcToPoint(
        Offset(0, size.height - size.width / 2),
        clockwise: true,
        radius: Radius.circular(size.width / 2),
      )
      ..lineTo(0, size.width / 2);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(RoundTopBottomClipper oldClipper) => true;
}
