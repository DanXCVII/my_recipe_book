import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../hive.dart';
import '../../../models/recipe.dart';
import '../step_images/step_images_bloc.dart';
import '../step_images/step_images_state.dart';

part 'steps_event.dart';
part 'steps_state.dart';

class StepsBloc extends Bloc<StepsEvent, StepsState> {
  List<List<String>> stepImages;
  StreamSubscription subscription;

  StepsBloc(StepImagesBloc stepImagesBloc) {
    subscription = stepImagesBloc.listen((siState) {
      if (state is SCanSave) {
        if (siState is LoadedStepImages) {
          stepImages = siState.stepImages;
        }
      }
    });
  }

  @override
  StepsState get initialState => SCanSave();

  @override
  Stream<StepsState> mapEventToState(
    StepsEvent event,
  ) async* {
    if (event is SetCanSave) {
      yield* _mapSetCanSaveToState(event);
    } else if (event is FinishedEditing) {
      yield* _mapFinishedEditingToState(event);
    }
  }

  Stream<StepsState> _mapSetCanSaveToState(SetCanSave event) async* {
    yield SCanSave();
  }

  Stream<StepsState> _mapFinishedEditingToState(FinishedEditing event) async* {
    if (state is SCanSave) {
      bool stepImagesValid = true;
      for (int i = event.steps.length; i < stepImages.length; i++) {
        if (stepImages[i].length != 0) {
          stepImagesValid = false;
          break;
        }
      }
      if (!stepImagesValid) {
        yield SCanSave(isValid: false, time: DateTime.now());
        return;
      }

      if (event.goBack) {
        yield SEditingFinishedGoBack();
      } else {
        yield SEditingFinished();
      }

      if (event.steps.length > 1) {
        for (int i = event.steps.length; i < stepImages.length; i++) {
          stepImages.removeLast();
        }
      }

      Recipe newRecipe;
      if (!event.editingRecipe) {
        newRecipe = HiveProvider().getTmpRecipe().copyWith(
              notes: event.notes,
              stepImages: stepImages,
              effort: event.complexity,
              steps: event.steps,
            );
        await HiveProvider().saveTmpRecipe(newRecipe);
      } else {
        newRecipe = HiveProvider().getTmpEditingRecipe().copyWith(
              notes: event.notes,
              stepImages: stepImages,
              effort: event.complexity,
              steps: event.steps,
            );
        await HiveProvider().saveTmpEditingRecipe(newRecipe);
      }

      if (event.goBack) {
        yield SSavedGoBack();
      } else {
        yield SSaved(newRecipe);
      }
    }
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
