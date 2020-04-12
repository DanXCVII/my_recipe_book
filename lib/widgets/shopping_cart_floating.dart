import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/app/app_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import 'dialogs/shopping_cart_add_dialog.dart';
import 'shopping_list.dart';

class ShoppingCartFloating extends StatefulWidget {
  final Offset initialPosition;

  ShoppingCartFloating({
    @required this.initialPosition,
    Key key,
  }) : super(key: key);

  @override
  _ShoppingCartFloatingState createState() => _ShoppingCartFloatingState();
}

class _ShoppingCartFloatingState extends State<ShoppingCartFloating>
    with TickerProviderStateMixin {
  double width = 100.0, height = 100.0;
  Offset position;
  bool visible = false;
  Map<Recipe, List<CheckableIngredient>> shoppingCart;

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
          child: Draggable(
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
                        return _getShoppingCartContent(state.shoppingCart);
                      } else {
                        return Text(state.toString());
                      }
                    })
                  : Container(),
            ),
            feedback: Material(
              color: Colors.transparent,
              child: _getShoppingCartContent(shoppingCart),
            ),
            childWhenDragging: Container(),
            onDraggableCanceled: (Velocity velocity, Offset offset) {
              setState(() => position = offset);
            },
          ),
        ),
      ),
    );
  }

  Widget _getShoppingCartContent(
          Map<Recipe, List<CheckableIngredient>> shoppingCart) =>
      Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                spreadRadius: 1,
                color: Theme.of(context).backgroundColor == Colors.white
                    ? Colors.grey[400]
                    : Colors.black,
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(30)),
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
              ShoppingList(shoppingCart),
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
      );
}
