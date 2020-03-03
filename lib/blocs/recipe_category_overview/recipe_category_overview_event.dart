import 'package:equatable/equatable.dart';

import '../../models/recipe.dart';

abstract class RecipeCategoryOverviewEvent extends Equatable {
  const RecipeCategoryOverviewEvent();

  @override
  List<Object> get props => [];
}

class RCOLoadRecipeCategoryOverview extends RecipeCategoryOverviewEvent {}

class RCOAddRecipes extends RecipeCategoryOverviewEvent {
  final List<Recipe> recipes;

  const RCOAddRecipes(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class RCOUpdateRecipe extends RecipeCategoryOverviewEvent {
  final Recipe oldRecipe;
  final Recipe updatedRecipe;

  const RCOUpdateRecipe(this.oldRecipe, this.updatedRecipe);

  @override
  List<Object> get props => [oldRecipe, updatedRecipe];
}

class RCODeleteRecipe extends RecipeCategoryOverviewEvent {
  final Recipe recipe;

  const RCODeleteRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class RCOAddCategory extends RecipeCategoryOverviewEvent {
  final List<String> categories;

  const RCOAddCategory(this.categories);

  @override
  List<Object> get props => [categories];
}

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
}
