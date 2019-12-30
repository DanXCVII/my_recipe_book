import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/ingredient.dart';

abstract class IngredientsEvent extends Equatable {
  const IngredientsEvent();
}

class FinishedEditing extends IngredientsEvent {
  final bool editingRecipe;
  final bool goBack;

  final List<List<Ingredient>> ingredients;
  final List<String> ingredientsGlossary;
  final Vegetable vegetable;

  FinishedEditing([
    this.editingRecipe,
    this.goBack,
    this.ingredients,
    this.ingredientsGlossary,
    this.vegetable,
  ]);

  @override
  List<Object> get props => [
        editingRecipe,
        goBack,
        ingredients,
        ingredientsGlossary,
        vegetable,
      ];
}