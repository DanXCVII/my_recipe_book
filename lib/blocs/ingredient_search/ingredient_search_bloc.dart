import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/enums.dart';

import '../../constants/global_constants.dart' as Constants;
import '../../local_storage/hive.dart';
import '../../models/recipe.dart';
import '../../models/string_int_tuple.dart';
import '../../models/tuple.dart';

part 'ingredient_search_event.dart';
part 'ingredient_search_state.dart';

class IngredientSearchBloc
    extends Bloc<IngredientSearchEvent, IngredientSearchState> {
  IngredientSearchBloc() : super(IngredientSearchInitial()) {
    on<SearchRecipes>((event, emit) async {
      emit(SearchingRecipes());

      List<Tuple2<int, Recipe>> filteredRecipes = [];

      if (event.ingredients.isNotEmpty) {
        filteredRecipes = (await HiveProvider()
            .getRecipesWithIngredients(event.ingredients))
          ..sort((a, b) => b.item1.compareTo(a.item1));
      }
      if (filteredRecipes.isNotEmpty) {
        if (event.categories.isNotEmpty) {
          if (filteredRecipes.isNotEmpty) {
            for (String category in event.categories) {
              filteredRecipes.removeWhere(
                  (tuple) => !tuple.item2.categories.contains(category));
            }
          }
        }
        if (event.recipeTags.isNotEmpty) {
          if (filteredRecipes.isNotEmpty) {
            for (StringIntTuple recipeTag in event.recipeTags) {
              filteredRecipes.removeWhere(
                  (tuple) => !tuple.item2.tags.contains(recipeTag));
            }
          }
        }
        if (event.vegetable != null) {
          filteredRecipes.removeWhere(
              (tuple) => !(tuple.item2.vegetable == event.vegetable));
        }
      } else {
        List<Recipe> allRecipes = await HiveProvider().getAllRecipes();
        if (event.recipeTags.isNotEmpty ||
            event.categories.isNotEmpty ||
            event.vegetable != null) {
          for (Recipe recipe in allRecipes) {
            bool addRecipe = true;
            if (event.categories.length == 1 &&
                event.categories[0] == Constants.noCategory &&
                recipe.categories.isEmpty) {
            } else {
              for (String category in event.categories) {
                if (!recipe.categories.contains(category)) {
                  addRecipe = false;
                }
              }
            }
            for (StringIntTuple recipeTag in event.recipeTags) {
              if (!recipe.tags.contains(recipeTag)) {
                addRecipe = false;
              }
            }
            if (event.vegetable != null &&
                event.vegetable != recipe.vegetable) {
              addRecipe = false;
            }
            if (addRecipe) {
              filteredRecipes.add(Tuple2<int, Recipe>(0, recipe));
            }
          }
        }
      }
      emit(IngredientSearchMatches(
        filteredRecipes,
        event.ingredients.length,
      ));
    });
  }
}
