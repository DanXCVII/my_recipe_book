import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager.dart';
import 'package:my_recipe_book/models/nutrition.dart';

abstract class NutritionsEvent extends Equatable {
  const NutritionsEvent();
}

class SetCanSave extends NutritionsEvent {
  @override
  List<Object> get props => [];
}

class FinishedEditing extends NutritionsEvent {
  final String editingRecipeName;
  final bool goBack;
  final RecipeManagerBloc recipeManagerBloc;

  final List<Nutrition> nutritions;

  FinishedEditing(
    this.editingRecipeName,
    this.goBack,
    this.nutritions,
    this.recipeManagerBloc,
  );

  @override
  List<Object> get props => [
        editingRecipeName,
        goBack,
        nutritions,
        recipeManagerBloc,
      ];
}
