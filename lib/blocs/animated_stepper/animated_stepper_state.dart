part of 'animated_stepper_bloc.dart';

abstract class AnimatedStepperState extends Equatable {
  const AnimatedStepperState();
}

class SelectedStep extends AnimatedStepperState {
  final int selectedStep;

  SelectedStep(this.selectedStep);

  @override
  List<Object> get props => [selectedStep];
}
