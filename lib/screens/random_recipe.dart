import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/widgets/tinder_card.dart';

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
  ListView _getCategorySelectorTopBar(
      List<String> categoryNames, String selectedCategory) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categoryNames.length * 2 + 1,
      itemBuilder: (context, index) {
        if (index == 0) return VerticalDivider();
        index++;
        if (index % 2 == 0) {
          String currentCategory = categoryNames[(index / 2).floor() - 1];
          // return Container(
          //   height: 20.0,
          //   child: RaisedButton(
          //     elevation: 0,
          //     color: Colors.grey[200],
          //     onPressed: () {
          //       BlocProvider.of<RandomRecipeExplorerBloc>(context)
          //           .add(ChangeCategory(currentCategory));
          //     },
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(80.0)),
          //     padding: EdgeInsets.all(0.0),
          //     child: Ink(
          //       height: 50,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(30.0),
          //         gradient: currentCategory == selectedCategory
          //             ? LinearGradient(
          //                 colors: [Colors.brown, Colors.brown[900]],
          //                 begin: Alignment.centerLeft,
          //                 end: Alignment.centerRight,
          //               )
          //             : null,
          //       ),
          //       child: Container(
          //         constraints: BoxConstraints(maxHeight: 50.0, minWidth: 100),
          //         alignment: Alignment.center,
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //           child: Text(
          //             currentCategory == "no category"
          //                 ? I18n.of(context).no_category
          //                 : currentCategory == "all categories"
          //                     ? I18n.of(context).all_categories
          //                     : currentCategory,
          //             textAlign: TextAlign.center,
          //             style: TextStyle(
          //               color: currentCategory == selectedCategory
          //                   ? Colors.amber
          //                   : null,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // );
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

  Widget _getCategoriesSelectorSideList(
      List<String> categoryNames, String selectedCategory) {
    return Container(
      height: double.infinity,
      color: Color(0xff313131),
      width: 300,
      child: ListView(
        children: List.generate(
          categoryNames.length * 2,
          (index) => index % 2 == 0
              ? Material(
                  color: selectedCategory == categoryNames[(index / 2).floor()]
                      ? Colors.grey
                      : Colors.transparent,
                  child: ListTile(
                    title: Text(
                        categoryNames[(index / 2).floor()] == "no category"
                            ? I18n.of(context).no_category
                            : categoryNames[(index / 2).floor()] ==
                                    "all categories"
                                ? I18n.of(context).all_categories
                                : categoryNames[(index / 2).floor()],
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      BlocProvider.of<RandomRecipeExplorerBloc>(context).add(
                          ChangeCategory(categoryNames[(index / 2).floor()]));
                    },
                  ),
                )
              : Divider(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<RandomRecipeExplorerBloc, RandomRecipeExplorerState>(
          builder: (context, state) {
        if (state is LoadingRandomRecipeExplorer) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadingRecipes) {
          return Column(
              children: <Widget>[
            MediaQuery.of(context).size.width <= 750
                ? SafeArea(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.only(top: 8.0),
                      width: MediaQuery.of(context).size.width,
                      child: _getCategorySelectorTopBar(state.categories,
                          state.categories[state.selectedCategory]),
                    ),
                  )
                : null,
            MediaQuery.of(context).size.width <= 750 ? Divider() : null,
            Expanded(
              child: Row(
                children: <Widget>[
                  MediaQuery.of(context).size.width > 750
                      ? _getCategoriesSelectorSideList(
                          state.categories,
                          state.categories[state.selectedCategory],
                        )
                      : null,
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ]..removeWhere((item) => item == null),
              ),
            )
          ]..removeWhere((item) => item == null));
        } else if (state is LoadedRandomRecipeExplorer) {
          return Column(
            children: <Widget>[
              MediaQuery.of(context).size.width <= 750
                  ? SafeArea(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(top: 8.0),
                        width: MediaQuery.of(context).size.width,
                        child: _getCategorySelectorTopBar(state.categories,
                            state.categories[state.selectedCategory]),
                      ),
                    )
                  : null,
              MediaQuery.of(context).size.width <= 750 ? Divider() : null,
              Expanded(
                child: Row(
                  children: <Widget>[
                    MediaQuery.of(context).size.width > 750
                        ? _getCategoriesSelectorSideList(
                            state.categories,
                            state.categories[state.selectedCategory],
                          )
                        : null,
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: state.randomRecipes.isEmpty
                            ? Center(
                                child: IconInfoMessage(
                                iconWidget: Icon(
                                  MdiIcons.chefHat,
                                  color: Colors.white,
                                  size: 70.0,
                                ),
                                description: I18n.of(context)
                                    .no_recipes_under_this_category,
                              ))
                            : TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0.1, end: 1),
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOutQuad,
                                child: LayoutBuilder(
                                  builder: (context, constraints) =>
                                      SwypingCards(
                                    maxHeigth: constraints.maxHeight,
                                    maxWidth: constraints.maxWidth,
                                    recipes: state.randomRecipes,
                                  ),
                                ),
                                builder: (_, double opacity, myChild) =>
                                    Opacity(opacity: opacity, child: myChild),
                              ),
                      ),
                    ),
                  ]..removeWhere((item) => item == null),
                ),
              ),
            ]..removeWhere((item) => item == null),
          );
        } else {
          return Text("uncatched state $state");
        }
      }),
    );
  }
}

class SwypingCards extends StatefulWidget {
  final List<Recipe> recipes;
  final double maxWidth;
  final double maxHeigth;

  SwypingCards({
    @required this.recipes,
    @required this.maxWidth,
    @required this.maxHeigth,
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
    double maxWidthCard;
    double maxHeightCard = widget.maxHeigth > 650 ? 650 : widget.maxHeigth;
    double calculatedWidth = maxHeightCard / 1.5;
    if (calculatedWidth > widget.maxWidth) {
      maxWidthCard = widget.maxWidth - 30;
    } else {
      maxWidthCard = calculatedWidth;
    }

    return Stack(children: <Widget>[
      Center(
          child: Container(
        width: maxWidthCard,
        child: Center(
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
          ),
        ),
      )),
      Center(
        child: Container(
          height: maxHeightCard + 50,
          width: maxWidthCard + 50,
          child: TinderSwapCard(
            orientation: AmassOrientation.TOP,
            totalNum: 50,
            stackNum: 3,
            animDuration: 200,
            swipeEdge: 4.0,
            maxWidth: maxWidthCard,
            maxHeight: maxHeightCard,
            widgetWidth: maxWidthCard,
            widgetHeight: maxHeightCard,
            minWidth: maxWidthCard * 0.9,
            minHeight: maxHeightCard * 0.9,
            cardBuilder: (context, index) => RecipeCardBig(
              recipe: widget.recipes[index - currentSwipeIndex],
              index: index,
              cardWidth: maxWidthCard,
              cardHeight: maxHeightCard,
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
      ),
    ]);
  }
}
