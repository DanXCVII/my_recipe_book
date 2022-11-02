import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_book/constants/global_constants.dart' as Constants;

import '../blocs/app/app_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import 'dialogs/shopping_cart_add_dialog.dart';
import 'shopping_list.dart';

class ShoppingCartFloating extends StatefulWidget {
  final Offset initialPosition;

  ShoppingCartFloating({
    required this.initialPosition,
    Key? key,
  }) : super(key: key);

  @override
  _ShoppingCartFloatingState createState() => _ShoppingCartFloatingState();
}

class _ShoppingCartFloatingState extends State<ShoppingCartFloating>
    with TickerProviderStateMixin {
  double width = 100.0, height = 100.0;
  late Offset position;
  bool visible = false;
  Map<Recipe, List<CheckableIngredient>>? shoppingCart;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          if (state is LoadedState) {
            if (state.shoppingCartOpen != visible) {
              setState(() {
                visible = state.shoppingCartOpen;
              });
            }
          }
        },
        child: Material(
          color: Colors.transparent,
          child: AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 150),
            curve: Curves.fastOutSlowIn,
            child: visible
                ? BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                    builder: (context, state) {
                    if (state is LoadingShoppingCart) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is LoadedShoppingCart) {
                      if (shoppingCart != state.shoppingCart) {
                        shoppingCart = state.shoppingCart;
                      }
                      return BlocBuilder<AppBloc, AppState>(
                          builder: (context, appState) {
                        if (appState is LoadedState) {
                          return _getShoppingCartContent(state.shoppingCart,
                              appState.showShoppingCartSummary);
                        } else {
                          return Container();
                        }
                      });
                    } else {
                      return Text(state.toString());
                    }
                  })
                : Container(
                    height: 550,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _getShoppingCartContent(
      Map<Recipe, List<CheckableIngredient>> shoppingCart, bool showSummary) {
    if (shoppingCart == null) return Container();
    Recipe? _summaryRecipe;

    if (showSummary) {
      _summaryRecipe = shoppingCart.keys
          .toList()
          .firstWhere((recipe) => recipe.name == Constants.summary);
    }

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    spreadRadius: 1,
                    color: Theme.of(context).backgroundColor == Colors.white
                        ? Colors.grey[400]!
                        : Colors.black,
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Theme.of(context).backgroundColor == Colors.white
                    ? Colors.grey[200]
                    : Colors.grey[800]),
            height: MediaQuery.of(context).size.height > 500
                ? 500
                : MediaQuery.of(context).size.height,
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: <Widget>[
                  showSummary
                      ? ShoppingListSummary(
                          shoppingCart[_summaryRecipe!],
                          _summaryRecipe,
                        )
                      : ShoppingList(
                          shoppingCart,
                          roundBorders: false,
                        ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 2.0, // default 20.0
                            spreadRadius: 1.0, // default 5.0
                            offset: Offset(0.0, 1.5),
                          ),
                        ],
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: BlocBuilder<AppBloc, AppState>(
                          builder: (context, state) {
                        if (state is LoadedState) {
                          return Switch(
                            value: state.showShoppingCartSummary,
                            onChanged: (value) {
                              BlocProvider.of<AppBloc>(context)
                                  .add(ShoppingCartShowSummary(value));
                            },
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                      ),
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
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 383, top: 25),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor == Colors.white
                    ? Colors.grey[900]
                    : Colors.grey[200],
                shape: BoxShape.circle),
            width: 25,
            height: 25,
          ),
        ),
        Container(
          width: 430,
          height: 60,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Theme.of(context).backgroundColor == Colors.white
                      ? Colors.grey[400]
                      : Colors.grey[900],
                  size: 36,
                ),
                onPressed: () {
                  BlocProvider.of<AppBloc>(context)
                    ..add(ChangeShoppingCartView(false));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
