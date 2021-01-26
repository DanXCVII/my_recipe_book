part of 'steps_bloc.dart';

abstract class StepsEvent extends Equatable {
  const StepsEvent();
}

class SetCanSave extends StepsEvent {
  @override
  List<Object> get props => [];
}

class AddStep extends StepsEvent {
  final String step;

  AddStep(this.step);

  @override
  List<Object> get props => [step];
}

class FinishedEditing extends StepsEvent {
  final bool editingRecipe;
  final bool goBack;

  final int complexity;
  final String notes;
  // List<List<String>> images -> the bloc keeps track of that

  FinishedEditing(
    this.editingRecipe,
    this.goBack,
    this.complexity,
    this.notes,
  );

  @override
  List<Object> get props => [
        editingRecipe,
        goBack,
        complexity,
        notes,
      ];
}
