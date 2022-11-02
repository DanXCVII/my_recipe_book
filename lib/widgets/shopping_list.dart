import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/constants/global_settings.dart';

import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as Constants;
import '../generated/i18n.dart';
import '../util/helper.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import 'icon_info_message.dart';
import 'recipe_image_hero.dart';

class ShoppingListSummary extends StatelessWidget {
  final Recipe /*?*/ summaryRecipe;
  final List<CheckableIngredient>? ingredients;

  const ShoppingListSummary(
    this.ingredients,
    this.summaryRecipe, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        children: List.generate(ingredients!.length * 2 + 1, (index) {
          if (index % 2 != 0) {
            int ingredientIndex = ((index - 1) / 2).round();
            CheckableIngredient currentIngred = ingredients![ingredientIndex];

            return Dismissible(
              key: Key(
                  '${currentIngred.name}${currentIngred.name}${currentIngred.unit}'),
              onDismissed: (_) {
                BlocProvider.of<ShoppingCartBloc>(context).add(
                    RemoveIngredients(
                        [currentIngred.getIngredient()], summaryRecipe));
              },
              background: PrimaryBackgroundDismissable(),
              secondaryBackground: SecondaryBackgroundDismissible(),
              child: ListTile(
                onTap: () {
                  BlocProvider.of<ShoppingCartBloc>(context).add(
                    CheckIngredients(
                      [currentIngred],
                      summaryRecipe,
                    ),
                  );
                },
                //  tileColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  "${currentIngred.name}",
                  style: TextStyle(
                    decoration: currentIngred.checked
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                trailing:
                    currentIngred.amount == null && currentIngred.unit == ""
                        ?
                        // needs size, otherwise error
                        Container(width: 1, height: 1)
                        : Text(
                            "${currentIngred.amount != null ? (GlobalSettings().showDecimal() ? cutDouble(currentIngred.amount!) : getFractionDouble(currentIngred.amount!)) : ""}${currentIngred.unit == null ? "" : " " + currentIngred.unit!}",
                            style: TextStyle(
                              decoration: currentIngred.checked
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                leading: Checkbox(
                  activeColor: Colors.green[700],
                  shape: CircleBorder(),
                  value: currentIngred.checked,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  onChanged: (bool? x) {
                    BlocProvider.of<ShoppingCartBloc>(context).add(
                      CheckIngredients(
                        [currentIngred],
                        summaryRecipe,
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return Container(
              //color: Theme.of(context).scaffoldBackgroundColor,
              child: Divider(),
            );
          }
        }),
      ),
    );
  }
}

class ShoppingList extends StatelessWidget {
  final bool roundBorders;

  final Map<Recipe, List<CheckableIngredient>> ingredients;

  const ShoppingList(
    this.ingredients, {
    this.roundBorders = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Recipe> recipes = ingredients.keys.toList();
    if (ingredients == null ||
        ingredients.keys.isEmpty ||
        ingredients[ingredients.keys.first]!.isEmpty) {
      return displayNothingAdded(context);
    }
    Recipe summaryRecipe =
        recipes.firstWhere((recipe) => recipe.name == Constants.summary);
    if (summaryRecipe != recipes.first) {
      recipes.removeWhere((recipe) => recipe.name == "summary");
      recipes.insert(0, summaryRecipe);
    }
    Color? ingredBackgroundColor =
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
              roundBorders: roundBorders,
            );
          } else {
            return Dismissible(
              key: Key('$recipe'),
              onDismissed: (_) {
                List<Ingredient> removeIngreds = ingredients[recipe]!
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
                roundBorders: roundBorders,
              ),
            );
          }
        }).toList()
          ..add(Center(child: Container(height: 60))),
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
            description: I18n.of(context)!.shopping_cart_is_empty),
      ),
    );
  }
}

class ShoppingCartListTile extends StatelessWidget {
  final Recipe recipe;
  final List<CheckableIngredient>? ingredients;
  final Color? ingredientTextColor;
  final Color? backgroundColor;
  final bool roundBorders;

  const ShoppingCartListTile(
    this.recipe,
    this.backgroundColor,
    this.ingredients, {
    this.ingredientTextColor,
    this.roundBorders = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: roundBorders
              ? BorderRadius.circular(15.0)
              : BorderRadius.circular(3.0),
        ),
        child: ExpansionTile(
          leading: recipe.name == Constants.summary || recipe.notes == "noLink"
              ? null
              : RecipeImageHero(
                  recipe,
                  "${recipe.name}s",
                  showAds: true,
                ),
          title: Text(
            recipe.name == Constants.summary
                ? I18n.of(context)!.summary
                : recipe.name,
          ),
          children: ingredients!.map((ingredient) {
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
              background: PrimaryBackgroundDismissable(
                roundBottomBorder:
                    ingredients!.last == ingredient && roundBorders,
              ),
              secondaryBackground: SecondaryBackgroundDismissible(
                roundBottomBorder:
                    ingredients!.last == ingredient && roundBorders,
              ),
              child: InkWell(
                onTap: () {
                  BlocProvider.of<ShoppingCartBloc>(context)
                      .add(CheckIngredients([ingredient], recipe));
                },
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            ingredients!.last == ingredient && roundBorders
                                ? BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15))
                                : BorderRadius.zero,
                        color: backgroundColor,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(),
                            child: Center(
                              child: Checkbox(
                                activeColor: Colors.green[700],
                                value: ingredient.checked,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                onChanged: (bool? x) {
                                  BlocProvider.of<ShoppingCartBloc>(context)
                                      .add(
                                    CheckIngredients(
                                      [ingredient],
                                      recipe,
                                    ),
                                  );
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
                                      ? Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .color
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
                                      '${(GlobalSettings().showDecimal() ? cutDouble(ingredient.amount!) : getFractionDouble(ingredient.amount!))} ${ingredient.unit == null ? "" : ingredient.unit}',
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
                                                .bodyText2!
                                                .color
                                            : ingredientTextColor,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ))
                              : null
                        ].whereType<Widget>().toList(),
                      )),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class PrimaryBackgroundDismissable extends StatelessWidget {
  final bool roundBottomBorder;

  const PrimaryBackgroundDismissable({
    this.roundBottomBorder = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            bottomLeft: roundBottomBorder ? Radius.circular(15) : Radius.zero,
            bottomRight: roundBottomBorder ? Radius.circular(15) : Radius.zero,
          )),
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

class SecondaryBackgroundDismissible extends StatelessWidget {
  final bool roundBottomBorder;

  const SecondaryBackgroundDismissible({this.roundBottomBorder = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            bottomLeft: roundBottomBorder ? Radius.circular(15) : Radius.zero,
            bottomRight: roundBottomBorder ? Radius.circular(15) : Radius.zero,
          )),
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
