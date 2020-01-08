import 'package:equatable/equatable.dart';

abstract class ClearRecipeEvent extends Equatable {
  const ClearRecipeEvent();
}

class Clear extends ClearRecipeEvent {
  final bool editingRecipe;

  final DateTime dateTime;

  Clear(this.editingRecipe, this.dateTime);

  @override
  List<Object> get props => [dateTime];
}
