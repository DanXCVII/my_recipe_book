import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:my_recipe_book/models/shopping_cart.dart';
import 'package:my_recipe_book/shopping_cart/shopping_cart.dart';
import 'package:scoped_model/scoped_model.dart';

import '../database.dart';
import '../recipe.dart';
import '../search.dart';

class FancyShoppingCartScreen extends StatelessWidget {
  const FancyShoppingCartScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          )
        ],
        expandedHeight: 200.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text('ShoppingCart'),
          background:
              Image.asset('images/shopping_basket.jpg', fit: BoxFit.cover),
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.all(12),
        sliver: ScopedModelDescendant<ShoppingCartKeeper>(
            builder: (context, child, model) => SliverList(
                  delegate: SliverChildListDelegate(
                      getRecipeShoppingList(model, context)),
                )),
      ),
    ]);
  }

  List<Widget> getRecipeShoppingList(
      ShoppingCartKeeper scKeeper, BuildContext context) {
    List<String> recipes = scKeeper.recipes;
    var shoppingCart = scKeeper.shoppingCart;
    if (shoppingCart['summary'].isEmpty) {
      return [
        Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 400,
                  child: Center(
                      child: Text(
                    "Nothing added yet",
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'RibeyeMarrow',
                    ),
                  ))),
              Container(
                  height: (MediaQuery.of(context).size.height - 415) / 2,
                  child: Align(
                      alignment: Alignment(1, 1),
                      child: Image.asset(
                        'images/cookingPen.png',
                        height: 75,
                      )))
            ],
          ),
        )
      ];
    }
    return recipes.map((recipeName) {
      Color ingredBackgroundColor =
          Theme.of(context).brightness == Brightness.dark
              ? Color(0xff40392F)
              : Color(0xffFEF3E1);
      if (recipeName.compareTo('summery') == 0) {
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
          background: _getPrimaryBackgroundDismissable(),
          secondaryBackground: _getSecondaryBackgroundDismissable(),
          child: getRecipeTile(
            recipeName,
            scKeeper,
            ingredBackgroundColor,
          ),
        );
      }
    }).toList();
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
            background: _getPrimaryBackgroundDismissable(),
            secondaryBackground: _getSecondaryBackgroundDismissable(),
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

  Widget _getPrimaryBackgroundDismissable() {
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

  Widget _getSecondaryBackgroundDismissable() {
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
