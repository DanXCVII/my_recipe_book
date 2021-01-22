part of 'favorite_recipes_bloc.dart';

abstract class FavoriteRecipesEvent extends Equatable {
  const FavoriteRecipesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoriteRecipesEvent {}

class AddFavorite extends FavoriteRecipesEvent {
  final Recipe recipe;

  const AddFavorite(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'Add Favorite { recipe: $recipe }';
}

class RemoveFavorite extends FavoriteRecipesEvent {
  final Recipe recipe;

  const RemoveFavorite(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'Remove Favorite { recipe: $recipe }';
}
