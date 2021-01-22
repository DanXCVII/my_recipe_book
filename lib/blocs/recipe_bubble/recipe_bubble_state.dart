part of 'recipe_bubble_bloc.dart';

abstract class RecipeBubbleState extends Equatable {
  const RecipeBubbleState();
}

class LoadedRecipeBubbles extends RecipeBubbleState {
  final List<Recipe> recipes;

  LoadedRecipeBubbles(this.recipes);

  @override
  List<Object> get props => [recipes];
}
