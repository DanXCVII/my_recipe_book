import 'dart:async';
import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/models/shopping_cart.dart';
import 'package:my_recipe_book/models/selected_index.dart';
import 'package:my_recipe_book/settings/import_recipe.dart';
import 'package:my_recipe_book/shopping_cart/shopping_cart_fancy.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:flutter/rendering.dart';

import 'package:my_recipe_book/SplashScreen.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/random_recipe/random_recipe.dart';
import 'package:my_recipe_book/recipe_overview/category_manager_screen.dart';
import 'package:my_recipe_book/recipe_overview/recipe_category_overview/category_gridview.dart';
import 'package:my_recipe_book/settings/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'dialogs/dialog_types.dart';
import 'dialogs/shopping_cart_add_dialog.dart';
import 'generated/i18n.dart';
import 'models/recipe.dart';
import 'recipe_overview/recipe_category_overview/r_category_overview.dart';
import 'shopping_cart/shopping_cart.dart';
import 'recipe_overview/add_recipe_screen/add_recipe.dart';
import './favortie_screen/favorite_screen.dart';
import './search.dart';
import './theming.dart';

import 'dart:math';

void main() {
  debugPaintSizeEnabled = false;
  runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: MyApp(
        MainPageNavigator(),
        RecipeKeeper(),
        ShoppingCartKeeper(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final MainPageNavigator bottomNavIndex;
  final RecipeKeeper recipeKeeper;
  final ShoppingCartKeeper scKeeper;
  final appTitle = 'Drawer Demo';
  static bool initialized = false;

  MyApp(
    this.bottomNavIndex,
    this.recipeKeeper,
    this.scKeeper,
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScopedModel<ShoppingCartKeeper>(
      model: scKeeper,
      child: ScopedModel<MainPageNavigator>(
        model: bottomNavIndex,
        child: ScopedModel<RecipeKeeper>(
          model: recipeKeeper,
          child: MaterialApp(
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            showPerformanceOverlay: false,
            theme: CustomTheme.of(context),
            initialRoute: '/',
            routes: {
              '/': (context) => SplashScreen(
                    rKeeper: recipeKeeper,
                    mainPageNavigator: bottomNavIndex,
                    sCKeeper: scKeeper,
                  ),
              '/add-recipe': (context) => AddRecipeForm(),
              '/manage-categories': (context) => CategoryManager(),
            },
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final RecipeKeeper rKeeper;

  MyHomePage(this.rKeeper);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Future<SharedPreferences> prefs;

  MyHomePageState({
    Key key,
    String title,
  });

  AnimationController _controller;
  static const List<IconData> icons = const [
    GroovinMaterialIcons.grid_large,
    Icons.description,
  ];

  @override
  void initState() {
    super.initState();
    prefs = SharedPreferences.getInstance();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    SystemChannels.lifecycle.setMessageHandler((msg) {
      if (msg.contains('resumed')) {
        initializeIntent();
      }
      return;
    });

    // Case 2: App is started by the intent:
    // Call Java MethodHandler on application start up to check for shared data
    initializeIntent();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainPageNavigator>(
        builder: (context, child, mpNavigator) {
      return Scaffold(
        appBar: _buildAppBar(mpNavigator.index, mpNavigator),
        floatingActionButton: _getFloatingB(mpNavigator.index),
        body: IndexedStack(
          index: mpNavigator.index,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: mpNavigator.recipeCatOverview == true
                  ? RecipeCategoryOverview()
                  : CategoryGridView(),
            ),
            FavoriteScreen(),
            mpNavigator.showFancyShoppingList
                ? FancyShoppingCartScreen()
                : ShoppingCartScreen(),
            SwypingCardsScreen(),
            Settings(),
          ],
        ),
        backgroundColor: _getBackgroundColor(mpNavigator.index),
        bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.black87),
            child: BottomNavyBar(
                backgroundColor: Color(0xff232323),
                animationDuration: Duration(milliseconds: 150),
                selectedIndex: mpNavigator.index,
                showElevation: true,
                onItemSelected: (index) => _onItemTapped(mpNavigator, index),
                items: [
                  BottomNavyBarItem(
                      icon: Icon(GroovinMaterialIcons.notebook),
                      title: Text(S.of(context).recipes),
                      activeColor: Colors.orange,
                      inactiveColor: Colors.white),
                  BottomNavyBarItem(
                    icon: Icon(Icons.favorite),
                    title: Text(S.of(context).favorites),
                    activeColor: Colors.pink,
                    inactiveColor: Colors.white,
                  ),
                  BottomNavyBarItem(
                      icon: Icon(Icons.shopping_basket),
                      title: Text(S.of(context).basket),
                      activeColor: Colors.brown[300],
                      inactiveColor: Colors.white),
                  BottomNavyBarItem(
                    icon: Icon(GroovinMaterialIcons.dice_multiple),
                    title: Text(S.of(context).explore),
                    activeColor: Colors.green,
                    inactiveColor: Colors.white,
                  ),
                  BottomNavyBarItem(
                      icon: Icon(Icons.settings),
                      title: Text(S.of(context).settings),
                      activeColor: Colors.grey[100],
                      inactiveColor: Colors.white)
                ])

            // child: BottomNavigationBar(
            //   fixedColor: Colors.white,
            //   items: <BottomNavigationBarItem>[
            //     BottomNavigationBarItem(
            //         icon: Icon(
            //           GroovinMaterialIcons.notebook,
            //           color: mpNavigator.index == 0
            //               ? Colors.brown[400]
            //               : Colors.white,
            //         ),
            //         title: Text("recipes")),
            //     BottomNavigationBarItem(
            //         icon: mpNavigator.index == 1
            //             ? Icon(Icons.favorite, color: Colors.pink)
            //             : Icon(Icons.favorite_border),
            //         title: Text("favorites")),
            //     BottomNavigationBarItem(
            //         icon: Icon(Icons.shopping_cart,
            //             color:
            //                 mpNavigator.index == 2 ? Colors.grey : Colors.white),
            //         title: Text("shopping cart")),
            //     BottomNavigationBarItem(
            //         icon: Icon(GroovinMaterialIcons.dice_multiple,
            //             color:
            //                 mpNavigator.index == 3 ? Colors.green : Colors.white),
            //         title: Text("feelin' lucky?!")),
            //     BottomNavigationBarItem(
            //         icon: Icon(Icons.settings,
            //             color:
            //                 mpNavigator.index == 4 ? Colors.grey : Colors.white),
            //         title: Text("settings"))
            //   ],
            //   currentIndex: mpNavigator.index,
            //   onTap: (index) {
            //     _onItemTapped(mpNavigator, index);
            //   },
            // ),
            ),
      );
    });
  }

  initializeIntent() async {
    var importZipPath = await getIntentPath();
    if (importZipPath != null) {
      showDialog(
          context: context,
          builder: (_) => getImportRecipeDialog(importZipPath, widget.rKeeper));
    }
  }

  static const platform = const MethodChannel('app.channel.shared.data');

  getIntentPath() async {
    var sharedData = await platform.invokeMethod("getSharedText");
    return sharedData == null ? null : sharedData;
  }

  Widget getImportRecipeDialog(String importPath, RecipeKeeper rKeeper) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text("import recipe"),
      content: Text(
        'Do you want to import the recipe/s?',
      ),
      actions: <Widget>[
        FlatButton(
            child: Text("no"),
            onPressed: () {
              Navigator.pop(context);
            }),
        FlatButton(
          child: Text("yes"),
          onPressed: () {
            importSingleMultipleRecipes(rKeeper, File(importPath), context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  AppBar _buildAppBar(int selectedIndex, MainPageNavigator mpNavigator) {
    // if shoppingCartPage with sliverAppBar
    String title;
    switch (selectedIndex) {
      case 0:
        title = S.of(context).recipes;
        break;
      case 1:
        title = S.of(context).favorites;
        break;
      case 2:
        title = S.of(context).shoppingcart;
        break;
      case 3:
        title = S.of(context).roll_the_dice;
        break;
      case 4:
        title = S.of(context).settings;
        break;
      default:
        break;
    }
    if (mpNavigator.index == 2 && mpNavigator.showFancyShoppingList) {
      return null;
    }
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        mpNavigator.index == 0
            ? IconButton(
                icon: Icon(mpNavigator.recipeCatOverview
                    ? Icons.grid_off
                    : Icons.grid_on),
                onPressed: () {
                  _changeMainPageOverview(mpNavigator);
                },
              )
            : null,
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            DBProvider.db.getRecipeNames().then((recipeNames) {
              showSearch(context: context, delegate: RecipeSearch(recipeNames));
            });
          },
        ),
        ScopedModelDescendant<ShoppingCartKeeper>(
            builder: (context, child, model) => IconButton(
                  icon: Icon(Icons.adb),
                  onPressed: () {
                    model.addMulitpleIngredientsToCart('Zutat', [
                      Ingredient(name: 'Zutat', amount: 1, unit: 'g'),
                      Ingredient(name: 'Zutat2', amount: 2, unit: 'h')
                    ]);
                  },
                ))
      ].where((child) => child != null).toList(),
    );
  }

  void _changeMainPageOverview(MainPageNavigator mpNavigator) {
    prefs.then((prefs) {
      if (mpNavigator.recipeCatOverview == true) {
        prefs.setBool('recipeCatOverview', false).then((_) {
          mpNavigator.changeCurrentMainView(false);
        });
      } else {
        prefs.setBool('recipeCatOverview', true).then((_) {
          mpNavigator.changeCurrentMainView(true);
        });
      }
    });
  }

  Widget _getFloatingB(int selectedIndex) {
    Color backgroundColor = Theme.of(context).primaryColor;
    //  Color foregroundColor = Theme.of(context).accentColor;
    if (selectedIndex == 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(icons.length, (int index) {
          Widget child = Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _controller,
                curve: Interval(0.0, 1.0 - index / icons.length / 2.0,
                    curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.white,
                mini: true,
                child: Icon(icons[index], color: backgroundColor),
                onPressed: () {
                  _controller.reverse();
                  index == 1
                      ? Navigator.pushNamed(context, '/add-recipe')
                      : Navigator.pushNamed(context, '/manage-categories');
                },
              ),
            ),
          );
          return child;
        }).toList()
          ..add(
            FloatingActionButton(
              backgroundColor: backgroundColor,
              heroTag: null,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                    transform: Matrix4.rotationZ(_controller.value * 0.5 * pi),
                    alignment: FractionalOffset.center,
                    child: Icon(
                      _controller.isDismissed ? Icons.add : Icons.close,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
            ),
          ),
      );
    }
    return null;
  }

  Color _getBackgroundColor(int selectedIndex) {
    if (selectedIndex == 0) {
      return Theme.of(context).scaffoldBackgroundColor;
    } else if (selectedIndex == 1) {
      // if bright theme
      if (Theme.of(context).backgroundColor == Colors.white) {
        return Color(0xffFFCDEB);
      } // if dark theme
      else if (Theme.of(context).backgroundColor == Color(0xff212225)) {
        return Color(0xff58153D);
      } // if oledBlack theme
      else {
        return Color(0xff43112F);
      }
    } else if (selectedIndex == 2) {
      return Theme.of(context).scaffoldBackgroundColor;
    }
    return Theme.of(context).scaffoldBackgroundColor;
  }

  void _onItemTapped(MainPageNavigator mainPageNavigator, int index) {
    mainPageNavigator.changeIndex(index);
  }
}
