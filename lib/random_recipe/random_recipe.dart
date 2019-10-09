import 'package:flutter/material.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/recipe_overview/recipe_overview.dart';
import './tinder_card.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/random_recipe/recipe_card_big.dart';
import 'package:scoped_model/scoped_model.dart';

import '../database.dart';
import 'package:my_recipe_book/generated/i18n.dart';

class SwypingCardsScreen extends StatefulWidget {
  SwypingCardsScreen();

  @override
  _SwypingCardsScreenState createState() => _SwypingCardsScreenState();
}

class _SwypingCardsScreenState extends State<SwypingCardsScreen> {
  String _selectedCategory = 'all categories';

  ListView _getCategorySelector(
      List<String> categoryNames, RecipeKeeper rKeeper) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: (categoryNames.length + 1) * 2 + 1,
      itemBuilder: (context, index) {
        if (index == 0) return VerticalDivider();
        index--;
        if (index % 2 == 0) {
          String currentCategory = (index / 2).floor() == 0
              ? 'all categories'
              : categoryNames[(index / 2).floor() - 1];
          String categoryName;
          if (currentCategory == 'all categories') {
            categoryName = S.of(context).all_categories;
          } else if (currentCategory == 'no category') {
            categoryName = S.of(context).no_category;
          } else {
            categoryName = currentCategory;
          }
          return FlatButton(
            color: currentCategory == _selectedCategory ? Colors.brown : null,
            textColor:
                currentCategory == _selectedCategory ? Colors.amber : null,
            onPressed: () {
              setState(() {
                rKeeper.swypingCardCategory = currentCategory;
                _selectedCategory = currentCategory;

                rKeeper.changeSwypeCardCategory(currentCategory);
              });
            },
            child: Text(categoryName),
          );
        } else {
          return VerticalDivider();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: ScopedModelDescendant<RecipeKeeper>(
              builder: (context, child, rKeeper) =>
                  _getCategorySelector(rKeeper.categories, rKeeper),
            ),
          ),
        ),
        Divider(),
        Container(
          height: MediaQuery.of(context).size.height - 200,
          child: ScopedModelDescendant<RecipeKeeper>(
              builder: (context, child, rKeeper) {
            if (rKeeper.isLoadingSwypeCards) {
              return Center(child: CircularProgressIndicator());
            } else if (rKeeper.swypingCardRecipes.isEmpty) {
              return NoRecipeCategory();
            } else {
              return SwypingCards(
                key: Key(_selectedCategory),
                currentCategory: _selectedCategory,
                recipes: rKeeper.swypingCardRecipes,
              );
            }
          }),
        )
      ],
    );
  }
}

class SwypingCards extends StatefulWidget {
  final List<Recipe> recipes;
  final String currentCategory;

  SwypingCards({
    @required this.currentCategory,
    @required this.recipes,
    Key key,
  }) : super(key: key);

  _SwypingCardsState createState() => _SwypingCardsState();
}

class _SwypingCardsState extends State<SwypingCards>
    with TickerProviderStateMixin {
  CardController controller; //Use this to trigger swap.

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height - 200;
    double maxWidth = maxHeight / 1.4;
    if (maxWidth > MediaQuery.of(context).size.width * 0.9) {
      maxWidth = MediaQuery.of(context).size.width * 0.9;
    }
    return Container(
        height: MediaQuery.of(context).size.height,
        child: new TinderSwapCard(
            orientation: AmassOrientation.TOP,
            totalNum: 100,
            stackNum: 3,
            animDuration: 200,
            swipeEdge: 4.0,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            minWidth: maxWidth * 0.9,
            minHeight: maxHeight - 100,
            cardBuilder: (context, index) => RecipeCardBig(
                  recipe: widget.recipes[index],
                  index: index,
                  cardWidth: maxWidth,
                  cardHeight: maxHeight,
                ),
            cardController: controller = CardController(),
            swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
              /// Get swiping card's alignment
              if (align.x < 0) {
                //Card is LEFT swiping
              } else if (align.x > 0) {
                //Card is RIGHT swiping
              }
            },
            swipeCompleteCallback:
                (CardSwipeOrientation orientation, int index) {
              String getCategoryName =
                  widget.currentCategory == 'all categories'
                      ? null
                      : widget.currentCategory;
              DBProvider.db
                  .getNewRandomRecipe(widget.recipes.last.name,
                      categoryName: getCategoryName)
                  .then((recipe) {
                widget.recipes
                    .add(recipe == null ? widget.recipes.last : recipe);

                if (index - 2 >= 0) {
                  widget.recipes[index - 2] = null;
                }
              });

              /// Get orientation & index of swiped card!
            }));
  }
}
