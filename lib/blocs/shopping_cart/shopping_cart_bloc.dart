import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_recipe_book/models/recipe.dart';

import '../../hive.dart';
import '../../models/ingredient.dart';

part 'shopping_cart_event.dart';
part 'shopping_cart_state.dart';

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  @override
  ShoppingCartState get initialState {
    return LoadingShoppingCart();
  }

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
    Map<Recipe, List<CheckableIngredient>> shoppingCart =
        await HiveProvider().getShoppingCart();

    yield LoadedShoppingCart(shoppingCart);
  }

  Stream<ShoppingCartState> _mapCleanAddIngredientsToState(
      CleanAddIngredients event) async* {
    await HiveProvider()
        .removeAndAddIngredients(event.recipeName, event.ingredients);

    yield LoadedShoppingCart(await HiveProvider().getShoppingCart());
  }

  Stream<ShoppingCartState> _mapRemoveIngredientsToState(
      RemoveIngredients event) async* {
    await HiveProvider()
        .removeIngredientsFromCart(event.recipeName.name, event.ingredients);
    yield LoadedShoppingCart(await HiveProvider().getShoppingCart());
  }

  Stream<ShoppingCartState> _mapCheckIngredientsToState(
      CheckIngredients event) async* {
    for (CheckableIngredient i in event.ingredients) {
      await HiveProvider().checkIngredient(
          event.recipeName.name, i.copyWith(checked: !i.checked));
    }

    Map<Recipe, List<CheckableIngredient>> shoppingCart =
        await HiveProvider().getShoppingCart();

    yield LoadedShoppingCart(shoppingCart);
  }
}
