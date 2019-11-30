import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_recipe_book/models/recipe.dart';

abstract class RandomRecipeExplorerEvent extends Equatable {
  const RandomRecipeExplorerEvent();

  @override
  List<Object> get props => [];
}

class InitializeRandomRecipeExplorer extends RandomRecipeExplorerEvent {
  final String selectedCategory;

  const InitializeRandomRecipeExplorer(
      {this.selectedCategory = 'all categories'});

  @override
  List<Object> get props => [selectedCategory];

  @override
  String toString() =>
      'current category { selectedCategory: $selectedCategory }';
}

class ReloadRandomRecipeExplorer extends RandomRecipeExplorerEvent {}

class AddCategory extends RandomRecipeExplorerEvent {
  final String category;

  const AddCategory(this.category);

  @override
  List<Object> get props => [category];

  @override
  String toString() => 'Add Category { category: $category }';
}

class DeleteCategory extends RandomRecipeExplorerEvent {
  final String category;

  const DeleteCategory(this.category);

  @override
  List<Object> get props => [category];

  @override
  String toString() => 'Delete Category { category: $category }';
}

class DeleteRecipe extends RandomRecipeExplorerEvent {
  final Recipe recipe;

  const DeleteRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'Delete Recipe { recipe: $recipe }';
}

class UpdateRecipe extends RandomRecipeExplorerEvent {
  final Recipe oldRecipe;
  final Recipe updatedRecipe;

  const UpdateRecipe(this.oldRecipe, this.updatedRecipe);

  @override
  List<Object> get props => [oldRecipe, updatedRecipe];

  @override
  String toString() =>
      'Update Recipe { oldRecipe: $oldRecipe, updatedRecipe: $updatedRecipe }';
}

class UpdateCategory extends RandomRecipeExplorerEvent {
  final String oldCategory;
  final String newCategory;

  const UpdateCategory(this.oldCategory, this.newCategory);

  @override
  List<Object> get props => [oldCategory, newCategory];

  @override
  String toString() =>
      'Update Category { oldCategory: $oldCategory , newCategory: $newCategory}';
}

class ChangeCategory extends RandomRecipeExplorerEvent {
  final String category;

  const ChangeCategory(this.category);

  @override
  List<Object> get props => [category];

  @override
  String toString() => 'Change Category { category: $category }';
}

class RotateRecipe extends RandomRecipeExplorerEvent {}
