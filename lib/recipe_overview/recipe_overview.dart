import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:scoped_model/scoped_model.dart';

import '../database.dart';
import '../recipe.dart';
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
  final int randomCategoryImage;

  const RecipeGridView(
      {this.category, @required this.randomCategoryImage, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RecipeKeeper>(
        builder: (context, child, model) {
      List<RecipePreview> recipePreviews = model.getRecipesOfCategory(category);
      if (recipePreviews.isNotEmpty) {
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
                )
              ],
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(category),
                background: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage(
                          '${recipePreviews[randomCategoryImage].imagePreviewPath}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(12),
              sliver: SliverGrid.extent(
                childAspectRatio: 0.75,
                maxCrossAxisExtent: 300,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: getRecipeCards(recipePreviews, context),
              ),
            )
          ]),
        );
      } else {
        return noRecipeScreen(context);
      }
    });
  }

  Widget noRecipeScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(0, -0.5),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "No recipes under this category",
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
              height: 280,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getRecipeCards(
      List<RecipePreview> recipes, BuildContext context) {
    List<RecipeCard> recipeCards = [];
    for (int i = 0; i < recipes.length; i++) {
      recipeCards.add(
        RecipeCard(
          recipePreview: recipes[i],
          shadow: Theme.of(context).backgroundColor == Colors.white
              ? Colors.grey[400]
              : Colors.black,
          heroImageTag: "${recipes[i].imagePreviewPath}-${recipes[i].id}",
          heroTitle: "recipe-${recipes[i].id}",
        ),
      );
    }
    return recipeCards;
  }
}

class Favorite extends StatefulWidget {
  final Recipe recipe;
  final double iconSize;
  final RecipeKeeper rKeeper;

  Favorite(this.recipe, this.rKeeper, {this.iconSize});

  @override
  State<StatefulWidget> createState() => FavoriteState();
}

class FavoriteState extends State<Favorite> {
  bool isFavorite;

  @override
  void initState() {
    isFavorite = widget.recipe.isFavorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: widget.iconSize == null ? 24 : widget.iconSize,
      color: isFavorite ? Colors.pink : Colors.white,
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      onPressed: () {
        if (isFavorite) {
          widget.rKeeper.removeFromFavorites(widget.recipe.name);
          DBProvider.db.updateFavorite(false, widget.recipe.id).then((_) {
            setState(() {
              widget.recipe.isFavorite = false;
              isFavorite = false;
            });
          });
        } else {
          widget.rKeeper.addFavorite(widget.recipe);
          DBProvider.db.updateFavorite(true, widget.recipe.id).then((_) {
            setState(() {
              widget.recipe.isFavorite = true;
              isFavorite = true;
            });
          });
        }
      },
    );
  }
}
