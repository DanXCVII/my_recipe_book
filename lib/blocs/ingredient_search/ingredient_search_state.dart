part of 'ingredient_search_bloc.dart';

abstract class IngredientSearchState extends Equatable {
  const IngredientSearchState();
}

class IngredientSearchInitial extends IngredientSearchState {
  @override
  List<Object> get props => [];
}

class SearchingRecipes extends IngredientSearchState {
  @override
  List<Object> get props => [];
}

class IngredientSearchMatches extends IngredientSearchState {
  final List<Tuple2<int, Recipe>> tupleMatchesRecipe;
  final int totalIngredAmount;

  IngredientSearchMatches(this.tupleMatchesRecipe, this.totalIngredAmount);

  @override
  List<Object> get props => [tupleMatchesRecipe];
}
