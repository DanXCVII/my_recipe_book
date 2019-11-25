import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/models/recipe.dart';

abstract class RecipeManagerEvent extends Equatable {
  const RecipeManagerEvent();
}

class RMAddRecipe extends RecipeManagerEvent {
  final Recipe recipe;

  const RMAddRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'AddRecipe { recipe: $recipe }';
}

class RMUpdateRecipe extends RecipeManagerEvent {
  final Recipe oldRecipe;
  final Recipe updatedRecipe;

  const RMUpdateRecipe(this.oldRecipe, this.updatedRecipe);

  @override
  List<Object> get props => [oldRecipe, updatedRecipe];

  @override
  String toString() => 'UpdateRecipe { updatedRecipe: $updatedRecipe }';
}

class RMDeleteRecipe extends RecipeManagerEvent {
  final Recipe recipe;

  const RMDeleteRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'DeleteRecipe { recipeName: $recipe }';
}

class RMAddFavorite extends RecipeManagerEvent {
  final Recipe recipe;

  const RMAddFavorite(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'Add Favorite { recipe: $recipe }';
}

class RMRemoveFavorite extends RecipeManagerEvent {
  final Recipe recipe;

  const RMRemoveFavorite(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'Add Favorite { recipe: $recipe }';
}

class RMDeleteCategory extends RecipeManagerEvent {
  final String category;

  const RMDeleteCategory(this.category);

  @override
  List<Object> get props => [category];

  @override
  String toString() => 'DeleteCategory { category: $category }';
}

class RMAddCategory extends RecipeManagerEvent {
  final String category;

  const RMAddCategory(this.category);

  @override
  List<Object> get props => [category];

  @override
  String toString() => 'AddCategory { category: $category }';
}

class RMUpdateCategory extends RecipeManagerEvent {
  final String oldCategory;
  final String updatedCategory;

  const RMUpdateCategory(this.oldCategory, this.updatedCategory);

  @override
  List<Object> get props => [oldCategory, updatedCategory];

  @override
  String toString() =>
      'UpdateCategory { oldCategory: $oldCategory, updatedCategory: $updatedCategory }';
}

class RMMoveCategory extends RecipeManagerEvent {
  final int oldIndex;
  final int newIndex;

  const RMMoveCategory(this.oldIndex, this.newIndex);

  @override
  List<Object> get props => [oldIndex, newIndex];

  @override
  String toString() =>
      'move category { oldIndex: $oldIndex, newIndex: $newIndex }';
}
