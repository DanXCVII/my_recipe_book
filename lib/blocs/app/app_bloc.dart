import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  SharedPreferences? prefs;
  AppBloc() : super(LoadingState()) {
    on<InitializeData>((event, emit) async {
      prefs ??= await SharedPreferences.getInstance();

      emit(LoadedState(
        event.recipeCategoryOverview,
        event.showIntro,
        false,
        false,
        event.showSummary,
        0,
        I18n.of(event.context)!.recipes,
      ));
    });

    on<ChangeView>((event, emit) async {
      late String title;
      switch (event.index) {
        case 0:
          title = I18n.of(event.context)!.recipes;
          break;
        case 1:
          title = I18n.of(event.context)!.favorites;
          break;
        case 2:
          title = I18n.of(event.context)!.shoppingcart;
          break;
        case 3:
          title = I18n.of(event.context)!.roll_the_dice;
          break;
        case 4:
          title = I18n.of(event.context)!.settings;
          break;
        default:
          break;
      }

      emit(LoadedState(
        (state as LoadedState).recipeCategoryOverview,
        (state as LoadedState).showIntro,
        (state as LoadedState).shoppingCartOpen,
        (state as LoadedState).recipeCalendarOpen,
        (state as LoadedState).showShoppingCartSummary,
        event.index,
        title,
      ));
    });

    on<ChangeCategoryOverview>((event, emit) async {
      await prefs!.setBool('recipeCatOverview', event.recipeCategoryOverview);

      emit(LoadedState(
        event.recipeCategoryOverview,
        false,
        (state as LoadedState).shoppingCartOpen,
        (state as LoadedState).recipeCalendarOpen,
        (state as LoadedState).showShoppingCartSummary,
        (state as LoadedState).selectedIndex,
        (state as LoadedState).title,
      ));
    });

    on<ChangeShoppingCartView>((event, emit) async {
      emit(LoadedState(
        (state as LoadedState).recipeCategoryOverview,
        (state as LoadedState).showIntro,
        event.open,
        (state as LoadedState).recipeCalendarOpen,
        (state as LoadedState).showShoppingCartSummary,
        (state as LoadedState).selectedIndex,
        (state as LoadedState).title,
      ));
    });

    on<ShoppingCartShowSummary>((event, emit) async {
      await prefs!.setBool("shoppingCartSummary", event.showSummary);

      emit(LoadedState(
        (state as LoadedState).recipeCategoryOverview,
        (state as LoadedState).showIntro,
        (state as LoadedState).shoppingCartOpen,
        (state as LoadedState).recipeCalendarOpen,
        event.showSummary,
        (state as LoadedState).selectedIndex,
        (state as LoadedState).title,
      ));
    });

    on<ChangeRecipeCalendarView>((event, emit) async {
      emit(LoadedState(
        (state as LoadedState).recipeCategoryOverview,
        (state as LoadedState).showIntro,
        (state as LoadedState).shoppingCartOpen,
        event.open,
        (state as LoadedState).showShoppingCartSummary,
        (state as LoadedState).selectedIndex,
        (state as LoadedState).title,
      ));
    });
  }
}
