part of 'clear_recipe_bloc.dart';

abstract class ClearRecipeEvent {
  const ClearRecipeEvent();
}

class Clear extends ClearRecipeEvent {
  final bool editingRecipe;

  Clear(this.editingRecipe);
}

class RemoveRecipeImage extends ClearRecipeEvent {
  final bool editingRecipe;

  RemoveRecipeImage(this.editingRecipe);
}
