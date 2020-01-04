import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager.dart';

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
      if (event.editingRecipeName == null) {
        event.recipeManagerBloc.add(RMAddRecipe(newRecipe));
      } else {
        event.recipeManagerBloc.add(
          RMUpdateRecipe(
            await HiveProvider().getRecipeByName(event.editingRecipeName),
            newRecipe,
          ),
        );
      }
    }

    if (event.goBack) {
      yield NSavedGoBack();
    } else {
      yield NSaved(newRecipe);
    }
  }
}