import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/local_storage/hive.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';

import '../generated/i18n.dart';
import '../models/enums.dart';
import '../screens/recipe_overview.dart';

class RecipeFilter extends StatefulWidget {
  final bool showVegetableFilter;
  final bool showRecipeTagFilter;
  final RecipeSort initialRecipeSort;
  final bool initialAscending;
  final Function(RecipeSort rSort) changeOrder;
  final Function(bool ascending) changeAscending;
  final Function(Vegetable vegetable) filterVegetableRecipes;
  final Function(List<String> recipeTags) filterRecipeTagRecipes;

  RecipeFilter({
    this.showVegetableFilter = true,
    this.initialRecipeSort = RecipeSort.BY_NAME,
    this.initialAscending = true,
    this.showRecipeTagFilter = false,
    this.filterRecipeTagRecipes,
    @required this.changeOrder,
    @required this.changeAscending,
    @required this.filterVegetableRecipes,
    Key key,
  }) : super(key: key);

  @override
  _RecipeFilterState createState() => _RecipeFilterState();
}

class _RecipeFilterState extends State<RecipeFilter>
    with SingleTickerProviderStateMixin {
  RecipeSort dropdownValue;
  Vegetable vegetableFilter;
  bool _isExpanded = false;
  List<StringIntTuple> selectedRecipeTags = [];
  List<StringIntTuple> recipeTags = [];

  @override
  void initState() {
    super.initState();
    if (widget.showRecipeTagFilter) {
      recipeTags = HiveProvider().getRecipeTags();
    }
    dropdownValue = widget.initialRecipeSort;
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Center(
        child: Container(
          width:
              MediaQuery.of(context).size.width > 500 ? 500 : double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(2, 2),
                blurRadius: 3,
                spreadRadius: 1,
                color: Colors.black26,
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              colors: Theme.of(context).backgroundColor != Colors.white
                  ? [Colors.grey[800], Colors.grey[800]]
                  : [Colors.grey[200], Colors.grey[200]],
              stops: [0, 0.5],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: kToolbarHeight,
                child: Row(
                  children: <Widget>[
                    RotatingArrow(
                      initialAscending: widget.initialAscending,
                      onChangeDirection: widget.changeAscending,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<RecipeSort>(
                        isExpanded: false,
                        value: dropdownValue,
                        elevation: 16,
                        // underline: Container(
                        //   height: 2,
                        //   color: Colors.amber,
                        // ),
                        onChanged: (RecipeSort newValue) {
                          widget.changeOrder(newValue);
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <RecipeSort>[
                          RecipeSort.BY_NAME,
                          RecipeSort.BY_EFFORT,
                          RecipeSort.BY_INGREDIENT_COUNT,
                          RecipeSort.BY_LAST_MODIFIED,
                        ].map<DropdownMenuItem<RecipeSort>>((RecipeSort value) {
                          return DropdownMenuItem<RecipeSort>(
                            value: value,
                            child: Container(
                              width:
                                  MediaQuery.of(context).size.width - 206 < 170
                                      ? MediaQuery.of(context).size.width - 206
                                      : 170,
                              child: Text(
                                value == RecipeSort.BY_NAME
                                    ? I18n.of(context).by_name
                                    : value == RecipeSort.BY_EFFORT
                                        ? I18n.of(context).by_effort
                                        : value ==
                                                RecipeSort.BY_INGREDIENT_COUNT
                                            ? I18n.of(context)
                                                .by_ingredientsamount
                                            : I18n.of(context).by_last_modified,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width -
                                                    206 <
                                                170
                                            ? 12
                                            : 15),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Spacer(),
                    widget.showVegetableFilter
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: DropdownButton<Vegetable>(
                              isExpanded: false,
                              value: vegetableFilter,
                              elevation: 16,
                              // underline: Container(
                              //   height: 2,
                              //   color: Colors.amber,
                              // ),
                              icon: Container(),
                              underline: Container(),
                              onChanged: (Vegetable newValue) {
                                setState(() {
                                  widget.filterVegetableRecipes(newValue);
                                  vegetableFilter = newValue;
                                });
                              },
                              items: <Vegetable>[
                                null,
                                Vegetable.NON_VEGETARIAN,
                                Vegetable.VEGAN,
                                Vegetable.VEGETARIAN
                              ].map<DropdownMenuItem<Vegetable>>(
                                  (Vegetable value) {
                                return DropdownMenuItem<Vegetable>(
                                  value: value,
                                  child: _getVegetableIcon(value),
                                );
                              }).toList(),
                            ),
                          )
                        : Container(),
                    widget.showRecipeTagFilter && recipeTags.isNotEmpty
                        ? IconButton(
                            icon: Icon(_isExpanded
                                ? Icons.expand_less
                                : Icons.expand_more),
                            onPressed: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                          )
                        : Container(),
                  ],
                ),
              ),
              AnimatedSize(
                vsync: this,
                duration: Duration(milliseconds: 150),
                curve: Curves.fastOutSlowIn,
                child: _isExpanded
                    ? Container(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                        child: Wrap(
                          spacing: 5.0,
                          runSpacing: 3.0,
                          children: recipeTags.map((recipeTag) {
                            return FilterChip(
                              label: Text(recipeTag.text),
                              backgroundColor: Color(recipeTag.number),
                              selected: selectedRecipeTags.contains(recipeTag),
                              onSelected: (isSelected) {
                                setState(() {
                                  if (isSelected) {
                                    selectedRecipeTags.add(recipeTag);
                                  } else {
                                    selectedRecipeTags.remove(recipeTag);
                                  }
                                  widget.filterRecipeTagRecipes(
                                      selectedRecipeTags
                                          .map((tag) => tag.text)
                                          .toList());
                                });
                              },
                            );
                          }).toList(),
                        ))
                    : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getVegetableIcon(Vegetable vegetable) {
    switch (vegetable) {
      case Vegetable.VEGETARIAN:
        return _getVegetableCircleIcon([Colors.green[600], Colors.green[900]],
            MdiIcons.cheese, Colors.amber);

      case Vegetable.VEGAN:
        return _getVegetableCircleIcon([Colors.orange, Colors.orange[800]],
            MdiIcons.leaf, Colors.green[700]);

      case Vegetable.NON_VEGETARIAN:
        return _getVegetableCircleIcon(
            [Colors.lightBlue[400], Colors.lightBlue[600]],
            MdiIcons.cow,
            Colors.brown[800]);

      default:
        return Stack(
          children: <Widget>[
            _getVegetableCircleIcon(
              [Colors.orange, Colors.orange[800]],
              MdiIcons.leaf,
              Colors.green[700],
            ),
            ClipPath(
              clipper: OneThirdClipperRight(),
              child: _getVegetableCircleIcon(
                [Colors.lightBlue[400], Colors.lightBlue[600]],
                MdiIcons.cow,
                Colors.brown[800],
              ),
            ),
            ClipPath(
              clipper: OneThirdClipperLeft(),
              child: _getVegetableCircleIcon(
                [Colors.green[600], Colors.green[900]],
                MdiIcons.cheese,
                Colors.amber,
              ),
            ),
          ],
        );
    }
  }

  Widget _getVegetableCircleIcon(
      List<Color> backgroundColors, IconData iconData, Color iconColor) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: backgroundColors),
      ),
      child: Center(
        child: iconData == null
            ? null
            : Icon(
                iconData,
                color: iconColor,
                size: 22,
              ),
      ),
    );
  }
}

class RotatingArrow extends StatefulWidget {
  final Function(bool pointingDown) onChangeDirection;
  final bool initialAscending;

  RotatingArrow({
    @required this.onChangeDirection,
    this.initialAscending = true,
    Key key,
  }) : super(key: key);

  @override
  _RotatingArrowState createState() => _RotatingArrowState();
}

class _RotatingArrowState extends State<RotatingArrow>
    with TickerProviderStateMixin {
  AnimationController _controller;
  bool ascending;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    if (!widget.initialAscending) {
      _controller.forward();
      ascending = false;
    } else {
      ascending = true;
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
      child: IconButton(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        icon: Icon(MdiIcons.arrowUpBold),
        onPressed: () {
          setState(() {
            if (ascending) {
              ascending = false;
              _controller.forward();
              widget.onChangeDirection(false);
            } else {
              ascending = true;
              _controller.animateBack(0);
              widget.onChangeDirection(true);
            }
          });
        },
      ),
    );
  }
}
