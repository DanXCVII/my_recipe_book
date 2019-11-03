import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipe_book/intro_screen.dart';
import 'package:my_recipe_book/models/nutrition.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/models/selected_index.dart';
import 'package:my_recipe_book/models/shopping_cart.dart';
import 'package:my_recipe_book/theming.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:hive/hive.dart';

import 'models/enums.dart';
import 'models/ingredient.dart';
import 'models/recipe.dart';
import 'models/shopping_cart_tuple.dart';

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
    _initHive();

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
  }

  Future<void> initializeFirstStartData() async {
    widget.rKeeper.firstStartInitialize();
  }

  Future<void> _initHive() async {
    Hive.init((await getApplicationDocumentsDirectory()).path);
    Hive.registerAdapter(RecipeAdapter(), 0);
    Hive.registerAdapter(IngredientAdapter(), 1);
    Hive.registerAdapter(CheckableIngredientAdapter(), 2);
    Hive.registerAdapter(VegetableAdapter(), 3);
    Hive.registerAdapter(NutritionAdapter(), 4);
    Hive.registerAdapter(RecipeAdapter(), 5);
    Hive.registerAdapter(StringListTupleAdapter(), 6);
    Hive.registerAdapter(RecipeSortAdapter(), 7);

    await Hive.openBox('recipes', lazy: true);
    await Hive.openBox<String>(Vegetable.NON_VEGETARIAN.toString());
    await Hive.openBox<String>(Vegetable.VEGETARIAN.toString());
    await Hive.openBox<String>(Vegetable.VEGAN.toString());
    await Hive.openBox<String>('categories');
    await Hive.openBox<String>('recipeName');

    await Hive.openBox<String>('favorites');
    await Hive.openBox<String>('ingredientNames');

    await Hive.openBox<List<String>>('order');
    await Hive.openBox<List<CheckableIngredient>>('shoppingCart');
    await Hive.openBox<List<String>>('recipeCategories');

    // initializing with the must have values
    if (Hive.box<String>('categories').keys.isEmpty)
      Hive.box<String>('categories').put('no category', 'no category');

    if (Hive.box<String>('recipeName').keys.isEmpty)
      Hive.box<String>('recipeName').put('summary', 'summary');

    if (Hive.box<List<CheckableIngredient>>('shoppingCart').keys.isEmpty)
      Hive.box<List<CheckableIngredient>>('shoppingCart').put('summary', []);

    if (Hive.box<List<String>>('recipeCategories').keys.isEmpty)
      Hive.box<List<String>>('recipeCategories').put('no category', []);

    if (Hive.box<List<String>>('order').keys.isEmpty) {
      Box<List<String>> boxOrder = Hive.box<List<String>>('order');
      boxOrder.put('categories', ['no category']);
      boxOrder.put('nutritions', []);
    }
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
