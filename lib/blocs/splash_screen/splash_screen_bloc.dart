import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/theming.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../hive.dart';
import './splash_screen.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  @override
  SplashScreenState get initialState => InitializingData();

  @override
  Stream<SplashScreenState> mapEventToState(
    SplashScreenEvent event,
  ) async* {
    if (event is SPInitializeData) {
      yield* _mapInitializeDataToState(event);
    }
  }

  Stream<SplashScreenState> _mapInitializeDataToState(
      SPInitializeData event) async* {
    bool showIntro = false;
    bool recipeCategoryOverview;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    recipeCategoryOverview = _initRecipeOverviewScreen(prefs);
    _initTheme(prefs, event.context);

    // delete cache
    // await getTemporaryDirectory()
    //  ..delete(recursive: true);

    if (!prefs.containsKey('showIntro')) {
      showIntro = true;
      prefs.setBool('showIntro', true);
      await _initializeFirstStartData();
      await initHive(true);
    } else {
      await initHive(false);
    }

    yield InitializedData(recipeCategoryOverview, showIntro);
  }

  bool _initRecipeOverviewScreen(SharedPreferences prefs) {
    if (prefs.containsKey('recipeCatOverview')) {
      return prefs.getBool('recipeCatOverview');
    }
    return true;
  }

  void _initTheme(SharedPreferences prefs, BuildContext context) {
    int theme = 0;
    if (prefs.containsKey('theme')) {
      theme = prefs.getInt('theme');
    }
    switch (theme) {
      case 0:
        var brightness = MediaQuery.of(context).platformBrightness;
        if (brightness == Brightness.dark)
          CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.DARK);
        else
          CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.LIGHT);
        return;
      case 1:
        CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.LIGHT);
        return;
      case 2:
        CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.DARK);
        return;
      case 3:
        CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.OLEDBLACK);
        return;
      default:
    }
  }

  Future<void> _initializeFirstStartData() {
    // TODO: Add some nutritions whatever
  }
}
