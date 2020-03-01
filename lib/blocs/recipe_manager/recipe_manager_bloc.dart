import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:equatable/equatable.dart';

import '../../local_storage/hive.dart';
part 'recipe_manager_event.dart';
part 'recipe_manager_state.dart';

class RecipeManagerBloc extends Bloc<RecipeManagerEvent, RecipeManagerState> {
  @override
  RecipeManagerState get initialState => InitialRecipeManagerState();

  @override
  Stream<RecipeManagerState> mapEventToState(
    RecipeManagerEvent event,
  ) async* {
    if (event is RMAddRecipe) {
      yield* _mapAddRecipeToState(event);
    } else if (event is RMDeleteRecipe) {
      yield* _mapDeleteRecipeToState(event);
    } else if (event is RMAddCategories) {
      yield* _mapAddCategoriesToState(event);
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
    Recipe newRecipe =
        event.recipe.copyWith(lastModified: DateTime.now().toString());
    await HiveProvider().saveRecipe(newRecipe);

    yield AddRecipeState(newRecipe);
  }

  /// not deleting files because when a recipe is modified, the event also fires
  Stream<DeleteRecipeState> _mapDeleteRecipeToState(
      RMDeleteRecipe event) async* {
    Recipe deletedRecipe =
        await HiveProvider().getRecipeByName(event.recipeName);

    if (deletedRecipe != null) {
      await HiveProvider().deleteRecipe(deletedRecipe.name);

      yield DeleteRecipeState(deletedRecipe);
    }
  }

  Stream<AddCategoriesState> _mapAddCategoriesToState(
      RMAddCategories event) async* {
    for (String category in event.categories) {
      await HiveProvider().addCategory(category);
    }

    yield AddCategoriesState(event.categories);
  }

  Stream<DeleteCategoryState> _mapDeleteCategoryToState(
      RMDeleteCategory event) async* {
    await HiveProvider().deleteCategory(event.category);

    yield DeleteCategoryState(event.category);
  }

  Stream<UpdateCategoryState> _mapUpdateCategoryToState(
      RMUpdateCategory event) async* {
    HiveProvider().renameCategory(event.oldCategory, event.updatedCategory);

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
