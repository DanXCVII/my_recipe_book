import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(LoadingState());

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is InitializeData) {
      yield* _mapLoadingToState(event);
    } else if (event is ChangeView) {
      yield* _mapChangeViewToState(event);
    } else if (event is ChangeCategoryOverview) {
      yield* _mapChangeCategoryOverviewToState(event);
    } else if (event is ChangeShoppingCartView) {
      yield* _mapChangeShoppingCartView(event);
    }
  }

  Stream<AppState> _mapLoadingToState(InitializeData event) async* {
    yield LoadedState(
      event.recipeCategoryOverview,
      event.showIntro,
      false,
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
      event.index,
      title,
    );
  }

  Stream<AppState> _mapChangeCategoryOverviewToState(
      ChangeCategoryOverview event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('recipeCatOverview', event.recipeCategoryOverview);

    yield LoadedState(
      event.recipeCategoryOverview,
      false,
      (state as LoadedState).shoppingCartOpen,
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
      (state as LoadedState).selectedIndex,
      (state as LoadedState).title,
    );
  }
}
