import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../local_storage/hive.dart';
import '../../../models/recipe.dart';
import '../step_images/step_images_bloc.dart';

part 'steps_event.dart';
part 'steps_state.dart';

class StepsBloc extends Bloc<StepsEvent, StepsState> {
  List<List<String>> stepImages = [[]];
  List<String> stepTitles = [""];
  List<String> steps = [];
  late StreamSubscription subscription;

  StepsBloc(StepImagesBloc stepImagesBloc)
      : super(SCanSave(isValid: true, time: DateTime.now())) {
    subscription = stepImagesBloc.stream.listen((siState) {
      if (state is SCanSave) {
        if (siState is LoadedStepImages) {
          stepImages = siState.stepImages;
          steps = siState.steps;
          stepTitles = siState.stepTitles;
        }
      }
    });

    on<SetCanSave>((event, emit) async {
      emit(SCanSave(isValid: true, time: DateTime.now()));
    });

    on<FinishedEditing>((event, emit) async {
      if (state is SCanSave) {
        List<String> recipeSteps = steps.map((e) => e).toList();
        List<String> recipeStepTitles = stepTitles.map((e) => e).toList();

        bool stepImagesValid = true;
        for (int i = steps.length; i < stepImages.length; i++) {
          if (stepImages[i].length != 0) {
            stepImagesValid = false;
            break;
          }
        }

        if (!stepImagesValid) {
          emit(SCanSave(isValid: false, time: DateTime.now()));
          return;
        }

        if (event.goBack) {
          emit(SEditingFinishedGoBack());
        } else {
          emit(SEditingFinished());
        }

        if (steps.length > 1) {
          for (int i = steps.length; i < stepImages.length; i++) {
            stepImages.removeLast();
          }
        }

        Recipe newRecipe;
        if (!event.editingRecipe) {
          newRecipe = HiveProvider().getTmpRecipe()!.copyWith(
                notes: event.notes,
                stepImages: stepImages,
                effort: event.complexity,
                steps: recipeSteps,
                stepTitles: recipeStepTitles,
              );
          await HiveProvider().saveTmpRecipe(newRecipe);
        } else {
          newRecipe = HiveProvider().getTmpEditingRecipe()!.copyWith(
                notes: event.notes,
                stepImages: stepImages,
                effort: event.complexity,
                steps: recipeSteps,
                stepTitles: recipeStepTitles,
              );
          await HiveProvider().saveTmpEditingRecipe(newRecipe);
        }

        if (event.goBack) {
          emit(SSavedGoBack());
        } else {
          emit(SSaved(newRecipe));
        }
      }
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
