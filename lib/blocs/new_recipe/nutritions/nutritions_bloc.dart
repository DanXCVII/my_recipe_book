import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../hive.dart';
import '../../../local_storage/io_operations.dart' as IO;
import '../../../models/recipe.dart';
import '../../recipe_manager/recipe_manager_bloc.dart';
import 'nutritions_event.dart';
import 'nutritions_state.dart';

class NutritionsBloc extends Bloc<NutritionsEvent, NutritionsState> {
  bool finishedEditing = false;

  @override
  NutritionsState get initialState => NCanSave();

  @override
  Stream<NutritionsState> mapEventToState(
    NutritionsEvent event,
  ) async* {
    if (event is SetCanSave) {
      yield* _mapSetCanSaveToState(event);
    } else if (event is FinishedEditing) {
      yield* _mapFinishedEditingToState(event);
    }
  }

  Stream<NutritionsState> _mapSetCanSaveToState(SetCanSave event) async* {
    yield NCanSave();
  }

  Stream<NutritionsState> _mapFinishedEditingToState(
      FinishedEditing event) async* {
    // case that the user quickly presses the done button twice
    if (finishedEditing) return;
    finishedEditing = true;

    if (event.goBack) {
      yield NEditingFinishedGoBack();
    } else {
      yield NEditingFinished();
    }

    Recipe newRecipe;
    if (event.editingRecipeName == null) {
      Recipe nutritionRecipe = HiveProvider().getTmpRecipe().copyWith(
            nutritions: event.nutritions,
          );

      if (event.goBack) {
        await HiveProvider().saveTmpRecipe(newRecipe);
      } else {
        newRecipe = await IO.fixImagePaths(nutritionRecipe);
        await HiveProvider().resetTmpRecipe();
        await IO.deleteRecipeData("tmp");
        event.recipeManagerBloc.add(RMAddRecipe(newRecipe));
      }
    } else {
      if (event.goBack) {
        await HiveProvider().saveTmpEditingRecipe(newRecipe);
      }

      if (!event.goBack) {
        if (event.editingRecipeName == null) {
          event.recipeManagerBloc.add(RMAddRecipe(newRecipe));
        } else {
          event.recipeManagerBloc
              .add(RMDeleteRecipe(event.editingRecipeName, deleteFiles: false));
          await Future.delayed(Duration(milliseconds: 100));
          Recipe nutritionRecipe = HiveProvider()
              .getTmpEditingRecipe()
              .copyWith(nutritions: event.nutritions);
          newRecipe = await IO.fixImagePaths(nutritionRecipe);
          // IO.deleteRecipeData('edit');
          await HiveProvider().deleteTmpEditingRecipe();
          event.recipeManagerBloc.add(RMAddRecipe(newRecipe));
        }
      }
    }

    if (event.goBack) {
      yield NSavedGoBack();
    } else {
      yield NSaved(newRecipe);
    }
  }
}
