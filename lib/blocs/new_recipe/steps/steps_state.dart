import 'package:equatable/equatable.dart';

import '../../../models/recipe.dart';

abstract class StepsState extends Equatable {
  const StepsState();

  @override
  List<Object> get props => [];
}

class SCanSave extends StepsState {
  final bool isValid;
  final DateTime time;

  SCanSave({this.isValid, this.time});

  @override
  List<Object> get props => [isValid, time];
}

class SSavingTmpData extends StepsState {}

class SEditingFinished extends StepsState {}

class SSaved extends StepsState {
  final Recipe recipe;

  SSaved(this.recipe);

  @override
  List<Object> get props => [recipe];
}

/// when the user wants to pop the route and we're saving the edited
/// data to hive
class SEditingFinishedGoBack extends StepsState {}

class SSavedGoBack extends StepsState {}
