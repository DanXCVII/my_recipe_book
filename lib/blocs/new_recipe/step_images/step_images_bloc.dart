import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:my_recipe_book/io/io_operations.dart' as IO;
import '../../../recipe.dart';
import './step_images.dart';

class StepImagesBloc extends Bloc<StepImagesEvent, StepImagesState> {
  @override
  StepImagesState get initialState => LoadedStepImages([[]]);

  @override
  Stream<StepImagesState> mapEventToState(
    StepImagesEvent event,
  ) async* {
    // TODO: Add Logic
  }

  Stream<StepImagesState> _mapAddImageToState(AddImage event) async* {
    List<List<String>> images =
        List<List<String>>.from((state as LoadedStepImages).stepImages);
    images[event.stepNumber].add(
      await IO.saveStepImage(
        event.stepImage,
        event.stepNumber,
        recipeName: event.recipeName,
      ),
    );

    yield LoadedStepImages(images);
  }

  Stream<StepImagesState> _mapRemoveImageToState(RemoveImage event) async* {
    String stepImageName =
        event.stepImage.substring(event.stepImage.lastIndexOf('/') + 1);

    IO.deleteStepImage(
      event.recipeName,
      event.stepNumber,
      stepImageName,
    );

    List<List<String>> images =
        List<List<String>>.from((state as LoadedStepImages).stepImages);
    images[event.stepNumber].remove(event.stepImage);

    yield LoadedStepImages(images);
  }

  Stream<StepImagesState> _mapAddStepToState(AddStep event) async* {
    yield LoadedStepImages((state as LoadedStepImages).stepImages..add([]));
  }

  Stream<StepImagesState> _mapRemoveStepToState(RemoveStep event) async* {
    if ((state as LoadedStepImages).stepImages.length != 1) {
      String stepPath = await PathProvider.pP.getRecipeStepNumberDirFull(
          event.recipeName, (state as LoadedStepImages).stepImages.length);
      Directory(stepPath).delete(recursive: true);

      String stepPreviewPath = await PathProvider.pP
          .getRecipeStepPreviewNumberDirFull(
              event.recipeName, (state as LoadedStepImages).stepImages.length);
      await Directory(stepPreviewPath).delete(recursive: true);

      yield LoadedStepImages(
          (state as LoadedStepImages).stepImages..removeLast());
    }
  }
}
