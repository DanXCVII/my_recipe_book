part of 'recipe_calendar_bloc.dart';

abstract class RecipeCalendarState extends Equatable {
  const RecipeCalendarState();

  @override
  List<Object> get props => [];
}

class LoadingRecipeCalendar extends RecipeCalendarState {}

class LoadedRecipeCalendarVertical extends RecipeCalendarState {
  final DateTime from;
  final int days;
  final Map<DateTime, List<Tuple2<DateTime, Recipe>>> recipes;
  final Tuple2<DateTime, String> addedRecipe;

  LoadedRecipeCalendarVertical(
    this.from,
    this.days,
    this.recipes, {
    this.addedRecipe,
  });

  @override
  List<Object> get props => [
        from,
        days,
        recipes,
        addedRecipe,
      ];
}

class LoadedRecipeCalendarOverview extends RecipeCalendarState {
  final Map<DateTime, List<String>> events;
  final List<Tuple2<DateTime, Recipe>> currentRecipes;
  final Tuple2<DateTime, String> addedRecipe;
  final DateTime selectedDay;

  LoadedRecipeCalendarOverview(
    this.events,
    this.currentRecipes,
    this.selectedDay, {
    this.addedRecipe,
  });

  @override
  List<Object> get props => [
        events,
        currentRecipes,
        selectedDay,
        addedRecipe,
      ];
}
