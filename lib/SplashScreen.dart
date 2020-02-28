import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ad_related/ad.dart';
import 'local_storage/hive.dart';
import 'screens/intro_screen.dart';
import 'theming.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  bool recipeCatOverview = true;
  bool showFancyShoppingList = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
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

  Future<void> loadData() async {
    await initHive(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Ads.initialize(MediaQuery.of(context).size.width >= 468 ? true : false);
    _initRecipeOverviewScreen(prefs);
    _initTheme(prefs);

    // delete cache
    // await getTemporaryDirectory()
    //  ..delete(recursive: true);

    if (prefs.containsKey('showIntro')) {
      onDoneLoading();
    } else {
      prefs.setBool('showIntro', true);
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      Navigator.of(context).pushReplacementNamed("/");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => IntroScreen(),
        ),
      );
    }
  }

  Future<void> clearCache() async {}

  void _initRecipeOverviewScreen(SharedPreferences prefs) {
    if (prefs.containsKey('recipeCatOverview')) {
      recipeCatOverview = prefs.getBool('recipeCatOverview');
    }
  }

  void _initTheme(SharedPreferences prefs) {
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

  onDoneLoading() async {
    Navigator.of(context).pushReplacementNamed("/");
  }
}
