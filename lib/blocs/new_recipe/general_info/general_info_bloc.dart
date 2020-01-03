import 'dart:async';

import 'package:bloc/bloc.dart';

import './general_info.dart';
import '../../../helper.dart';
import '../../../hive.dart';
import '../../../local_storage/io_operations.dart' as IO;
import '../../../local_storage/local_paths.dart';
import '../../../models/recipe.dart';

class GeneralInfoBloc extends Bloc<GeneralInfoEvent, GeneralInfoState> {
  @override
  GeneralInfoState get initialState => GCanSave();

  @override
  Stream<GeneralInfoState> mapEventToState(
    GeneralInfoEvent event,
  ) async* {
    if (event is UpdateRecipeImage) {
      yield* _mapUpdateRecipeImageToState(event);
    } else if (event is FinishedEditing) {
      yield* _mapFinishedEditingToState(event);
    } else if (event is AddCategoryToRecipe) {
      yield* _mapAddCategoryToRecipeToMap(event);
    } else if (event is RemoveCategoryFromRecipe) {
      yield* _mapRemoveCategoryFromRecipeToState(event);
    }
  }

  Stream<GeneralInfoState> _mapUpdateRecipeImageToState(
      UpdateRecipeImage event) async* {
    yield GSavingTmpData();

    String imageDataType = getImageDatatype(event.recipeImage.path);
    String recipeName = event.editingRecipe ? 'edit' : 'tmp';

    await IO.deleteRecipeImageIfExists(recipeName);
    await IO.saveRecipeImage(event.recipeImage, recipeName);

    String recipeImagePathFull =
        await PathProvider.pP.getRecipePathFull(recipeName, imageDataType);
    String recipeImagePreviewPathFull = await PathProvider.pP
        .getRecipePreviewPathFull(recipeName, imageDataType);

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
          );
      await HiveProvider().saveTmpRecipe(newRecipe);
    } else {
      newRecipe = HiveProvider().getTmpEditingRecipe().copyWith(
            name: event.recipeName,
            preperationTime: event.preperationTime,
            cookingTime: event.cookingTime,
            totalTime: event.totalTime,
          );
      await HiveProvider().saveTmpEditingRecipe(newRecipe);
    }

    if (event.goBack) {
      yield GSavedGoBack();
    } else {
      yield GSaved(newRecipe);
    }
  }

  Stream<GeneralInfoState> _mapAddCategoryToRecipeToMap(
      AddCategoryToRecipe event) async* {
    if (!event.editingRecipe) {
      await HiveProvider().saveTmpRecipe(
        HiveProvider().getTmpRecipe().copyWith(
              categories: HiveProvider().getTmpRecipe().categories
                ..add(event.category),
            ),
      );
    } else {
      await HiveProvider().saveTmpEditingRecipe(
        HiveProvider().getTmpEditingRecipe().copyWith(
              categories: HiveProvider().getTmpEditingRecipe().categories
                ..add(event.category),
            ),
      );
    }
  }

  Stream<GeneralInfoState> _mapRemoveCategoryFromRecipeToState(
      RemoveCategoryFromRecipe event) async* {
    if (!event.editingRecipe) {
      await HiveProvider().saveTmpRecipe(
        HiveProvider().getTmpRecipe().copyWith(
              categories: HiveProvider().getTmpRecipe().categories
                ..remove(event.category),
            ),
      );
    } else {
      await HiveProvider().saveTmpEditingRecipe(
        HiveProvider().getTmpEditingRecipe().copyWith(
              categories: HiveProvider().getTmpEditingRecipe().categories
                ..remove(event.category),
            ),
      );
    }
  }
}
