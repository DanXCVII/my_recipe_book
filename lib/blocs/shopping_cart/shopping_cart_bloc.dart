import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:my_recipe_book/hive.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import './shopping_cart.dart';

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
    yield LoadedShoppingCart(HiveProvider().getShoppingCart());
  }

  Stream<ShoppingCartState> _mapCleanAddIngredientsToState(
      CleanAddIngredients event) async* {
    HiveProvider().removeAndAddIngredients(event.recipeName, event.ingredients);
    yield LoadedShoppingCart(HiveProvider().getShoppingCart());
  }

  Stream<ShoppingCartState> _mapRemoveIngredientsToState(
      RemoveIngredients event) async* {
    HiveProvider()
        .removeIngredientsFromCart(event.recipeName, event.ingredients);
    yield LoadedShoppingCart(HiveProvider().getShoppingCart());
  }

  Stream<ShoppingCartState> _mapCheckIngredientsToState(
      CheckIngredients event) async* {
    for (CheckableIngredient i in event.ingredients) {
      HiveProvider().checkIngredient(event.recipeName, i);
    }

    yield LoadedShoppingCart(HiveProvider().getShoppingCart());
  }
}
