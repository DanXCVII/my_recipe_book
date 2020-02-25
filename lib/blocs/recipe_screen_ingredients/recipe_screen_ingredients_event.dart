part of 'recipe_screen_ingredients_bloc.dart';

abstract class RecipeScreenIngredientsEvent extends Equatable {
  const RecipeScreenIngredientsEvent();

  @override
  List<Object> get props => [];
}

class InitializeIngredients extends RecipeScreenIngredientsEvent {
  final String recipeName;
  final double servings;
  final List<List<Ingredient>> ingredients;

  const InitializeIngredients(this.recipeName, this.servings, this.ingredients);

  @override
  List<Object> get props => [recipeName, servings, ingredients];

  @override
  String toString() =>
      'initialize ingredients { recipeName : $recipeName, servings: $servings, ingredients: $ingredients }';
}

class AddToCart extends RecipeScreenIngredientsEvent {
  final String recipeName;
  final List<Ingredient> ingredients;

  const AddToCart(this.recipeName, this.ingredients);

  @override
  List<Object> get props => [recipeName, ingredients];

  @override
  String toString() =>
      'add to cart { recipeName: $recipeName, ingredients: $ingredients }';
}

class RemoveFromCart extends RecipeScreenIngredientsEvent {
  final String recipeName;
  final List<Ingredient> ingredients;

  const RemoveFromCart(this.recipeName, this.ingredients);

  @override
  List<Object> get props => [recipeName, ingredients];

  @override
  String toString() =>
      'remove from cart { recipeName : $recipeName, ingredients: $ingredients }';
}

class DecreaseServings extends RecipeScreenIngredientsEvent {
  final double newServings;

  const DecreaseServings(this.newServings);

  @override
  List<Object> get props => [newServings];

  @override
  String toString() => 'decrease servings { newServings : $newServings }';
}

class IncreaseServings extends RecipeScreenIngredientsEvent {
  final double newServings;

  const IncreaseServings(this.newServings);

  @override
  List<Object> get props => [newServings];

  @override
  String toString() => 'increase servings { newServings : $newServings }';
}
