part of 'recipe_calendar_bloc.dart';

abstract class RecipeCalendarEvent extends Equatable {
  const RecipeCalendarEvent();

  @override
  List<Object> get props => [];
}

class LoadRecipeCalendarEvent extends RecipeCalendarEvent {}

class ChangeSelectedDateEvent extends RecipeCalendarEvent {
  final DateTime day;

  ChangeSelectedDateEvent(this.day);

  @override
  List<Object> get props => [day];
}

class RemoveRecipeFromDateEvent extends RecipeCalendarEvent {
  final DateTime/*!*/ date;
  final String/*!*/ recipeName;

  RemoveRecipeFromDateEvent(this.date, this.recipeName);

  @override
  List<Object> get props => [date, recipeName];
}

class ChangeRecipeCalendarViewEvent extends RecipeCalendarEvent {
  final bool showVerticalCalendar;

  ChangeRecipeCalendarViewEvent(this.showVerticalCalendar);

  @override
  List<Object> get props => [showVerticalCalendar];
}

class ChangeSelectedTimeVerticalEvent extends RecipeCalendarEvent {
  // if false, prevWeek
  final bool nextWeek;

  ChangeSelectedTimeVerticalEvent(this.nextWeek);

  @override
  List<Object> get props => [nextWeek];
}

class RemoveRecipeFromCalendarEvent extends RecipeCalendarEvent {
  final String/*!*/ recipeName;

  RemoveRecipeFromCalendarEvent(this.recipeName);

  @override
  List<Object> get props => [recipeName];
}

class AddRecipeToCalendarEvent extends RecipeCalendarEvent {
  final DateTime date;
  final String/*!*/ recipeName;

  AddRecipeToCalendarEvent(this.date, this.recipeName);

  @override
  List<Object> get props => [date, recipeName];
}
