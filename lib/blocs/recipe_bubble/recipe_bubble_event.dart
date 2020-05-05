part of 'recipe_bubble_bloc.dart';

abstract class RecipeBubbleEvent {
  const RecipeBubbleEvent();
}

class AddRecipeBubble extends RecipeBubbleEvent {
  final List<Recipe> recipes;

  const AddRecipeBubble(this.recipes);
}

class RemoveRecipeBubble extends RecipeBubbleEvent {
  final List<Recipe> recipes;

  RemoveRecipeBubble(this.recipes);
}

class ReloadRecipeBubbles extends RecipeBubbleEvent {}
