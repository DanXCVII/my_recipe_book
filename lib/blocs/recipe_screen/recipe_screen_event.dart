part of 'recipe_screen_bloc.dart';

abstract class RecipeScreenEvent extends Equatable {
  const RecipeScreenEvent();
}

class InitRecipeScreen extends RecipeScreenEvent {
  final Recipe/*!*//*!*/ recipe;

  const InitRecipeScreen(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class HideRecipe extends RecipeScreenEvent {
  HideRecipe();

  @override
  List<Object> get props => [];
}

// Not used but maybe nice to have
class ShowRecipe extends RecipeScreenEvent {
  final Recipe recipe;

  ShowRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}
