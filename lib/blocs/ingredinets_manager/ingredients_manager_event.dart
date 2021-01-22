part of 'ingredients_manager_bloc.dart';

abstract class IngredientsManagerEvent extends Equatable {
  const IngredientsManagerEvent();

  @override
  List<Object> get props => [];
}

class LoadIngredientsManager extends IngredientsManagerEvent {}

class AddIngredient extends IngredientsManagerEvent {
  final String ingredient;

  const AddIngredient(this.ingredient);

  @override
  List<Object> get props => [ingredient];
}

class DeleteIngredient extends IngredientsManagerEvent {
  final String ingredient;

  const DeleteIngredient(this.ingredient);

  @override
  List<Object> get props => [ingredient];
}

class UpdateIngredient extends IngredientsManagerEvent {
  final String oldIngredient;
  final String updatedIngredient;

  const UpdateIngredient(this.oldIngredient, this.updatedIngredient);

  @override
  List<Object> get props => [oldIngredient, updatedIngredient];
}
