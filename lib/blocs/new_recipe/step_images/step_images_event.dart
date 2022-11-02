part of 'step_images_bloc.dart';

abstract class StepImagesEvent extends Equatable {
  const StepImagesEvent();
}

class InitializeStepImages extends StepImagesEvent {
  final List<List<String>> stepImages;
  final List<String> steps;
  final List<String> stepTitles;

  InitializeStepImages(this.steps, this.stepTitles, {required this.stepImages});

  @override
  List<Object> get props => [stepImages];
}

class AddImage extends StepImagesEvent {
  final File stepImage;
  final int stepNumber;
  final bool editingRecipe;

  const AddImage(
    this.stepImage,
    this.stepNumber,
    this.editingRecipe,
  );

  @override
  List<Object> get props => [
        stepImage,
        stepNumber,
        editingRecipe,
      ];
}

class AddStep extends StepImagesEvent {
  final String step;
  final DateTime time;

  const AddStep(this.step, this.time);

  @override
  List<Object> get props => [step, time];
}

class RemoveImage extends StepImagesEvent {
  final int stepNumber;
  final int stepImageIndex;
  final bool editingRecipe;

  const RemoveImage(
    this.stepNumber,
    this.stepImageIndex,
    this.editingRecipe,
  );

  @override
  List<Object> get props => [
        stepImageIndex,
        stepNumber,
        editingRecipe,
      ];
}

class RemoveStep extends StepImagesEvent {
  final String recipeName;
  final DateTime dateTime;
  final int? stepNumber;

  const RemoveStep(this.recipeName, this.dateTime, {this.stepNumber});

  @override
  List<Object> get props => [recipeName, dateTime];
}

class EditStepTitle extends StepImagesEvent {
  final String stepTitle;
  final int stepIndex;

  EditStepTitle(this.stepTitle, this.stepIndex);

  @override
  List<Object> get props => [stepTitle, stepIndex];
}

class EditStep extends StepImagesEvent {
  final String step;
  final int stepIndex;

  EditStep(this.step, this.stepIndex);

  @override
  List<Object> get props => [step, stepIndex];
}

class MoveStep extends StepImagesEvent {
  final int oldIndex;
  final int newIndex;

  MoveStep(this.oldIndex, this.newIndex);

  @override
  List<Object> get props => [oldIndex, newIndex];
}
