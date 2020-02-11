import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:my_recipe_book/widgets/icon_info_message.dart';

import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_event.dart';
import '../blocs/shopping_cart/shopping_cart_state.dart';
import '../generated/i18n.dart';
import '../helper.dart';
import '../hive.dart';
import '../models/ingredient.dart';
import '../widgets/dialogs/shopping_cart_add_dialog.dart';
import '../widgets/search.dart';

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
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 22, 22, 12),
                      child: AddShoppingCartDialog(),
                    ),
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
      Map<String, List<CheckableIngredient>> ingredients,
      BuildContext context,
      scaleFactor) {
    List<String> recipes = ingredients.keys.toList();
    if (ingredients['summary'].isEmpty) {
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
          ingredBackgroundColor,
          ingredients,
          context,
        );
      } else {
        return Dismissible(
          key: Key('$recipeName'),
          onDismissed: (_) {
            List<Ingredient> removeIngreds = ingredients[recipeName]
                .map((ingred) => ingred.getIngredient())
                .toList();
            BlocProvider.of<ShoppingCartBloc>(context)
                .add(RemoveIngredients(removeIngreds, recipeName));
          },
          background: _getPrimaryBackgroundDismissible(),
          secondaryBackground: _getSecondaryBackgroundDismissible(),
          child: getRecipeTile(
            recipeName,
            ingredBackgroundColor,
            ingredients,
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
              description: S.of(context).shopping_cart_is_empty)),
    );
  }

  Widget getRecipeTile(
      String recipeName,
      Color backgroundcolor,
      Map<String, List<CheckableIngredient>> ingredients,
      BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          recipeName,
        ),
        children: ingredients[recipeName].map((ingredient) {
          return Dismissible(
            key: Key('$recipeName${ingredient.name}${ingredient.unit}'),
            onDismissed: (_) {
              BlocProvider.of<ShoppingCartBloc>(context).add(RemoveIngredients([
                Ingredient(
                    name: ingredient.name,
                    amount: ingredient.amount,
                    unit: ingredient.unit)
              ], recipeName));
            },
            background: _getPrimaryBackgroundDismissible(),
            secondaryBackground: _getSecondaryBackgroundDismissible(),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundcolor,
              ),
              child: IngredientRow(
                ingredient: ingredient,
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

class IngredientRow extends StatelessWidget {
  final CheckableIngredient ingredient;
  final String recipeName;
  final Color textColor;
  final bool showBorder;

  IngredientRow({
    Key key,
    this.textColor,
    this.showBorder = false,
    @required this.recipeName,
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
              splashColor: Colors.transparent,
              iconSize: 30,
              icon: Icon(
                ingredient.checked
                    ? GroovinMaterialIcons.check_circle_outline
                    : GroovinMaterialIcons.circle_outline,
              ),
              color: ingredient.checked ? Colors.green : Colors.grey,
              onPressed: () {
                BlocProvider.of<ShoppingCartBloc>(context)
                    .add(CheckIngredients([ingredient], recipeName));
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
