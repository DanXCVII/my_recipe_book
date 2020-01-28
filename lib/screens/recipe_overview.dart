import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../blocs/recipe_overview/recipe_overview_bloc.dart';
import '../blocs/recipe_overview/recipe_overview_event.dart';
import '../blocs/recipe_overview/recipe_overview_state.dart';
import '../blocs/shopping_cart/shopping_cart.dart';
import '../generated/i18n.dart';
import '../hive.dart';
import '../models/enums.dart';
import '../models/recipe.dart';
import '../models/recipe_sort.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search.dart';

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

class RecipeGridViewArguments {
  final String category;
  final ShoppingCartBloc shoppingCartBloc;

  RecipeGridViewArguments({
    @required this.category,
    @required this.shoppingCartBloc,
  });
}

class RecipeGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.height / 800;

    return BlocBuilder<RecipeOverviewBloc, RecipeOverviewState>(
      builder: (context, state) {
        if (state is LoadingRecipeOverview) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadedRecipeOverview) {
          String title = _getTitle(context, state.category, state.vegetable);
          if (state.recipes.isNotEmpty) {
            return Scaffold(
              body: CustomScrollView(slivers: <Widget>[
                SliverAppBar(
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        showSearch(
                            context: context,
                            delegate: RecipeSearch(
                              HiveProvider().getRecipeNames(),
                              BlocProvider.of<ShoppingCartBloc>(context),
                            ));
                      },
                    ),
                    PopupMenuButton<RSort>(
                      icon: Icon(GroovinMaterialIcons.sort),
                      onSelected: (value) =>
                          BlocProvider.of<RecipeOverviewBloc>(context)
                              .add(ChangeRecipeSort(value)),
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
                            value: RSort(RecipeSort.BY_INGREDIENT_COUNT, true),
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
                            value: RSort(RecipeSort.BY_INGREDIENT_COUNT, false),
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
                      title: Text(title),
                      background: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: state.randomImage == 'images/randomFood.jpg'
                                ? AssetImage(state.randomImage)
                                : FileImage(File(state.randomImage)),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.0)),
                          ),
                        ),
                      )),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(12),
                  sliver: SliverGrid.extent(
                    childAspectRatio: 0.75,
                    maxCrossAxisExtent: 300,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: getRecipeCards(
                      state.recipes,
                      context,
                      state.category,
                      state.vegetable,
                    ),
                  ),
                )
              ]),
            );
          } else {
            return Scaffold(appBar: AppBar(), body: NoRecipeCategory());
          }
        } else {
          return Text(state.toString());
        }
      },
    );
  }

  List<Widget> getRecipeCards(List<Recipe> recipes, BuildContext context,
      String category, Vegetable vegetable) {
    return recipes
        .map(
          (recipe) => RecipeCard(
            recipe: recipe,
            shadow: Theme.of(context).backgroundColor == Colors.white
                ? Colors.grey[400]
                : Colors.black,
            activateVegetableHero: recipe.vegetable == vegetable ? false : true,
            heroImageTag: "$category${recipe.name}",
          ),
        )
        .toList();
  }

  String _getTitle(BuildContext context, String category, Vegetable vegetable) {
    if (category != null) {
      if (category == "no category") {
        return S.of(context).no_category;
      } else if (category == "all categories") {
        return S.of(context).all_categories;
      } else {
        return category;
      }
    } else {
      if (vegetable == Vegetable.NON_VEGETARIAN) {
        return S.of(context).with_meat;
      } else if (vegetable == Vegetable.VEGETARIAN) {
        return S.of(context).vegetarian;
      } else if (vegetable == Vegetable.VEGAN) {
        return S.of(context).vegan;
      }
    }
    return "title not found";
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
                    : Colors.white,
              ),
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
    return WatchBoxBuilder(
        box: Hive.box<String>('favorites'),
        watchKeys: [HiveProvider().getHiveKey(recipe.name)],
        builder: (context, snapshot) {
          String hiveRecipeKey = HiveProvider().getHiveKey(recipe.name);
          bool isFavorite = snapshot.get(hiveRecipeKey) != null ? true : false;
          return IconButton(
            iconSize: iconSize == null ? 24 : iconSize,
            color: isFavorite ? Colors.pink : Colors.white,
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              if (!isFavorite) {
                addFavorite();
              } else {
                removeFavorite();
              }
            },
          );
        });
  }
}
