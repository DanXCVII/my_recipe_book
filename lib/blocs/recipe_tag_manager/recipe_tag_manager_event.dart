part of 'recipe_tag_manager_bloc.dart';

abstract class RecipeTagManagerEvent extends Equatable {
  const RecipeTagManagerEvent();
}

class InitializeRecipeTagManager extends RecipeTagManagerEvent {
  @override
  List<Object> get props => [];
}

class AddRecipeTags extends RecipeTagManagerEvent {
  final List<StringIntTuple> recipeTags;

  const AddRecipeTags(this.recipeTags);

  @override
  List<Object> get props => [recipeTags];
}

class DeleteRecipeTag extends RecipeTagManagerEvent {
  final StringIntTuple recipeTag;

  const DeleteRecipeTag(this.recipeTag);

  @override
  List<Object> get props => [recipeTag];
}

class UpdateRecipeTag extends RecipeTagManagerEvent {
  final StringIntTuple oldRecipeTag;
  final StringIntTuple updatedRecipeTag;

  const UpdateRecipeTag(
    this.oldRecipeTag,
    this.updatedRecipeTag,
  );

  @override
  List<Object> get props => [
        oldRecipeTag,
        updatedRecipeTag,
      ];
}

class SelectRecipeTag extends RecipeTagManagerEvent {
  final StringIntTuple recipeTag;

  const SelectRecipeTag(this.recipeTag);

  @override
  List<Object> get props => [recipeTag];
}

class UnselectRecipeTag extends RecipeTagManagerEvent {
  final StringIntTuple recipeTag;

  const UnselectRecipeTag(this.recipeTag);

  @override
  List<Object> get props => [recipeTag];
}
