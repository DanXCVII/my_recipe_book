part of 'recipe_tag_manager_bloc.dart';

abstract class RecipeTagManagerState extends Equatable {
  const RecipeTagManagerState();
}

class LoadingRecipeTagManager extends RecipeTagManagerState {
  @override
  List<Object> get props => [];
}

class LoadedRecipeTagManager extends RecipeTagManagerState {
  final List<StringIntTuple/*!*/> recipeTags;

  const LoadedRecipeTagManager([this.recipeTags = const []]);

  @override
  List<Object> get props => [recipeTags];
}
