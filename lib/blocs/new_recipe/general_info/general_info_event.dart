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

class FinishedEditing extends GeneralInfoEvent {
  final bool editingRecipe;
  final bool goBack;

  final String recipeName;
  final double preperationTime;
  final double cookingTime;
  final double totalTime;
  final String source;
  final List<String> categories;
  final List<StringIntTuple> recipeTags;

  FinishedEditing(
      [this.editingRecipe,
      this.goBack,
      this.recipeName,
      this.preperationTime,
      this.cookingTime,
      this.totalTime,
      this.source,
      this.categories,
      this.recipeTags]);

  @override
  List<Object> get props => [
        editingRecipe,
        goBack,
        recipeName,
        preperationTime,
        cookingTime,
        totalTime,
        categories,
        recipeTags,
      ];
}
