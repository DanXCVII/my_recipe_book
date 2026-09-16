part of 'favorite_recipes_bloc.dart';

abstract class FavoriteRecipesState extends Equatable {
  const FavoriteRecipesState();
}

class LoadingFavorites extends FavoriteRecipesState {
  @override
  List<Object> get props => [];
}

class FailedFavorites extends FavoriteRecipesState {
  @override
  List<Object> get props => [];
}

class LoadedFavorites extends FavoriteRecipesState {
  const LoadedFavorites({
    this.allRecipes = const [],
    this.visibleRecipes = const [],
    this.categoryCounts = const {},
    required this.recipeSort,
    this.query = '',
    this.selectedCategory,
    this.selectedVegetable,
  });

  final List<Recipe> allRecipes;
  final List<Recipe> visibleRecipes;
  final Map<String, int> categoryCounts;
  final RSort recipeSort;
  final String query;
  final String? selectedCategory;
  final Vegetable? selectedVegetable;

  List<Recipe> get recipes => visibleRecipes;

  bool get hasActiveFilters =>
      query.trim().isNotEmpty ||
      selectedCategory != null ||
      selectedVegetable != null;

  @override
  List<Object?> get props => [
    allRecipes,
    visibleRecipes,
    categoryCounts,
    recipeSort,
    query,
    selectedCategory,
    selectedVegetable,
  ];
}
