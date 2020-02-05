import 'dart:async';

import 'package:bloc/bloc.dart';

import './shopping_cart.dart';
import '../../hive.dart';
import '../../models/ingredient.dart';

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  @override
  ShoppingCartState get initialState => LoadingShoppingCart();

  @override
  Stream<ShoppingCartState> mapEventToState(
    ShoppingCartEvent event,
  ) async* {
    if (event is LoadShoppingCart) {
      yield* _mapLoadShoppingCartToState(event);
    } else if (event is CleanAddIngredients) {
      yield* _mapCleanAddIngredientsToState(event);
    } else if (event is CheckIngredients) {
      yield* _mapCheckIngredientsToState(event);
    } else if (event is RemoveIngredients) {
      yield* _mapRemoveIngredientsToState(event);
    }
  }

  Stream<ShoppingCartState> _mapLoadShoppingCartToState(
      ShoppingCartEvent event) async* {
    Map<String, List<CheckableIngredient>> shoppingCart =
        HiveProvider().getShoppingCart();

    yield LoadedShoppingCart(shoppingCart);
  }

  Stream<ShoppingCartState> _mapCleanAddIngredientsToState(
      CleanAddIngredients event) async* {
    await HiveProvider()
        .removeAndAddIngredients(event.recipeName, event.ingredients);

    yield LoadedShoppingCart(HiveProvider().getShoppingCart());
  }

  Stream<ShoppingCartState> _mapRemoveIngredientsToState(
      RemoveIngredients event) async* {
    await HiveProvider()
        .removeIngredientsFromCart(event.recipeName, event.ingredients);
    yield LoadedShoppingCart(HiveProvider().getShoppingCart());
  }

  Stream<ShoppingCartState> _mapCheckIngredientsToState(
      CheckIngredients event) async* {
    for (CheckableIngredient i in event.ingredients) {
      await HiveProvider()
          .checkIngredient(event.recipeName, i.copyWith(checked: !i.checked));
    }

    Map<String, List<CheckableIngredient>> shoppingCart =
        HiveProvider().getShoppingCart();

    yield LoadedShoppingCart(shoppingCart);
  }
}
