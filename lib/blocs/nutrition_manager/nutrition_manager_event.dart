import 'package:equatable/equatable.dart';

abstract class NutritionManagerEvent extends Equatable {
  const NutritionManagerEvent();

  @override
  List<Object> get props => [];
}

class LoadNutritionManager extends NutritionManagerEvent {}

class AddNutrition extends NutritionManagerEvent {
  final String nutrition;

  const AddNutrition(this.nutrition);

  @override
  List<Object> get props => [nutrition];

  @override
  String toString() => 'add nutrition { nutrition: $nutrition }';
}

class DeleteNutrition extends NutritionManagerEvent {
  final String nutrition;

  const DeleteNutrition(this.nutrition);

  @override
  List<Object> get props => [nutrition];

  @override
  String toString() => 'delete nutrition { nutrition: $nutrition }';
}

class MoveNutrition extends NutritionManagerEvent {
  final int oldIndex;
  final int newIndex;

  const MoveNutrition(this.oldIndex, this.newIndex);

  @override
  List<Object> get props => [oldIndex, newIndex];

  @override
  String toString() =>
      'move nutrition { oldIndex: $oldIndex , newIndex: $newIndex }';
}

class UpdateNutrition extends NutritionManagerEvent {
  final String oldNutrition;
  final String updatedNutrition;

  const UpdateNutrition(this.oldNutrition, this.updatedNutrition);

  @override
  List<Object> get props => [oldNutrition, updatedNutrition];

  @override
  String toString() =>
      'update nutrition { oldIndex: $oldNutrition , newIndex: $updatedNutrition }';
}
