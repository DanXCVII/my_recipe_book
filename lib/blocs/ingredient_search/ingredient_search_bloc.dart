import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../local_storage/local_repository.dart';
import '../../models/enums.dart';
import '../../models/recipe.dart';
import '../../models/string_int_tuple.dart';
import '../recipe_manager/recipe_manager_bloc.dart' as recipe_manager;

part 'ingredient_search_event.dart';
part 'ingredient_search_state.dart';

enum IngredientSearchSort { bestMatch, shortestTime, lowestEffort, name }

class IngredientSearchCriteria extends Equatable {
  const IngredientSearchCriteria({
    this.ingredients = const [],
    this.categories = const [],
    this.recipeTags = const [],
    this.vegetable,
    this.maxTotalTimeMinutes,
    this.maxEffort,
    this.sort = IngredientSearchSort.bestMatch,
  });

  final List<String> ingredients;
  final List<String> categories;
  final List<StringIntTuple> recipeTags;
  final Vegetable? vegetable;
  final int? maxTotalTimeMinutes;
  final int? maxEffort;
  final IngredientSearchSort sort;

  bool get isEmpty =>
      ingredients.isEmpty &&
      categories.isEmpty &&
      recipeTags.isEmpty &&
      vegetable == null &&
      maxTotalTimeMinutes == null &&
      maxEffort == null;

  int get advancedFilterCount =>
      categories.length +
      recipeTags.length +
      (maxTotalTimeMinutes == null ? 0 : 1) +
      (maxEffort == null ? 0 : 1);

  @override
  List<Object?> get props => [
    ingredients,
    categories,
    recipeTags,
    vegetable,
    maxTotalTimeMinutes,
    maxEffort,
    sort,
  ];
}

class IngredientSearchResult extends Equatable {
  const IngredientSearchResult({
    required this.recipe,
    required this.matchedIngredientCount,
  });

  final Recipe recipe;
  final int matchedIngredientCount;

  IngredientSearchResult copyWith({Recipe? recipe}) => IngredientSearchResult(
    recipe: recipe ?? this.recipe,
    matchedIngredientCount: matchedIngredientCount,
  );

  @override
  List<Object> get props => [recipe, matchedIngredientCount];
}

typedef IngredientSearchResultList = List<IngredientSearchResult>;

class IngredientSearchBloc
    extends Bloc<IngredientSearchEvent, IngredientSearchState> {
  IngredientSearchBloc({
    required this.repository,
    required recipe_manager.RecipeManagerBloc recipeManagerBloc,
  }) : _recipeManagerBloc = recipeManagerBloc,
       super(const IngredientSearchInitial(IngredientSearchCriteria())) {
    on<UpdateIngredientSearch>(_search);
    on<RetryIngredientSearch>(_retry);
    on<_SyncFavorite>(_syncFavorite);
    _recipeManagerSubscription = _recipeManagerBloc.stream.listen((state) {
      if (state is recipe_manager.AddFavoriteState) {
        add(_SyncFavorite(state.recipe));
      } else if (state is recipe_manager.RemoveFavoriteState) {
        add(_SyncFavorite(state.recipe));
      }
    });
  }

  final LocalRepository repository;
  final recipe_manager.RecipeManagerBloc _recipeManagerBloc;
  late final StreamSubscription<recipe_manager.RecipeManagerState>
  _recipeManagerSubscription;
  int _requestId = 0;

  Future<void> _search(
    UpdateIngredientSearch event,
    Emitter<IngredientSearchState> emit,
  ) async {
    final requestId = ++_requestId;
    final criteria = event.criteria;

    if (criteria.isEmpty) {
      emit(IngredientSearchInitial(criteria));
      return;
    }

    emit(SearchingRecipes(criteria));
    try {
      final IngredientSearchResultList matches;
      if (criteria.ingredients.isEmpty) {
        final recipes = await repository.getAllRecipes();
        matches = recipes
            .map(
              (recipe) => IngredientSearchResult(
                recipe: recipe,
                matchedIngredientCount: 0,
              ),
            )
            .toList();
      } else {
        final recipes = await repository.getRecipesWithIngredients(
          criteria.ingredients,
        );
        matches = recipes
            .map(
              (tuple) => IngredientSearchResult(
                recipe: tuple.item2,
                matchedIngredientCount: tuple.item1,
              ),
            )
            .toList();
      }

      matches.removeWhere((match) => !_matchesCriteria(match.recipe, criteria));
      _sort(matches, criteria.sort);

      if (requestId != _requestId) return;
      emit(IngredientSearchMatches(criteria, List.unmodifiable(matches)));
    } catch (_) {
      if (requestId != _requestId) return;
      emit(IngredientSearchFailure(criteria));
    }
  }

  bool _matchesCriteria(Recipe recipe, IngredientSearchCriteria criteria) {
    if (criteria.vegetable != null && recipe.vegetable != criteria.vegetable) {
      return false;
    }
    if (!criteria.categories.every(recipe.categories.contains)) return false;
    if (!criteria.recipeTags.every(recipe.tags.contains)) return false;

    final maxTime = criteria.maxTotalTimeMinutes;
    if (maxTime != null &&
        (recipe.totalTime <= 0 || recipe.totalTime > maxTime)) {
      return false;
    }

    final maxEffort = criteria.maxEffort;
    if (maxEffort != null &&
        (recipe.effort == null || recipe.effort! > maxEffort)) {
      return false;
    }
    return true;
  }

  void _sort(IngredientSearchResultList matches, IngredientSearchSort sort) {
    matches.sort((first, second) {
      final int result;
      switch (sort) {
        case IngredientSearchSort.bestMatch:
          result = second.matchedIngredientCount.compareTo(
            first.matchedIngredientCount,
          );
        case IngredientSearchSort.shortestTime:
          result = _compareKnownPositive(
            first.recipe.totalTime,
            second.recipe.totalTime,
          );
        case IngredientSearchSort.lowestEffort:
          result = _compareNullable(first.recipe.effort, second.recipe.effort);
        case IngredientSearchSort.name:
          result = first.recipe.name.toLowerCase().compareTo(
            second.recipe.name.toLowerCase(),
          );
      }
      if (result != 0) return result;
      return first.recipe.name.toLowerCase().compareTo(
        second.recipe.name.toLowerCase(),
      );
    });
  }

  int _compareKnownPositive(double first, double second) {
    final firstKnown = first > 0;
    final secondKnown = second > 0;
    if (firstKnown != secondKnown) return firstKnown ? -1 : 1;
    return first.compareTo(second);
  }

  int _compareNullable(int? first, int? second) {
    if (first == null && second == null) return 0;
    if (first == null) return 1;
    if (second == null) return -1;
    return first.compareTo(second);
  }

  void _retry(
    RetryIngredientSearch event,
    Emitter<IngredientSearchState> emit,
  ) {
    add(UpdateIngredientSearch(event.criteria));
  }

  void _syncFavorite(_SyncFavorite event, Emitter<IngredientSearchState> emit) {
    final current = state;
    if (current is! IngredientSearchMatches) return;
    final index = current.results.indexWhere(
      (result) => result.recipe.name == event.recipe.name,
    );
    if (index < 0) return;
    final updated = List<IngredientSearchResult>.from(current.results)
      ..[index] = current.results[index].copyWith(recipe: event.recipe);
    emit(IngredientSearchMatches(current.criteria, List.unmodifiable(updated)));
  }

  @override
  Future<void> close() async {
    await _recipeManagerSubscription.cancel();
    return super.close();
  }
}
