import 'dart:io';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:like_button/like_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/widgets/clipper.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share/share.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ad_related/ad.dart';
import '../blocs/ad_manager/ad_manager_bloc.dart';
import '../blocs/animated_stepper/animated_stepper_bloc.dart';
import '../blocs/recipe_bubble/recipe_bubble_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/recipe_screen/recipe_screen_bloc.dart';
import '../blocs/recipe_screen_ingredients/recipe_screen_ingredients_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as Constants;
import '../constants/global_settings.dart';
import '../constants/routes.dart';
import '../generated/i18n.dart';
import '../util/helper.dart';
import '../local_storage/hive.dart';
import '../local_storage/io_operations.dart' as IO;
import '../local_storage/local_paths.dart';
import '../models/enums.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/string_int_tuple.dart';
import '../util/my_wrapper.dart';
import '../util/pdf_share.dart';
import '../screens/recipe_overview.dart';
import '../widgets/animated_stepper.dart';
import '../widgets/animated_vegetable.dart';
import '../widgets/category_circle_image.dart';
import '../widgets/gallery_view.dart';
import '../widgets/icon_info_message.dart';
import '../widgets/recipe_info_vertical.dart';
import '../widgets/recipe_screen/complexity_wave.dart';
import '../widgets/recipe_screen/recipe_tag_wrap.dart';
import '../widgets/recipe_screen/time_complexity_compressed.dart';
import '../widgets/recipe_screen/time_info.dart';
import '../widgets/recipe_screen/time_info_chart.dart';
import 'add_recipe/general_info_screen/general_info_screen.dart';

const double timeTextsize = 15;
const double timeText = 17;
const double paddingBottomTime = 5;
const double headingSize = 19;
const Color textColor = Colors.white;
const String recipeScreenFontFamily = 'Roboto';

const Map<Vegetable, List<int>> vegetableColor = {
  Vegetable.NON_VEGETARIAN: [0xff520808, 0xff400303],
  Vegetable.VEGETARIAN: [0xff1A490A, 0xff193F0B],
  Vegetable.VEGAN: [0xff144E00, 0xff0F3800]
};

enum PopupOptionsMore { DELETE, SHARE, PRINT }
enum PopupOptionsShare { EXPORT_ZIP, EXPORT_TEXT, EXPORT_PDF }

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
    // if (_pc.isAttached) _pc.close();

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
            if (adState is ShowAds && ModalRoute.of(context).isCurrent) {
              Navigator.popAndPushNamed(
                context,
                RouteNames.recipeScreen,
                arguments: RecipeScreenArguments(
                    BlocProvider.of<ShoppingCartBloc>(context),
                    state.recipe,
                    "",
                    BlocProvider.of<RecipeManagerBloc>(context),
                    initialScrollOffset: _scrollController.hasClients
                        ? _scrollController?.offset
                        : null,
                    initialSelectedStep:
                        (BlocProvider.of<AnimatedStepperBloc>(context).state
                                as SelectedStep)
                            .selectedStep),
              ).then((_) => Ads.hideBottomBannerAd());
              Future.delayed(Duration(seconds: 3))
                  .then((_) => Ads.showBottomBannerAd());
            }
          },
          child: state.recipe.nutritions.isEmpty
              ? Scaffold(
                  //##
                  appBar: MediaQuery.of(context).size.width > 550
                      ? MyGradientAppBar(state.recipe)
                      : null,
                  body: RecipePage(
                    recipe: state.recipe,
                    heroImageTag: widget.heroImageTag,
                    scrollController: _scrollController,
                    categoriesFiles: state.categoryImages,
                  ),
                )
              : Scaffold(
                  appBar: MediaQuery.of(context).size.width > 550
                      ? MyGradientAppBar(state.recipe)
                      : null,
                  body: SlidingUpPanel(
                    renderPanelSheet: false,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width > 450
                          ? (MediaQuery.of(context).size.width - 450) / 2
                          : 0,
                      right: MediaQuery.of(context).size.width > 450
                          ? (MediaQuery.of(context).size.width - 450) / 2
                          : 0,
                    ),
                    controller: _pc,
                    backdropColor: Color.fromRGBO(0, 0, 0, 0.5),
                    backdropEnabled: true,
                    // margin: EdgeInsets.only(left: 20, right: 20),
                    parallaxEnabled:
                        MediaQuery.of(context).size.width > 450 ? false : true,
                    parallaxOffset: 0.5,
                    minHeight: 50,
                    maxHeight: MediaQuery.of(context).size.height -
                                kToolbarHeight -
                                30 >
                            450
                        ? 480
                        : MediaQuery.of(context).size.height -
                            kToolbarHeight -
                            30,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),

                    panel: ClipPath(
                      clipper: NutritionDraggableClipper(),
                      child: Container(
                        width: 50,
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
                        ),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: 20),
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
                                      height: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  kToolbarHeight -
                                                  88 >
                                              377
                                          ? 377
                                          : MediaQuery.of(context).size.height -
                                              kToolbarHeight -
                                              133,
                                      child: ListView.builder(
                                        itemCount:
                                            state.recipe.nutritions.length * 2,
                                        itemBuilder: (context, index) {
                                          if ((index - 1) % 2 == 0) {
                                            return Divider();
                                          } else {
                                            int nutritionIndex =
                                                (index / 2).round();
                                            return ListTile(
                                              leading: Icon(MdiIcons.gateOr,
                                                  color: Colors.white),
                                              title: Text(
                                                state
                                                    .recipe
                                                    .nutritions[nutritionIndex]
                                                    .name,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              trailing: Text(
                                                state
                                                    .recipe
                                                    .nutritions[nutritionIndex]
                                                    .amountUnit,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    )
                                  ]),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, right: 40),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    _pc.animatePanelToPosition(1);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    width: 80,
                                    height: 50,
                                    child: Center(
                                      child: Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    body: RecipePage(
                      recipe: state.recipe,
                      heroImageTag: widget.heroImageTag,
                      scrollController: _scrollController,
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
    return Center(
      child: Container(
          width: MediaQuery.of(context).size.width > 450
              ? 450
              : MediaQuery.of(context).size.width,
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
          )),
    );
  }
}

class MyGradientAppBar extends StatelessWidget with PreferredSizeWidget {
  final Recipe recipe;

  MyGradientAppBar(
    this.recipe, {
    Key key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return GradientAppBar(
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
                  if (isPinned == false && state.recipes.length == 3) {
                    final scaffold = Scaffold.of(context);
                    scaffold.hideCurrentSnackBar();

                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(
                            I18n.of(context).maximum_recipe_pin_count_exceeded),
                        action: SnackBarAction(
                          label: I18n.of(context).dismiss,
                          onPressed: scaffold.hideCurrentSnackBar,
                        ),
                      ),
                    );
                  } else if (isPinned) {
                    BlocProvider.of<RecipeBubbleBloc>(context)
                        .add(RemoveRecipeBubble([recipe]));
                  } else {
                    BlocProvider.of<RecipeBubbleBloc>(context)
                        .add(AddRecipeBubble([recipe]));

                    final scaffold = Scaffold.of(context);
                    scaffold.hideCurrentSnackBar();

                    scaffold.showSnackBar(
                      SnackBar(
                        content:
                            Text(I18n.of(context).recipe_pinned_to_overview),
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
            Ads.hideBottomBannerAd();

            HiveProvider().saveTmpEditingRecipe(recipe).then((_) {
              BlocProvider.of<AdManagerBloc>(context).add(LoadVideo());
              Navigator.pushNamed(
                context,
                RouteNames.addRecipeGeneralInfo,
                arguments: GeneralInfoArguments(
                  recipe,
                  BlocProvider.of<ShoppingCartBloc>(context),
                  editingRecipeName: recipe.name,
                ),
              );
            });
          },
        ),
        PopupMenuButton<PopupOptionsMore>(
          icon: Icon(Icons.more_vert),
          onSelected: (value) => _choiceActionMore(value, context),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: PopupOptionsMore.DELETE,
                child: Row(children: [
                  Icon(Icons.delete,
                      color: Theme.of(context).backgroundColor == Colors.white
                          ? Colors.grey
                          : Colors.white),
                  SizedBox(width: 10),
                  Text(I18n.of(context).delete_recipe)
                ]),
              ),
              PopupMenuItem(
                value: PopupOptionsMore.SHARE,
                child: Row(children: [
                  Icon(Icons.share,
                      color: Theme.of(context).backgroundColor == Colors.white
                          ? Colors.grey
                          : Colors.white),
                  SizedBox(width: 10),
                  Text(I18n.of(context).share_recipe)
                ]),
              ),
              PopupMenuItem(
                value: PopupOptionsMore.PRINT,
                child: Row(children: [
                  Icon(Icons.print,
                      color: Theme.of(context).backgroundColor == Colors.white
                          ? Colors.grey
                          : Colors.white),
                  SizedBox(width: 10),
                  Text(I18n.of(context).print_recipe)
                ]),
              ),
            ];
          },
        ),
      ],
    );
  }

  void _choiceActionMore(PopupOptionsMore value, context) async {
    if (value == PopupOptionsMore.DELETE) {
      _showDeleteDialog(context, recipe.name);
    } else if (value == PopupOptionsMore.PRINT) {
      getRecipePdf(recipe, context).then((pdf) =>
          Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf));
    } else if (value == PopupOptionsMore.SHARE) {
      await showMenu<PopupOptionsShare>(
        context: context,
        position: RelativeRect.fromLTRB(1000, 25, 0, 0),
        items: [
          PopupMenuItem(
            value: PopupOptionsShare.EXPORT_TEXT,
            child: getMenuListItem(
              I18n.of(context).export_text,
              Icon(MdiIcons.formatColorText),
              PopupOptionsShare.EXPORT_TEXT,
              context,
            ),
          ),
          PopupMenuItem(
            value: PopupOptionsShare.EXPORT_ZIP,
            child: getMenuListItem(
              I18n.of(context).export_zip,
              Icon(MdiIcons.package),
              PopupOptionsShare.EXPORT_ZIP,
              context,
            ),
          ),
          PopupMenuItem(
            value: PopupOptionsShare.EXPORT_PDF,
            child: getMenuListItem(
              I18n.of(context).export_pdf,
              Icon(MdiIcons.fileDocument),
              PopupOptionsShare.EXPORT_PDF,
              context,
            ),
          ),
        ],
        elevation: 8.0,
      );
    }
  }

  Widget getMenuListItem(
    String description,
    Icon leadingIcon,
    PopupOptionsShare option,
    BuildContext context,
  ) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        _choiceActionShare(option, context);
      },
      child: Container(
          height: 60,
          width: 250,
          child: Center(
            child: Row(
              children: <Widget>[
                leadingIcon,
                SizedBox(width: 12),
                Text(description),
              ],
            ),
          )),
    );
  }

  void _choiceActionShare(PopupOptionsShare value, context) {
    if (value == PopupOptionsShare.EXPORT_TEXT) {
      Share.share(_getRecipeAsString(recipe, context),
          subject: stringReplaceSpaceUnderscore(recipe.name));
    } else if (value == PopupOptionsShare.EXPORT_ZIP) {
      _exportRecipe(recipe).then((_) {});
    } else if (value == PopupOptionsShare.EXPORT_PDF) {
      getRecipePdf(recipe, context).then((pdf) => Printing.sharePdf(
          bytes: pdf,
          filename: '${stringReplaceSpaceUnderscore(recipe.name)}.pdf'));
    }
  }

  Future<bool> _exportRecipe(Recipe recipe) async {
    String zipFilePath = await IO.saveRecipeZip(
        await PathProvider.pP.getShareDir(), recipe.name);

    ShareExtend.share(zipFilePath, "file",
        subject: stringReplaceSpaceUnderscore(recipe.name) + ".zip");

    return true;
  }

  void _showDeleteDialog(BuildContext context, String recipeName) {
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
            textColor: Theme.of(context).textTheme.bodyText1.color,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text(I18n.of(context).yes),
            textColor: Theme.of(context).textTheme.bodyText1.color,
            color: Colors.red[600],
            onPressed: () {
              if (recipe != null) {
                Navigator.pop(context);
                Navigator.pop(context);
                BlocProvider.of<RecipeManagerBloc>(context)
                    .add(RMDeleteRecipe(recipe.name, deleteFiles: true));
                Future.delayed(Duration(milliseconds: 60)).then((_) async {
                  await IO.deleteRecipeData(recipe.name);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  String _getRecipeAsString(Recipe recipe, BuildContext context) {
    String recipeText = '${I18n.of(context).recipe_name}: ${recipe.name}\n';
    if (recipe.preperationTime != 0 ||
        recipe.cookingTime != 0 ||
        recipe.totalTime != 0) recipeText += '====================\n';
    if (recipe.preperationTime != 0)
      recipeText +=
          '${I18n.of(context).prep_time}: ${getTimeHoursMinutes(recipe.preperationTime)}\n';
    if (recipe.cookingTime != 0)
      recipeText +=
          '${I18n.of(context).cook_time}: ${getTimeHoursMinutes(recipe.cookingTime)} min\n';
    if (recipe.totalTime != 0)
      recipeText +=
          '${I18n.of(context).total_time}: ${getTimeHoursMinutes(recipe.totalTime)} min\n'
                  '====================\n' +
              (recipe.servings == null
                  ? I18n.of(context).ingredients + ":"
                  : '${I18n.of(context).ingredients_for} ${recipe.servings} ${recipe.servingName ?? I18n.of(context).servings}:\n');
    if (recipe.ingredientsGlossary.isNotEmpty) {
      for (int i = 0; i < recipe.ingredientsGlossary.length; i++) {
        recipeText +=
            '${I18n.of(context).ingredients}: ${recipe.ingredientsGlossary[i]}:\n';
        for (int j = 0; j < recipe.ingredients[i].length; j++) {
          recipeText += '${recipe.ingredients[i][j].amount ?? ""} '
              '${recipe.ingredients[i][j].unit ?? ""} '
              '${recipe.ingredients[i][j].name}\n';
        }
        recipeText += '====================\n';
      }
    } else if (recipe.ingredients.first.isNotEmpty) {
      for (int j = 0; j < recipe.ingredients.first.length; j++) {
        recipeText += '${recipe.ingredients.first[j].amount} '
            '${recipe.ingredients.first[j].unit ?? ""} '
            '${recipe.ingredients.first[j].unit ?? ""}\n';
      }
      recipeText += '====================\n';
    }

    int i = 1;
    for (final String step in recipe.steps) {
      recipeText += '$i. $step\n';
      i++;
    }
    if (recipe.tags != null && recipe.tags.isNotEmpty) {
      recipeText += '====================\n${I18n.of(context).tags}: ';
      for (StringIntTuple tag in recipe.tags) {
        if (!(tag == recipe.tags.last)) {
          recipeText += '${tag.text}, ';
        } else {
          recipeText += '${tag.text}';
        }
      }
    }
    if (recipe.notes != null && recipe.notes != '') {
      recipeText += '====================\n';
      recipeText += '${I18n.of(context).notes}: ${recipe.notes}\n';
    }
    if (recipe.source != null && recipe.source != '') {
      recipeText += '====================\n';
      recipeText += '${I18n.of(context).source}: ${recipe.source}\n';
    }

    return recipeText;
  }
}

class RecipePage extends StatelessWidget {
  final Recipe recipe;
  final String heroImageTag;
  final List<String> categoriesFiles;
  final ScrollController scrollController;

  RecipePage({
    @required this.recipe,
    this.heroImageTag,
    this.categoriesFiles,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MediaQuery.of(context).size.width > 550
              ? Container(
                  width: (MediaQuery.of(context).size.width * 0.4 > 350)
                      ? 350
                      : MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                  ),
                  child: RecipeInfoVertical(
                    recipe,
                    (MediaQuery.of(context).size.width * 0.45 > 350)
                        ? 350
                        : MediaQuery.of(context).size.width * 0.45,
                    categoriesFiles,
                    heroImageTag,
                  ),
                )
              : null,
          MediaQuery.of(context).size.width > 1000
              ? Container(
                  height: double.infinity,
                  width: 370,
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
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: IngredientsScreen(
                          currentRecipe: recipe,
                          animationWaitTime: MyIntWrapper(0),
                          addToCartIngredients: [],
                        ),
                      ),
                    ],
                  ),
                )
              : null,
          MediaQuery.of(context).size.width > 1000
              ? Expanded(
                  child: Container(
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
                    child: ListView(
                      children: <Widget>[
                        StepsSection(
                          recipe.steps,
                          recipe.stepImages,
                          recipe.name,
                          recipe.nutritions.isNotEmpty,
                          expandHeight: true,
                        ),
                      ],
                    ),
                  ),
                )
              : null,
          MediaQuery.of(context).size.width > 1000
              ? null
              : Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: MediaQuery.of(context).size.width > 550
                          ? null
                          : Color(0xff51473b),
                      gradient: MediaQuery.of(context).size.width > 550
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xff672B00),
                                Color(0xff3A1900),
                              ],
                            )
                          : null,
                    ),
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: <Widget>[
                        MediaQuery.of(context).size.width > 550
                            ? null
                            : SliverAppBar(
                                flexibleSpace: MyGradientAppBar(recipe),
                                floating: true,
                              ),
                        SliverList(
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
                                MediaQuery.of(context).size.width > 550
                                    ? null
                                    : GestureDetector(
                                        onTap: () {
                                          _showPictureFullView(recipe.imagePath,
                                              heroImageTag, context);
                                        },
                                        child: Container(
                                          height: 270,
                                          child: Stack(children: <Widget>[
                                            Hero(
                                              tag: GlobalSettings()
                                                      .animationsEnabled()
                                                  ? heroImageTag
                                                  : "heroImageTag2",
                                              child: Material(
                                                color: Colors.transparent,
                                                child: ClipPath(
                                                  clipper: MyClipper(),
                                                  child: Container(
                                                      height: 250,
                                                      child: recipe.imagePath ==
                                                              Constants
                                                                  .noRecipeImage
                                                          ? Image.asset(
                                                              Constants
                                                                  .noRecipeImage,
                                                              width: double
                                                                  .infinity,
                                                              fit: BoxFit.cover)
                                                          : Image.file(
                                                              File(recipe
                                                                  .imagePath),
                                                              width: double
                                                                  .infinity,
                                                              fit: BoxFit
                                                                  .cover)),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0, right: 8.0),
                                                child: AnimatedVegetable(
                                                    recipe.vegetable),
                                              ),
                                            )
                                          ]),
                                        ),
                                      ),
                                MediaQuery.of(context).size.width > 550
                                    ? null
                                    : Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              0,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              0),
                                          child: Text(
                                            recipe.name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: 27,
                                              fontFamily:
                                                  recipeScreenFontFamily,
                                            ),
                                          ),
                                        ),
                                      ),
                                MediaQuery.of(context).size.width > 550
                                    ? null
                                    : SizedBox(height: 30),
                                MediaQuery.of(context).size.width > 550
                                    ? null
                                    : Center(
                                        child: TopSectionRecipe(
                                          preperationTime:
                                              recipe.preperationTime,
                                          cookingTime: recipe.cookingTime,
                                          totalTime: recipe.totalTime,
                                          effort: recipe.effort,
                                          recipeTags: recipe.tags,
                                        ),
                                      ),
                                MediaQuery.of(context).size.width > 550
                                    ? null
                                    : SizedBox(height: 20),
                                IngredientsScreen(
                                  currentRecipe: recipe,
                                  animationWaitTime: MyIntWrapper(0),
                                  addToCartIngredients: [],
                                ),
                                SizedBox(height: 30),
                              ]..removeWhere((item) => item == null)),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient:
                                    MediaQuery.of(context).size.width <= 550
                                        ? LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xff672B00),
                                              Color(0xff3A1900),
                                            ],
                                          )
                                        : null,
                              ),
                              child: StepsSection(
                                recipe.steps,
                                recipe.stepImages,
                                recipe.name,
                                recipe.nutritions.isNotEmpty,
                              ),
                            ),
                            (recipe.notes != "" ||
                                        recipe.categories.isNotEmpty ||
                                        recipe.source != null) &&
                                    MediaQuery.of(context).size.width <= 550
                                ? Container(
                                    height: 20,
                                    decoration:
                                        BoxDecoration(color: Colors.black87),
                                  )
                                : null,
                            recipe.notes != "" &&
                                    MediaQuery.of(context).size.width <= 550
                                ? NotesSection(notes: recipe.notes)
                                : null,
                            recipe.source != null &&
                                    recipe.source != "" &&
                                    MediaQuery.of(context).size.width <= 550
                                ? RecipeSource(recipe.source)
                                : null,
                            recipe.categories.length > 0 &&
                                    MediaQuery.of(context).size.width <= 550
                                ? CategoriesSection(
                                    categories: recipe.categories,
                                    categoriesFiles: categoriesFiles)
                                : null,
                            recipe.nutritions.isEmpty
                                ? Container()
                                : Container(height: 50),
                          ]..removeWhere((item) => item == null)),
                        ),
                      ]..removeWhere((item) => item == null),
                    ),
                  ),
                ),
        ]..removeWhere((item) => item == null));
  }

  void _showPictureFullView(String image, String tag, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Ads().getAdPage(
          GalleryPhotoView(
            initialIndex: 0,
            galleryImagePaths: [image],
            descriptions: [''],
            heroTags: [tag],
          ),
          context,
        ),
      ),
    );
  }
}

class RecipeSource extends StatelessWidget {
  final String source;

  const RecipeSource(this.source, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                  child: Icon(
                    Icons.cloud_circle,
                  ),
                ),
                Expanded(
                  child: RichText(
                      text: TextSpan(
                    text: source,
                    style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch(source);
                      },
                  )),
                )
              ]),
            ),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            )),
      ),
    );
  }
}

class TopSectionRecipe extends StatelessWidget {
  final double preperationTime;
  final double cookingTime;
  final double totalTime;
  final int effort;
  final List<StringIntTuple> recipeTags;

  const TopSectionRecipe({
    this.preperationTime = 0,
    this.cookingTime = 0,
    this.totalTime = 0,
    this.effort,
    this.recipeTags,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width > 450
            ? 450
            : MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            _showComplexTopArea(preperationTime, cookingTime, totalTime)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      TimeInfo(
                        textColor,
                        recipeScreenFontFamily,
                        preperationTime,
                        totalTime,
                        cookingTime,
                      ),
                      Spacer(),
                      TimeInfoChart(
                        textColor,
                        preperationTime ?? 0,
                        cookingTime ?? 0,
                        totalTime ?? 0,
                        recipeScreenFontFamily,
                      ),
                      Spacer(),
                      ComplexityWave(
                        textColor,
                        recipeScreenFontFamily,
                        effort,
                      ),
                      Spacer(),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TimeComplexityCompressed(
                      preperationTime,
                      cookingTime,
                      totalTime,
                      effort,
                      recipeScreenFontFamily,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15.0),
              child: RecipeTagWrap(
                recipeTags,
                recipeScreenFontFamily,
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// method which determines if the circular chart and complexity termometer should be
/// shown or only a minimal version
bool _showComplexTopArea(
    double preperationTime, double cookingTime, double totalTime) {
  int validator = 0;

  if (preperationTime != 0 && preperationTime != null) validator++;
  if (cookingTime != 0 && cookingTime != null) validator++;
  if (totalTime != 0 && totalTime != null) validator++;
  if (preperationTime == totalTime || cookingTime == totalTime) return false;
  if (validator > 1) return true;
  return false;
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
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width > 450
            ? 450
            : MediaQuery.of(context).size.width,
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
                                      BlocProvider.of<ShoppingCartBloc>(
                                          context),
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
      ),
    );
  }
}

class StepsSection extends StatelessWidget {
  final List<List<String>> stepImages;
  final List<String> steps;
  final String recipeName;
  final bool expandHeight;
  final bool hasNutritions;

  final List<Color> stepsColors = [
    Color(0xff28B404),
    Color(0xff009BDE),
    Color(0xffE3B614),
    Color(0xff8600C5),
  ];

  StepsSection(
    this.steps,
    this.stepImages,
    this.recipeName,
    this.hasNutritions, {
    this.expandHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) return Container();
    return FutureBuilder<List<List<String>>>(
        future: PathProvider.pP
            .getRecipeStepPreviewPathList(stepImages, recipeName),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    height: 40,
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.3)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            I18n.of(context).directions,
                            style: TextStyle(
                              color: textColor,
                              fontSize: headingSize,
                              fontFamily: recipeScreenFontFamily,
                            ),
                          ),
                        ),
                      ),
                    )),
                SizedBox(height: 15),
                GlobalSettings().showStepsIntro() ? StepsIntro() : null,
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width > 500
                        ? 500
                        : MediaQuery.of(context).size.width,
                    child: AnimatedStepper(
                      steps,
                      stepImages: stepImages,
                      fontFamily: recipeScreenFontFamily,
                      lowResStepImages: snapshot.data,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                hasNutritions && MediaQuery.of(context).size.width > 550
                    ? Container(height: 80)
                    : Container(),
              ]..removeWhere((item) => item == null),
            );
          } else {
            return Container(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}

class StepsIntro extends StatefulWidget {
  StepsIntro({Key key}) : super(key: key);

  @override
  _StepsIntroState createState() => _StepsIntroState();
}

class _StepsIntroState extends State<StepsIntro> {
  bool show = true;

  @override
  Widget build(BuildContext context) {
    return show
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        I18n.of(context).steps_intro,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: recipeScreenFontFamily,
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: Icon(Icons.check, color: Colors.white),
                        onPressed: () {
                          SharedPreferences.getInstance().then(
                            (prefs) => setState(() {
                              prefs.setBool("showStepsIntro", false);
                              GlobalSettings().hasSeenStepIntro(true);
                              show = false;
                            }),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : Container();
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
                    likeBuilder: (bool isChecked) {
                      return Icon(
                        isChecked
                            ? Icons.check_circle
                            : Icons.add_circle_outline,
                        color: isChecked ? Colors.green : Colors.white,
                      );
                    },
                    onTap: (bool isChecked) async {
                      if (!isChecked) {
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
                Expanded(
                  child: Container(
                    child: Text(
                      currentIngredient.name,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: recipeScreenFontFamily,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 12,
                ),
                Container(
                  width: 80,
                  child: Text(
                    "${currentIngredient.amount == null ? "" : (cutDouble(currentIngredient.amount))} "
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
              Expanded(
                child: Text(
                    "${currentRecipe.ingredientsGlossary.isNotEmpty ? currentRecipe.ingredientsGlossary[i] : ''}",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontFamily: recipeScreenFontFamily,
                    )),
              ),
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
                      child: Center(
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
                                      _decreaseServings(
                                          state.servings, context);
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
                                      _increaseServings(
                                          state.servings, context);
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      currentRecipe.servingName ??
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
              ),
            ]..add(Center(
                child: Container(
                  width: 400,
                  child: Column(
                    children: getIngredientsData(
                        state.ingredients, state.sectionCheck, context),
                  ),
                ),
              )),
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
    path.lineTo(0.0, size.height * 0.8);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(
        size.width / 4 * 3, size.height, size.width, size.height * 0.8);
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
