part of 'ingredients_manager_bloc.dart';

abstract class IngredientsManagerState extends Equatable {
  const IngredientsManagerState();
}

class IngredientsManagerInitial extends IngredientsManagerState {
  @override
  List<Object> get props => [];
}

class LoadingIngredientsManager extends IngredientsManagerState {
  @override
  List<Object> get props => [];
}

class LoadedIngredientsManager extends IngredientsManagerState {
  final List<String> ingredients;

  const LoadedIngredientsManager([this.ingredients = const []]);

  @override
  List<Object> get props => [ingredients];
}
