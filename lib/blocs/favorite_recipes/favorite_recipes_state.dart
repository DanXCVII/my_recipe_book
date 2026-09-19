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
    required this.recipeSort,
    this.query = '',
    this.filters = const RecipeCollectionFilters(),
  });

  final List<Recipe> allRecipes;
  final List<Recipe> visibleRecipes;
  final RSort recipeSort;
  final String query;
  final RecipeCollectionFilters filters;

  List<Recipe> get recipes => visibleRecipes;

  bool get hasActiveFilters => query.trim().isNotEmpty || !filters.isEmpty;

  @override
  List<Object?> get props => [
    allRecipes,
    visibleRecipes,
    recipeSort,
    query,
    filters,
  ];
}
