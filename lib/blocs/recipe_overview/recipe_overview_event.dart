import 'package:equatable/equatable.dart';

import '../../models/enums.dart';
import '../../models/recipe.dart';
import '../../models/recipe_sort.dart';

// TODO: Maybe add "addCategory" "updateCategory" "deleteCategory" events
abstract class RecipeOverviewEvent extends Equatable {
  const RecipeOverviewEvent();

  @override
  List<Object> get props => [];
}

class LoadVegetableRecipeOverview extends RecipeOverviewEvent {
  final Vegetable vegetable;

  const LoadVegetableRecipeOverview(this.vegetable);

  @override
  List<Object> get props => [vegetable];
}

class LoadCategoryRecipeOverview extends RecipeOverviewEvent {
  final String category;

  const LoadCategoryRecipeOverview(this.category);

  @override
  List<Object> get props => [category];
}

class ChangeRecipeSort extends RecipeOverviewEvent {
  final RSort recipeSort;

  const ChangeRecipeSort(this.recipeSort);

  @override
  List<Object> get props => [recipeSort];
}

class AddRecipe extends RecipeOverviewEvent {
  final Recipe recipe;

  const AddRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class UpdateRecipe extends RecipeOverviewEvent {
  final Recipe oldRecipe;
  final Recipe updatedRecipe;

  const UpdateRecipe(this.oldRecipe, this.updatedRecipe);

  @override
  List<Object> get props => [oldRecipe, updatedRecipe];
}

class DeleteRecipe extends RecipeOverviewEvent {
  final Recipe recipe;

  const DeleteRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class UpdateFavoriteStatus extends RecipeOverviewEvent {
  final Recipe recipe;

  const UpdateFavoriteStatus(this.recipe);

  @override
  List<Object> get props => [recipe];
}
