import 'package:equatable/equatable.dart';

abstract class IngredientsState extends Equatable {
  const IngredientsState();

  @override
  List<Object> get props => [];
}

class ICanSave extends IngredientsState {}

class ISavingTmpData extends IngredientsState {}

class IEditingFinished extends IngredientsState {}

class ISaved extends IngredientsState {}

/// when the user wants to pop the route and we're saving the edited
/// data to hive
class IEditingFinishedGoBack extends IngredientsState {}

class ISavedGoBack extends IngredientsState {}
