part of 'nutrition_manager_bloc.dart';

abstract class NutritionManagerState extends Equatable {
  const NutritionManagerState();
}

class InitialNutritionManagerState extends NutritionManagerState {
  @override
  List<Object> get props => [];
}

class LoadingNutritionManager extends NutritionManagerState {
  @override
  List<Object> get props => [];
}

class LoadedNutritionManager extends NutritionManagerState {
  final List<String> nutritions;

  const LoadedNutritionManager([this.nutritions = const []]);

  @override
  List<Object> get props => [nutritions];
}
