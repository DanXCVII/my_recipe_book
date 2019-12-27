import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:my_recipe_book/hive.dart';
import 'package:my_recipe_book/io/io_operations.dart' as IO;
import 'package:my_recipe_book/models/recipe.dart';
import '../../../helper.dart';
import '../../../recipe.dart';
import './general_info.dart';

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
    }
  }

  Stream<GeneralInfoState> _mapUpdateRecipeImageToState(
      UpdateRecipeImage event) async* {
    yield GSavingTmpData();

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

    yield GCanSave();
  }

  Stream<GeneralInfoState> _mapFinishedEditingToState(
      FinishedEditing event) async* {
    if (event.goBack) {
      yield GEditingFinishedGoBack();
    } else {
      yield GEditingFinished();
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
      yield GSaved();
    } else {
      yield GSavedGoBack();
    }
  }
}
