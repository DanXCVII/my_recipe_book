import 'dart:async';

import 'package:bloc/bloc.dart';

import './nutritions.dart';
import '../../../hive.dart';
import '../../../local_storage/io_operations.dart' as IO;
import '../../../models/recipe.dart';

class NutritionsBloc extends Bloc<NutritionsEvent, NutritionsState> {
  @override
  NutritionsState get initialState => NCanSave();

  @override
  Stream<NutritionsState> mapEventToState(
    NutritionsEvent event,
  ) async* {
    if (event is FinishedEditing) {
      yield* _mapFinishedEditingToState(event);
    }
  }

  Stream<NutritionsState> _mapFinishedEditingToState(
      FinishedEditing event) async* {
    if (event.goBack) {
      yield NEditingFinishedGoBack();
    } else {
      yield NEditingFinished();
    }

    Recipe newRecipe;
    if (!event.editingRecipe) {
      Recipe nutritionRecipe = HiveProvider().getTmpRecipe().copyWith(
            nutritions: event.nutritions,
          );
      newRecipe = await IO.fixImagePaths(nutritionRecipe);

      if (event.goBack) {
        await HiveProvider().saveTmpRecipe(newRecipe);
      } else {
        await HiveProvider().deleteTmpRecipe();
      }
    } else {
      Recipe nutritionRecipe = HiveProvider().getTmpEditingRecipe().copyWith(
            nutritions: event.nutritions,
          );
      newRecipe = await IO.fixImagePaths(nutritionRecipe);

      if (event.goBack) {
        await HiveProvider().saveTmpEditingRecipe(newRecipe);
      } else {
        await HiveProvider().deleteTmpEditingRecipe();
      }
    }
    if (!event.goBack) {
      await HiveProvider().saveRecipe(newRecipe);
    }

    if (event.goBack) {
      yield NSavedGoBack();
    } else {
      yield NSaved(newRecipe);
    }
  }
}
