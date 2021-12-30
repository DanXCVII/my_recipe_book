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
  bool isVertical;
  DateTime overviewSelectedDay;
  DateTime verticalSelectedWeek;
  StreamSubscription subscription;
  SharedPreferences prefs;

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
          // TODO: Either remove recipe or update which is more effort
        } else if (rmState is RM.UpdateCategoryState ||
            rmState is RM.DeleteCategoryState ||
            rmState is RM.UpdateRecipeTagState ||
            rmState is RM.DeleteRecipeTagState) {
          add(LoadRecipeCalendarEvent());
        }
      }
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }

  @override
  Stream<RecipeCalendarState> mapEventToState(
    RecipeCalendarEvent event,
  ) async* {
    if (event is LoadRecipeCalendarEvent) {
      yield* _mapLoadRecipeCalendarEventToState(event);
    } else if (event is RemoveRecipeFromDateEvent) {
      yield* _mapRemoveRecipeFromDateEventToState(event);
    } else if (event is ChangeSelectedDateEvent) {
      yield* _mapChangeSelectedDateEventToState(event);
    } else if (event is AddRecipeToCalendarEvent) {
      yield* _mapAddRecipeToCalendarEventToState(event);
    } else if (event is RemoveRecipeFromCalendarEvent) {
      yield* _mapRemoveRecipeFromCalendarEventToState(event);
    } else if (event is ChangeRecipeCalendarViewEvent) {
      yield* _mapChangeRecipeCalendarViewEventToState(event);
    } else if (event is ChangeSelectedTimeVerticalEvent) {
      yield* _mapChangeSelectedTimeVerticalEventToState(event);
    }
  }

  Stream<RecipeCalendarState> _mapLoadRecipeCalendarEventToState(
      LoadRecipeCalendarEvent event) async* {
    yield LoadingRecipeCalendar();

    prefs ??= await SharedPreferences.getInstance();
    if (prefs.containsKey("recipeCalendarIsVertical")) {
      isVertical = prefs.getBool("recipeCalendarIsVertical");
    } else {
      prefs.setBool("recipeCalendarIsVertical", false);
    }

    yield* _refreshCalendar();
  }

  Stream<RecipeCalendarState> _mapRemoveRecipeFromDateEventToState(
      RemoveRecipeFromDateEvent event) async* {
    yield LoadingRecipeCalendar();

    await HiveProvider()
        .removeRecipeFromDateCalendar(event.date, event.recipeName);

    yield* _refreshCalendar();
  }

  Stream<RecipeCalendarState> _mapChangeSelectedDateEventToState(
      ChangeSelectedDateEvent event) async* {
    overviewSelectedDay = event.day;

    // yep it unnesseserily releoads the events but this shouldn't be too cpu intensive..
    yield* _refreshCalendar();
  }

  Stream<RecipeCalendarState> _mapAddRecipeToCalendarEventToState(
      AddRecipeToCalendarEvent event) async* {
    await HiveProvider().addRecipeToCalendar(event.date, event.recipeName);

    yield* _refreshCalendar(
      addedRecipe: Tuple2<DateTime, String>(event.date, event.recipeName),
    );
  }

  Stream<RecipeCalendarState> _mapChangeRecipeCalendarViewEventToState(
      ChangeRecipeCalendarViewEvent event) async* {
    isVertical = event.showVerticalCalendar;
    await prefs.setBool("recipeCalendarIsVertical", event.showVerticalCalendar);

    yield* _refreshCalendar();
  }

  Stream<RecipeCalendarState> _mapRemoveRecipeFromCalendarEventToState(
      RemoveRecipeFromCalendarEvent event) async* {
    await HiveProvider().removeRecipeFromCalendar(event.recipeName);

    yield* _refreshCalendar();
  }

  Stream<RecipeCalendarState> _mapChangeSelectedTimeVerticalEventToState(
      ChangeSelectedTimeVerticalEvent event) async* {
    if (event.nextWeek) {
      verticalSelectedWeek = verticalSelectedWeek.add(Duration(days: 7));
    } else {
      verticalSelectedWeek = verticalSelectedWeek.subtract(Duration(days: 7));
    }

    yield* _refreshCalendar();
  }

  // loads the calendar with the selected vertical state an
  Stream<RecipeCalendarState> _refreshCalendar(
      {Tuple2<DateTime, String> addedRecipe}) async* {
    Map<DateTime, List<String>> recipeCalendar =
        await HiveProvider().getRecipeCalendar();

    if (isVertical == true) {
      Map<DateTime, List<Tuple2<DateTime, Recipe>>> dateRecipes =
          await getRecipesFromTo(verticalSelectedWeek, 7, recipeCalendar);

      yield LoadedRecipeCalendarVertical(
        verticalSelectedWeek,
        7,
        dateRecipes,
        addedRecipe: addedRecipe,
      );
    } else {
      List<Tuple2<DateTime, Recipe>> currentDayRecipes =
          await getRecipesFromDay(overviewSelectedDay, recipeCalendar);

      yield LoadedRecipeCalendarOverview(
        recipeCalendar,
        currentDayRecipes,
        overviewSelectedDay,
        addedRecipe: addedRecipe,
      );
    }
  }

  Future<Map<DateTime, List<Tuple2<DateTime, Recipe>>>> getRecipesFromTo(
      DateTime from,
      int days,
      Map<DateTime, List<String>> recipeCalendar) async {
    Map<DateTime, List<Tuple2<DateTime, Recipe>>> dateRecipes = {};
    for (int i = 0; i < days; i++) {
      DateTime selectedDateTime = from.add(Duration(days: i));
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
      for (String recipeName in recipeCalendar[selectedKeys[i]]) {
        dateRecipes.add(Tuple2<DateTime, Recipe>(
            selectedKeys[i], await HiveProvider().getRecipeByName(recipeName)));
      }
    }

    return dateRecipes;
  }
}
