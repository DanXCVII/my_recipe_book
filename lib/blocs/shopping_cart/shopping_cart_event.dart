part of 'shopping_cart_bloc.dart';

abstract class ShoppingCartEvent extends Equatable {
  const ShoppingCartEvent();

  @override
  List<Object?> get props => [];
}

class LoadShoppingCart extends ShoppingCartEvent {}

class CleanAddIngredients extends ShoppingCartEvent {
  final String recipeName;
  final List<Ingredient> ingredients;

  const CleanAddIngredients(this.ingredients, this.recipeName);

  @override
  List<Object> get props => [ingredients, recipeName];

  @override
  String toString() =>
      'Add ingredients { ingrdients: $ingredients, recipeName: $recipeName }';
}

class AddShoppingCartIngredient extends ShoppingCartEvent {
  final Ingredient ingredient;

  const AddShoppingCartIngredient(this.ingredient);

  @override
  List<Object> get props => [ingredient];
}

class CheckIngredients extends ShoppingCartEvent {
  final Recipe recipeName;
  final List<CheckableIngredient> ingredients;

  const CheckIngredients(this.ingredients, this.recipeName);

  @override
  List<Object> get props => [ingredients, recipeName];
}

class RemoveIngredients extends ShoppingCartEvent {
  final Recipe recipeName;
  final List<Ingredient>? ingredients;

  const RemoveIngredients(this.ingredients, this.recipeName);

  @override
  List<Object?> get props => [ingredients, recipeName];
}

class UpdateShoppingCartServings extends ShoppingCartEvent {
  final String recipeName;
  final double servings;

  const UpdateShoppingCartServings(this.recipeName, this.servings);

  @override
  List<Object> get props => [recipeName, servings];
}

class RemoveCheckedIngredients extends ShoppingCartEvent {}

class RestoreShoppingCart extends ShoppingCartEvent {
  final ShoppingCartData snapshot;

  const RestoreShoppingCart(this.snapshot);

  @override
  List<Object> get props => [snapshot];
}
