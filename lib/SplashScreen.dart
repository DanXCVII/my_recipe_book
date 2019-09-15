import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipe_book/intro_screen.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/models/selected_index.dart';
import 'package:my_recipe_book/models/shopping_cart.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  final RecipeKeeper recipeKeeper;
  final MainPageNavigator
      mainPageNavigator; // TODO: change currentMainView to bool and not Widget..
  final ShoppingCartKeeper sCKeeper;

  SplashScreen({
    this.recipeKeeper,
    this.mainPageNavigator,
    this.sCKeeper,
  });

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  bool recipeCatOverview;

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
    if (prefs.containsKey('recipeCatOverview')) {
      recipeCatOverview = prefs.getBool('recipeCatOverview');
    } else {
      recipeCatOverview = true;
    }

    await widget.sCKeeper.initCart();
    await widget.recipeKeeper.initData();
    
    if (prefs.containsKey('showIntro')) {
      onDoneLoading();
    } else {
      prefs.setBool('showIntro', true);
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => IntroScreen(recipeCatOverview)));
    }
  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacement(PageTransition(
        type: PageTransitionType.fade, child: MyHomePage(recipeCatOverview)));
  }
}
