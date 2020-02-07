part of 'recipe_screen_bloc.dart';

abstract class RecipeScreenState extends Equatable {
  const RecipeScreenState();
}

class RecipeScreenInfo extends RecipeScreenState {
  final Recipe recipe;

  RecipeScreenInfo(this.recipe);

  @override
  List<Object> get props => [recipe];
}
