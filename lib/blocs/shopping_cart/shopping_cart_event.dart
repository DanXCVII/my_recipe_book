part of 'shopping_cart_bloc.dart';

abstract class ShoppingCartEvent extends Equatable {
  const ShoppingCartEvent();

  @override
  List<Object> get props => [];
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

class CheckIngredients extends ShoppingCartEvent {
  final Recipe recipeName;
  final List<CheckableIngredient> ingredients;

  const CheckIngredients(this.ingredients, this.recipeName);

  @override
  List<Object> get props => [ingredients, recipeName];
}

class RemoveIngredients extends ShoppingCartEvent {
  final Recipe recipeName;
  final List<Ingredient> ingredients;

  const RemoveIngredients(this.ingredients, this.recipeName);

  @override
  List<Object> get props => [ingredients, recipeName];
}
