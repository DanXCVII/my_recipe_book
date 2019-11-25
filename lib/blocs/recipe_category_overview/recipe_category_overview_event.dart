import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/models/recipe.dart';

abstract class RecipeCategoryOverviewEvent extends Equatable {
  const RecipeCategoryOverviewEvent();

  @override
  List<Object> get props => [];
}

class RCOLoadRecipeCategoryOverview extends RecipeCategoryOverviewEvent {}

class RCOAddRecipe extends RecipeCategoryOverviewEvent {
  final Recipe recipe;

  const RCOAddRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'AddRecipe { recipe: $recipe }';
}

class RCOUpdateRecipe extends RecipeCategoryOverviewEvent {
  final Recipe oldRecipe;
  final Recipe updatedRecipe;

  const RCOUpdateRecipe(this.oldRecipe, this.updatedRecipe);

  @override
  List<Object> get props => [oldRecipe, updatedRecipe];

  @override
  String toString() => 'UpdateRecipe { updatedRecipe: $updatedRecipe }';
}

class RCODeleteRecipe extends RecipeCategoryOverviewEvent {
  final Recipe recipe;

  const RCODeleteRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'DeleteRecipe { recipe: $recipe }';
}

/// No need for AddCategory because categories with no recipes
/// will not be displayed
class RCODeleteCategory extends RecipeCategoryOverviewEvent {
  final String category;

  const RCODeleteCategory(this.category);

  @override
  List<Object> get props => [category];
}

class RCOUpdateCategory extends RecipeCategoryOverviewEvent {
  final String oldCategory;
  final String updatedCategory;

  const RCOUpdateCategory(this.oldCategory, this.updatedCategory);

  @override
  List<Object> get props => [oldCategory, updatedCategory];
}

class RCOMoveCategory extends RecipeCategoryOverviewEvent {
  final int oldIndex;
  final int newIndex;

  const RCOMoveCategory(this.oldIndex, this.newIndex);

  @override
  List<Object> get props => [oldIndex, newIndex];

  @override
  String toString() =>
      'move category { oldIndex: $oldIndex , newIndex: $newIndex }';
}
