import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:my_recipe_book/blocs/bloc_provider.dart';
import 'package:my_recipe_book/blocs/recipe_overview_bloc.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/recipe_sort.dart';

import '../hive.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:tuple/tuple.dart';

import '../database.dart';
import '../recipe_card.dart';
import '../search.dart';

Map<String, List<Color>> colors = {
  "${Vegetable.NON_VEGETARIAN.toString()}1": [
    Color(0xffD10C0C),
    Color(0xffC90505)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}2": [
    Color(0xffC90505),
    Color(0xffB40808)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}3": [
    Color(0xffB40808),
    Color(0xff880000)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}4": [
    Color(0xff880000),
    Color(0xff800101)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}5": [
    Color(0xff800101),
    Color(0xff710101)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}6": [
    Color(0xff710101),
    Color(0xff5F0000)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}7": [
    Color(0xff5F0000),
    Color(0xff540000)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}8": [
    Color(0xff540000),
    Color(0xff430000)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}9": [
    Color(0xff430000),
    Color(0xff380000)
  ],
  "${Vegetable.NON_VEGETARIAN.toString()}10": [
    Color(0xff380000),
    Color(0xff280000)
  ],
  "${Vegetable.VEGAN.toString()}1": [Color(0xff216715), Color(0xff1D5F13)],
  "${Vegetable.VEGAN.toString()}2": [Color(0xff1D5F13), Color(0xff19590F)],
  "${Vegetable.VEGAN.toString()}3": [Color(0xff19590F), Color(0xff15520B)],
  "${Vegetable.VEGAN.toString()}4": [Color(0xff15520B), Color(0xff104A07)],
  "${Vegetable.VEGAN.toString()}5": [Color(0xff104A07), Color(0xff0C4403)],
  "${Vegetable.VEGAN.toString()}6": [Color(0xff0C4403), Color(0xff0B4003)],
  "${Vegetable.VEGAN.toString()}7": [Color(0xff0B4003), Color(0xff093802)],
  "${Vegetable.VEGAN.toString()}8": [Color(0xff093802), Color(0xff083201)],
  "${Vegetable.VEGAN.toString()}9": [Color(0xff083201), Color(0xff072F00)],
  "${Vegetable.VEGAN.toString()}10": [Color(0xff072F00), Color(0xff062700)],
  "${Vegetable.VEGETARIAN.toString()}1": [Color(0xff798210), Color(0xff767E0F)],
  "${Vegetable.VEGETARIAN.toString()}2": [Color(0xff767E0F), Color(0xff6E770C)],
  "${Vegetable.VEGETARIAN.toString()}3": [Color(0xff6E770C), Color(0xff666F0A)],
  "${Vegetable.VEGETARIAN.toString()}4": [Color(0xff666F0A), Color(0xff5F6609)],
  "${Vegetable.VEGETARIAN.toString()}5": [Color(0xff5F6609), Color(0xff555B07)],
  "${Vegetable.VEGETARIAN.toString()}6": [Color(0xff555B07), Color(0xff4F5504)],
  "${Vegetable.VEGETARIAN.toString()}7": [Color(0xff4F5504), Color(0xff495002)],
  "${Vegetable.VEGETARIAN.toString()}8": [Color(0xff495002), Color(0xff454A02)],
  "${Vegetable.VEGETARIAN.toString()}9": [Color(0xff454A02), Color(0xff216715)],
  "${Vegetable.VEGETARIAN.toString()}10": [
    Color(0xff3D4202),
    Color(0xff083201)
  ],
};

class RecipeGridView extends StatelessWidget {
  final String category;
  // set when the screen should show recipes of one vegetabletype
  final Vegetable vegetableRoute;
  final String title;

  /// Either specify the list of recipes or a recipecategory
  /// Either specify the category or a title
  const RecipeGridView({
    this.category,
    this.vegetableRoute,
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RecipeOverviewBloc bloc =
        BlocProvider.of<RecipeOverviewBloc>(context);

    double scaleFactor = MediaQuery.of(context).size.height / 800;
    return StreamBuilder<List<Recipe>>(
        stream: bloc.outRecipeList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Recipe> recipes = snapshot.data;
            if (recipes.isNotEmpty) {
              return Scaffold(
                body: CustomScrollView(slivers: <Widget>[
                  SliverAppBar(
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          DBProvider.db.getRecipeNames().then((recipeNames) {
                            showSearch(
                                context: context,
                                delegate: RecipeSearch(recipeNames));
                          });
                        },
                      ),
                      PopupMenuButton<RSort>(
                        icon: Icon(GroovinMaterialIcons.sort),
                        onSelected: (value) => bloc.changeOrder(value),
                        itemBuilder: (BuildContext context) {
                          return [
                            // TODO: internationalize
                            /// idea: maybe replace asc. with icon up and desc. with icon down
                            /// so that no complex logic is needed
                            PopupMenuItem(
                              value: RSort(RecipeSort.BY_NAME, true),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(GroovinMaterialIcons.arrow_up_bold),
                                  SizedBox(width: 5),
                                  Text(S.of(context).by_name),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: RSort(RecipeSort.BY_NAME, false),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(GroovinMaterialIcons.arrow_down_bold),
                                  SizedBox(width: 5),
                                  Text(S.of(context).by_name),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: RSort(RecipeSort.BY_EFFORT, true),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(GroovinMaterialIcons.arrow_up_bold),
                                  SizedBox(width: 5),
                                  Text(S.of(context).by_effort),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: RSort(RecipeSort.BY_EFFORT, false),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(GroovinMaterialIcons.arrow_down_bold),
                                  SizedBox(width: 5),
                                  Text(S.of(context).by_effort),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value:
                                  RSort(RecipeSort.BY_INGREDIENT_COUNT, true),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(GroovinMaterialIcons.arrow_up_bold),
                                  SizedBox(width: 5),
                                  Text(S.of(context).by_ingredientsamount),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value:
                                  RSort(RecipeSort.BY_INGREDIENT_COUNT, false),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(GroovinMaterialIcons.arrow_down_bold),
                                  SizedBox(width: 5),
                                  Text(S.of(context).by_ingredientsamount),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                    ],
                    expandedHeight: scaleFactor * 200.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(category != null ? category : title),
                      background: StreamBuilder<String>(
                          stream: bloc.outRandomImage,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        snapshot.data == 'images/randomFood.jpg'
                                            ? AssetImage(snapshot.data)
                                            : FileImage(File(snapshot.data)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 5.0, sigmaY: 5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.0)),
                                  ),
                                ),
                              );
                            } else {
                              //TODO: when no data is there
                              return Container();
                            }
                          }),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(12),
                    sliver: SliverGrid.extent(
                      childAspectRatio: 0.75,
                      maxCrossAxisExtent: 300,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: getRecipeCards(recipes, context),
                    ),
                  )
                ]),
              );
            } else {
              return Scaffold(appBar: AppBar(), body: NoRecipeCategory());
            }
          } else {
            return Text('NO DAAAAAAAAATAAAAAAAAAAAAA');
          }
        });
  }

  List<Widget> getRecipeCards(List<Recipe> recipes, BuildContext context) {
    return recipes
        .map(
          (recipe) => RecipeCard(
            recipe: recipe,
            shadow: Theme.of(context).backgroundColor == Colors.white
                ? Colors.grey[400]
                : Colors.black,
            activateVegetableHero:
                recipe.vegetable == vegetableRoute ? false : true,
            heroImageTag: "$category${recipe.name}",
          ),
        )
        .toList();
  }
}

class NoRecipeCategory extends StatelessWidget {
  const NoRecipeCategory({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment(0, -0.5),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              S.of(context).no_recipes_under_this_category,
              textScaleFactor: deviceHeight / 800,
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'RibeyeMarrow',
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).backgroundColor == Colors.white
                      ? Colors.black
                      : Colors.white),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            'images/hatWithSpoonFork.png',
            height: deviceHeight / 800 * 280,
          ),
        ),
      ],
    );
  }
}

class Favorite extends StatelessWidget {
  final Recipe recipe;
  final double iconSize;

  Favorite(this.recipe, {this.iconSize});

  @override
  Widget build(BuildContext context) {
    return WatchBoxBuilder(
        box: Hive.box<Recipe>('recipes') as LazyBox,
        watchKeys: [getHiveKey(recipe.name)],
        builder: (context, snapshot) {
          String hiveRecipeKey = getHiveKey(recipe.name);
          bool isFavorite = snapshot.get(hiveRecipeKey);
          return IconButton(
            iconSize: iconSize == null ? 24 : iconSize,
            color: isFavorite ? Colors.pink : Colors.white,
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              snapshot.get(hiveRecipeKey).then((recipe) {
                if (recipe.isFavorite) {
                  // widget.rKeeper.removeFromFavorites(widget.recipe.name);
                  recipe.isFavorite = false;
                  recipe.save();
                } else {
                  recipe.isFavorite = true;
                  recipe.save();
                }
              });
            },
          );
        });
  }
}
