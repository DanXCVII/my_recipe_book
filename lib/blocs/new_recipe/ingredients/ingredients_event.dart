import 'package:equatable/equatable.dart';

import '../../../models/enums.dart';
import '../../../models/ingredient.dart';

abstract class IngredientsEvent extends Equatable {
  const IngredientsEvent();
}

class SetCanSave extends IngredientsEvent {
  @override
  List<Object> get props => [];
}

class FinishedEditing extends IngredientsEvent {
  final bool editingRecipe;
  final bool goBack;

  final double servings;
  final List<List<Ingredient>> ingredients;
  final List<String> ingredientsGlossary;
  final Vegetable vegetable;

  FinishedEditing([
    this.editingRecipe,
    this.goBack,
    this.servings,
    this.ingredients,
    this.ingredientsGlossary,
    this.vegetable,
  ]);

  @override
  List<Object> get props => [
        editingRecipe,
        goBack,
        servings,
        ingredients,
        ingredientsGlossary,
        vegetable,
      ];
}
