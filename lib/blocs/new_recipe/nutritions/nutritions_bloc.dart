import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../models/nutrition.dart';

import '../../../local_storage/local_repository.dart';
import '../../../local_storage/io_operations.dart' as IO;
import '../../../models/recipe.dart';
import '../../recipe_manager/recipe_manager_bloc.dart';
import 'nutritions_event.dart';
import 'nutritions_state.dart';

class NutritionsBloc extends Bloc<NutritionsEvent, NutritionsState> {
  bool finishedEditing = false;
  final LocalRepository repository;

  NutritionsBloc(this.repository) : super(NCanSave()) {
    on<SetCanSave>((event, emit) async {
      emit(NCanSave());
    });
    on<FinishedEditing>((event, emit) async {
      // case that the user quickly presses the done button twice
      if (finishedEditing) return;
      finishedEditing = true;

      if (event.goBack) {
        emit(NEditingFinishedGoBack());
      } else {
        for (Nutrition n in event.nutritions) {
          await repository.addNutrition(n.name);
        }
        emit(NEditingFinished());
      }

      Recipe? newRecipe;
      if (event.editingRecipeName == null) {
        Recipe nutritionRecipe = repository.getTmpRecipe()!.copyWith(
          nutritions: event.nutritions,
        );

        if (event.goBack) {
          await repository.saveTmpRecipe(nutritionRecipe);
        } else {
          newRecipe = (await IO.fixImagePaths(nutritionRecipe));
          await repository.resetTmpRecipe();
          await IO.deleteRecipeData("tmp");
          event.recipeManagerBloc.add(RMAddRecipes([newRecipe]));
        }
      } else {
        Recipe nutritionRecipe = repository.getTmpEditingRecipe()!.copyWith(
          nutritions: event.nutritions,
        );
        if (event.goBack) {
          await repository.saveTmpEditingRecipe(nutritionRecipe);
        }

        if (!event.goBack) {
          newRecipe = await IO.fixImagePaths(nutritionRecipe);
          if (event.editingRecipeName != newRecipe.name) {
            await IO.deleteRecipeData(event.editingRecipeName!);
          }
          imageCache.clear();
          await repository.deleteTmpEditingRecipe();
          event.recipeManagerBloc.add(
            RMUpdateRecipe(event.editingRecipeName!, newRecipe),
          );
        }
      }

      if (event.goBack) {
        emit(NSavedGoBack());
      } else {
        emit(NSaved(newRecipe));
      }
    });
  }
}
