import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/screens/settings_screen.dart';
import '../screens/recipe_overview.dart';

import '../generated/i18n.dart';
import '../models/enums.dart';

class RecipeFilter extends StatefulWidget {
  final bool showVegetableFilter;
  final RecipeSort initialRecipeSort;
  final bool initialAscending;
  final Function(RecipeSort rSort) changeOrder;
  final Function(bool ascending) changeAscending;
  final Function(Vegetable vegetable) filterVegetableRecipes;

  RecipeFilter({
    this.showVegetableFilter = true,
    this.initialRecipeSort = RecipeSort.BY_NAME,
    this.initialAscending = true,
    @required this.changeOrder,
    @required this.changeAscending,
    @required this.filterVegetableRecipes,
    Key key,
  }) : super(key: key);

  @override
  _RecipeFilterState createState() => _RecipeFilterState();
}

class _RecipeFilterState extends State<RecipeFilter> {
  RecipeSort dropdownValue;
  Vegetable vegetableFilter;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialRecipeSort;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800]
          : Colors.grey[300],
      height: kToolbarHeight,
      child: Row(
        children: <Widget>[
          RotatingArrow(
            initialAscending: widget.initialAscending,
            onChangeDirection: widget.changeAscending,
          ),
          Container(
            child: Padding(
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
                    child: Text(value == RecipeSort.BY_NAME
                        ? I18n.of(context).by_name
                        : value == RecipeSort.BY_EFFORT
                            ? I18n.of(context).by_effort
                            : value == RecipeSort.BY_INGREDIENT_COUNT
                                ? I18n.of(context).by_ingredientsamount
                                : I18n.of(context).by_last_modified),
                  );
                }).toList(),
              ),
            ),
          ),
          Spacer(),
          widget.showVegetableFilter
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                    ].map<DropdownMenuItem<Vegetable>>((Vegetable value) {
                      return DropdownMenuItem<Vegetable>(
                        value: value,
                        child: _getVegetableIcon(value),
                      );
                    }).toList(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _getVegetableIcon(Vegetable vegetable) {
    switch (vegetable) {
      case Vegetable.VEGETARIAN:
        return _getVegetableCircleIcon(
          Colors.green[700],
          Colors.amber,
          iconData: MdiIcons.cheese,
        );

      case Vegetable.VEGAN:
        return _getVegetableCircleIcon(
          Colors.orange,
          Colors.green[700],
          iconData: MdiIcons.leaf,
        );

      case Vegetable.NON_VEGETARIAN:
        return _getVegetableCircleIcon(
          Colors.lightBlue[300],
          Colors.brown[800],
          iconData: MdiIcons.cow,
        );

      default:
        return Stack(
          children: <Widget>[
            _getVegetableCircleIcon(
              Colors.orange,
              Colors.green[700],
            ),
            ClipPath(
              clipper: OneThirdClipperRight(),
              child: _getVegetableCircleIcon(
                Colors.lightBlue[300],
                Colors.brown[800],
              ),
            ),
            ClipPath(
              clipper: OneThirdClipperLeft(),
              child: _getVegetableCircleIcon(
                Colors.green[700],
                Colors.amber,
              ),
            ),
          ],
        );
    }
  }

  Widget _getVegetableCircleIcon(Color backgroundColor, Color iconColor,
      {IconData iconData}) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
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
