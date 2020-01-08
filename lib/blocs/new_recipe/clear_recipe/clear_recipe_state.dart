import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/models/recipe.dart';

abstract class ClearRecipeState extends Equatable {
  const ClearRecipeState();
}

class InitialClearRecipeState extends ClearRecipeState {
  @override
  List<Object> get props => [];
}

class ClearedRecipe extends ClearRecipeState {
  final Recipe recipe;

  final DateTime dateTime;

  ClearedRecipe(this.recipe, this.dateTime);

  @override
  List<Object> get props => [recipe, dateTime];
}
