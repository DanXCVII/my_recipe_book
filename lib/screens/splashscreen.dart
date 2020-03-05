import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ad_related/ad.dart';
import '../blocs/import_recipe/import_recipe_bloc.dart';
import '../blocs/splash_screen/splash_screen_bloc.dart';
import '../widgets/dialogs/import_dialog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  static const platform = const MethodChannel('app.channel.shared.data');

  @override
  void initState() {
    super.initState();
    initializeIntent();

    // Listen to lifecycle events.
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      initializeIntent();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  initializeIntent() async {
    var importZipFilePath = await getIntentPath();
    if (importZipFilePath == null) {
      BlocProvider.of<SplashScreenBloc>(context).add(CheckForImport(false));
    }
    if (importZipFilePath != null) {
      BlocProvider.of<SplashScreenBloc>(context).add(CheckForImport(true));

      BuildContext importRecipeBlocContext = context;

      showDialog(
        context: context,
        builder: (context) => BlocProvider<ImportRecipeBloc>.value(
            value: BlocProvider.of<ImportRecipeBloc>(importRecipeBlocContext)
              ..add(StartImportRecipes(File(importZipFilePath.toString()),
                  delay: Duration(milliseconds: 300))),
            child: ImportDialog(closeAfterFinished: true)),
      );
    }
  }

  getIntentPath() async {
    var sharedData = await platform.invokeMethod("getSharedText");
    return sharedData == null ? null : sharedData;
  }

  @override
  Widget build(BuildContext context) {
    // Not nice but don't know any alternative yet
    double deviceWidth = MediaQuery.of(context).size.width;
    if (deviceWidth >= 468) {
      Ads.showWideBannerAds();
    }
    return Container(
      color: Colors.amber,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/cookingHat.png',
            fit: BoxFit.cover,
            height: 150,
          ),
        ],
      )),
    );
  }
}
