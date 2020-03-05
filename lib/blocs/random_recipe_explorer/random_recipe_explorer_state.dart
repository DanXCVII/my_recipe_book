part of 'random_recipe_explorer_bloc.dart';

abstract class RandomRecipeExplorerState extends Equatable {
  const RandomRecipeExplorerState();
}

class LoadingRandomRecipeExplorer extends RandomRecipeExplorerState {
  @override
  List<Object> get props => [];
}

class LoadingRecipes extends RandomRecipeExplorerState {
  final List<String> categories;
  final int selectedCategory;

  LoadingRecipes(this.categories, this.selectedCategory);

  @override
  List<Object> get props => [categories, selectedCategory];
}

class LoadedRandomRecipeExplorer extends RandomRecipeExplorerState {
  final List<String> categories;
  final int selectedCategory;
  final List<Recipe> randomRecipes;

  const LoadedRandomRecipeExplorer(
      [this.randomRecipes = const [], this.categories, this.selectedCategory]);

  @override
  List<Object> get props => [selectedCategory, categories, randomRecipes];

  @override
  String toString() =>
      'loaded random recipes { selectedCategory: $selectedCategory, categories: $categories, recipes: $randomRecipes }';
}
