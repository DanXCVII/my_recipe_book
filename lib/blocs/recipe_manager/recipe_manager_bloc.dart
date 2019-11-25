import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/blocs/category_overview/category_overview_bloc.dart';
import './recipe_manager.dart';

class RecipeManagerBloc extends Bloc<RecipeManagerEvent, RecipeManagerState> {
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
    // TODO: Add recipe to hive
    yield AddRecipeState(event.recipe);
  }

  Stream<DeleteRecipeState> _mapDeleteRecipeToState(
      RMDeleteRecipe event) async* {
    // TODO: Delete recipe from hive
    // Maybe first yield and then delete data
    yield DeleteRecipeState(event.recipe);
  }

  Stream<UpdateRecipeState> _mapUpdateRecipeToState(
      RMUpdateRecipe event) async* {
    // TODO: Update recipe in hive
    yield UpdateRecipeState(event.oldRecipe, event.updatedRecipe);
  }

  Stream<AddCategoryState> _mapAddCategoryToState(RMAddCategory event) async* {
    // TODO: Add category to hive
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
    // TODO: Add favorite in hive
    yield AddFavoriteState(event.recipe);
  }

  Stream<RemoveFavoriteState> _mapRemoveFavoriteToState(
      RMRemoveFavorite event) async* {
    // TODO: Remove favorite from hive
    yield RemoveFavoriteState(event.recipe);
  }

  Stream<MoveCategoryState> _mapMoveCategoryToState(
      RMMoveCategory event) async* {
    // TODO: update hive
    yield MoveCategoryState(event.oldIndex, event.newIndex);
  }
}
