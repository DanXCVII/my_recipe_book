import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:my_recipe_book/hive.dart';
import 'package:my_recipe_book/io/io_operations.dart' as IO;
import 'package:my_recipe_book/models/recipe.dart';
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
    if (event is AddCategoryToRecipe) {
      yield* _mapAddCategoryToRecipeToState(event);
    } else if (event is UpdateRecipeImage) {
      yield* _mapUpdateRecipeImageToState(event);
    } else if (event is FinishedEditing) {
      yield* _mapFinishedEditingToState(event);
    }
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

  Stream<GeneralInfoState> _mapAddCategoryToRecipeToState(
      AddCategoryToRecipe event) async* {
    yield SavingTmpData();

    if (!event.editingRecipe) {
      Recipe oldRecipe = HiveProvider().getTmpRecipe();
      await HiveProvider().saveTmpRecipe(oldRecipe.copyWith(
          categories: oldRecipe.categories..add(event.category)));
    } else {
      Recipe oldRecipe = HiveProvider().getTmpEditingRecipe();
      await HiveProvider().saveTmpEditingRecipe(oldRecipe.copyWith(
          categories: oldRecipe.categories..add(event.category)));
    }

    yield CanSave();
  }

  Stream<GeneralInfoState> _mapFinishedEditingToState(
      FinishedEditing event) async* {
    if (event.goBack) {
      yield EditingFinishedGoBack();
    } else {
      yield EditingFinished();
    }

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

    if (event.goBack) {
      yield Saved();
    } else {
      yield SavedGoBack();
    }
  }
}
