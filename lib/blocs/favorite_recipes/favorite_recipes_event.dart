part of 'favorite_recipes_bloc.dart';

abstract class FavoriteRecipesEvent extends Equatable {
  const FavoriteRecipesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoriteRecipesEvent {
  const LoadFavorites({this.showLoading = true});

  final bool showLoading;

  @override
  List<Object> get props => [showLoading];
}

class FilterFavoritesQuery extends FavoriteRecipesEvent {
  const FilterFavoritesQuery(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}

class FilterFavoritesCategory extends FavoriteRecipesEvent {
  const FilterFavoritesCategory(this.category);

  final String? category;

  @override
  List<Object?> get props => [category];
}

class FilterFavoritesVegetable extends FavoriteRecipesEvent {
  const FilterFavoritesVegetable(this.vegetable);

  final Vegetable? vegetable;

  @override
  List<Object?> get props => [vegetable];
}

class ChangeFavoritesSort extends FavoriteRecipesEvent {
  const ChangeFavoritesSort(this.recipeSort);

  final RecipeSort recipeSort;

  @override
  List<Object> get props => [recipeSort];
}

class ChangeFavoritesAscending extends FavoriteRecipesEvent {
  const ChangeFavoritesAscending(this.ascending);

  final bool ascending;

  @override
  List<Object> get props => [ascending];
}

class ClearFavoriteFilters extends FavoriteRecipesEvent {}
