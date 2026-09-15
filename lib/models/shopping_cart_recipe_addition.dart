import 'package:equatable/equatable.dart';

import 'ingredient.dart';

class ShoppingCartRecipeAddition extends Equatable {
  const ShoppingCartRecipeAddition({
    required this.recipeName,
    required this.ingredients,
    this.servings,
  });

  final String recipeName;
  final List<Ingredient> ingredients;
  final double? servings;

  @override
  List<Object?> get props => [recipeName, ingredients, servings];
}
