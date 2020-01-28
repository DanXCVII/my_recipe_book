import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:my_recipe_book/blocs/new_recipe/general_info/general_info.dart';

import './step_images.dart';
import '../../../local_storage/io_operations.dart' as IO;
import '../../../local_storage/local_paths.dart';

class StepImagesBloc extends Bloc<StepImagesEvent, StepImagesState> {
  List<List<String>> editingStepImages;

  @override
  StepImagesState get initialState => LoadedStepImages([[]]);

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
    }
  }

  Stream<StepImagesState> _mapInitializeDataToState(
      InitializeStepImages event) async* {
    editingStepImages = event.stepImages;

    yield LoadedStepImages(event.stepImages);
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
        recipeName: event.editingRecipe ? 'edit' : 'tmp',
      ),
    );

    yield LoadedStepImages(images);
  }

  Stream<StepImagesState> _mapRemoveImageToState(RemoveImage event) async* {
    String stepImageName =
        event.stepImage.substring(event.stepImage.lastIndexOf('/') + 1);

    if (!editingStepImages.contains(event.stepImage)) {
      await IO.deleteStepImage(
        event.editingRecipe ? 'edit' : 'tmp',
        event.stepNumber,
        stepImageName,
      );
    }

    final List<List<String>> images = (state as LoadedStepImages)
        .stepImages
        .map((list) => list.map((item) => item).toList())
        .toList();
    images[event.stepNumber].remove(event.stepImage);

    yield LoadedStepImages(images);
  }

  Stream<StepImagesState> _mapAddStepToState(AddStep event) async* {
    List<List<String>> stepImages = (state as LoadedStepImages)
        .stepImages
        .map<List<String>>(
            (list) => list.map<String>((element) => element).toList())
        .toList()
          ..add([]);

    yield LoadedStepImages(stepImages);
  }

  Stream<StepImagesState> _mapRemoveStepToState(RemoveStep event) async* {
    if ((state as LoadedStepImages).stepImages.length != 1) {
      String stepPath = await PathProvider.pP.getRecipeStepNumberDirFull(
          event.recipeName, (state as LoadedStepImages).stepImages.length - 1);
      await Directory(stepPath).delete(recursive: true);

      String stepPreviewPath = await PathProvider.pP
          .getRecipeStepPreviewNumberDirFull(event.recipeName,
              (state as LoadedStepImages).stepImages.length - 1);
      await Directory(stepPreviewPath).delete(recursive: true);

      yield LoadedStepImages((state as LoadedStepImages)
          .stepImages
          .map<List<String>>(
              (list) => list.map<String>((element) => element).toList())
          .toList()
            ..removeLast());
    }
  }
}
