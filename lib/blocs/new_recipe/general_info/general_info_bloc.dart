import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/constants/global_constants.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';

import '../../../helper.dart';
import '../../../local_storage/hive.dart';
import '../../../local_storage/io_operations.dart' as IO;
import '../../../local_storage/local_paths.dart';
import '../../../models/recipe.dart';

part 'general_info_event.dart';
part 'general_info_state.dart';

class GeneralInfoBloc extends Bloc<GeneralInfoEvent, GeneralInfoState> {
  @override
  GeneralInfoState get initialState => GCanSave();

  @override
  Stream<GeneralInfoState> mapEventToState(
    GeneralInfoEvent event,
  ) async* {
    if (event is SetCanSave) {
      yield* _mapSetCanSaveToState(event);
    } else if (event is InitializeGeneralInfo) {
      yield* _mapInitializeGeneralInfoToState(event);
    } else if (event is UpdateRecipeImage) {
      yield* _mapUpdateRecipeImageToState(event);
    } else if (event is FinishedEditing) {
      yield* _mapFinishedEditingToState(event);
    } else if (event is GRemoveRecipeImage) {
      yield* _mapGRemoveRecipeImageToState(event);
    }
  }

  Stream<GeneralInfoState> _mapSetCanSaveToState(SetCanSave event) async* {
    yield GCanSave();
  }

  Stream<GeneralInfoState> _mapInitializeGeneralInfoToState(
      InitializeGeneralInfo event) async* {
    yield GSavingTmpData();

    if (event.isEditing) {
      await HiveProvider().deleteTmpEditingRecipe();
    }

    yield GCanSave();
  }

  Stream<GeneralInfoState> _mapGRemoveRecipeImageToState(
      GRemoveRecipeImage event) async* {
    if (!event.editingRecipe) {
      await IO.deleteRecipeImageIfExists(newRecipeLocalPathString);

      await HiveProvider().saveTmpRecipe(
        HiveProvider().getTmpRecipe().copyWith(
              imagePath: noRecipeImage,
              imagePreviewPath: noRecipeImage,
            ),
      );
    } else {
      await IO.deleteRecipeImageIfExists(editRecipeLocalPathString);

      await HiveProvider().saveTmpEditingRecipe(
        HiveProvider().getTmpEditingRecipe().copyWith(
              imagePath: noRecipeImage,
              imagePreviewPath: noRecipeImage,
            ),
      );
    }
  }

  Stream<GeneralInfoState> _mapUpdateRecipeImageToState(
      UpdateRecipeImage event) async* {
    yield GSavingTmpData();

    String imageDataType = getImageDatatype(event.recipeImage.path);
    String recipeName = event.editingRecipe
        ? editRecipeLocalPathString
        : newRecipeLocalPathString;

    await IO.deleteRecipeImageIfExists(recipeName);
    await IO.saveRecipeImage(event.recipeImage, recipeName);

    String recipeImagePathFull =
        await PathProvider.pP.getRecipeImagePathFull(recipeName, imageDataType);
    String recipeImagePreviewPathFull = await PathProvider.pP
        .getRecipeImagePreviewPathFull(recipeName, imageDataType);

    if (!event.editingRecipe) {
      await HiveProvider().saveTmpRecipe(
        HiveProvider().getTmpRecipe().copyWith(
              imagePath: recipeImagePathFull,
              imagePreviewPath: recipeImagePreviewPathFull,
            ),
      );
    } else {
      await HiveProvider().saveTmpEditingRecipe(
        HiveProvider().getTmpEditingRecipe().copyWith(
              imagePath: recipeImagePathFull,
              imagePreviewPath: recipeImagePreviewPathFull,
            ),
      );
    }

    yield GCanSave();
  }

  Stream<GeneralInfoState> _mapFinishedEditingToState(
      FinishedEditing event) async* {
    if (event.goBack) {
      yield GEditingFinishedGoBack();
    } else {
      yield GEditingFinished();
    }

    Recipe newRecipe;
    if (!event.editingRecipe) {
      newRecipe = HiveProvider().getTmpRecipe().copyWith(
          name: event.recipeName,
          preperationTime: event.preperationTime,
          cookingTime: event.cookingTime,
          totalTime: event.totalTime,
          categories: event.categories,
          tags: event.recipeTags,
          source: event.source);
      await HiveProvider().saveTmpRecipe(newRecipe);
    } else {
      newRecipe = HiveProvider().getTmpEditingRecipe().copyWith(
            name: event.recipeName,
            preperationTime: event.preperationTime,
            cookingTime: event.cookingTime,
            totalTime: event.totalTime,
            categories: event.categories,
            tags: event.recipeTags,
            source: event.source,
          );
      await HiveProvider().saveTmpEditingRecipe(newRecipe);
    }

    if (event.goBack) {
      yield GSavedGoBack();
    } else {
      yield GSaved(newRecipe);
    }
  }
}
