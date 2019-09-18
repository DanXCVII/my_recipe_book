import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipe_book/intro_screen.dart';
import 'package:my_recipe_book/models/random_recipe.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/models/selected_index.dart';
import 'package:my_recipe_book/models/shopping_cart.dart';
import 'package:my_recipe_book/theming.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  final RecipeKeeper recipeKeeper;
  final MainPageNavigator mainPageNavigator;
  final ShoppingCartKeeper sCKeeper;
  final RandomRecipeKeeper rrKeeper;

  SplashScreen({
    @required this.recipeKeeper,
    @required this.mainPageNavigator,
    @required this.sCKeeper,
    @required this.rrKeeper,
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
    await widget.recipeKeeper.initData();
    await widget.rrKeeper.initRecipes();

    if (prefs.containsKey('showIntro')) {
      onDoneLoading();
    } else {
      prefs.setBool('showIntro', true);
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => IntroScreen(
                recipeCatOverview: recipeCatOverview,
                showFancyShoppingList: showFancyShoppingList,
                onDonePop: false,
              )));
    }
  }

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
    Navigator.of(context).pushReplacement(
        PageTransition(type: PageTransitionType.fade, child: MyHomePage()));
  }
}
