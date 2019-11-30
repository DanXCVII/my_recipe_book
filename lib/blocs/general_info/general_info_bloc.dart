import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:my_recipe_book/hive.dart';
import 'package:my_recipe_book/io/io_operations.dart' as IO;
import '../../helper.dart';
import '../../recipe.dart';
import './general_info.dart';

class GeneralInfoBloc extends Bloc<GeneralInfoEvent, GeneralInfoState> {
  @override
  GeneralInfoState get initialState => CanSave();

  @override
  Stream<GeneralInfoState> mapEventToState(
    GeneralInfoEvent event,
  ) async* {
    if (event is UpdateRecipeName) {
      yield* _mapUpdateRecipeNameToState(event);
    } else if (event is UpdatePrepTime) {
      yield* _mapUpdatePrepTimeToState(event);
    } else if (event is UpdateCookingTime) {
      yield* _mapUpdateCookingTimeToState(event);
    } else if (event is UpdateTotalTime) {
      yield* _mapUpdateTotalTimeToState(event);
    } else if (event is UpdateCategories) {
      yield* _mapUpdateCategoriesToState(event);
    } else if (event is UpdateRecipeImage) {
      yield* _mapUpdateRecipeImageToState(event);
    } else if (event is FinishedEditing) {
      yield* _mapFinishedEditingToState(event);
    }
  }

  Stream<GeneralInfoState> _mapUpdateRecipeNameToState(
      UpdateRecipeName event) async* {
    yield SavingTmpData();

    if (!event.editingRecipe) {
      await HiveProvider().saveTmpRecipe(
          HiveProvider().getTmpRecipe().copyWith(name: event.recipeName));
    } else {
      await HiveProvider().saveTmpEditingRecipe(HiveProvider()
          .getTmpEditingRecipe()
          .copyWith(name: event.recipeName));
    }

    yield CanSave();
  }

  Stream<GeneralInfoState> _mapUpdateRecipeImageToState(
      UpdateRecipeImage event) async* {
    yield SavingTmpData();

    if (!event.editingRecipe) {
      await IO.saveRecipeImage(event.recipeImage, 'tmp');

      String dataType = getImageDatatype(event.recipeImage.path);

      String recipeImagePathFull =
          await PathProvider.pP.getRecipePathFull('tmp', dataType);
      String recipeImagePreviewPathFull =
          await PathProvider.pP.getRecipePreviewPathFull('tmp', dataType);

      await HiveProvider().saveTmpRecipe(HiveProvider().getTmpRecipe().copyWith(
          imagePath: recipeImagePathFull,
          imagePreviewPath: recipeImagePreviewPathFull));
    } else {
      // TODO: When editing recipe
    }

    yield CanSave();
  }

  Stream<GeneralInfoState> _mapUpdatePrepTimeToState(
      UpdatePrepTime event) async* {
    yield SavingTmpData();

    if (!event.editingRecipe) {
      await HiveProvider().saveTmpRecipe(HiveProvider()
          .getTmpRecipe()
          .copyWith(preperationTime: event.prepTime));
    } else {
      await HiveProvider().saveTmpEditingRecipe(HiveProvider()
          .getTmpEditingRecipe()
          .copyWith(preperationTime: event.prepTime));
    }

    yield CanSave();
  }

  Stream<GeneralInfoState> _mapUpdateCookingTimeToState(
      UpdateCookingTime event) async* {
    yield SavingTmpData();

    if (!event.editingRecipe) {
      await HiveProvider().saveTmpRecipe(HiveProvider()
          .getTmpRecipe()
          .copyWith(cookingTime: event.cookingTime));
    } else {
      await HiveProvider().saveTmpEditingRecipe(HiveProvider()
          .getTmpEditingRecipe()
          .copyWith(cookingTime: event.cookingTime));
    }

    yield CanSave();
  }

  Stream<GeneralInfoState> _mapUpdateTotalTimeToState(
      UpdateTotalTime event) async* {
    yield SavingTmpData();

    if (!event.editingRecipe) {
      await HiveProvider().saveTmpRecipe(
          HiveProvider().getTmpRecipe().copyWith(totalTime: event.totalTime));
    } else {
      await HiveProvider().saveTmpEditingRecipe(HiveProvider()
          .getTmpEditingRecipe()
          .copyWith(totalTime: event.totalTime));
    }

    yield CanSave();
  }

  Stream<GeneralInfoState> _mapUpdateCategoriesToState(
      UpdateCategories event) async* {
    yield SavingTmpData();

    if (!event.editingRecipe) {
      await HiveProvider().saveTmpRecipe(
          HiveProvider().getTmpRecipe().copyWith(categories: event.categories));
    } else {
      await HiveProvider().saveTmpEditingRecipe(HiveProvider()
          .getTmpEditingRecipe()
          .copyWith(categories: event.categories));
    }

    yield CanSave();
  }

  Stream<GeneralInfoState> _mapFinishedEditingToState(
      FinishedEditing event) async* {
    yield EditingFinished();

    if (!event.editingRecipe) {
      await HiveProvider().saveTmpRecipe(
        HiveProvider().getTmpRecipe().copyWith(
              name: event.recipeName,
              preperationTime: event.preperationTime,
              cookingTime: event.cookingTime,
              totalTime: event.totalTime,
            ),
      );
    } else {
      await HiveProvider()
          .saveTmpEditingRecipe(HiveProvider().getTmpEditingRecipe().copyWith(
                name: event.recipeName,
                preperationTime: event.preperationTime,
                cookingTime: event.cookingTime,
                totalTime: event.totalTime,
              ));
    }

    yield Saved();
  }
}
