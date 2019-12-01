import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class GeneralInfoEvent extends Equatable {
  const GeneralInfoEvent();
}

class UpdateRecipeName extends GeneralInfoEvent {
  final String recipeName;
  final bool editingRecipe;

  UpdateRecipeName([this.recipeName, this.editingRecipe]);

  @override
  List<Object> get props => [recipeName, editingRecipe];

  @override
  String toString() =>
      'add recipe name { recipe name: $recipeName , editing recipe: $editingRecipe }';
}

class AddCategoryToRecipe extends GeneralInfoEvent {
  final String category;
  final bool editingRecipe;

  AddCategoryToRecipe(this.category, this.editingRecipe);

  @override
  List<Object> get props => [category, editingRecipe];

  @override
  String toString() => 'add category { category: $category '
      ', editingRecipe: $editingRecipe}';
}

class RemoveCategoryFromRecipe extends GeneralInfoEvent {
  final String category;
  final bool editingRecipe;

  RemoveCategoryFromRecipe(this.category, this.editingRecipe);

  @override
  List<Object> get props => [category, editingRecipe];

  @override
  String toString() => 'remove category { category: $category, '
      'editingRecipe: $editingRecipe }';
}

class UpdateRecipeImage extends GeneralInfoEvent {
  final File recipeImage;
  final bool editingRecipe;

  UpdateRecipeImage([this.recipeImage, this.editingRecipe]);

  @override
  List<Object> get props => [recipeImage, editingRecipe];

  @override
  String toString() => 'recipe image { recipe image: $recipeImage '
      ', editing recipe: $editingRecipe }';
}

class FinishedEditing extends GeneralInfoEvent {
  final bool editingRecipe;
  final bool goBack;

  final String recipeName;
  final double preperationTime;
  final double cookingTime;
  final double totalTime;

  FinishedEditing([
    this.editingRecipe,
    this.goBack,
    this.recipeName,
    this.preperationTime,
    this.cookingTime,
    this.totalTime,
  ]);

  @override
  List<Object> get props => [
        editingRecipe,
        goBack,
        recipeName,
        preperationTime,
        cookingTime,
        totalTime,
      ];

  @override
  String toString() =>
      'finished general info { editingRecipe: $editingRecipe , '
      'goBack: $goBack ,'
      'recipeName: $recipeName, '
      'preperationTime: $preperationTime'
      'cookingTime: $cookingTime'
      'totalTime: $totalTime }';
}
