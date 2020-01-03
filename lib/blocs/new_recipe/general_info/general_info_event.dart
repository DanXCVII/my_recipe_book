import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class GeneralInfoEvent extends Equatable {
  const GeneralInfoEvent();
}

class UpdateRecipeImage extends GeneralInfoEvent {
  final File recipeImage;
  final bool editingRecipe;

  UpdateRecipeImage([this.recipeImage, this.editingRecipe]);

  @override
  List<Object> get props => [recipeImage, editingRecipe];
}

class AddCategoryToRecipe extends GeneralInfoEvent {
  final String category;
  final bool editingRecipe;

  AddCategoryToRecipe([
    this.category,
    this.editingRecipe,
  ]);

  @override
  List<Object> get props => [
        category,
        editingRecipe,
      ];
}

class RemoveCategoryFromRecipe extends GeneralInfoEvent {
  final String category;
  final bool editingRecipe;

  RemoveCategoryFromRecipe([
    this.category,
    this.editingRecipe,
  ]);

  @override
  List<Object> get props => [
        category,
        editingRecipe,
      ];
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
}
