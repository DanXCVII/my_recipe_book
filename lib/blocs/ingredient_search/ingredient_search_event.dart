part of 'ingredient_search_bloc.dart';

abstract class IngredientSearchEvent extends Equatable {
  const IngredientSearchEvent();
}

class UpdateIngredientSearch extends IngredientSearchEvent {
  const UpdateIngredientSearch(this.criteria);

  final IngredientSearchCriteria criteria;

  @override
  List<Object> get props => [criteria];
}

class RetryIngredientSearch extends IngredientSearchEvent {
  const RetryIngredientSearch(this.criteria);

  final IngredientSearchCriteria criteria;

  @override
  List<Object> get props => [criteria];
}

class _SyncFavorite extends IngredientSearchEvent {
  const _SyncFavorite(this.recipe);

  final Recipe recipe;

  @override
  List<Object> get props => [recipe];
}
