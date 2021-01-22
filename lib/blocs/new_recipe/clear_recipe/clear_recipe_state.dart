part of 'clear_recipe_bloc.dart';

abstract class ClearRecipeState {
  const ClearRecipeState();
}

class InitialClearRecipeState extends ClearRecipeState {}

class ClearedRecipe extends ClearRecipeState {
  final Recipe recipe;

  ClearedRecipe(
    this.recipe,
  );
}

class RemovedRecipeImage extends ClearRecipeState {}
