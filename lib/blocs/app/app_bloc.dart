import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  SharedPreferences prefs;
  AppBloc() : super(LoadingState());

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is InitializeData) {
      yield* _mapInitializeDataToState(event);
    } else if (event is ChangeView) {
      yield* _mapChangeViewToState(event);
    } else if (event is ChangeCategoryOverview) {
      yield* _mapChangeCategoryOverviewToState(event);
    } else if (event is ChangeShoppingCartView) {
      yield* _mapChangeShoppingCartView(event);
    } else if (event is ShoppingCartShowSummary) {
      yield* _mapShoppingCartShowSummaryToState(event);
    } else if (event is ChangeRecipeCalendarView) {
      yield* _mapChangeRecipeCalendarView(event);
    }
  }

  Stream<AppState> _mapInitializeDataToState(InitializeData event) async* {
    prefs ??= await SharedPreferences.getInstance();

    yield LoadedState(
      event.recipeCategoryOverview,
      event.showIntro,
      false,
      false,
      event.showSummary,
      0,
      I18n.of(event.context).recipes,
    );
  }

  Stream<AppState> _mapChangeViewToState(ChangeView event) async* {
    String title;
    switch (event.index) {
      case 0:
        title = I18n.of(event.context).recipes;
        break;
      case 1:
        title = I18n.of(event.context).favorites;
        break;
      case 2:
        title = I18n.of(event.context).shoppingcart;
        break;
      case 3:
        title = I18n.of(event.context).roll_the_dice;
        break;
      case 4:
        title = I18n.of(event.context).settings;
        break;
      default:
        break;
    }

    yield LoadedState(
      (state as LoadedState).recipeCategoryOverview,
      (state as LoadedState).showIntro,
      (state as LoadedState).shoppingCartOpen,
      (state as LoadedState).recipeCalendarOpen,
      (state as LoadedState).showShoppingCartSummary,
      event.index,
      title,
    );
  }

  Stream<AppState> _mapChangeCategoryOverviewToState(
      ChangeCategoryOverview event) async* {
    await prefs.setBool('recipeCatOverview', event.recipeCategoryOverview);

    yield LoadedState(
      event.recipeCategoryOverview,
      false,
      (state as LoadedState).shoppingCartOpen,
      (state as LoadedState).recipeCalendarOpen,
      (state as LoadedState).showShoppingCartSummary,
      (state as LoadedState).selectedIndex,
      (state as LoadedState).title,
    );
  }

  Stream<AppState> _mapChangeShoppingCartView(
      ChangeShoppingCartView event) async* {
    yield LoadedState(
      (state as LoadedState).recipeCategoryOverview,
      (state as LoadedState).showIntro,
      event.open,
      (state as LoadedState).recipeCalendarOpen,
      (state as LoadedState).showShoppingCartSummary,
      (state as LoadedState).selectedIndex,
      (state as LoadedState).title,
    );
  }

  Stream<AppState> _mapChangeRecipeCalendarView(
      ChangeRecipeCalendarView event) async* {
    yield LoadedState(
      (state as LoadedState).recipeCategoryOverview,
      (state as LoadedState).showIntro,
      (state as LoadedState).shoppingCartOpen,
      event.open,
      (state as LoadedState).showShoppingCartSummary,
      (state as LoadedState).selectedIndex,
      (state as LoadedState).title,
    );
  }

  Stream<AppState> _mapShoppingCartShowSummaryToState(
      ShoppingCartShowSummary event) async* {
    await prefs.setBool("shoppingCartSummary", event.showSummary);

    yield LoadedState(
      (state as LoadedState).recipeCategoryOverview,
      (state as LoadedState).showIntro,
      (state as LoadedState).shoppingCartOpen,
      (state as LoadedState).recipeCalendarOpen,
      event.showSummary,
      (state as LoadedState).selectedIndex,
      (state as LoadedState).title,
    );
  }
}
