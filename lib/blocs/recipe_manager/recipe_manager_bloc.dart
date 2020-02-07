import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:equatable/equatable.dart';

import '../../hive.dart';
part 'recipe_manager_event.dart';
part 'recipe_manager_state.dart';

class RecipeManagerBloc extends Bloc<RecipeManagerEvent, RecipeManagerState> {
  final String test = "k";
  @override
  RecipeManagerState get initialState => InitialRecipeManagerState();

  // TODO: IMPORTANT: Map the events to state and ALSO!! update the database accordingly
  @override
  Stream<RecipeManagerState> mapEventToState(
    RecipeManagerEvent event,
  ) async* {
    if (event is RMAddRecipe) {
      yield* _mapAddRecipeToState(event);
    } else if (event is RMDeleteRecipe) {
      yield* _mapDeleteRecipeToState(event);
    } else if (event is RMUpdateRecipe) {
      yield* _mapUpdateRecipeToState(event);
    } else if (event is RMAddCategory) {
      yield* _mapAddCategoryToState(event);
    } else if (event is RMDeleteCategory) {
      yield* _mapDeleteCategoryToState(event);
    } else if (event is RMUpdateCategory) {
      yield* _mapUpdateCategoryToState(event);
    } else if (event is RMAddFavorite) {
      yield* _mapAddFavoriteToState(event);
    } else if (event is RMRemoveFavorite) {
      yield* _mapRemoveFavoriteToState(event);
    } else if (event is RMMoveCategory) {
      yield* _mapMoveCategoryToState(event);
    }
  }

  Stream<AddRecipeState> _mapAddRecipeToState(RMAddRecipe event) async* {
    await HiveProvider().saveRecipe(event.recipe);

    yield AddRecipeState(event.recipe);
  }

  /// not deleting files
  Stream<DeleteRecipeState> _mapDeleteRecipeToState(
      RMDeleteRecipe event) async* {
    // TODO: Delete files if set
    Recipe deletedRecipe =
        await HiveProvider().getRecipeByName(event.recipeName);

    await HiveProvider().deleteRecipe(deletedRecipe.name);

    yield DeleteRecipeState(deletedRecipe);
  }

  Stream<UpdateRecipeState> _mapUpdateRecipeToState(
      RMUpdateRecipe event) async* {
    // TODO: Update recipe in hive
    yield UpdateRecipeState(event.oldRecipe, event.updatedRecipe);
  }

  Stream<AddCategoryState> _mapAddCategoryToState(RMAddCategory event) async* {
    await HiveProvider().addCategory(event.category);

    yield AddCategoryState(event.category);
  }

  Stream<DeleteCategoryState> _mapDeleteCategoryToState(
      RMDeleteCategory event) async* {
    // TODO: Delete category from hive
    yield DeleteCategoryState(event.category);
  }

  Stream<UpdateCategoryState> _mapUpdateCategoryToState(
      RMUpdateCategory event) async* {
    // TODO: Update category in hive
    yield UpdateCategoryState(event.oldCategory, event.updatedCategory);
  }

  Stream<AddFavoriteState> _mapAddFavoriteToState(RMAddFavorite event) async* {
    await HiveProvider().addToFavorites(event.recipe);

    yield AddFavoriteState(event.recipe.copyWith(isFavorite: true));
  }

  Stream<RemoveFavoriteState> _mapRemoveFavoriteToState(
      RMRemoveFavorite event) async* {
    await HiveProvider().removeFromFavorites(event.recipe);

    yield RemoveFavoriteState(event.recipe.copyWith(isFavorite: false));
  }

  Stream<MoveCategoryState> _mapMoveCategoryToState(
      RMMoveCategory event) async* {
    await HiveProvider().moveCategory(event.oldIndex, event.newIndex);

    yield MoveCategoryState(
      event.oldIndex,
      event.newIndex,
      event.time,
    );
  }
}
