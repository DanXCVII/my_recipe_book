import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../blocs/random_recipe_explorer/random_recipe_explorer_bloc.dart';
import '../generated/i18n.dart';
import '../models/recipe.dart';
import '../widgets/icon_info_message.dart';
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
            child: Text(currentCategory == "no category"
                ? I18n.of(context).no_category
                : currentCategory == "all categories"
                    ? I18n.of(context).all_categories
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
          Row(
            children: <Widget>[
              MediaQuery.of(context).size.width > 550
                  ? Container(
                      height: 500,
                      width: 300,
                      child: ListView(
                        children: <Widget>[],
                      ),
                    )
                  : null,
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ]..removeWhere((item) => item == null),
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
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height > 730
                    ? MediaQuery.of(context).size.height - 200
                    : MediaQuery.of(context).size.height - 136,
                child: state.randomRecipes.isEmpty
                    ? Center(
                        child: IconInfoMessage(
                        iconWidget: Icon(
                          MdiIcons.chefHat,
                          color: Colors.white,
                          size: 70.0,
                        ),
                        description:
                            I18n.of(context).no_recipes_under_this_category,
                      ))
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
    double cardWidthSpace = MediaQuery.of(context).size.width > 550
        ? MediaQuery.of(context).size.width - 200
        : MediaQuery.of(context).size.width;

    double maxHeight = MediaQuery.of(context).size.height > 730
        ? MediaQuery.of(context).size.height - 200
        : MediaQuery.of(context).size.height - 150;
    double maxWidth = maxHeight / 1.4;
    if (maxWidth > cardWidthSpace * 0.9) {
      maxWidth = cardWidthSpace * 0.9;
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
        description: I18n.of(context).you_made_it_to_the_end,
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
