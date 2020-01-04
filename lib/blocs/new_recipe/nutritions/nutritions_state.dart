import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/models/recipe.dart';

abstract class NutritionsState extends Equatable {
  const NutritionsState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class NCanSave extends NutritionsState {}

class NSavingTmpData extends NutritionsState {}

class NEditingFinished extends NutritionsState {}

class NSaved extends NutritionsState {
  final Recipe recipe;

  NSaved(this.recipe);

  @override
  List<Object> get props => [recipe];
}

/// when the user wants to pop the route and we're saving the edited
/// data to hive
class NEditingFinishedGoBack extends NutritionsState {}

class NSavedGoBack extends NutritionsState {}