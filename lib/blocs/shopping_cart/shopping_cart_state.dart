import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/models/ingredient.dart';

abstract class ShoppingCartState extends Equatable {
  const ShoppingCartState();
}

class LoadingShoppingCart extends ShoppingCartState {
  @override
  List<Object> get props => [];
}

class LoadedShoppingCart extends ShoppingCartState {
  final Map<String, List<CheckableIngredient>> shoppingCart;

  LoadedShoppingCart(this.shoppingCart);

  @override
  List<Object> get props => [shoppingCart];

  @override
  String toString() => 'Loaded recipe overview { shoppingCart: $shoppingCart}';
}
