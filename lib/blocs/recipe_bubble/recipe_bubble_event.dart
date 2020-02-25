part of 'recipe_bubble_bloc.dart';

abstract class RecipeBubbleEvent extends Equatable {
  const RecipeBubbleEvent();
}

class AddRecipeBubble extends RecipeBubbleEvent {
  final Recipe recipe;

  const AddRecipeBubble(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class RemoveRecipeBubble extends RecipeBubbleEvent {
  final Recipe recipe;

  RemoveRecipeBubble(this.recipe);

  @override
  List<Object> get props => [recipe];
}
