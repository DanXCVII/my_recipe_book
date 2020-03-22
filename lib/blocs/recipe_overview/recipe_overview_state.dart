part of 'recipe_overview_bloc.dart';

abstract class RecipeOverviewState extends Equatable {
  const RecipeOverviewState();
}

class LoadingRecipeOverview extends RecipeOverviewState {
  @override
  List<Object> get props => [];
}

class LoadedRecipeOverview extends RecipeOverviewState {
  final List<Recipe> recipes;
  final String randomImage;
  final String category;
  final Vegetable vegetable;
  final StringIntTuple recipeTag;
  final RSort recipeSort;

  const LoadedRecipeOverview(
      {this.recipes,
      this.randomImage,
      this.vegetable,
      this.category,
      this.recipeTag,
      this.recipeSort});

  @override
  List<Object> get props => [
        recipes,
        randomImage,
        vegetable,
        category,
        recipeTag,
        recipeSort,
      ];
}
