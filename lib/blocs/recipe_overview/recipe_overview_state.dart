import 'package:equatable/equatable.dart';

import '../../models/enums.dart';
import '../../models/recipe.dart';
import '../../models/recipe_sort.dart';

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
  final RSort recipeSort;

  const LoadedRecipeOverview(
      {this.recipes,
      this.randomImage,
      this.vegetable,
      this.category,
      this.recipeSort});

  @override
  List<Object> get props => [
        recipes,
        randomImage,
        vegetable,
        category,
        recipeSort,
      ];

  @override
  String toString() =>
      'Loaded recipe overview { recipes: $recipes , randomImage: $randomImage , vegetable: $vegetable , category : $category , recipeSort: $recipeSort}';
}
