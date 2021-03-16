import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';
import 'package:my_recipe_book/blocs/ad_manager/ad_manager_bloc.dart';
import 'package:my_recipe_book/local_storage/io_operations.dart' as IO;
import 'package:my_recipe_book/models/recipe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ad_related/ad.dart';
import '../../constants/global_constants.dart' as Constants;
import '../../constants/global_settings.dart';
import '../../generated/i18n.dart';
import '../../local_storage/hive.dart';
import '../../theming.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  bool _recipeCategoryOverview;
  bool _showIntro;
  bool _showShoppingCartSummary = false;
  bool _splashScreenFinished = false;
  bool _initialized = false;

  SplashScreenBloc() : super(InitializingData());

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
    print("started initialization");
    bool showIntro = false;
    bool recipeCategoryOverview;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // check if showSummary for shoppingCart
    if (prefs.containsKey("shoppingCartSummary")) {
      _showShoppingCartSummary = prefs.getBool("shoppingCartSummary");
    } else {
      await prefs.setBool("shoppingCartSummary", _showShoppingCartSummary);
    }
    // check if showSummary for shoppingCart
    if (!prefs.containsKey(Constants.showDecimal)) {
      await prefs.setBool(Constants.showDecimal, _showShoppingCartSummary);
    }

    recipeCategoryOverview = _initRecipeOverviewScreen(prefs);
    _initTheme(prefs, event.context);
    await _initAds();

    await IO.clearCache();

    // delete cache
    // await getTemporaryDirectory()
    //  ..delete(recursive: true);

    if (!prefs.containsKey('showIntro')) {
      showIntro = true;
      GlobalSettings().thisIsFirstStart(true);
      await prefs.setBool('shoppingCartSummary', false);
      await prefs.setBool('showIntro', false);
      await prefs.setBool('showStepsIntro', true);
      await prefs.setBool(Constants.enableAnimations, true);
      await prefs.setBool(Constants.disableStandby, true);
      GlobalSettings().enableAnimations(true);
      await initHive(true);
      await prefs.setBool('pro_version', false);
      await _initializeFirstStartData(event.context);
    } else {
      GlobalSettings()
          .enableAnimations(prefs.getBool(Constants.enableAnimations));
      GlobalSettings().hasSeenStepIntro(!prefs.getBool('showStepsIntro'));
      GlobalSettings().disableStandby(prefs.getBool(Constants.disableStandby));
      GlobalSettings().shouldShowDecimal(prefs.getBool(Constants.showDecimal));
      await initHive(false);
    }
    // TODO: getPermission
    // Map<PermissionGroup, PermissionStatus> permissions =
    //     await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    await IO.updateBackup();

    if (prefs.getBool('pro_version') == true ||
        BlocProvider.of<AdManagerBloc>(event.context).state is IsPurchased) {
      Ads.initialize(false);
    } else {
      await GdprDialog.instance
          .showDialog(
        'pub-7711778152436774',
        'https://sites.google.com/view/my-recipebook-privacy-policy',
        // isForTest: true,
        testDeviceId: '',
      )
          .then((onValue) {
        Ads.initialize(true, personalized: onValue);
        Ads.adHeight = MediaQuery.of(event.context).size.width > 480 ? 60 : 50;
      });
    }

    this._recipeCategoryOverview = recipeCategoryOverview;
    this._showIntro = showIntro;

    _initialized = true;

    print("finished initialization");
    if (_splashScreenFinished)
      yield InitializedData(
        recipeCategoryOverview,
        _showShoppingCartSummary,
        showIntro,
      );
  }

  Stream<SplashScreenState> _mapSPFinishedToState(SPFinished event) async* {
    _splashScreenFinished = true;
    if (_initialized) {
      yield InitializedData(
        _recipeCategoryOverview,
        _showShoppingCartSummary,
        _showIntro,
      );
    }
  }

  bool _initRecipeOverviewScreen(SharedPreferences prefs) {
    if (prefs.containsKey('recipeCatOverview')) {
      return prefs.getBool('recipeCatOverview');
    }
    return true;
  }

  Future<void> _initAds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('noAdsUntil')) {
      String noAdsUntil =
          (DateTime.now().subtract(Duration(days: 1000))).toString();
      await prefs.setString('noAdsUntil', noAdsUntil);
    }
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

  Future<void> _initializeFirstStartData(BuildContext context) async {
    ByteData data = await rootBundle.load('assets/firstStartRecipes.zip');

    final buffer = data.buffer;
    await Directory((await getTemporaryDirectory()).path)
        .create(recursive: true);
    File recipesFile =
        await File((await getTemporaryDirectory()).path + "/assetRecipes.zip")
            .writeAsBytes(
                buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    List<Recipe> importRecipeData = await IO.importFirstStartRecipes(
        recipesFile, I18n.of(context).two_char_locale);
    for (Recipe r in importRecipeData) {
      await HiveProvider().saveRecipe(r);
    }
  }
}
