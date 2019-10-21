import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipe_book/intro_screen.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/models/selected_index.dart';
import 'package:my_recipe_book/models/shopping_cart.dart';
import 'package:my_recipe_book/theming.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:hive/hive.dart';

import 'models/recipe.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
}

class SplashScreen extends StatefulWidget {
  final RecipeKeeper rKeeper;
  final MainPageNavigator mainPageNavigator;
  final ShoppingCartKeeper sCKeeper;

  SplashScreen({
    @required this.rKeeper,
    @required this.mainPageNavigator,
    @required this.sCKeeper,
  });

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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _initShoppingListScreen(prefs);
    _initRecipeOverviewScreen(prefs);
    _initTheme(prefs);
    await widget.sCKeeper.initCart();
    await widget.rKeeper.initData();

    // delete cache
    // await getTemporaryDirectory()
    //  ..delete(recursive: true);

    if (prefs.containsKey('showIntro')) {
      onDoneLoading();
    } else {
      prefs.setBool('showIntro', true);
      await initializeFirstStartData();
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage(widget.rKeeper)));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => IntroScreen(),
        ),
      );
    }

    await Hive.openBox<Recipe>('recipes');
    await Hive.openBox<String>('categories');
    await Hive.openBox<List<String>>('ingredientNames');
    await Hive.openBox<CheckableIngredient>('shoppingCart');
  }

  Future<void> initializeFirstStartData() async {
    widget.rKeeper.firstStartInitialize();
  }

  Future<void> clearCache() async {}

  void _initShoppingListScreen(SharedPreferences prefs) {
    if (prefs.containsKey('showFancyShoppingList')) {
      showFancyShoppingList = prefs.getBool('showFancyShoppingList');
    }
    widget.mainPageNavigator.changeFancyShoppingList(showFancyShoppingList);
  }

  void _initRecipeOverviewScreen(SharedPreferences prefs) {
    if (prefs.containsKey('recipeCatOverview')) {
      recipeCatOverview = prefs.getBool('recipeCatOverview');
    }
    widget.mainPageNavigator.initCurrentMainView(recipeCatOverview);
  }

  void _initTheme(SharedPreferences prefs) {
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

  onDoneLoading() async {
    Navigator.of(context).pushReplacement(PageTransition(
        type: PageTransitionType.fade, child: MyHomePage(widget.rKeeper)));
  }
}
