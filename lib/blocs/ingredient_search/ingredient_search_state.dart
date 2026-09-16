part of 'ingredient_search_bloc.dart';

abstract class IngredientSearchState extends Equatable {
  const IngredientSearchState(this.criteria);

  final IngredientSearchCriteria criteria;

  @override
  List<Object?> get props => [criteria];
}

class IngredientSearchInitial extends IngredientSearchState {
  const IngredientSearchInitial(super.criteria);
}

class SearchingRecipes extends IngredientSearchState {
  const SearchingRecipes(super.criteria);
}

class IngredientSearchMatches extends IngredientSearchState {
  const IngredientSearchMatches(super.criteria, this.results);

  final List<IngredientSearchResult> results;

  @override
  List<Object?> get props => [...super.props, results];
}

class IngredientSearchFailure extends IngredientSearchState {
  const IngredientSearchFailure(super.criteria);
}
