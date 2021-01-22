part of 'animated_stepper_bloc.dart';

abstract class AnimatedStepperEvent extends Equatable {
  const AnimatedStepperEvent();
}

class ChangeStep extends AnimatedStepperEvent {
  final int selectedStep;

  ChangeStep(this.selectedStep);

  @override
  List<Object> get props => [selectedStep];
}
