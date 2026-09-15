import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart'
    as RM;
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/tuple.dart';

import '../../local_storage/local_repository.dart';

part 'recipe_calendar_event.dart';
part 'recipe_calendar_state.dart';

class RecipeCalendarBloc
    extends Bloc<RecipeCalendarEvent, RecipeCalendarState> {
  RecipeCalendarBloc(this.recipeManagerBloc, this.repository)
    : selectedWeekStart = startOfWeek(DateTime.now()),
      super(LoadingRecipeCalendar()) {
    subscription = recipeManagerBloc.stream.listen((rmState) {
      if (state is! LoadedRecipeCalendarWeek) return;
      if (rmState is RM.DeleteRecipeState) {
        add(RemoveRecipeFromCalendarEvent(rmState.recipe.name));
      } else if (rmState is RM.UpdateRecipeState) {
        add(
          UpdateRecipeEvent(rmState.oldRecipe.name, rmState.updatedRecipe.name),
        );
      } else if (rmState is RM.UpdateCategoryState ||
          rmState is RM.DeleteCategoryState ||
          rmState is RM.UpdateRecipeTagState ||
          rmState is RM.DeleteRecipeTagState) {
        add(LoadRecipeCalendarEvent());
      }
    });

    on<LoadRecipeCalendarEvent>((event, emit) async {
      emit(LoadingRecipeCalendar());
      await _emitRefresh(emit);
    });

    on<ChangeCalendarWeek>((event, emit) async {
      selectedWeekStart = selectedWeekStart.add(
        Duration(days: event.deltaWeeks * 7),
      );
      await _emitRefresh(emit);
    });

    on<GoToCurrentCalendarWeek>((event, emit) async {
      selectedWeekStart = startOfWeek(DateTime.now());
      await _emitRefresh(emit);
    });

    on<AddRecipeToCalendarEvent>((event, emit) async {
      try {
        await repository.addRecipeToCalendar(event.date, event.recipeName);
        await _emitRefresh(
          emit,
          addedRecipe: Tuple2(event.date, event.recipeName),
        );
      } catch (error) {
        emit(FailedRecipeCalendar(error, selectedWeekStart));
      }
    });

    on<RemoveRecipeFromDateEvent>((event, emit) async {
      try {
        await repository.removeRecipeFromDateCalendar(
          event.date,
          event.recipeName,
        );
        await _emitRefresh(
          emit,
          removedRecipe: Tuple2(event.date, event.recipeName),
        );
      } catch (error) {
        emit(FailedRecipeCalendar(error, selectedWeekStart));
      }
    });

    on<RemoveRecipeFromCalendarEvent>((event, emit) async {
      try {
        await repository.removeRecipeFromCalendar(event.recipeName);
        await _emitRefresh(emit);
      } catch (error) {
        emit(FailedRecipeCalendar(error, selectedWeekStart));
      }
    });

    on<UpdateRecipeEvent>((event, emit) async {
      try {
        final calendar = await repository.getRecipeCalendar();
        final times = calendar.entries
            .where((entry) => entry.value.contains(event.oldRecipeName))
            .expand(
              (entry) => List<DateTime>.filled(
                entry.value.where((name) => name == event.oldRecipeName).length,
                entry.key,
              ),
            )
            .toList(growable: false);
        await repository.removeRecipeFromCalendar(event.oldRecipeName);
        for (final time in times) {
          await repository.addRecipeToCalendar(time, event.newRecipeName);
        }
        await _emitRefresh(emit);
      } catch (error) {
        emit(FailedRecipeCalendar(error, selectedWeekStart));
      }
    });
  }

  final RM.RecipeManagerBloc recipeManagerBloc;
  final LocalRepository repository;
  late DateTime selectedWeekStart;
  late final StreamSubscription subscription;

  static DateTime startOfWeek(DateTime value) {
    final date = DateTime(value.year, value.month, value.day);
    return date.subtract(Duration(days: date.weekday - DateTime.monday));
  }

  Future<void> _emitRefresh(
    Emitter<RecipeCalendarState> emit, {
    Tuple2<DateTime, String>? addedRecipe,
    Tuple2<DateTime, String>? removedRecipe,
  }) async {
    try {
      final calendar = await repository.getRecipeCalendar();
      final recipes = await getRecipesFromTo(selectedWeekStart, 7, calendar);
      emit(
        LoadedRecipeCalendarWeek(
          weekStart: selectedWeekStart,
          recipes: recipes,
          addedRecipe: addedRecipe,
          removedRecipe: removedRecipe,
        ),
      );
    } catch (error) {
      emit(FailedRecipeCalendar(error, selectedWeekStart));
    }
  }

  Future<Map<DateTime, List<Tuple2<DateTime, Recipe>>>> getRecipesFromTo(
    DateTime from,
    int days,
    Map<DateTime, List<String>> recipeCalendar,
  ) async {
    final dateRecipes = <DateTime, List<Tuple2<DateTime, Recipe>>>{};
    for (var index = 0; index < days; index++) {
      final date = from.add(Duration(days: index));
      dateRecipes[date] = await getRecipesFromDay(date, recipeCalendar);
    }
    return dateRecipes;
  }

  Future<List<Tuple2<DateTime, Recipe>>> getRecipesFromDay(
    DateTime day,
    Map<DateTime, List<String>> recipeCalendar,
  ) async {
    final keys =
        recipeCalendar.keys
            .where(
              (key) =>
                  key.year == day.year &&
                  key.month == day.month &&
                  key.day == day.day,
            )
            .toList()
          ..sort();
    final result = <Tuple2<DateTime, Recipe>>[];
    for (final key in keys) {
      for (final recipeName in recipeCalendar[key]!) {
        final recipe = await repository.getRecipeByName(recipeName);
        if (recipe != null) result.add(Tuple2(key, recipe));
      }
    }
    return result;
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
