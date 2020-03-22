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
    } else if (event is AddCategoryToRecipe) {
      yield* _mapAddCategoryToRecipeToMap(event);
    } else if (event is RemoveCategoriesFromRecipe) {
      yield* _mapRemoveCategoriesFromRecipeToState(event);
    } else if (event is AddRecipeTagToRecipe) {
      yield* _mapAddRecipeTagToRecipeToState(event);
    } else if (event is RemoveRecipeTagsFromRecipe) {
      yield* _mapRemoveRecipeTagsFromRecipeToState(event);
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
              categories:
                  List<String>.from(HiveProvider().getTmpRecipe().categories)
                    ..add(event.category),
            ),
      );
    } else {
      await HiveProvider().saveTmpEditingRecipe(
        HiveProvider().getTmpEditingRecipe().copyWith(
              categories: List<String>.from(
                  HiveProvider().getTmpEditingRecipe().categories)
                ..add(event.category),
            ),
      );
    }
  }

  Stream<GeneralInfoState> _mapRemoveCategoriesFromRecipeToState(
      RemoveCategoriesFromRecipe event) async* {
    if (!event.editingRecipe) {
      List<String> categories = [];
      for (String category in HiveProvider().getTmpRecipe().categories) {
        if (!event.categories.contains(category)) {
          categories.add(category);
        }
      }

      await HiveProvider().saveTmpRecipe(
        HiveProvider().getTmpRecipe().copyWith(
              categories: categories,
            ),
      );
    } else {
      List<String> categories = [];
      for (String category in HiveProvider().getTmpEditingRecipe().categories) {
        if (!event.categories.contains(category)) {
          categories.add(category);
        }
      }

      await HiveProvider().saveTmpEditingRecipe(
        HiveProvider().getTmpEditingRecipe().copyWith(
              categories: categories,
            ),
      );
    }
  }

  Stream<GeneralInfoState> _mapAddRecipeTagToRecipeToState(
      AddRecipeTagToRecipe event) async* {
    if (!event.editingRecipe) {
      await HiveProvider().saveTmpRecipe(
        HiveProvider().getTmpRecipe().copyWith(
              tags:
                  List<StringIntTuple>.from(HiveProvider().getTmpRecipe().tags)
                    ..add(event.recipeTag),
            ),
      );
    } else {
      await HiveProvider().saveTmpEditingRecipe(
        HiveProvider().getTmpEditingRecipe().copyWith(
              tags: List<StringIntTuple>.from(
                  HiveProvider().getTmpEditingRecipe().tags)
                ..add(event.recipeTag),
            ),
      );
    }
  }

  Stream<GeneralInfoState> _mapRemoveRecipeTagsFromRecipeToState(
      RemoveRecipeTagsFromRecipe event) async* {
    if (!event.editingRecipe) {
      List<StringIntTuple> recipeTags = [];
      for (StringIntTuple category in HiveProvider().getTmpRecipe().tags) {
        if (!event.recipeTags.contains(category)) {
          recipeTags.add(category);
        }
      }

      await HiveProvider().saveTmpRecipe(
        HiveProvider().getTmpRecipe().copyWith(
              tags: recipeTags,
            ),
      );
    } else {
      List<StringIntTuple> recipeTags = [];
      for (StringIntTuple recipeTag
          in HiveProvider().getTmpEditingRecipe().tags) {
        if (!event.recipeTags.contains(recipeTag)) {
          recipeTags.add(recipeTag);
        }
      }

      await HiveProvider().saveTmpEditingRecipe(
        HiveProvider().getTmpEditingRecipe().copyWith(
              tags: recipeTags,
            ),
      );
    }
  }
}
