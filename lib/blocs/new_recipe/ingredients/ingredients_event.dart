part of 'ingredients_bloc.dart';

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
  final String servingName;
  final List<List<Ingredient>> ingredients;
  final List<String> ingredientsGlossary;
  final Vegetable vegetable;

  FinishedEditing([
    this.editingRecipe,
    this.goBack,
    this.servings,
    this.servingName,
    this.ingredients,
    this.ingredientsGlossary,
    this.vegetable,
  ]);

  @override
  List<Object> get props => [
        editingRecipe,
        goBack,
        servings,
        servingName,
        ingredients,
        ingredientsGlossary,
        vegetable,
      ];
}
