import 'package:equatable/equatable.dart';

import '../../models/recipe.dart';

abstract class RecipeManagerState extends Equatable {
  const RecipeManagerState();
}

class InitialRecipeManagerState extends RecipeManagerState {
  @override
  List<Object> get props => [];
}

class AddRecipeState extends RecipeManagerState {
  final Recipe recipe;

  const AddRecipeState(this.recipe);
  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'AddRecipe { recipe: $recipe }';
}

class AddFavoriteState extends RecipeManagerState {
  final Recipe recipe;

  const AddFavoriteState(this.recipe);
  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'Add favorite { recipe: $recipe }';
}

class RemoveFavoriteState extends RecipeManagerState {
  final Recipe recipe;

  const RemoveFavoriteState(this.recipe);
  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'Remove favorite { recipe: $recipe }';
}

class DeleteRecipeState extends RecipeManagerState {
  final Recipe recipe;

  const DeleteRecipeState(this.recipe);
  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'DeleteRecipe { recipe: $recipe }';
}

class UpdateRecipeState extends RecipeManagerState {
  final Recipe oldRecipe;
  final Recipe updatedRecipe;

  const UpdateRecipeState(this.oldRecipe, this.updatedRecipe);

  @override
  List<Object> get props => [oldRecipe, updatedRecipe];

  @override
  String toString() =>
      'DeleteRecipe { oldRecipe: $oldRecipe, updatedRecipe: $updatedRecipe }';
}

class AddCategoryState extends RecipeManagerState {
  final String category;

  const AddCategoryState(this.category);
  @override
  List<Object> get props => [category];

  @override
  String toString() => 'AddCategory { category: $category }';
}

class DeleteCategoryState extends RecipeManagerState {
  final String category;

  const DeleteCategoryState(this.category);

  @override
  List<Object> get props => [category];

  @override
  String toString() => 'DeleteCategory { category: $category }';
}

class UpdateCategoryState extends RecipeManagerState {
  final String oldCategory;
  final String updatedCategory;

  const UpdateCategoryState(this.oldCategory, this.updatedCategory);

  @override
  List<Object> get props => [oldCategory, updatedCategory];

  @override
  String toString() =>
      'DeleteCategory { oldCategory: $oldCategory, updatedCategory: $updatedCategory }';
}

class MoveCategoryState extends RecipeManagerState {
  final int oldIndex;
  final int newIndex;
  final DateTime time;

  const MoveCategoryState(
    this.oldIndex,
    this.newIndex,
    this.time,
  );

  @override
  List<Object> get props => [
        oldIndex,
        newIndex,
        time,
      ];

  @override
  String toString() =>
      'move category { oldIndex: $oldIndex, newIndex: $newIndex }';
}
