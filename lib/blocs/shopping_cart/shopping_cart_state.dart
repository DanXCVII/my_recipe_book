part of 'shopping_cart_bloc.dart';

abstract class ShoppingCartState {
  const ShoppingCartState();
}

class LoadingShoppingCart extends ShoppingCartState {}

class LoadedShoppingCart extends ShoppingCartState {
  final ShoppingCartData data;
  final ShoppingCartData? undoSnapshot;
  final ShoppingCartActionError? actionError;

  LoadedShoppingCart(this.data, {this.undoSnapshot, this.actionError});

  Map<Recipe, List<CheckableIngredient>> get shoppingCart => data.toLegacyMap();
}

class FailedShoppingCart extends ShoppingCartState {
  final Object error;

  const FailedShoppingCart(this.error);
}

enum ShoppingCartActionError { add, check, remove, servings, restore }
