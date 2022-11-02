part of 'recipe_overview_bloc.dart';

abstract class RecipeOverviewState extends Equatable {
  const RecipeOverviewState();
}

class LoadingRecipeOverview extends RecipeOverviewState {
  @override
  List<Object> get props => [];
}

class LoadingRecipes extends RecipeOverviewState {
  final String? randomImage;
  final String? category;
  final Vegetable? vegetable;
  final StringIntTuple? recipeTag;

  const LoadingRecipes({
    this.randomImage,
    this.vegetable,
    this.category,
    this.recipeTag,
  });

  @override
  List<Object?> get props => [
        randomImage,
        vegetable,
        category,
        recipeTag,
      ];
}

class LoadedRecipeOverview extends RecipeOverviewState {
  final List<Recipe>? recipes;
  final String? randomImage;
  final String? category;
  final Vegetable? vegetable;
  final StringIntTuple? recipeTag;
  final RSort? recipeSort;

  const LoadedRecipeOverview(
      {this.recipes,
      this.randomImage,
      this.vegetable,
      this.category,
      this.recipeTag,
      this.recipeSort});

  @override
  List<Object?> get props => [
        recipes,
        randomImage,
        vegetable,
        category,
        recipeTag,
        recipeSort,
      ];
}
