import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class StepImagesEvent extends Equatable {
  const StepImagesEvent();
}

class AddImage extends StepImagesEvent {
  final File stepImage;
  final int stepNumber;
  final String recipeName;

  const AddImage(
    this.stepImage,
    this.stepNumber,
    this.recipeName,
  );

  @override
  List<Object> get props => [
        stepImage,
        stepNumber,
        recipeName,
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
  final String recipeName;

  const RemoveImage(
    this.stepImage,
    this.stepNumber,
    this.recipeName,
  );

  @override
  List<Object> get props => [
        stepImage,
        stepNumber,
        recipeName,
      ];
}

class RemoveStep extends StepImagesEvent {
  final String recipeName;
  final DateTime dateTime;

  const RemoveStep(this.recipeName, this.dateTime);

  @override
  List<Object> get props => [recipeName, dateTime];
}
