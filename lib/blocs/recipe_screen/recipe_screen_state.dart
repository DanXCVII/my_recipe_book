part of 'recipe_screen_bloc.dart';

abstract class RecipeScreenState extends Equatable {
  const RecipeScreenState();
}

class RecipeScreenInfo extends RecipeScreenState {
  final Recipe recipe;
  final List<String> categoryImages;

  RecipeScreenInfo(
    this.recipe,
    this.categoryImages,
  );

  @override
  List<Object> get props => [
        recipe,
        categoryImages,
      ];
}

class RecipeEditedDeleted extends RecipeScreenState {
  RecipeEditedDeleted();

  @override
  List<Object> get props => [];
}
