import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/blocs/recipe_calendar/recipe_calendar_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wakelock/wakelock.dart';

import '../ad_related/ad.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as Constants;
import '../constants/global_settings.dart';
import '../constants/routes.dart';
import '../generated/i18n.dart';
import '../util/helper.dart';
import '../models/enums.dart';
import '../models/recipe.dart';
import '../screens/recipe_overview.dart';
import '../screens/recipe_screen.dart';

const Map<int, Color> complexityColors = {
  1: Color(0xff28E424),
  2: Color(0xff4ED220),
  3: Color(0xff33B51E),
  4: Color(0xff188E24),
  5: Color(0xff135B12),
  6: Color(0xff691A1A),
  7: Color(0xff892020),
  8: Color(0xffB51E1E),
  9: Color(0xffDC1818),
  10: Color(0xffFD0000)
};

FontWeight itemsFW = FontWeight.w400;

class RecipeCard extends StatelessWidget {
  final Recipe? recipe;
  final double width;
  final String heroImageTag;
  final bool activateVegetableHero;

  const RecipeCard({
    this.recipe,
    required this.width,
    required this.heroImageTag,
    this.activateVegetableHero = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (GlobalSettings().standbyDisabled()) {
          Wakelock.enable();
        }
        Navigator.pushNamed(
          context,
          RouteNames.recipeScreen,
          arguments: RecipeScreenArguments(
            BlocProvider.of<ShoppingCartBloc>(context),
            BlocProvider.of<RecipeCalendarBloc>(context),
            recipe,
            heroImageTag,
            BlocProvider.of<RecipeManagerBloc>(context),
          ),
        ).then((_) {
          Wakelock.disable();
          Ads.hideBottomBannerAd();
        });
      },
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]!.withAlpha(100)
                      : Colors.grey[100]!.withAlpha(200),
                  Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).cardColor.withAlpha(150)
                      : Colors.white.withAlpha(200),
                ],
              ),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  offset: Offset(2, 2),
                  blurRadius: 3,
                  spreadRadius: 1,
                  color: Colors.black26,
                ),
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: GlobalSettings().animationsEnabled()
                        ? heroImageTag
                        : "${heroImageTag}6",
                    child: Material(
                      color: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: FadeInImage(
                          image:
                              (recipe!.imagePreviewPath == Constants.noRecipeImage
                                  ? AssetImage(recipe!.imagePreviewPath)
                                  : FileImage(File(recipe!.imagePreviewPath))) as ImageProvider<Object>,
                          placeholder: MemoryImage(kTransparentImage),
                          fadeInDuration: Duration(milliseconds: 250),
                          fit: BoxFit.cover,
                          height: width - 40,
                          width: width + 80,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 7, 12, 12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: width - 12,
                            child: Text(
                              "${recipe!.name}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "Questrial",
                                fontWeight: FontWeight.w700,
                                fontSize: 10 + width / 35,
                              ),
                            ),
                          ),
                          SizedBox(height: 7),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: width - 27,
                                    child: Text(
                                      (recipe!.totalTime != null
                                              ? "${getTimeHoursMinutes(recipe!.totalTime)} • "
                                              : "") +
                                          ("${getIngredientCount(recipe!.ingredients)} ${I18n.of(context)!.ingredients}"),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontWeight: itemsFW,
                                        fontSize: 11,
                                        fontFamily: 'Questrial',
                                      ),
                                    ),
                                  ),
                                  Container(height: 12),
                                  Container(
                                    width: width - 27,
                                    height: 18,
                                    child: Row(
                                      children: List<Widget>.generate(5,
                                          (index) {
                                        if (recipe!.effort! >= (index + 1) * 2) {
                                          return Icon(
                                            MdiIcons.knife,
                                            size: 18,
                                            color: Theme.of(context)
                                                        .backgroundColor ==
                                                    Colors.white
                                                ? Colors.grey[400]
                                                : Colors.grey[200],
                                          );
                                        } else {
                                          if (recipe!.effort == index * 2 + 1) {
                                            return Stack(
                                              children: <Widget>[
                                                Container(
                                                  child: Icon(
                                                    MdiIcons.knife,
                                                    size: 18,
                                                    color: Theme.of(context)
                                                                .backgroundColor ==
                                                            Colors.white
                                                        ? Colors.grey[900]
                                                        : Colors.black,
                                                  ),
                                                ),
                                                ClipPath(
                                                  clipper:
                                                      LeftHalfVerticalClipper(),
                                                  child: ClipPath(
                                                    child: Icon(
                                                      MdiIcons.knife,
                                                      size: 18,
                                                      color: Theme.of(context)
                                                                  .backgroundColor ==
                                                              Colors.white
                                                          ? Colors.grey[400]
                                                          : Colors.grey[200],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Icon(
                                              MdiIcons.knife,
                                              size: 18,
                                              color: Theme.of(context)
                                                          .backgroundColor ==
                                                      Colors.white
                                                  ? Colors.grey[900]
                                                  : Colors.black,
                                            );
                                          }
                                        }
                                      })
                                        ..addAll([
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              if (activateVegetableHero)
                                                Navigator.pushNamed(
                                                  context,
                                                  RouteNames.vegetableRecipes,
                                                  arguments: RecipeGridViewArguments(
                                                      shoppingCartBloc: BlocProvider
                                                          .of<ShoppingCartBloc>(
                                                              context),
                                                      recipeCalendarBloc:
                                                          BlocProvider.of<
                                                                  RecipeCalendarBloc>(
                                                              context),
                                                      vegetable:
                                                          recipe!.vegetable),
                                                ).then((_) {
                                                  Ads.hideBottomBannerAd();
                                                });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: recipe!.vegetable ==
                                                        Vegetable.VEGETARIAN
                                                    ? Colors.green[700]
                                                    : recipe!.vegetable ==
                                                            Vegetable.VEGAN
                                                        ? Colors.orange
                                                        : Colors.lightBlue[400],
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  recipe!.vegetable ==
                                                          Vegetable.VEGETARIAN
                                                      ? MdiIcons.cheese
                                                      : recipe!.vegetable ==
                                                              Vegetable.VEGAN
                                                          ? MdiIcons.leaf
                                                          : MdiIcons
                                                              .foodDrumstick,
                                                  color: recipe!.vegetable ==
                                                          Vegetable.VEGETARIAN
                                                      ? Colors.amber
                                                      : recipe!.vegetable ==
                                                              Vegetable.VEGAN
                                                          ? Colors.green[700]
                                                          : Colors.brown[600],
                                                  size: recipe!.vegetable ==
                                                          Vegetable
                                                              .NON_VEGETARIAN
                                                      ? 16
                                                      : 18,
                                                ),
                                              ),
                                              height: 20,
                                              width: 20,
                                            ),
                                          )
                                        ]),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                            ],
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),

          recipe!.isFavorite == true
              ? Align(
                  alignment: Alignment(0.95, -0.95),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3.0, right: 2),
                    child: Container(
                      height: 37,
                      width: 37,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(50, 50, 50, 0.7),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          )),
                      child: Center(
                        child: SpinKitPumpingHeart(
                          color: Colors.pink,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ),
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

}

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

class LeftHalfVerticalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(size.width / 1.6, 0)
      ..lineTo(size.width / 1.6, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
