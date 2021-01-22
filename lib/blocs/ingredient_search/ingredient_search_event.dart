part of 'ingredient_search_bloc.dart';

abstract class IngredientSearchEvent extends Equatable {
  const IngredientSearchEvent();
}

class SearchRecipes extends IngredientSearchEvent {
  final List<String> ingredients;
  final List<String> categories;
  final List<StringIntTuple> recipeTags;
  final Vegetable vegetable;

  SearchRecipes(
    this.ingredients,
    this.categories,
    this.recipeTags,
    this.vegetable,
  );

  @override
  List<Object> get props => [ingredients, categories, recipeTags, vegetable];
}
