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

class UpdatePrepTime extends GeneralInfoEvent {
  final double prepTime;
  final bool editingRecipe;

  UpdatePrepTime([this.prepTime, this.editingRecipe]);

  @override
  List<Object> get props => [prepTime, editingRecipe];

  @override
  String toString() =>
      'update preperation time { preperation time: $prepTime , editing recipe: $editingRecipe }';
}

class UpdateCookingTime extends GeneralInfoEvent {
  final double cookingTime;
  final bool editingRecipe;

  UpdateCookingTime([this.cookingTime, this.editingRecipe]);

  @override
  List<Object> get props => [cookingTime, editingRecipe];

  @override
  String toString() =>
      'update cooking time { cooking time: $cookingTime , editing recipe: $editingRecipe }';
}

class UpdateTotalTime extends GeneralInfoEvent {
  final double totalTime;
  final bool editingRecipe;

  UpdateTotalTime([this.totalTime, this.editingRecipe]);

  @override
  List<Object> get props => [totalTime, editingRecipe];

  @override
  String toString() =>
      'update total time { total time: $totalTime , editing recipe: $editingRecipe }';
}

class UpdateCategories extends GeneralInfoEvent {
  final List<String> categories;
  final bool editingRecipe;

  UpdateCategories([this.categories, this.editingRecipe]);

  @override
  List<Object> get props => [categories, editingRecipe];

  @override
  String toString() =>
      'update categories { categories: $categories , editing recipe: $editingRecipe }';
}

class UpdateRecipeImage extends GeneralInfoEvent {
  final File recipeImage;
  final bool editingRecipe;

  UpdateRecipeImage([this.recipeImage, this.editingRecipe]);

  @override
  List<Object> get props => [recipeImage, editingRecipe];

  @override
  String toString() =>
      'recipe image { recipe image: $recipeImage , editing recipe: $editingRecipe }';
}

class FinishedEditing extends GeneralInfoEvent {
  final bool editingRecipe;

  final String recipeName;
  final double preperationTime;
  final double cookingTime;
  final double totalTime;

  FinishedEditing([
    this.editingRecipe,
    this.recipeName,
    this.preperationTime,
    this.cookingTime,
    this.totalTime,
  ]);

  @override
  List<Object> get props => [
        editingRecipe,
        recipeName,
        preperationTime,
        cookingTime,
        totalTime,
      ];

  @override
  String toString() =>
      'finished general info { editingRecipe: $editingRecipe , '
      'recipeName: $recipeName, '
      'preperationTime: $preperationTime'
      'cookingTime: $cookingTime'
      'totalTime: $totalTime }';
}
