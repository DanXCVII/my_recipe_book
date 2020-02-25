import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class StepImagesEvent extends Equatable {
  const StepImagesEvent();
}

class InitializeStepImages extends StepImagesEvent {
  final List<List<String>> stepImages;

  InitializeStepImages({this.stepImages});

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
  final DateTime time;

  const AddStep(this.time);

  @override
  List<Object> get props => [time];
}

class RemoveImage extends StepImagesEvent {
  final String stepImage;
  final int stepNumber;
  final bool editingRecipe;

  const RemoveImage(
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

class RemoveStep extends StepImagesEvent {
  final String recipeName;
  final DateTime dateTime;

  const RemoveStep(this.recipeName, this.dateTime);

  @override
  List<Object> get props => [recipeName, dateTime];
}
