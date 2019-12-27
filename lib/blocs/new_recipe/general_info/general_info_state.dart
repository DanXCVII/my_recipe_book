import 'package:equatable/equatable.dart';

abstract class GeneralInfoState extends Equatable {
  const GeneralInfoState();

  @override
  List<Object> get props => [];
}

class GCanSave extends GeneralInfoState {}

class GSavingTmpData extends GeneralInfoState {}

class GEditingFinished extends GeneralInfoState {}

class GSaved extends GeneralInfoState {}

/// when the user wants to pop the route and we're saving the edited
/// data to hive
class GEditingFinishedGoBack extends GeneralInfoState {}

class GSavedGoBack extends GeneralInfoState {}
