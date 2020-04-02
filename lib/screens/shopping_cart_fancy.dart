import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as Constants;
import '../generated/i18n.dart';
import '../helper.dart';
import '../local_storage/hive.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../widgets/dialogs/shopping_cart_add_dialog.dart';
import '../widgets/icon_info_message.dart';
import '../widgets/recipe_image_hero.dart';
import '../widgets/search.dart';

class FancyShoppingCartScreen extends StatelessWidget {
  final Image shoppingCartImage;

  const FancyShoppingCartScreen(
    this.shoppingCartImage, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.height / 800;
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        centerTitle: false,
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
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<ShoppingCartBloc>(context),
                  child: ShoppingCartAddDialog(),
                ),
              );
            },
          ),
        ],
        expandedHeight: scaleFactor * 200.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: false,
          title: Text(I18n.of(context).shoppingcart),
          background: shoppingCartImage,
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.all(12),
        sliver: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
            builder: (context, state) {
          if (state is LoadingShoppingCart) {
            return SliverList(
                delegate: SliverChildListDelegate(
                    [Center(child: CircularProgressIndicator())]));
          } else if (state is LoadedShoppingCart) {
            return SliverList(
              delegate: SliverChildListDelegate(getRecipeShoppingList(
                  state.shoppingCart, context, scaleFactor)),
            );
          } else {
            return Text(state.toString());
          }
        }),
      ),
    ]);
  }

  List<Widget> getRecipeShoppingList(
      Map<Recipe, List<CheckableIngredient>> ingredients,
      BuildContext context,
      scaleFactor) {
    List<Recipe> recipes = ingredients.keys.toList();
    if (ingredients.keys.isEmpty ||
        ingredients[ingredients.keys.first].isEmpty) {
      return [
        displayNothingAdded(context, scaleFactor),
      ];
    }
    Recipe summaryRecipe =
        recipes.firstWhere((recipe) => recipe.name == Constants.summary);
    if (summaryRecipe != recipes.first) {
      recipes.removeWhere((recipe) => recipe.name == "summary");
      recipes.insert(0, summaryRecipe);
    }
    return recipes.map((recipe) {
      Color ingredBackgroundColor =
          Theme.of(context).brightness == Brightness.dark
              ? Color(0xff40392F)
              : Colors.grey[100];
      if (recipe.name == 'summary') {
        return _getRecipeTile(
          recipe,
          ingredBackgroundColor,
          ingredients[recipe],
          context,
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
          background: _getPrimaryBackgroundDismissible(),
          secondaryBackground: _getSecondaryBackgroundDismissible(),
          child: _getRecipeTile(
            recipe,
            ingredBackgroundColor,
            ingredients[recipe],
            context,
          ),
        );
      }
    }).toList();
  }

  Widget displayNothingAdded(BuildContext context, double scaleFactor) {
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

  Widget _getRecipeTile(Recipe recipe, Color backgroundcolor,
      List<CheckableIngredient> ingredients, BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: recipe.name == Constants.summary || recipe.notes == "noLink"
            ? null
            : RecipeImageHero(recipe),
        title: Text(
          recipe.name == Constants.summary
              ? I18n.of(context).summary
              : recipe.name,
        ),
        children: ingredients.map((ingredient) {
          return Dismissible(
            key: Key('${recipe.name}${ingredient.name}${ingredient.unit}'),
            onDismissed: (_) {
              BlocProvider.of<ShoppingCartBloc>(context).add(RemoveIngredients([
                Ingredient(
                    name: ingredient.name,
                    amount: ingredient.amount,
                    unit: ingredient.unit)
              ], recipe));
            },
            background: _getPrimaryBackgroundDismissible(),
            secondaryBackground: _getSecondaryBackgroundDismissible(),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundcolor,
              ),
              child: IngredientRow(
                ingredient: ingredient,
                recipe: recipe,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _getPrimaryBackgroundDismissible() {
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

  Widget _getSecondaryBackgroundDismissible() {
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
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Container(
            width: MediaQuery.of(context).size.width - 200,
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
        Spacer(),
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
