part of 'animated_stepper_bloc.dart';

abstract class AnimatedStepperState extends Equatable {
  const AnimatedStepperState();
}

class AnimatedStepperInitial extends AnimatedStepperState {
  @override
  List<Object> get props => [];
}

class SelectedStep extends AnimatedStepperState {
  final int selectedStep;

  SelectedStep(this.selectedStep);

  @override
  List<Object> get props => [selectedStep];
}
