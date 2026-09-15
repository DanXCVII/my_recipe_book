part of 'step_images_bloc.dart';

abstract class StepImagesState {
  const StepImagesState();
}

class LoadedStepImages extends StepImagesState {
  final List<List<String>> stepImages;
  final List<String> steps;
  final List<String> stepTitles;
  final List<List<String>> stepIngredientIds;
  final int? removedStep;

  final List<Key> stepKeys;

  LoadedStepImages(
    this.stepImages,
    this.steps,
    this.stepTitles,
    this.stepKeys, {
    this.removedStep,
    this.stepIngredientIds = const [],
  });

  // @override
  // List<Object> get props => [stepImages, removedStep, stepTitles];
}
