part of 'favorite_recipes_bloc.dart';

abstract class FavoriteRecipesState {
  const FavoriteRecipesState();
}

class LoadingFavorites extends FavoriteRecipesState {}

class LoadedFavorites extends FavoriteRecipesState {
  final List<Recipe/*!*/> recipes;

  const LoadedFavorites([this.recipes = const []]);
}
