import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';

import '../blocs/recipe_overview/recipe_overview_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as Constants;
import '../generated/i18n.dart';
import '../local_storage/hive.dart';
import '../models/enums.dart';
import '../models/recipe.dart';
import '../widgets/icon_info_message.dart';
import '../widgets/recipe_card.dart';
import '../widgets/recipe_filter_bar.dart';
import '../widgets/search.dart';

class RecipeGridViewArguments {
  final String category;
  final Vegetable vegetable;
  final StringIntTuple recipeTag;
  final ShoppingCartBloc shoppingCartBloc;

  RecipeGridViewArguments({
    this.category,
    this.vegetable,
    this.recipeTag,
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
          String title = _getTitle(
              context, state.category, state.vegetable, state.recipeTag);
          // also checking for randomImage because, when filter changed, there can be no recipes visible
          // but still the category has recipes
          if (state.recipes.isNotEmpty || state.randomImage != null) {
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
                  ],
                  expandedHeight: scaleFactor * 200.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                      title: Text(title),
                      background: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: state.randomImage == Constants.noRecipeImage
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
                SliverStickyHeader(
                  sticky: false,
                  header: RecipeFilter(
                    showVegetableFilter: state.vegetable != null ? false : true,
                    showRecipeTagFilter: state.recipeTag == null ? true : false,
                    initialRecipeSort: state.recipeSort.sort,
                    initialAscending: state.recipeSort.ascending,
                    changeAscending: (bool ascending) =>
                        BlocProvider.of<RecipeOverviewBloc>(context)
                            .add(ChangeAscending(ascending)),
                    changeOrder: (RecipeSort rSort) =>
                        BlocProvider.of<RecipeOverviewBloc>(context).add(
                      ChangeRecipeSort(rSort),
                    ),
                    filterVegetableRecipes: (Vegetable vegetable) =>
                        BlocProvider.of<RecipeOverviewBloc>(context)
                            .add(FilterRecipesVegetable(vegetable)),
                    filterRecipeTagRecipes: (List<String> recipeTag) =>
                        BlocProvider.of<RecipeOverviewBloc>(context)
                            .add(FilterRecipesTag(recipeTag)),
                  ),
                  sliver: SliverPadding(
                    padding: EdgeInsets.all(12),
                    sliver: state.recipes.isEmpty
                        // if the category has recipes but not with the current (vegetable) filter
                        ? SliverList(
                            delegate: SliverChildListDelegate([
                              Container(
                                height: MediaQuery.of(context).size.height / 2,
                                child: Center(
                                  child: IconInfoMessage(
                                    iconWidget: Icon(
                                      MdiIcons.chefHat,
                                      color: Colors.white,
                                      size: 70.0,
                                    ),
                                    description: I18n.of(context)
                                        .no_recipes_fit_your_filter,
                                  ),
                                ),
                              )
                            ]),
                          )
                        : SliverStaggeredGrid.countBuilder(
                            crossAxisCount: 4,
                            itemCount: state.recipes.length,
                            itemBuilder: (BuildContext context, int index) =>
                                RecipeCard(
                              recipe: state.recipes[index],
                              shadow: Theme.of(context).backgroundColor ==
                                      Colors.white
                                  ? Colors.grey[400]
                                  : Colors.black,
                              activateVegetableHero:
                                  state.recipes[index].vegetable ==
                                          state.vegetable
                                      ? false
                                      : true,
                              heroImageTag:
                                  "${state.category}${state.recipes[index].name}",
                              showAds: true,
                            ),
                            staggeredTileBuilder: (int index) =>
                                StaggeredTile.fit(2),
                            mainAxisSpacing: 12.0,
                            crossAxisSpacing: 12.0,
                          ),
                  ),
                ),
              ]),
            );
          } else {
            return Scaffold(
                appBar: GradientAppBar(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xffAF1E1E), Color(0xff641414)],
                  ),
                  title: Text(title),
                ),
                body: NoRecipeCategory(
                  recipeTag: state.recipeTag != null ? true : false,
                  vegetable: state.vegetable != null ? true : false,
                ));
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
            showAds: true,
          ),
        )
        .toList();
  }

  String _getTitle(BuildContext context, String category, Vegetable vegetable,
      StringIntTuple recipeTag) {
    if (category != null) {
      if (category == Constants.noCategory) {
        return I18n.of(context).no_category;
      } else if (category == Constants.allCategories) {
        return I18n.of(context).all_categories;
      } else {
        return category;
      }
    } else if (vegetable != null) {
      if (vegetable == Vegetable.NON_VEGETARIAN) {
        return I18n.of(context).with_meat;
      } else if (vegetable == Vegetable.VEGETARIAN) {
        return I18n.of(context).vegetarian;
      } else if (vegetable == Vegetable.VEGAN) {
        return I18n.of(context).vegan;
      }
    } else {
      return recipeTag.text;
    }
  }
}

class NoRecipeCategory extends StatelessWidget {
  final bool recipeTag;
  final bool vegetable;

  const NoRecipeCategory({
    this.recipeTag = false,
    this.vegetable = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconInfoMessage(
          iconWidget: Icon(
            recipeTag
                ? MdiIcons.tag
                : vegetable ? MdiIcons.foodApple : MdiIcons.chefHat,
            color: Colors.white,
            size: 70.0,
          ),
          description: recipeTag
              ? I18n.of(context).no_recipes_with_this_tag
              : I18n.of(context).no_recipes_under_this_category),
    );
  }
}

class OneThirdClipperRight extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width / 2, size.height / 2)
      ..lineTo(size.width, size.height * 0.8)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(OneThirdClipperRight oldClipper) => true;
}

class OneThirdClipperLeft extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width / 2, size.height / 2)
      ..lineTo(0, size.height * 0.8)
      ..lineTo(0, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(OneThirdClipperLeft oldClipper) => true;
}

@override
Path getClip(Size size) {
  final Path path = new Path()
    ..lineTo(size.width / 2, 0)
    ..lineTo(size.width / 2, size.height)
    ..lineTo(size.width, size.height)
    ..lineTo(size.width, 0);
  return path;
}

@override
bool shouldReclip(CustomClipper<Path> oldClipper) {
  return true;
}
