part of 'recipe_screen_ingredients_bloc.dart';

abstract class RecipeScreenIngredientsEvent extends Equatable {
  const RecipeScreenIngredientsEvent();

  @override
  List<Object?> get props => [];
}

class InitializeIngredients extends RecipeScreenIngredientsEvent {
  final String recipeName;
  final double? servings;
  final List<List<Ingredient>> ingredients;

  const InitializeIngredients(this.recipeName, this.servings, this.ingredients);

  @override
  List<Object?> get props => [recipeName, servings, ingredients];

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

class UpdateServings extends RecipeScreenIngredientsEvent {
  final double? oldServings;
  final double newServings;

  const UpdateServings(
    this.oldServings,
    this.newServings,
  );

  @override
  List<Object?> get props => [
        oldServings,
        newServings,
      ];
}
