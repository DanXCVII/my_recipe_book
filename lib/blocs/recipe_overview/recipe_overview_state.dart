part of 'recipe_overview_bloc.dart';

abstract class RecipeOverviewState extends Equatable {
  const RecipeOverviewState();
}

class LoadingRecipeOverview extends RecipeOverviewState {
  @override
  List<Object> get props => [];
}

class LoadingRecipes extends RecipeOverviewState {
  final String? category;
  final Vegetable? vegetable;
  final StringIntTuple? recipeTag;

  const LoadingRecipes({this.vegetable, this.category, this.recipeTag});

  @override
  List<Object?> get props => [vegetable, category, recipeTag];
}

class FailedRecipeOverview extends RecipeOverviewState {
  final String? category;
  final Vegetable? vegetable;
  final StringIntTuple? recipeTag;

  const FailedRecipeOverview({this.category, this.vegetable, this.recipeTag});

  @override
  List<Object?> get props => [category, vegetable, recipeTag];
}

class LoadedRecipeOverview extends RecipeOverviewState {
  final List<Recipe> allRecipes;
  final List<Recipe> visibleRecipes;
  final String? category;
  final Vegetable? vegetable;
  final StringIntTuple? recipeTag;
  final RSort recipeSort;
  final String query;
  final Vegetable? selectedVegetable;
  final List<String> selectedRecipeTags;

  const LoadedRecipeOverview({
    required this.allRecipes,
    required this.visibleRecipes,
    required this.recipeSort,
    this.category,
    this.vegetable,
    this.recipeTag,
    this.query = '',
    this.selectedVegetable,
    this.selectedRecipeTags = const [],
  });

  List<Recipe> get recipes => visibleRecipes;

  bool get hasActiveFilters =>
      query.trim().isNotEmpty ||
      selectedVegetable != null ||
      selectedRecipeTags.isNotEmpty;

  @override
  List<Object?> get props => [
    allRecipes,
    visibleRecipes,
    vegetable,
    category,
    recipeTag,
    recipeSort,
    query,
    selectedVegetable,
    selectedRecipeTags,
  ];
}
