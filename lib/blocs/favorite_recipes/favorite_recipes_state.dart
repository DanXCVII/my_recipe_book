import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/models/recipe.dart';

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
