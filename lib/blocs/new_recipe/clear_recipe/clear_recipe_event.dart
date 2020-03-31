part of 'clear_recipe_bloc.dart';

abstract class ClearRecipeEvent {
  const ClearRecipeEvent();
}

class Clear extends ClearRecipeEvent {
  final bool editingRecipe;

  final DateTime dateTime;

  Clear(this.editingRecipe, this.dateTime);
}

class RemoveRecipeImage extends ClearRecipeEvent {
  final bool editingRecipe;

  RemoveRecipeImage(this.editingRecipe);
}
