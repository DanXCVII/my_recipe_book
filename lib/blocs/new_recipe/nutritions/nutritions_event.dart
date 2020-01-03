import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/models/nutrition.dart';

abstract class NutritionsEvent extends Equatable {
  const NutritionsEvent();
}

class FinishedEditing extends NutritionsEvent {
  final bool editingRecipe;
  final bool goBack;

  final List<Nutrition> nutritions;

  FinishedEditing([
    this.editingRecipe,
    this.goBack,
    this.nutritions,
  ]);

  @override
  List<Object> get props => [
        editingRecipe,
        goBack,
        nutritions,
      ];
}
