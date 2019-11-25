import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_sort.dart';

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

  @override
  String toString() => 'VegetableRecipeOverview { vegetable: $vegetable }';
}

class LoadCategoryRecipeOverview extends RecipeOverviewEvent {
  final String category;

  const LoadCategoryRecipeOverview(this.category);

  @override
  List<Object> get props => [category];

  @override
  String toString() => 'CategoryRecipeOverview { category: $category }';
}

class ChangeRecipeSort extends RecipeOverviewEvent {
  final RSort recipeSort;

  const ChangeRecipeSort(this.recipeSort);

  @override
  List<Object> get props => [recipeSort];

  @override
  String toString() => 'Change recipe sort { recipe sort: $recipeSort }';
}

class AddRecipe extends RecipeOverviewEvent {
  final Recipe recipe;

  const AddRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'Add recipe { recipe: $recipe }';
}

class UpdateRecipe extends RecipeOverviewEvent {
  final Recipe oldRecipe;
  final Recipe updatedRecipe;

  const UpdateRecipe(this.oldRecipe, this.updatedRecipe);

  @override
  List<Object> get props => [oldRecipe, updatedRecipe];

  @override
  String toString() =>
      'Update recipe { oldRecipe: $oldRecipe , updatedRecipe: $updatedRecipe }';
}

class DeleteRecipe extends RecipeOverviewEvent {
  final Recipe recipe;

  const DeleteRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'Delete recipe { recipe: $recipe }';
}
