import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/local_storage/hive.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart'
    as RM;
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/tuple.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'recipe_calendar_event.dart';
part 'recipe_calendar_state.dart';

class RecipeCalendarBloc
    extends Bloc<RecipeCalendarEvent, RecipeCalendarState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  bool? isVertical;
  late DateTime overviewSelectedDay;
  DateTime? verticalSelectedWeek;
  late StreamSubscription subscription;
  SharedPreferences? prefs;

  RecipeCalendarBloc(this.recipeManagerBloc) : super(LoadingRecipeCalendar()) {
    overviewSelectedDay = DateTime.now();
    verticalSelectedWeek = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    isVertical = false;
    subscription = recipeManagerBloc.stream.listen((rmState) {
      if (state is LoadedRecipeCalendarOverview ||
          state is LoadedRecipeCalendarVertical) {
        if (rmState is RM.DeleteRecipeState) {
          add(RemoveRecipeFromCalendarEvent(rmState.recipe.name));
        } else if (rmState is RM.UpdateRecipeState) {
          add(UpdateRecipeEvent(
              rmState.oldRecipe.name, rmState.updatedRecipe.name));
        } else if (rmState is RM.UpdateCategoryState ||
            rmState is RM.DeleteCategoryState ||
            rmState is RM.UpdateRecipeTagState ||
            rmState is RM.DeleteRecipeTagState) {
          add(LoadRecipeCalendarEvent());
        }
      }
    });

    on<LoadRecipeCalendarEvent>((event, emit) async {
      emit(LoadingRecipeCalendar());

      prefs ??= await SharedPreferences.getInstance();
      if (prefs!.containsKey("recipeCalendarIsVertical")) {
        isVertical = prefs!.getBool("recipeCalendarIsVertical");
      } else {
        prefs!.setBool("recipeCalendarIsVertical", false);
      }

      emit(await _refreshCalendar());
    });

    on<UpdateRecipeEvent>((event, emit) async {
      Map<DateTime, List<String>> recipeCalendar =
          await HiveProvider().getRecipeCalendar();
      // times, for which the recipe is added
      List<DateTime> times = [];

      for (DateTime time in recipeCalendar.keys) {
        if (recipeCalendar[time]?.contains(event.oldRecipeName) ?? false) {
          times.add(time);
        }
      }
      add(RemoveRecipeFromCalendarEvent(event.oldRecipeName));

      for (DateTime time in times) {
        await HiveProvider().addRecipeToCalendar(time, event.newRecipeName);
      }

      emit(await _refreshCalendar());
    });

    on<ChangeSelectedDateEvent>((event, emit) async {
      overviewSelectedDay = event.day;

      // yep it unnesseserily releoads the events but this shouldn't be too cpu intensive..
      emit(await _refreshCalendar());
    });

    on<AddRecipeToCalendarEvent>((event, emit) async {
      await HiveProvider().addRecipeToCalendar(event.date, event.recipeName);

      emit(await _refreshCalendar(
        addedRecipe: Tuple2<DateTime, String>(event.date, event.recipeName),
      ));
    });

    on<RemoveRecipeFromCalendarEvent>((event, emit) async {
      await HiveProvider().removeRecipeFromCalendar(event.recipeName);

      emit(await _refreshCalendar());
    });

    on<ChangeRecipeCalendarViewEvent>((event, emit) async {
      isVertical = event.showVerticalCalendar;
      await prefs!
          .setBool("recipeCalendarIsVertical", event.showVerticalCalendar);

      emit(await _refreshCalendar());
    });

    on<ChangeSelectedTimeVerticalEvent>((event, emit) async {
      if (event.nextWeek) {
        verticalSelectedWeek = verticalSelectedWeek!.add(Duration(days: 7));
      } else {
        verticalSelectedWeek =
            verticalSelectedWeek!.subtract(Duration(days: 7));
      }

      emit(await _refreshCalendar());
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }

  // loads the calendar with the selected vertical state an
  Future<RecipeCalendarState> _refreshCalendar(
      {Tuple2<DateTime, String>? addedRecipe}) async {
    Map<DateTime, List<String>> recipeCalendar =
        await HiveProvider().getRecipeCalendar();

    if (isVertical == true) {
      Map<DateTime, List<Tuple2<DateTime, Recipe>>> dateRecipes =
          await getRecipesFromTo(verticalSelectedWeek, 7, recipeCalendar);

      return LoadedRecipeCalendarVertical(
        verticalSelectedWeek!,
        7,
        dateRecipes,
        addedRecipe: addedRecipe,
      );
    } else {
      List<Tuple2<DateTime, Recipe>> currentDayRecipes =
          await getRecipesFromDay(overviewSelectedDay, recipeCalendar);

      return LoadedRecipeCalendarOverview(
        removeTimeFromDateKey(recipeCalendar),
        currentDayRecipes,
        overviewSelectedDay,
        addedRecipe: addedRecipe,
      );
    }
  }

  // creates a new map which has as keys a DateTime with only day-month-year without time
  Map<DateTime, List<String>> removeTimeFromDateKey(
      Map<DateTime, List<String>> events) {
    Map<DateTime, List<String>> eventsWithoutTime = {};
    for (DateTime timeKey in events.keys) {
      DateTime dateKeyClean =
          DateTime(timeKey.year, timeKey.month, timeKey.day);
      if (eventsWithoutTime.containsKey(dateKeyClean)) {
        eventsWithoutTime[dateKeyClean]!.addAll(events[timeKey]!);
      } else {
        eventsWithoutTime[dateKeyClean] = events[timeKey] ?? [];
      }
    }
    return eventsWithoutTime;
  }

  Future<Map<DateTime, List<Tuple2<DateTime, Recipe>>>> getRecipesFromTo(
      DateTime? from,
      int days,
      Map<DateTime, List<String>> recipeCalendar) async {
    Map<DateTime, List<Tuple2<DateTime, Recipe>>> dateRecipes = {};
    for (int i = 0; i < days; i++) {
      DateTime selectedDateTime = from!.add(Duration(days: i));
      dateRecipes.addAll({
        selectedDateTime: await getRecipesFromDay(
          selectedDateTime,
          recipeCalendar,
        )
      });
    }
    return dateRecipes;
  }

  Future<List<Tuple2<DateTime, Recipe>>> getRecipesFromDay(
      DateTime day, Map<DateTime, List<String>> recipeCalendar) async {
    List<Tuple2<DateTime, Recipe>> dateRecipes = [];

    List<DateTime> selectedKeys = [];
    for (DateTime key in recipeCalendar.keys) {
      String dateString = key.toIso8601String();
      String dateBegin =
          "${day.year}-${day.month < 10 ? "0" : ""}${day.month}-${day.day < 10 ? "0" : ""}${day.day}";
      if (dateString.startsWith(dateBegin)) {
        selectedKeys.add(key);
      }
    }

    selectedKeys.sort();
    for (int i = 0; i < selectedKeys.length; i++) {
      for (String recipeName in recipeCalendar[selectedKeys[i]]!) {
        if (await HiveProvider().doesRecipeExist(recipeName)) {
          dateRecipes.add(Tuple2<DateTime, Recipe>(selectedKeys[i],
              (await HiveProvider().getRecipeByName(recipeName))!));
        }
      }
    }

    return dateRecipes;
  }
}
