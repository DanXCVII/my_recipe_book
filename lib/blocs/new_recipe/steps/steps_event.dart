part of 'steps_bloc.dart';

abstract class StepsEvent extends Equatable {
  const StepsEvent();
}

class SetCanSave extends StepsEvent {
  @override
  List<Object> get props => [];
}

class FinishedEditing extends StepsEvent {
  final bool editingRecipe;
  final bool goBack;

  final int complexity;
  final List<String> steps;
  final List<String> stepTitles;
  final String notes;
  // List<List<String>> images -> the bloc keeps track of that

  FinishedEditing(
    this.editingRecipe,
    this.goBack,
    this.complexity,
    this.notes,
    this.steps,
    this.stepTitles,
  );

  @override
  List<Object> get props => [
        editingRecipe,
        goBack,
        complexity,
        notes,
        steps,
        stepTitles,
      ];
}
