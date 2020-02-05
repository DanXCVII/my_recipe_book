import 'package:equatable/equatable.dart';

import '../../models/ingredient.dart';

abstract class RecipeScreenIngredientsState extends Equatable {
  const RecipeScreenIngredientsState();
}

class InitialRecipeScreenIngredientsState extends RecipeScreenIngredientsState {
  @override
  List<Object> get props => [];
}

class LoadedRecipeIngredients extends RecipeScreenIngredientsState {
  final List<List<CheckableIngredient>> ingredients;
  final double servings;
  final List<bool> sectionCheck;

  const LoadedRecipeIngredients(
      [this.ingredients = const [[]], this.servings, this.sectionCheck]);

  @override
  List<Object> get props => [ingredients, servings, sectionCheck];

  @override
  String toString() =>
      'ingredients loaded { ingredients: $ingredients, servings: $servings, sectionCheck: $sectionCheck }';
}
