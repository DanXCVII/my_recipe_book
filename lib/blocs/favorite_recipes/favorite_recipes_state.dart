part of 'favorite_recipes_bloc.dart';

abstract class FavoriteRecipesState extends Equatable {
  const FavoriteRecipesState();

  @override
  List<Object> get props => [];
}

class LoadingFavorites extends FavoriteRecipesState {}

class LoadedFavorites extends FavoriteRecipesState {
  final List<Recipe> recipes;

  const LoadedFavorites([this.recipes = const []]);

  @override
  List<Object> get props => [recipes];

  @override
  String toString() => 'Favorite recipes loaded { recipes: $recipes }';
}
