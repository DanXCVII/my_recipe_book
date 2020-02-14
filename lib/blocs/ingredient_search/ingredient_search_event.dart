part of 'ingredient_search_bloc.dart';

abstract class IngredientSearchEvent extends Equatable {
  const IngredientSearchEvent();
}

class SearchRecipes extends IngredientSearchEvent {
  final List<String> ingredients;

  SearchRecipes(this.ingredients);

  @override
  List<Object> get props => [ingredients];
}
