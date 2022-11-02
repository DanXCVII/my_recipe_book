import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:my_recipe_book/local_storage/io_operations.dart' as IO;

import '../../local_storage/hive.dart';
import '../../models/recipe.dart';
import '../../models/string_int_tuple.dart';

part 'recipe_manager_event.dart';
part 'recipe_manager_state.dart';

class RecipeManagerBloc extends Bloc<RecipeManagerEvent, RecipeManagerState> {
  RecipeManagerBloc() : super(InitialRecipeManagerState()) {
    on<RMAddRecipes>((event, emit) async {
      List<Recipe> newRecipes = [];

      for (Recipe r in event.recipes) {
        Recipe newRecipe = r.copyWith(lastModified: DateTime.now().toString());
        Recipe fixedStepsRecipe = _fixRecipeSteps(newRecipe);

        newRecipes.add(fixedStepsRecipe);
        await HiveProvider().saveRecipe(fixedStepsRecipe);
      }

      await IO.updateBackup();

      emit(AddRecipesState(newRecipes));
    });

    on<RMDeleteRecipe>((event, emit) async {
      Recipe? deletedRecipe =
          await HiveProvider().getRecipeByName(event.recipeName);

      if (deletedRecipe != null) {
        await HiveProvider().deleteRecipe(deletedRecipe.name);

        emit(DeleteRecipeState(deletedRecipe));
      }
    });

    on<RMAddCategories>((event, emit) async {
      for (String category in event.categories) {
        await HiveProvider().addCategory(category);
      }

      emit(AddCategoriesState(event.categories));
    });

    on<RMDeleteCategory>((event, emit) async {
      await HiveProvider().deleteCategory(event.category);

      emit(DeleteCategoryState(event.category));
    });

    on<RMUpdateCategory>((event, emit) async {
      await HiveProvider()
          .renameCategory(event.oldCategory, event.updatedCategory);

      emit(UpdateCategoryState(event.oldCategory, event.updatedCategory));
    });

    on<RMAddFavorite>((event, emit) async {
      await HiveProvider().addToFavorites(event.recipe);

      emit(AddFavoriteState(event.recipe.copyWith(isFavorite: true)));
    });

    on<RMRemoveFavorite>((event, emit) async {
      await HiveProvider().removeFromFavorites(event.recipe);

      emit(RemoveFavoriteState(event.recipe.copyWith(isFavorite: false)));
    });

    on<RMMoveCategory>((event, emit) async {
      await HiveProvider().moveCategory(event.oldIndex, event.newIndex);

      emit(MoveCategoryState(
        event.oldIndex,
        event.newIndex,
        event.time,
      ));
    });

    on<RMAddRecipeTag>((event, emit) async {
      for (StringIntTuple recipeTag in event.recipeTags) {
        await HiveProvider().addRecipeTag(recipeTag.text, recipeTag.number);
      }

      emit(AddRecipeTagsState(event.recipeTags));
    });

    on<RMDeleteRecipeTag>((event, emit) async {
      await HiveProvider().deleteRecipeTag(event.recipeTag.text);

      emit(DeleteRecipeTagState(event.recipeTag));
    });

    on<RMUpdateRecipeTag>((event, emit) async {
      await HiveProvider().updateRecipeTag(event.oldRecipeTag.text,
          event.updatedRecipeTag.text, event.updatedRecipeTag.number);

      emit(UpdateRecipeTagState(event.oldRecipeTag, event.updatedRecipeTag));
    });
  }

  /// Updates the stepImages and stepTitles to fit the length of steps.
  /// stepsImages and stepTitles can also be null.
  Recipe _fixRecipeSteps(Recipe r) {
    List<String>? stepTitles;
    List<List<String>>? stepImages;
    if (r.stepTitles != null) {
      stepTitles = r.stepTitles!.map((e) => e).toList();
      stepImages = r.stepImages.map((e) => e.map((e) => e).toList()).toList();
    }

    if (stepTitles == null) {
      stepTitles = r.steps.map((e) => "").toList();
    } else if (stepTitles.length < r.steps.length) {
      for (int i = r.stepTitles!.length; i < r.steps.length; i++) {
        stepTitles.add("");
      }
    } else if (r.stepTitles!.length > r.steps.length) {
      for (int i = r.steps.length; i < r.stepTitles!.length; i++) {
        stepTitles.removeLast();
      }
    }
    if (stepImages == null) {
      stepImages = r.steps.map<List<String>>((e) => []).toList();
    } else if (r.stepImages.length < r.steps.length) {
      for (int i = r.stepImages.length; i < r.steps.length; i++) {
        stepImages.add([]);
      }
    } else if (r.stepImages.length > r.steps.length) {
      for (int i = r.steps.length; i < r.stepImages.length; i++) {
        stepImages.removeLast();
      }
    }

    return r.copyWith(
      stepImages: stepImages,
      stepTitles: stepTitles,
    );
  }
}
