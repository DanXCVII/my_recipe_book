part of 'general_info_bloc.dart';

abstract class GeneralInfoEvent extends Equatable {
  const GeneralInfoEvent();
}

class InitializeGeneralInfo extends GeneralInfoEvent {
  final bool isEditing;

  InitializeGeneralInfo(this.isEditing);

  @override
  List<Object> get props => [];
}

class SetCanSave extends GeneralInfoEvent {
  @override
  List<Object> get props => [];
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

class RemoveCategoriesFromRecipe extends GeneralInfoEvent {
  final List<String> categories;
  final bool editingRecipe;

  RemoveCategoriesFromRecipe([
    this.categories,
    this.editingRecipe,
  ]);

  @override
  List<Object> get props => [
        categories,
        editingRecipe,
      ];
}

class AddRecipeTagToRecipe extends GeneralInfoEvent {
  final StringIntTuple recipeTag;
  final bool editingRecipe;

  AddRecipeTagToRecipe([
    this.recipeTag,
    this.editingRecipe,
  ]);

  @override
  List<Object> get props => [
        recipeTag,
        editingRecipe,
      ];
}

class RemoveRecipeTagsFromRecipe extends GeneralInfoEvent {
  final List<StringIntTuple> recipeTags;
  final bool editingRecipe;

  RemoveRecipeTagsFromRecipe([
    this.recipeTags,
    this.editingRecipe,
  ]);

  @override
  List<Object> get props => [
        RemoveCategoriesFromRecipe(),
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
