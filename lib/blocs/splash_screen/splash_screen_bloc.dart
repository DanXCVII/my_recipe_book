import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ad_related/ad.dart';
import '../../constants/global_constants.dart' as Constants;
import '../../constants/global_settings.dart';

import 'package:my_recipe_book/generated/l10n.dart';

import '../../local_storage/local_repository.dart';
import '../../local_storage/storage_migration.dart';
import '../../local_storage/io_operations.dart' as IO;
import '../../models/recipe.dart';
import '../../theming.dart';
import '../ad_manager/ad_manager_bloc.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  bool? _recipeCategoryOverview;
  bool? _showIntro;
  bool? _showShoppingCartSummary = false;
  bool _splashScreenFinished = false;
  bool _initialized = false;
  int _migrationWarningCount = 0;
  final StorageMigrationCoordinator migrationCoordinator;
  LocalRepository get repository => migrationCoordinator.repository;

  SplashScreenBloc(this.migrationCoordinator) : super(InitializingData()) {
    Future<void> initialize(
      BuildContext context,
      Emitter<SplashScreenState> emit,
    ) async {
      print("started initialization");
      bool showIntro = false;
      bool? recipeCategoryOverview;

      SharedPreferences prefs = await SharedPreferences.getInstance();

      // check if showSummary for shoppingCart
      if (prefs.containsKey("shoppingCartSummary")) {
        _showShoppingCartSummary = prefs.getBool("shoppingCartSummary");
      } else {
        await prefs.setBool("shoppingCartSummary", _showShoppingCartSummary!);
      }
      // check if showSummary for shoppingCart
      if (!prefs.containsKey(Constants.showDecimal)) {
        await prefs.setBool(Constants.showDecimal, _showShoppingCartSummary!);
      }

      recipeCategoryOverview = _initRecipeOverviewScreen(prefs);
      _initTheme(prefs, context);
      await _initAds();

      await IO.clearCache();

      // delete cache
      // await getTemporaryDirectory()
      //  ..delete(recursive: true);

      final firstPreferenceLaunch = !prefs.containsKey('showIntro');
      if (firstPreferenceLaunch) {
        showIntro = true;
        GlobalSettings().thisIsFirstStart(true);
        await prefs.setBool('shoppingCartSummary', false);
        await prefs.setBool('showIntro', false);
        await prefs.setBool('showStepsIntro', true);
        await prefs.setBool(Constants.enableAnimations, true);
        await prefs.setBool(Constants.disableStandby, true);
        GlobalSettings().enableAnimations(true);
      } else {
        GlobalSettings().enableAnimations(
          prefs.getBool(Constants.enableAnimations)!,
        );
        GlobalSettings().hasSeenStepIntro(!prefs.getBool('showStepsIntro')!);
        GlobalSettings().disableStandby(
          prefs.getBool(Constants.disableStandby)!,
        );
        GlobalSettings().shouldShowDecimal(
          prefs.getBool(Constants.showDecimal)!,
        );
      }

      try {
        final migration = await migrationCoordinator.initialize(
          onProgress: (progress) => emit(MigratingData(progress)),
        );
        _migrationWarningCount = migration.skippedEntries;
        await prefs.setInt(
          'storageMigrationWarningCount',
          _migrationWarningCount,
        );
        if (migration.isFreshInstall) {
          await _initializeFirstStartData(context);
          await migrationCoordinator.repository.markFreshSeedComplete();
        }
      } on StorageMigrationException catch (error) {
        emit(StorageMigrationFailed(error.code));
        return;
      }
      if (!prefs.containsKey('pro_version')) {
        await prefs.setBool('pro_version', false);
      }
      // TODO: getPermission
      // Map<PermissionGroup, PermissionStatus> permissions =
      //     await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      await IO.updateBackup(repository);

      if (prefs.getBool('pro_version') == true ||
          BlocProvider.of<AdManagerBloc>(context).state is IsPurchased) {
        Ads.initialize(false);
      } else {
        try {
          final result = await InternetAddress.lookup('example.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            Ads.initialize(true, personalized: false);
            Ads.adHeight = MediaQuery.of(context).size.width > 480 ? 60 : 50;
          }
        } on SocketException catch (_) {
          Ads.initialize(true, personalized: false);
          Ads.adHeight = MediaQuery.of(context).size.width > 480 ? 60 : 50;
        }
      }

      this._recipeCategoryOverview = recipeCategoryOverview;
      this._showIntro = showIntro;

      _initialized = true;

      print("finished initialization");
      if (_splashScreenFinished)
        emit(
          InitializedData(
            recipeCategoryOverview,
            _showShoppingCartSummary,
            showIntro,
            _migrationWarningCount,
          ),
        );
    }

    on<SPInitializeData>((event, emit) => initialize(event.context, emit));
    on<SPRetryMigration>((event, emit) => initialize(event.context, emit));

    on<SPFinished>((event, emit) async {
      _splashScreenFinished = true;
      if (_initialized) {
        emit(
          InitializedData(
            _recipeCategoryOverview,
            _showShoppingCartSummary,
            _showIntro,
            _migrationWarningCount,
          ),
        );
      }
    });
  }

  bool? _initRecipeOverviewScreen(SharedPreferences prefs) {
    if (prefs.containsKey('recipeCatOverview')) {
      return prefs.getBool('recipeCatOverview');
    }
    return true;
  }

  Future<void> _initAds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('noAdsUntil')) {
      String noAdsUntil = (DateTime.now().subtract(Duration(days: 1000)))
          .toString();
      await prefs.setString('noAdsUntil', noAdsUntil);
    }
  }

  void _initTheme(SharedPreferences prefs, BuildContext context) {
    int? theme = 2;
    if (prefs.containsKey('theme')) {
      theme = prefs.getInt('theme');
    }
    switch (theme) {
      case 0:
        var brightness = MediaQuery.of(context).platformBrightness;
        if (brightness == Brightness.dark)
          CustomTheme.instanceOf(context)!.changeTheme(MyThemeKeys.DARK);
        else
          CustomTheme.instanceOf(context)!.changeTheme(MyThemeKeys.LIGHT);
        return;
      case 1:
        CustomTheme.instanceOf(context)!.changeTheme(MyThemeKeys.LIGHT);
        return;
      case 2:
        CustomTheme.instanceOf(context)!.changeTheme(MyThemeKeys.DARK);
        return;
      case 3:
        CustomTheme.instanceOf(context)!.changeTheme(MyThemeKeys.OLEDBLACK);
        return;
      default:
    }
  }

  Future<void> _initializeFirstStartData(BuildContext context) async {
    ByteData data = await rootBundle.load('assets/firstStartRecipes.zip');

    final buffer = data.buffer;
    await Directory((await getTemporaryDirectory()).path)
        .create(recursive: true);
    File recipesFile = await File(
      (await getTemporaryDirectory()).path + "/assetRecipes.zip",
    ).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    List<Recipe> importRecipeData = await IO.importFirstStartRecipes(
      recipesFile,
      S.of(context).two_char_locale,
    );
    for (Recipe r in importRecipeData) {
      await repository.saveRecipe(r);
    }
  }
}
