import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../local_storage/local_repository.dart';
import '../../../models/recipe.dart';
import '../step_images/step_images_bloc.dart';

part 'steps_event.dart';
part 'steps_state.dart';

class StepsBloc extends Bloc<StepsEvent, StepsState> {
  List<List<String>> stepImages = [[]];
  List<List<String>> stepIngredientIds = [];
  List<String> stepTitles = [""];
  List<String> steps = [];
  late StreamSubscription subscription;
  final LocalRepository repository;

  StepsBloc(StepImagesBloc stepImagesBloc, this.repository)
    : super(SCanSave(isValid: true, time: DateTime.now())) {
    subscription = stepImagesBloc.stream.listen((siState) {
      if (state is SCanSave) {
        if (siState is LoadedStepImages) {
          stepImages = siState.stepImages;
          steps = siState.steps;
          stepTitles = siState.stepTitles;
          stepIngredientIds = siState.stepIngredientIds;
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
        final recipeStepIngredientIds = List.generate(
          recipeSteps.length,
          (index) => index < stepIngredientIds.length
              ? List<String>.from(stepIngredientIds[index])
              : <String>[],
        );

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

        while (stepImages.length > steps.length) {
          stepImages.removeLast();
        }
        while (stepImages.length < steps.length) {
          stepImages.add(<String>[]);
        }

        Recipe newRecipe;
        if (!event.editingRecipe) {
          newRecipe = repository.getTmpRecipe()!.copyWith(
            notes: event.notes,
            stepImages: stepImages,
            effort: event.complexity,
            steps: recipeSteps,
            stepTitles: recipeStepTitles,
            stepIngredientIds: recipeStepIngredientIds,
          );
          await repository.saveTmpRecipe(newRecipe);
        } else {
          newRecipe = repository.getTmpEditingRecipe()!.copyWith(
            notes: event.notes,
            stepImages: stepImages,
            effort: event.complexity,
            steps: recipeSteps,
            stepTitles: recipeStepTitles,
            stepIngredientIds: recipeStepIngredientIds,
          );
          await repository.saveTmpEditingRecipe(newRecipe);
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
