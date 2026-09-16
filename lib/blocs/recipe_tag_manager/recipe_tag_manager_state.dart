part of 'recipe_tag_manager_bloc.dart';

abstract class RecipeTagManagerState extends Equatable {
  const RecipeTagManagerState();
}

class LoadingRecipeTagManager extends RecipeTagManagerState {
  @override
  List<Object> get props => [];
}

class LoadedRecipeTagManager extends RecipeTagManagerState {
  final List<StringIntTuple> recipeTags;
  final List<StringIntTuple> selectedTags;

  LoadedRecipeTagManager({
    List<StringIntTuple> recipeTags = const [],
    List<StringIntTuple> selectedTags = const [],
  }) : recipeTags = List.unmodifiable(recipeTags),
       selectedTags = List.unmodifiable(selectedTags);

  @override
  List<Object> get props => [recipeTags, selectedTags];
}
