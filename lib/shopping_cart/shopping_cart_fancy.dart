import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:my_recipe_book/dialogs/dialog_types.dart';
import 'package:my_recipe_book/dialogs/shopping_cart_add_dialog.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/shopping_cart.dart';
import 'package:my_recipe_book/shopping_cart/shopping_cart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_recipe_book/generated/i18n.dart';

import '../database.dart';
import '../search.dart';

class FancyShoppingCartScreen extends StatelessWidget {
  const FancyShoppingCartScreen({
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
              DBProvider.db.getRecipeNames().then((recipeNames) {
                showSearch(
                    context: context, delegate: RecipeSearch(recipeNames));
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22,22,22,12),
                    child: AddShoppingCartDialog(),
                  ),
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
            title: Text(S.of(context).shoppingcart),
            background: Image(
              image: AssetImage('images/cuisine.jpg'),
              fit: BoxFit.cover,
            )),
      ),
      SliverPadding(
        padding: EdgeInsets.all(12),
        sliver: ScopedModelDescendant<ShoppingCartKeeper>(
            builder: (context, child, model) => SliverList(
                  delegate: SliverChildListDelegate(
                      getRecipeShoppingList(model, context, scaleFactor)),
                )),
      ),
    ]);
  }

  List<Widget> getRecipeShoppingList(
      ShoppingCartKeeper scKeeper, BuildContext context, scaleFactor) {
    List<String> recipes = scKeeper.recipes;
    var shoppingCart = scKeeper.shoppingCart;
    if (shoppingCart['summary'].isEmpty) {
      return [
        displayNothingAdded(context, scaleFactor),
      ];
    }
    return recipes.map((recipeName) {
      Color ingredBackgroundColor =
          Theme.of(context).brightness == Brightness.dark
              ? Color(0xff40392F)
              : Color(0xffFEF3E1);
      if (recipeName.compareTo('summary') == 0) {
        return getRecipeTile(
          recipeName,
          scKeeper,
          ingredBackgroundColor,
        );
      } else {
        return Dismissible(
          key: Key('$recipeName'),
          onDismissed: (_) {
            scKeeper.removeRecipeFromCart(recipeName);
          },
          background: _getPrimaryBackgroundDismissible(),
          secondaryBackground: _getSecondaryBackgroundDismissible(),
          child: getRecipeTile(
            recipeName,
            scKeeper,
            ingredBackgroundColor,
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
        child: Text(
          S.of(context).shopping_cart_is_empty,
          textScaleFactor: deviceHeight / 800,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontFamily: 'RibeyeMarrow',
          ),
        ),
      ),
    );
  }

  Widget getRecipeTile(
      String recipeName, ShoppingCartKeeper scKeeper, Color backgroundcolor) {
    Map<String, List<CheckableIngredient>> shoppingCart = scKeeper.shoppingCart;
    return Card(
      child: ExpansionTile(
        title: Text(
          recipeName,
        ),
        children: shoppingCart[recipeName].map((ingredient) {
          return Dismissible(
            key: Key('$recipeName${ingredient.name}${ingredient.unit}'),
            onDismissed: (_) {
              scKeeper.removeIngredientFromCart(
                recipeName,
                Ingredient(
                    name: ingredient.name,
                    amount: ingredient.amount,
                    unit: ingredient.unit),
              );
            },
            background: _getPrimaryBackgroundDismissible(),
            secondaryBackground: _getSecondaryBackgroundDismissible(),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundcolor,
                border: Border(
                  bottom: BorderSide(
                      width:
                          ingredient == shoppingCart[recipeName].last ? 0 : 0),
                ),
              ),
              child: IngredientRow(
                ingredient: ingredient,
                scKeeper: scKeeper,
                recipeName: recipeName,
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
              GroovinMaterialIcons.delete_sweep,
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
              GroovinMaterialIcons.delete_sweep,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

class RoundEdgeShoppingCartClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0.0, 240)
      ..quadraticBezierTo(10, 200, 50, 200)
      ..lineTo(size.width - 50, 200)
      ..quadraticBezierTo(size.width - 10, 200, size.width, 240)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
