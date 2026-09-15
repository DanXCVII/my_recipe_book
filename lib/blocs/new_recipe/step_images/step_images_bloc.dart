import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../constants/global_constants.dart' as Constants;
import '../../../local_storage/io_operations.dart' as IO;
import '../../../local_storage/local_paths.dart';

part 'step_images_event.dart';
part 'step_images_state.dart';

class StepImagesBloc extends Bloc<StepImagesEvent, StepImagesState> {
  List<String>? editingSteps;
  List<String>? editingStepTitles;
  late List<List<String>> editingStepImages;

  List<Key> stepKeys = [];

  StepImagesBloc() : super(LoadedStepImages([[]], [], [], [])) {
    on<InitializeStepImages>((event, emit) async {
      // This is required for old recipes which don't have recipeTitles
      List<String> stepTitles = event.stepTitles;
      for (int i = stepTitles.length; i < event.steps.length; i++) {
        stepTitles.add("");
      }
      for (int i = 0; i < event.steps.length; i++) {
        stepKeys.add(Key(i.toString()));
      }

      final stepIngredientIds = List.generate(
        event.steps.length,
        (index) => index < event.stepIngredientIds.length
            ? List<String>.from(event.stepIngredientIds[index])
            : <String>[],
      );

      editingStepImages = event.stepImages;
      editingStepTitles = event.stepTitles;
      editingSteps = event.steps;

      emit(
        LoadedStepImages(
          event.stepImages,
          event.steps,
          stepTitles,
          stepKeys,
          stepIngredientIds: stepIngredientIds,
        ),
      );
    });

    on<AddImage>((event, emit) async {
      final List<List<String>> images = (state as LoadedStepImages).stepImages
          .map((list) => list.map((item) => item).toList())
          .toList();

      images[event.stepNumber].add(
        await IO.saveStepImage(
          event.stepImage,
          event.stepNumber,
          recipeName: event.editingRecipe
              ? Constants.editRecipeLocalPathString
              : Constants.newRecipeLocalPathString,
        ),
      );

      emit(
        LoadedStepImages(
          images,
          (state as LoadedStepImages).steps,
          (state as LoadedStepImages).stepTitles,
          (state as LoadedStepImages).stepKeys,
          stepIngredientIds: (state as LoadedStepImages).stepIngredientIds,
        ),
      );
    });

    on<RemoveImage>((event, emit) async {
      String stepImagePath = (state as LoadedStepImages)
          .stepImages[event.stepNumber][event.stepImageIndex];
      String stepImageName = stepImagePath.substring(
        stepImagePath.lastIndexOf('/') + 1,
      );

      final List<List<String>> images = (state as LoadedStepImages).stepImages
          .map((list) => list.map((item) => item).toList())
          .toList();
      images[event.stepNumber].removeAt(event.stepImageIndex);

      emit(
        LoadedStepImages(
          images,
          (state as LoadedStepImages).steps,
          (state as LoadedStepImages).stepTitles,
          (state as LoadedStepImages).stepKeys,
          stepIngredientIds: (state as LoadedStepImages).stepIngredientIds,
        ),
      );

      if (!editingStepImages.contains(stepImagePath)) {
        if (!event.editingRecipe) {
          await IO.deleteStepImage('tmp', event.stepNumber, stepImageName);
        }
      }
    });

    on<AddStep>((event, emit) async {
      final current = state as LoadedStepImages;
      final stepImages = current.stepImages
          .map((e) => List<String>.from(e))
          .toList();
      if (stepImages.length <= current.steps.length) stepImages.add([]);
      final steps = List<String>.from(current.steps)..add(event.step);
      final stepTitles = List<String>.from(current.stepTitles)..add("");
      final stepIngredientIds =
          current.stepIngredientIds.map(List<String>.from).toList()
            ..add(<String>[]);

      emit(
        LoadedStepImages(
          stepImages,
          steps,
          stepTitles,
          stepKeys..add(Key(stepKeys.length.toString())),
          stepIngredientIds: stepIngredientIds,
        ),
      );
    });

    on<RemoveStep>((event, emit) async {
      if (event.stepNumber != null) {
        final current = state as LoadedStepImages;
        final index = event.stepNumber!;
        final images = current.stepImages
            .map((e) => List<String>.from(e))
            .toList();
        if (index < images.length) images.removeAt(index);
        if (images.isEmpty) images.add([]);
        final keys = List<Key>.from(stepKeys)..removeAt(index);
        stepKeys = keys;
        emit(
          LoadedStepImages(
            images,
            List<String>.from(current.steps)..removeAt(index),
            List<String>.from(current.stepTitles)..removeAt(index),
            keys,
            stepIngredientIds:
                current.stepIngredientIds.map(List<String>.from).toList()
                  ..removeAt(index),
          ),
        );
      } else {
        String stepPath = await PathProvider.pP.getRecipeStepNumberDirFull(
          event.recipeName,
          (state as LoadedStepImages).stepImages.length - 1,
        );
        await Directory(stepPath).delete(recursive: true);

        String stepPreviewPath = await PathProvider.pP
            .getRecipeStepPreviewNumberDirFull(
              event.recipeName,
              (state as LoadedStepImages).stepImages.length - 1,
            );
        await Directory(stepPreviewPath).delete(recursive: true);

        emit(
          LoadedStepImages(
            (state as LoadedStepImages).stepImages
                .map((e) => e.map((e) => e).toList())
                .toList()
              ..removeLast(),
            (state as LoadedStepImages).steps.map((e) => e).toList()
              ..removeLast(),
            (state as LoadedStepImages).stepTitles.map((e) => e).toList()
              ..removeLast(),
            stepKeys.map((e) => e).toList()..removeLast(),
            stepIngredientIds:
                (state as LoadedStepImages).stepIngredientIds
                    .map(List<String>.from)
                    .toList()
                  ..removeLast(),
          ),
        );
      }
    });

    on<EditStepTitle>((event, emit) async {
      List<String> stepTitles = (state as LoadedStepImages).stepTitles
          .map((e) => e)
          .toList();
      stepTitles[event.stepIndex] = event.stepTitle;

      emit(
        LoadedStepImages(
          (state as LoadedStepImages).stepImages,
          (state as LoadedStepImages).steps,
          stepTitles,
          stepKeys,
          stepIngredientIds: (state as LoadedStepImages).stepIngredientIds,
        ),
      );
    });

    on<MoveStep>((event, emit) async {
      List<List<String>> stepImages = (state as LoadedStepImages).stepImages
          .map((e) => e.map((e) => e).toList())
          .toList();
      List<String> steps = (state as LoadedStepImages).steps
          .map((e) => e)
          .toList();
      List<String> stepTitles = (state as LoadedStepImages).stepTitles
          .map((e) => e)
          .toList();
      List<Key> copyStepKeys = stepKeys.map((e) => e).toList();
      final stepIngredientIds = (state as LoadedStepImages).stepIngredientIds
          .map(List<String>.from)
          .toList();

      _move(steps, event.oldIndex, event.newIndex);
      _move(stepTitles, event.oldIndex, event.newIndex);
      _move(copyStepKeys, event.oldIndex, event.newIndex);
      _move(stepImages, event.oldIndex, event.newIndex);
      _move(stepIngredientIds, event.oldIndex, event.newIndex);

      stepKeys = copyStepKeys;
      emit(
        LoadedStepImages(
          stepImages,
          steps,
          stepTitles,
          stepKeys,
          stepIngredientIds: stepIngredientIds,
        ),
      );
    });

    on<EditStep>((event, emit) async {
      List<String> steps = (state as LoadedStepImages).steps
          .map((e) => e)
          .toList();
      steps[event.stepIndex] = event.step;

      emit(
        LoadedStepImages(
          (state as LoadedStepImages).stepImages,
          steps,
          (state as LoadedStepImages).stepTitles,
          stepKeys,
          stepIngredientIds: (state as LoadedStepImages).stepIngredientIds,
        ),
      );
    });

    on<UpdateStepIngredients>((event, emit) {
      final current = state as LoadedStepImages;
      final assignments = List.generate(
        current.steps.length,
        (index) => index < current.stepIngredientIds.length
            ? List<String>.from(current.stepIngredientIds[index])
            : <String>[],
      );
      assignments[event.stepIndex] = List<String>.from(event.ingredientIds);
      emit(
        LoadedStepImages(
          current.stepImages,
          current.steps,
          current.stepTitles,
          current.stepKeys,
          stepIngredientIds: assignments,
        ),
      );
    });
  }

  void _move(List<Object> moveList, int oldIndex, int newIndex) {
    Object moveItem = moveList.removeAt(oldIndex);
    moveList.insert(newIndex, moveItem);
  }
}
