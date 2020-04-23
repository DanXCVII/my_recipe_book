import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipe_book/local_storage/io_operations.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/global_constants.dart' as Constants;
import '../../constants/global_settings.dart';
import '../../local_storage/hive.dart';
import '../../theming.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  bool _recipeCategoryOverview;
  bool _showIntro;

  bool _splashScreenFinished = false;
  bool _initialized = false;

  @override
  SplashScreenState get initialState => InitializingData();

  @override
  Stream<SplashScreenState> mapEventToState(
    SplashScreenEvent event,
  ) async* {
    if (event is SPInitializeData) {
      yield* _mapInitializeDataToState(event);
    } else if (event is SPFinished) {
      yield* _mapSPFinishedToState(event);
    }
  }

  Stream<SplashScreenState> _mapInitializeDataToState(
      SPInitializeData event) async* {
    bool showIntro = false;
    bool recipeCategoryOverview;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    recipeCategoryOverview = _initRecipeOverviewScreen(prefs);
    _initTheme(prefs, event.context);
    Directory tmpDir = await getTemporaryDirectory();
    if (await tmpDir.exists()) {
      await tmpDir.delete(recursive: true);
    }

    // delete cache
    // await getTemporaryDirectory()
    //  ..delete(recursive: true);

    if (!prefs.containsKey('showIntro')) {
      showIntro = true;
      prefs.setBool('showIntro', false);
      prefs.setBool('showStepsIntro', true);
      prefs.setBool(Constants.enableAnimations, true);
      prefs.setBool(Constants.disableStandby, true);
      GlobalSettings().enableAnimations(true);
      await initHive(true);
      await _initializeFirstStartData();
    } else {
      GlobalSettings()
          .enableAnimations(prefs.getBool(Constants.enableAnimations));
      GlobalSettings().hasSeenStepIntro(!prefs.getBool('showStepsIntro'));
      GlobalSettings().disableStandby(prefs.getBool(Constants.disableStandby));
      await initHive(false);
    }

    this._recipeCategoryOverview = recipeCategoryOverview;
    this._showIntro = showIntro;

    _initialized = true;
    if (_splashScreenFinished)
      yield InitializedData(recipeCategoryOverview, showIntro);
  }

  Stream<SplashScreenState> _mapSPFinishedToState(SPFinished event) async* {
    _splashScreenFinished = true;
    if (_initialized) {
      yield InitializedData(_recipeCategoryOverview, _showIntro);
    }
  }

  bool _initRecipeOverviewScreen(SharedPreferences prefs) {
    if (prefs.containsKey('recipeCatOverview')) {
      return prefs.getBool('recipeCatOverview');
    }
    return true;
  }

  void _initTheme(SharedPreferences prefs, BuildContext context) {
    int theme = 2;
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

  Future<void> _initializeFirstStartData() async {
    ByteData data = await rootBundle.load('assets/firstStartRecipes.zip');

    final buffer = data.buffer;
    await Directory((await getTemporaryDirectory()).path)
        .create(recursive: true);
    File recipesFile =
        await File((await getTemporaryDirectory()).path + "/assetRecipes.zip")
            .writeAsBytes(
                buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    Map<String, Recipe> importRecipeData =
        await importRecipesToTmp(recipesFile);
    for (var key in importRecipeData.keys) {
      if (importRecipeData[key] != null) {
        await importRecipeFromTmp(importRecipeData[key]);
        await HiveProvider().saveRecipe(importRecipeData[key]);
      }
    }
  }
}
