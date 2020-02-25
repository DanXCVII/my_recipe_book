part of 'general_info_bloc.dart';

abstract class GeneralInfoState extends Equatable {
  const GeneralInfoState();

  @override
  List<Object> get props => [];
}

class GCanSave extends GeneralInfoState {}

class GSavingTmpData extends GeneralInfoState {}

class GEditingFinished extends GeneralInfoState {}

class GSaved extends GeneralInfoState {
  final Recipe recipe;

  GSaved(this.recipe);

  @override
  List<Object> get props => [recipe];
}

/// when the user wants to pop the route and we're saving the edited
/// data to hive
class GEditingFinishedGoBack extends GeneralInfoState {}

class GSavedGoBack extends GeneralInfoState {}
