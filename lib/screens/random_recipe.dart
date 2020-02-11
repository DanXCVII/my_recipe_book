import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/widgets/icon_info_message.dart';

import '../blocs/random_recipe_explorer/random_recipe_explorer_bloc.dart';
import '../blocs/random_recipe_explorer/random_recipe_explorer_event.dart';
import '../blocs/random_recipe_explorer/random_recipe_explorer_state.dart';
import '../generated/i18n.dart';
import '../models/recipe.dart';
import '../screens/recipe_overview.dart';
import '../widgets/recipe_card_big.dart';

class SwypingCardsScreen extends StatefulWidget {
  SwypingCardsScreen();

  @override
  _SwypingCardsScreenState createState() => _SwypingCardsScreenState();
}

class _SwypingCardsScreenState extends State<SwypingCardsScreen> {
  ListView _getCategorySelector(
      List<String> categoryNames, String selectedCategory) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categoryNames.length * 2 + 1,
      itemBuilder: (context, index) {
        if (index == 0) return VerticalDivider();
        index++;
        if (index % 2 == 0) {
          String currentCategory = categoryNames[(index / 2).floor() - 1];

          return FlatButton(
            color: currentCategory == selectedCategory ? Colors.brown : null,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textColor:
                currentCategory == selectedCategory ? Colors.amber : null,
            onPressed: () {
              BlocProvider.of<RandomRecipeExplorerBloc>(context)
                  .add(ChangeCategory(currentCategory));
            },
            // TODO: put strings in extra class
            child: Text(currentCategory == "no category"
                ? S.of(context).no_category
                : currentCategory == "all categories"
                    ? S.of(context).all_categories
                    : currentCategory),
          );
        } else {
          return VerticalDivider();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RandomRecipeExplorerBloc, RandomRecipeExplorerState>(
        builder: (context, state) {
      if (state is LoadingRandomRecipeExplorer) {
        return Center(child: CircularProgressIndicator());
      } else if (state is LoadingRecipes) {
        return Column(children: <Widget>[
          SafeArea(
            child: Container(
              height: 40,
              padding: const EdgeInsets.only(top: 8.0),
              width: MediaQuery.of(context).size.width,
              child: _getCategorySelector(
                  state.categories, state.categories[state.selectedCategory]),
            ),
          ),
          Divider(),
          Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ]);
      } else if (state is LoadedRandomRecipeExplorer) {
        return Column(
          children: <Widget>[
            SafeArea(
              child: Container(
                height: 40,
                padding: const EdgeInsets.only(top: 8.0),
                width: MediaQuery.of(context).size.width,
                child: _getCategorySelector(
                    state.categories, state.categories[state.selectedCategory]),
              ),
            ),
            Divider(),
            Container(
              height: MediaQuery.of(context).size.height > 730
                  ? MediaQuery.of(context).size.height - 200
                  : MediaQuery.of(context).size.height - 136,
              child: state.randomRecipes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                                shape: BoxShape.circle),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height / 800 * 80,
                              child: Icon(
                                MdiIcons.chefHat,
                                color: Colors.white,
                                size: 70.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                S.of(context).no_recipes_under_this_category,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                    )
                  : TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.1, end: 1),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOutQuad,
                      child: SwypingCards(
                        recipes: state.randomRecipes,
                      ),
                      builder: (_, double opacity, myChild) =>
                          Opacity(opacity: opacity, child: myChild),
                    ),
            ),
          ],
        );
      } else {
        return Text("uncatched state $state");
      }
    });
  }
}

class SwypingCards extends StatefulWidget {
  final List<Recipe> recipes;

  SwypingCards({
    @required this.recipes,
    Key key,
  }) : super(key: key);

  _SwypingCardsState createState() => _SwypingCardsState();
}

class _SwypingCardsState extends State<SwypingCards>
    with TickerProviderStateMixin {
  CardController controller; //Use this to trigger swap.
  int currentSwipeIndex = 0;

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height > 730
        ? MediaQuery.of(context).size.height - 200
        : MediaQuery.of(context).size.height - 150;
    double maxWidth = maxHeight / 1.4;
    if (maxWidth > MediaQuery.of(context).size.width * 0.9) {
      maxWidth = MediaQuery.of(context).size.width * 0.9;
    }
    return Stack(children: <Widget>[
      Center(
          child: IconInfoMessage(
        iconWidget: IconButton(
          icon: Icon(Icons.refresh),
          iconSize: 70,
          onPressed: () {
            BlocProvider.of<RandomRecipeExplorerBloc>(context)
                .add(ReloadRandomRecipeExplorer());
          },
        ),
        description: "you made it to the end",
      )),
      Container(
        height: MediaQuery.of(context).size.height > 730
            ? MediaQuery.of(context).size.height - 200
            : MediaQuery.of(context).size.height - 50,
        child: TinderSwapCard(
          orientation: AmassOrientation.TOP,
          totalNum: 50,
          stackNum: 3,
          animDuration: 200,
          swipeEdge: 4.0,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          minWidth: maxWidth * 0.9,
          minHeight: maxHeight - 100,
          cardBuilder: (context, index) => RecipeCardBig(
            recipe: widget.recipes[index - currentSwipeIndex],
            index: index,
            cardWidth: maxWidth,
            cardHeight: maxHeight,
          ),
          cardController: CardController(),
          swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
            /// Get swiping card's alignment
            if (align.x < 0) {
              //Card is LEFT swiping
            } else if (align.x > 0) {
              //Card is RIGHT swiping
            }
          },
        ),
      ),
    ]);
  }
}
