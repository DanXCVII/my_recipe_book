import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../local_storage/hive.dart';
import '../../models/recipe.dart';
import '../../models/tuple.dart';

part 'ingredient_search_event.dart';
part 'ingredient_search_state.dart';

class IngredientSearchBloc
    extends Bloc<IngredientSearchEvent, IngredientSearchState> {
  @override
  IngredientSearchState get initialState => IngredientSearchInitial();

  @override
  Stream<IngredientSearchState> mapEventToState(
    IngredientSearchEvent event,
  ) async* {
    if (event is SearchRecipes) {
      yield* _mapSearchRecipesToState(event);
    }
  }

  Stream<IngredientSearchState> _mapSearchRecipesToState(
      SearchRecipes event) async* {
    yield SearchingRecipes();

    List<Tuple2<int, Recipe>> recipes = (await HiveProvider()
        .getRecipesWithIngredients(event.ingredients))
      ..sort((a, b) => b.item1.compareTo(a.item1));

    yield IngredientSearchMatches(recipes, event.ingredients.length);
  }
}
