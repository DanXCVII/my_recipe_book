import 'package:equatable/equatable.dart';

import '../../../models/nutrition.dart';
import '../../recipe_manager/recipe_manager.dart';

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
