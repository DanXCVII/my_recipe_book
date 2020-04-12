import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as Constants;
import '../generated/i18n.dart';
import '../helper.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import 'icon_info_message.dart';
import 'recipe_image_hero.dart';

class ShoppingList extends StatelessWidget {
  final Map<Recipe, List<CheckableIngredient>> ingredients;

  const ShoppingList(this.ingredients, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Recipe> recipes = ingredients?.keys?.toList();
    if (ingredients == null ||
        ingredients.keys.isEmpty ||
        ingredients[ingredients.keys.first].isEmpty) {
      return displayNothingAdded(context);
    }
    Recipe summaryRecipe =
        recipes.firstWhere((recipe) => recipe.name == Constants.summary);
    if (summaryRecipe != recipes.first) {
      recipes.removeWhere((recipe) => recipe.name == "summary");
      recipes.insert(0, summaryRecipe);
    }
    Color ingredBackgroundColor =
        Theme.of(context).brightness == Brightness.dark
            ? Color(0xff40392F)
            : Colors.grey[100];

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        children: recipes.map((recipe) {
          if (recipe.name == Constants.summary) {
            return ShoppingCartListTile(
              recipe,
              ingredBackgroundColor,
              ingredients[recipe],
            );
          } else {
            return Dismissible(
              key: Key('$recipe'),
              onDismissed: (_) {
                List<Ingredient> removeIngreds = ingredients[recipe]
                    .map((ingred) => ingred.getIngredient())
                    .toList();
                BlocProvider.of<ShoppingCartBloc>(context)
                    .add(RemoveIngredients(removeIngreds, recipe));
              },
              background: PrimaryBackgroundDismissable(),
              secondaryBackground: SecondaryBackgroundDismissible(),
              child: ShoppingCartListTile(
                recipe,
                ingredBackgroundColor,
                ingredients[recipe],
              ),
            );
          }
        }).toList(),
      ),
    );
  }

  Widget displayNothingAdded(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      height: deviceHeight / 2,
      child: Center(
        child: IconInfoMessage(
            iconWidget: Icon(
              Icons.shopping_basket,
              color: Colors.brown,
              size: 70.0,
            ),
            description: I18n.of(context).shopping_cart_is_empty),
      ),
    );
  }
}

class ShoppingCartListTile extends StatelessWidget {
  final Recipe recipe;
  final List<CheckableIngredient> ingredients;
  final Color ingredientTextColor;
  final Color backgroundColor;

  const ShoppingCartListTile(
    this.recipe,
    this.backgroundColor,
    this.ingredients, {
    this.ingredientTextColor,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width > 400 ? 400 : null,
      child: Card(
        child: ExpansionTile(
          leading: recipe.name == Constants.summary || recipe.notes == "noLink"
              ? null
              : RecipeImageHero(recipe, "${recipe.name}s"),
          title: Text(
            recipe.name == Constants.summary
                ? I18n.of(context).summary
                : recipe.name,
          ),
          children: ingredients.map((ingredient) {
            return Dismissible(
              key: Key('${recipe.name}${ingredient.name}${ingredient.unit}'),
              onDismissed: (_) {
                BlocProvider.of<ShoppingCartBloc>(context)
                    .add(RemoveIngredients([
                  Ingredient(
                      name: ingredient.name,
                      amount: ingredient.amount,
                      unit: ingredient.unit)
                ], recipe));
              },
              background: PrimaryBackgroundDismissable(),
              secondaryBackground: SecondaryBackgroundDismissible(),
              child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(),
                        child: Center(
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            iconSize: 30,
                            icon: Icon(
                              ingredient.checked
                                  ? MdiIcons.checkCircleOutline
                                  : MdiIcons.circleOutline,
                            ),
                            color:
                                ingredient.checked ? Colors.green : Colors.grey,
                            onPressed: () {
                              BlocProvider.of<ShoppingCartBloc>(context)
                                  .add(CheckIngredients([ingredient], recipe));
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            //'SpaghettiSauce von der Kuh mit ganz viel ',
                            '${ingredient.name}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              decoration: ingredient.checked
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: (ingredientTextColor == null)
                                  ? Theme.of(context).textTheme.body1.color
                                  : ingredientTextColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ingredient.amount != null
                          ? Container(
                              padding: EdgeInsets.all(3),
                              height: 50,
                              width: 99,
                              decoration: BoxDecoration(),
                              child: Center(
                                child: Text(
                                  '${cutDouble(ingredient.amount)} ${ingredient.unit == null ? "" : ingredient.unit}',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      decoration: ingredient.checked
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: (ingredientTextColor == null)
                                          ? Theme.of(context)
                                              .textTheme
                                              .body1
                                              .color
                                          : ingredientTextColor),
                                  maxLines: 2,
                                ),
                              ))
                          : null
                    ]..removeWhere((item) => item == null),
                  )),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class PrimaryBackgroundDismissable extends StatelessWidget {
  const PrimaryBackgroundDismissable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Icon(
              MdiIcons.deleteSweep,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

class SecondaryBackgroundDismissible extends StatefulWidget {
  SecondaryBackgroundDismissible({Key key}) : super(key: key);

  @override
  _SecondaryBackgroundDismissibleState createState() =>
      _SecondaryBackgroundDismissibleState();
}

class _SecondaryBackgroundDismissibleState
    extends State<SecondaryBackgroundDismissible> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              MdiIcons.deleteSweep,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

class IngredientRow extends StatelessWidget {
  final CheckableIngredient ingredient;
  final Recipe recipe;
  final Color textColor;
  final bool showBorder;

  IngredientRow({
    Key key,
    this.textColor,
    this.showBorder = false,
    @required this.recipe,
    @required this.ingredient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color ingredientTextColor = textColor;
    if (textColor == null)
      ingredientTextColor = Theme.of(context).textTheme.body1.color;
    return Row(
      children: <Widget>[
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(),
          child: Center(
            child: IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              iconSize: 30,
              icon: Icon(
                ingredient.checked
                    ? MdiIcons.checkCircleOutline
                    : MdiIcons.circleOutline,
              ),
              color: ingredient.checked ? Colors.green : Colors.grey,
              onPressed: () {
                BlocProvider.of<ShoppingCartBloc>(context)
                    .add(CheckIngredients([ingredient], recipe));
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              //'SpaghettiSauce von der Kuh mit ganz viel ',
              '${ingredient.name}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                decoration:
                    ingredient.checked ? TextDecoration.lineThrough : null,
                color: ingredientTextColor,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        ingredient.amount != null
            ? Container(
                padding: EdgeInsets.all(3),
                height: 50,
                width: 99,
                decoration: BoxDecoration(),
                child: Center(
                  child: Text(
                    '${cutDouble(ingredient.amount)} ${ingredient.unit == null ? "" : ingredient.unit}',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        decoration: ingredient.checked
                            ? TextDecoration.lineThrough
                            : null,
                        color: ingredientTextColor),
                    maxLines: 2,
                  ),
                ))
            : null
      ]..removeWhere((item) => item == null),
    );
  }
}
