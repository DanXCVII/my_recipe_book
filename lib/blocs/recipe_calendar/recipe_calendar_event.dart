part of 'recipe_calendar_bloc.dart';

abstract class RecipeCalendarEvent extends Equatable {
  const RecipeCalendarEvent();

  @override
  List<Object> get props => [];
}

class LoadRecipeCalendarEvent extends RecipeCalendarEvent {}

class ChangeCalendarWeek extends RecipeCalendarEvent {
  const ChangeCalendarWeek(this.deltaWeeks);

  final int deltaWeeks;

  @override
  List<Object> get props => [deltaWeeks];
}

class GoToCurrentCalendarWeek extends RecipeCalendarEvent {}

class RemoveRecipeFromDateEvent extends RecipeCalendarEvent {
  const RemoveRecipeFromDateEvent(this.date, this.recipeName);

  final DateTime date;
  final String recipeName;

  @override
  List<Object> get props => [date, recipeName];
}

class UpdateRecipeEvent extends RecipeCalendarEvent {
  const UpdateRecipeEvent(this.oldRecipeName, this.newRecipeName);

  final String oldRecipeName;
  final String newRecipeName;

  @override
  List<Object> get props => [oldRecipeName, newRecipeName];
}

class RemoveRecipeFromCalendarEvent extends RecipeCalendarEvent {
  const RemoveRecipeFromCalendarEvent(this.recipeName);

  final String recipeName;

  @override
  List<Object> get props => [recipeName];
}

class AddRecipeToCalendarEvent extends RecipeCalendarEvent {
  const AddRecipeToCalendarEvent(this.date, this.recipeName);

  final DateTime date;
  final String recipeName;

  @override
  List<Object> get props => [date, recipeName];
}
