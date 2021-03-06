part of 'step_images_bloc.dart';

abstract class StepImagesState extends Equatable {
  const StepImagesState();
}

class LoadedStepImages extends StepImagesState {
  final List<List<String>> stepImages;

  LoadedStepImages(this.stepImages);

  @override
  List<Object> get props => [stepImages];
}
