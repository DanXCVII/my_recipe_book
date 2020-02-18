import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './app.dart';
import '../../generated/i18n.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  @override
  AppState get initialState => LoadingState();

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
    }
  }

  Stream<AppState> _mapLoadingToState(InitializeData event) async* {
    yield LoadedState(event.recipeCategoryOverview, event.showIntro, 0,
        I18n.of(event.context).recipes);
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
      (state as LoadedState).selectedIndex,
      (state as LoadedState).title,
    );
  }
}
