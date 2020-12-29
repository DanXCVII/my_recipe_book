import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../local_storage/hive.dart';
import '../../models/recipe.dart';
import '../../models/string_int_tuple.dart';

part 'recipe_manager_event.dart';
part 'recipe_manager_state.dart';

class RecipeManagerBloc extends Bloc<RecipeManagerEvent, RecipeManagerState> {
  RecipeManagerBloc() : super(InitialRecipeManagerState());

  @override
  Stream<RecipeManagerState> mapEventToState(
    RecipeManagerEvent event,
  ) async* {
    if (event is RMAddRecipes) {
      yield* _mapAddRecipesToState(event);
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
    } else if (event is RMAddRecipeTag) {
      yield* _mapRMAddRecipeTagToState(event);
    } else if (event is RMDeleteRecipeTag) {
      yield* _mapRMDeleteRecipeTagToState(event);
    } else if (event is RMUpdateRecipeTag) {
      yield* _mapRMUpdateRecipeTagToState(event);
    }
  }

  Stream<AddRecipesState> _mapAddRecipesToState(RMAddRecipes event) async* {
    List<Recipe> newRecipes = [];

    for (Recipe r in event.recipes) {
      Recipe newRecipe = r.copyWith(lastModified: DateTime.now().toString());
      newRecipes.add(newRecipe);
      await HiveProvider().saveRecipe(newRecipe);
    }

    yield AddRecipesState(newRecipes);
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
    await HiveProvider()
        .renameCategory(event.oldCategory, event.updatedCategory);

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

  Stream<RecipeManagerState> _mapRMAddRecipeTagToState(
      RMAddRecipeTag event) async* {
    for (StringIntTuple recipeTag in event.recipeTags) {
      await HiveProvider().addRecipeTag(recipeTag.text, recipeTag.number);
    }

    yield AddRecipeTagsState(event.recipeTags);
  }

  Stream<RecipeManagerState> _mapRMDeleteRecipeTagToState(
      RMDeleteRecipeTag event) async* {
    await HiveProvider().deleteRecipeTag(event.recipeTag.text);

    yield DeleteRecipeTagState(event.recipeTag);
  }

  Stream<RecipeManagerState> _mapRMUpdateRecipeTagToState(
      RMUpdateRecipeTag event) async* {
    await HiveProvider().updateRecipeTag(event.oldRecipeTag.text,
        event.updatedRecipeTag.text, event.updatedRecipeTag.number);

    yield UpdateRecipeTagState(event.oldRecipeTag, event.updatedRecipeTag);
  }
}
