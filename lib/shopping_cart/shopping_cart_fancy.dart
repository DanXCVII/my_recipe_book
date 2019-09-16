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
                  delegate:
                      SliverChildListDelegate(getRecipeShoppingList(model)),
                )),
      ),
    ]);
  }

  List<Widget> getRecipeShoppingList(ShoppingCartKeeper scKeeper) {
    List<String> recipes = scKeeper.recipesOrder;
    return recipes.map((recipeName) {
      if (recipeName.compareTo('summery') == 0) {
        return getRecipeTile(recipeName, scKeeper);
      } else {
        return Dismissible(
          key: Key('$recipeName'),
          onDismissed: (_) {
            scKeeper.removeRecipeFromCart(recipeName);
          },
          background: _getPrimaryBackgroundDismissable(),
          secondaryBackground: _getSecondaryBackgroundDismissable(),
          child: getRecipeTile(recipeName, scKeeper),
        );
      }
    }).toList();
  }

  Widget getRecipeTile(String recipeName, ShoppingCartKeeper scKeeper) {
    Map<String, List<CheckableIngredient>> shoppingCart =
        scKeeper.fullShoppingCart;
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
                color: Color(0xffFEF3E1),
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
