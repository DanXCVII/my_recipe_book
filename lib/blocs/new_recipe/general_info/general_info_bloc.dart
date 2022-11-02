import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/constants/global_constants.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';

import '../../../util/helper.dart';
import '../../../local_storage/hive.dart';
import '../../../local_storage/io_operations.dart' as IO;
import '../../../local_storage/local_paths.dart';
import '../../../models/recipe.dart';

part 'general_info_event.dart';
part 'general_info_state.dart';

class GeneralInfoBloc extends Bloc<GeneralInfoEvent, GeneralInfoState> {
  GeneralInfoBloc() : super(GCanSave()) {
    on<SetCanSave>((event, emit) async {
      emit(GCanSave());
    });

    on<InitializeGeneralInfo>((event, emit) async {
      emit(GSavingTmpData());

      if (event.isEditing) {
        await HiveProvider().deleteTmpEditingRecipe();
      }

      emit(GCanSave());
    });

    on<UpdateRecipeImage>((event, emit) async {
      emit(GSavingTmpData());

      String? imageDataType = getImageDatatype(event.recipeImage!.path);
      String newImageDataType =
          imageDataType == ".png" ? ".jpg" : imageDataType!;

      String recipeName = event.editingRecipe
          ? editRecipeLocalPathString
          : newRecipeLocalPathString;

      await IO.deleteRecipeImageIfExists(recipeName);
      await IO.saveRecipeImage(event.recipeImage!, recipeName);

      String recipeImagePathFull = await PathProvider.pP
          .getRecipeImagePathFull(recipeName, newImageDataType);
      String recipeImagePreviewPathFull = await PathProvider.pP
          .getRecipeImagePreviewPathFull(recipeName, newImageDataType);

      if (!event.editingRecipe) {
        await HiveProvider().saveTmpRecipe(
          HiveProvider().getTmpRecipe()!.copyWith(
                imagePath: recipeImagePathFull,
                imagePreviewPath: recipeImagePreviewPathFull,
              ),
        );
      } else {
        await HiveProvider().saveTmpEditingRecipe(
          HiveProvider().getTmpEditingRecipe()!.copyWith(
                imagePath: recipeImagePathFull,
                imagePreviewPath: recipeImagePreviewPathFull,
              ),
        );
      }

      emit(GCanSave());
    });

    on<FinishedEditing>((event, emit) async {
      if (event.goBack!) {
        emit(GEditingFinishedGoBack());
      } else {
        emit(GEditingFinished());
      }

      Recipe newRecipe;
      if (!event.editingRecipe!) {
        newRecipe = HiveProvider().getTmpRecipe()!.copyWith(
            name: event.recipeName,
            preperationTime: event.preperationTime,
            cookingTime: event.cookingTime,
            totalTime: event.totalTime,
            categories: event.categories,
            tags: event.recipeTags,
            source: event.source);
        await HiveProvider().saveTmpRecipe(newRecipe);
      } else {
        newRecipe = HiveProvider().getTmpEditingRecipe()!.copyWith(
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

      if (event.goBack!) {
        emit(GSavedGoBack());
      } else {
        emit(GSaved(newRecipe));
      }
    });

    on<GRemoveRecipeImage>((event, emit) async {
      if (!event.editingRecipe) {
        await IO.deleteRecipeImageIfExists(newRecipeLocalPathString);

        await HiveProvider().saveTmpRecipe(
          HiveProvider().getTmpRecipe()!.copyWith(
                imagePath: noRecipeImage,
                imagePreviewPath: noRecipeImage,
              ),
        );
      } else {
        await IO.deleteRecipeImageIfExists(editRecipeLocalPathString);

        await HiveProvider().saveTmpEditingRecipe(
          HiveProvider().getTmpEditingRecipe()!.copyWith(
                imagePath: noRecipeImage,
                imagePreviewPath: noRecipeImage,
              ),
        );
      }
    });
  }
}
