import '../../models/ingredient.dart';

abstract class ShoppingCartState {
  const ShoppingCartState();
}

class LoadingShoppingCart extends ShoppingCartState {}

class LoadedShoppingCart extends ShoppingCartState {
  final Map<String, List<CheckableIngredient>> shoppingCart;

  LoadedShoppingCart(this.shoppingCart);

  @override
  String toString() => 'Loaded recipe overview { shoppingCart: $shoppingCart}';
}
