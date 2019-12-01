import 'package:equatable/equatable.dart';

abstract class GeneralInfoState extends Equatable {
  const GeneralInfoState();

  @override
  List<Object> get props => [];
}

class CanSave extends GeneralInfoState {}

class SavingTmpData extends GeneralInfoState {}

class EditingFinished extends GeneralInfoState {}

class Saved extends GeneralInfoState {}

class EditingFinishedGoBack extends GeneralInfoState {}

class SavedGoBack extends GeneralInfoState {}
