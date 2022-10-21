import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'animated_stepper_event.dart';
part 'animated_stepper_state.dart';

class AnimatedStepperBloc
    extends Bloc<AnimatedStepperEvent, AnimatedStepperState> {
  final initialStep;

  AnimatedStepperBloc({this.initialStep}) : super(SelectedStep(initialStep)) {
    on<ChangeStep>((event, emit) async {
      emit(SelectedStep(event.selectedStep));
    });
  }
}
