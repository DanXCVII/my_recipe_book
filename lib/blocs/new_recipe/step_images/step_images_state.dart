part of 'step_images_bloc.dart';

abstract class StepImagesState {
  const StepImagesState();
}

class LoadedStepImages extends StepImagesState {
  final List<List<String>> stepImages;
  final int removedStep;

  LoadedStepImages(this.stepImages, {this.removedStep});

  // @override
  // List<Object> get props => [stepImages, removedStep, stepTitles];
}
