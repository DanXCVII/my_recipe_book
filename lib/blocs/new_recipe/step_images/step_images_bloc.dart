import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:my_recipe_book/constants/global_constants.dart' as Constants;

import '../../../local_storage/io_operations.dart' as IO;
import '../../../local_storage/local_paths.dart';

part 'step_images_event.dart';
part 'step_images_state.dart';

class StepImagesBloc extends Bloc<StepImagesEvent, StepImagesState> {
  List<String> editingSteps;
  List<String> editingStepTitles;
  List<List<String>> editingStepImages;

  List<Key> stepKeys = [];

  StepImagesBloc() : super(LoadedStepImages([[]], [], [], []));

  @override
  Stream<StepImagesState> mapEventToState(
    StepImagesEvent event,
  ) async* {
    if (event is InitializeStepImages) {
      yield* _mapInitializeDataToState(event);
    } else if (event is AddImage) {
      yield* _mapAddImageToState(event);
    } else if (event is RemoveImage) {
      yield* _mapRemoveImageToState(event);
    } else if (event is AddStep) {
      yield* _mapAddStepToState(event);
    } else if (event is RemoveStep) {
      yield* _mapRemoveStepToState(event);
    } else if (event is EditStepTitle) {
      yield* _mapEditStepTitleToState(event);
    } else if (event is MoveStep) {
      yield* _mapOldIndexToState(event);
    } else if (event is EditStep) {
      yield* _mapEditStepToState(event);
    }
  }

  Stream<StepImagesState> _mapInitializeDataToState(
      InitializeStepImages event) async* {
    // This is required for old recipes which don't have recipeTitles
    List<String> stepTitles = event.stepTitles == null ? [] : event.stepTitles;
    for (int i = stepTitles.length; i < event.steps.length; i++) {
      stepTitles.add("");
    }
    for (int i = 0; i < event.steps.length; i++) {
      stepKeys.add(Key(i.toString()));
    }

    editingStepImages = event.stepImages;
    editingStepTitles = event.stepTitles;
    editingSteps = event.steps;

    yield LoadedStepImages(
      event.stepImages,
      event.steps,
      stepTitles,
      stepKeys,
    );
  }

  Stream<StepImagesState> _mapAddImageToState(AddImage event) async* {
    final List<List<String>> images = (state as LoadedStepImages)
        .stepImages
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

    yield LoadedStepImages(
      images,
      (state as LoadedStepImages).steps,
      (state as LoadedStepImages).stepTitles,
      (state as LoadedStepImages).stepKeys,
    );
  }

  Stream<StepImagesState> _mapRemoveImageToState(RemoveImage event) async* {
    String stepImagePath = (state as LoadedStepImages)
        .stepImages[event.stepNumber][event.stepImageIndex];
    String stepImageName =
        stepImagePath.substring(stepImagePath.lastIndexOf('/') + 1);

    final List<List<String>> images = (state as LoadedStepImages)
        .stepImages
        .map((list) => list.map((item) => item).toList())
        .toList();
    images[event.stepNumber].removeAt(event.stepImageIndex);

    yield LoadedStepImages(
      images,
      (state as LoadedStepImages).steps,
      (state as LoadedStepImages).stepTitles,
      (state as LoadedStepImages).stepKeys,
    );

    if (!editingStepImages.contains(stepImagePath)) {
      if (!event.editingRecipe) {
        await IO.deleteStepImage(
          'tmp',
          event.stepNumber,
          stepImageName,
        );
      }
    }
  }

  Stream<StepImagesState> _mapAddStepToState(AddStep event) async* {
    List<List<String>> stepImages = (state as LoadedStepImages)
        .stepImages
        .map((e) => e.map((e) => e).toList())
        .toList()
          ..add([]);
    List<String> steps = (state as LoadedStepImages)
        .steps
        .map((e) => e)
        .toList()
          ..add(event.step);
    List<String> stepTitles =
        (state as LoadedStepImages).stepTitles.map((e) => e).toList()..add("");

    yield LoadedStepImages(
      stepImages,
      steps,
      stepTitles,
      stepKeys..add(Key(stepKeys.length.toString())),
    );
  }

  Stream<StepImagesState> _mapRemoveStepToState(RemoveStep event) async* {
    if (event.stepNumber != null) {
      if ((state as LoadedStepImages)
          .stepImages
          .every((element) => element.isEmpty)) {
        /// No need to modify or remove images in storage, because this option is only available
        /// if there are no images added yet.
        yield LoadedStepImages(
            (state as LoadedStepImages)
                .stepImages
                .map((e) => e.map((e) => e).toList())
                .toList()
                  ..removeAt(event.stepNumber),
            (state as LoadedStepImages).steps.map((e) => e).toList()
              ..removeAt(event.stepNumber),
            (state as LoadedStepImages).stepTitles.map((e) => e).toList()
              ..removeAt(event.stepNumber),
            stepKeys.map((e) => e).toList()..removeAt(event.stepNumber));
      }
    } else {
      String stepPath = await PathProvider.pP.getRecipeStepNumberDirFull(
          event.recipeName, (state as LoadedStepImages).stepImages.length - 1);
      await Directory(stepPath).delete(recursive: true);

      String stepPreviewPath = await PathProvider.pP
          .getRecipeStepPreviewNumberDirFull(event.recipeName,
              (state as LoadedStepImages).stepImages.length - 1);
      await Directory(stepPreviewPath).delete(recursive: true);

      yield LoadedStepImages(
        (state as LoadedStepImages)
            .stepImages
            .map((e) => e.map((e) => e).toList())
            .toList()
              ..removeLast(),
        (state as LoadedStepImages).steps.map((e) => e).toList()..removeLast(),
        (state as LoadedStepImages).stepTitles.map((e) => e).toList()
          ..removeLast(),
        stepKeys.map((e) => e).toList()..removeLast(),
      );
    }
  }

  Stream<StepImagesState> _mapEditStepTitleToState(EditStepTitle event) async* {
    List<String> stepTitles =
        (state as LoadedStepImages).stepTitles.map((e) => e).toList();
    stepTitles[event.stepIndex] = event.stepTitle;

    yield LoadedStepImages(
      (state as LoadedStepImages).stepImages,
      (state as LoadedStepImages).steps,
      stepTitles,
      stepKeys,
    );
  }

  Stream<StepImagesState> _mapOldIndexToState(MoveStep event) async* {
    List<List<String>> stepImages = (state as LoadedStepImages)
        .stepImages
        .map((e) => e.map((e) => e).toList())
        .toList();
    List<String> steps =
        (state as LoadedStepImages).steps.map((e) => e).toList();
    List<String> stepTitles =
        (state as LoadedStepImages).stepTitles.map((e) => e).toList();
    List<Key> copyStepKeys = stepKeys.map((e) => e).toList();

    _move(steps, event.oldIndex, event.newIndex);
    _move(stepTitles, event.oldIndex, event.newIndex);
    _move(copyStepKeys, event.oldIndex, event.newIndex);
    _move(stepImages, event.oldIndex, event.newIndex);

    yield LoadedStepImages(
      stepImages,
      steps,
      stepTitles,
      stepKeys,
    );
  }

  void _move(List<Object> moveList, int oldIndex, int newIndex) {
    Object moveItem = moveList.removeAt(oldIndex);
    moveList.insert(newIndex, moveItem);
  }

  Stream<StepImagesState> _mapEditStepToState(EditStep event) async* {
    List<String> steps =
        (state as LoadedStepImages).steps.map((e) => e).toList();
    steps[event.stepIndex] = event.step;

    yield LoadedStepImages(
      (state as LoadedStepImages).stepImages,
      steps,
      (state as LoadedStepImages).stepTitles,
      stepKeys,
    );
  }
}
