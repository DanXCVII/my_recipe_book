part of 'recipe_calendar_bloc.dart';

abstract class RecipeCalendarState extends Equatable {
  const RecipeCalendarState();

  @override
  List<Object?> get props => [];
}

class LoadingRecipeCalendar extends RecipeCalendarState {}

class LoadedRecipeCalendarWeek extends RecipeCalendarState {
  const LoadedRecipeCalendarWeek({
    required this.weekStart,
    required this.recipes,
    this.addedRecipe,
    this.removedRecipe,
  });

  final DateTime weekStart;
  final Map<DateTime, List<Tuple2<DateTime, Recipe>>> recipes;
  final Tuple2<DateTime, String>? addedRecipe;
  final Tuple2<DateTime, String>? removedRecipe;

  int get recipeCount => recipes.values.fold(0, (sum, day) => sum + day.length);

  @override
  List<Object?> get props => [weekStart, recipes, addedRecipe, removedRecipe];
}

class FailedRecipeCalendar extends RecipeCalendarState {
  const FailedRecipeCalendar(this.error, this.weekStart);

  final Object error;
  final DateTime weekStart;

  @override
  List<Object?> get props => [error, weekStart];
}
