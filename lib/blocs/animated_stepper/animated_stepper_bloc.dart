import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'animated_stepper_event.dart';
part 'animated_stepper_state.dart';

class AnimatedStepperBloc
    extends Bloc<AnimatedStepperEvent, AnimatedStepperState> {
  final initialStep;

  AnimatedStepperBloc({this.initialStep}) : super(SelectedStep(initialStep));

  @override
  Stream<AnimatedStepperState> mapEventToState(
    AnimatedStepperEvent event,
  ) async* {
    if (event is ChangeStep) {
      yield* _mapChangeStepToState(event);
    }
  }

  Stream<AnimatedStepperState> _mapChangeStepToState(ChangeStep event) async* {
    yield SelectedStep(event.selectedStep);
  }
}
