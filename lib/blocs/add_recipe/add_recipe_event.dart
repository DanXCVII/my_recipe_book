import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/models/recipe.dart';

abstract class AddRecipeEvent extends Equatable {
  const AddRecipeEvent();

  @override
  List<Object> get props => [];
}

class InitializeEditing extends AddRecipeEvent {
  final Recipe recipe;

  InitializeEditing([this.recipe]);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'initialize editing { recipe : $recipe }';
}

class InitializeNewRecipe extends AddRecipeEvent {}

class SaveTemporaryRecipeData extends AddRecipeEvent {
  final Recipe recipe;

  SaveTemporaryRecipeData([this.recipe]);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'save temporary recipe data { recipe : $recipe }';
}

class SaveNewRecipe extends AddRecipeEvent {
  final Recipe recipe;

  SaveNewRecipe([this.recipe]);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'save recipe data { recipe : $recipe }';
}

class ModifyRecipe extends AddRecipeEvent {
  final Recipe recipe;
  final Recipe oldRecipe;

  ModifyRecipe([this.recipe, this.oldRecipe]);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() =>
      'edit recipe data { recipe : $recipe , oldRecipeImageName : $oldRecipe }';
}
