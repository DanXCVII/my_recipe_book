import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:my_recipe_book/models/random_recipe.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/models/shopping_cart.dart';
import 'package:my_recipe_book/models/selected_index.dart';
import 'package:my_recipe_book/recipe.dart';
import 'package:my_recipe_book/shopping_cart/shopping_cart_fancy.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:my_recipe_book/SplashScreen.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/random_recipe/random_recipe.dart';
import 'package:my_recipe_book/recipe_overview/category_manager_screen.dart';
import 'package:my_recipe_book/recipe_overview/recipe_category_overview/category_gridview.dart';
import 'package:my_recipe_book/settings/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'recipe_overview/recipe_category_overview/r_category_overview.dart';
import 'shopping_cart/shopping_cart.dart';
import 'recipe_overview/add_recipe_screen/add_recipe.dart';
import './favortie_screen/favorite_screen.dart';
import './search.dart';
import './theming.dart';

import 'package:flutter/rendering.dart';
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
        RandomRecipeKeeper(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final MainPageNavigator bottomNavIndex;
  final RecipeKeeper recipeKeeper;
  final ShoppingCartKeeper scKeeper;
  final RandomRecipeKeeper rrKeeper;
  final appTitle = 'Drawer Demo';

  MyApp(
    this.bottomNavIndex,
    this.recipeKeeper,
    this.scKeeper,
    this.rrKeeper,
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScopedModel<ShoppingCartKeeper>(
      model: scKeeper,
      child: ScopedModel<RandomRecipeKeeper>(
        model: rrKeeper,
        child: ScopedModel<MainPageNavigator>(
          model: bottomNavIndex,
          child: ScopedModel<RecipeKeeper>(
            model: recipeKeeper,
            child: MaterialApp(
              theme: CustomTheme.of(context),
              initialRoute: '/',
              routes: {
                '/': (context) => SplashScreen(
                      recipeKeeper: recipeKeeper,
                      mainPageNavigator: bottomNavIndex,
                      sCKeeper: scKeeper,
                      rrKeeper: rrKeeper,
                    ),
                '/add-recipe': (context) => AddRecipeForm(),
                '/manage-categories': (context) => CategoryManager(),
              },
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

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
    Icons.grid_on,
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainPageNavigator>(
        builder: (context, child, model) {
      return Scaffold(
        appBar: _buildAppBar(model.title, model),
        floatingActionButton: _getFloatingB(model.title),
        body: IndexedStack(
          index: model.index,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: model.recipeCatOverview == true
                  ? RecipeCategoryOverview()
                  : CategoryGridView(),
            ),
            FavoriteScreen(),
            model.showFancyShoppingList
                ? FancyShoppingCartScreen()
                : ShoppingCartScreen(),
            RandomRecipe(),
            Settings(),
          ],
        ),
        backgroundColor: _getBackgroundColor(model.title),
        bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.black87),
            child: BottomNavyBar(
                backgroundColor: Color(0xff232323),
                animationDuration: Duration(milliseconds: 150),
                selectedIndex: model.index,
                showElevation: true,
                onItemSelected: (index) => _onItemTapped(model, index),
                items: [
                  BottomNavyBarItem(
                      icon: Icon(GroovinMaterialIcons.notebook),
                      title: Text('recipes'),
                      activeColor: Colors.orange,
                      inactiveColor: Colors.white),
                  BottomNavyBarItem(
                    icon: Icon(Icons.favorite),
                    title: Text('favorites'),
                    activeColor: Colors.pink,
                    inactiveColor: Colors.white,
                  ),
                  BottomNavyBarItem(
                      icon: Icon(Icons.shopping_basket),
                      title: Text('basket'),
                      activeColor: Colors.brown[300],
                      inactiveColor: Colors.white),
                  BottomNavyBarItem(
                    icon: Icon(GroovinMaterialIcons.dice_multiple),
                    title: Text('explore'),
                    activeColor: Colors.green,
                    inactiveColor: Colors.white,
                  ),
                  BottomNavyBarItem(
                      icon: Icon(Icons.settings),
                      title: Text('settings'),
                      activeColor: Colors.grey[100],
                      inactiveColor: Colors.white)
                ])

            // BottomNavigationBar(
            //   fixedColor: Colors.white,
            //   items: <BottomNavigationBarItem>[
            //     BottomNavigationBarItem(
            //         icon: Icon(
            //           GroovinMaterialIcons.notebook,
            //           color: _selectedIndex == 0 ? Colors.brown[400] : Colors.white,
            //         ),
            //         title: Text("recipes")),
            //     BottomNavigationBarItem(
            //         icon: _selectedIndex == 1
            //             ? Icon(Icons.favorite, color: Colors.pink)
            //             : Icon(Icons.favorite_border),
            //         title: Text("favorites")),
            //     BottomNavigationBarItem(
            //         icon: Icon(Icons.shopping_cart,
            //             color: _selectedIndex == 2 ? Colors.grey : Colors.white),
            //         title: Text("shopping cart")),
            //     BottomNavigationBarItem(
            //         icon: Icon(GroovinMaterialIcons.dice_multiple,
            //             color: _selectedIndex == 3 ? Colors.green : Colors.white),
            //         title: Text("feelin' lucky?!")),
            //     BottomNavigationBarItem(
            //         icon: Icon(Icons.settings,
            //             color: _selectedIndex == 4 ? Colors.grey : Colors.white),
            //         title: Text("settings"))
            //   ],
            //   currentIndex: _selectedIndex,
            //   onTap: _onItemTapped,
            // ),
            ),
      );
    });
  }

  AppBar _buildAppBar(String title, MainPageNavigator mpNavigator) {
    // if shoppingCartPage with sliverAppBar
    if (mpNavigator.index == 2 && mpNavigator.showFancyShoppingList) {
      return null;
    }
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        mpNavigator.index == 0
            ? IconButton(
                icon: Icon(GroovinMaterialIcons.grid_large),
                onPressed: () {
                  _changeMainPageOverview(mpNavigator);
                },
              )
            : null,
        mpNavigator.index != 3
            ? IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  DBProvider.db.getRecipeNames().then((recipeNames) {
                    showSearch(
                        context: context, delegate: RecipeSearch(recipeNames));
                  });
                },
              )
            : null,
        ScopedModelDescendant<ShoppingCartKeeper>(
            builder: (context, child, model) => IconButton(
                  icon: Icon(Icons.adb),
                  onPressed: () {
                    print('****************************');
                    model.addMulitpleIngredientsToCart('Zutat', [
                      Ingredient(name: 'Zutat', amount: 1, unit: 'g'),
                      Ingredient(name: 'Zutat2', amount: 2, unit: 'h')
                    ]);

                    // var r = Recipe(
                    //   id: 1,
                    //   name: 'Steack mit Bratsauce',
                    //   imagePath: 'imagePath',
                    //   imagePreviewPath: 'imagePreviewPath',
                    //   servings: 3,
                    //   ingredientsGlossary: ['Steacksauce', 'Steack'],
                    //   ingredients: [
                    //     [
                    //       Ingredient(name: 'Rosmarin', amount: 5, unit: 'Zweige'),
                    //       Ingredient(name: 'Mehl', amount: 300, unit: 'g'),
                    //       Ingredient(name: 'Curry', amount: 1, unit: 'EL'),
                    //       Ingredient(name: 'Gewürze', amount: 3, unit: 'Priesen')
                    //     ],
                    //     [
                    //       Ingredient(name: 'Rohrzucker', amount: 50, unit: 'g'),
                    //       Ingredient(name: 'Steak', amount: 700, unit: 'g')
                    //     ],
                    //   ],
                    //   complexity: 4,
                    //   vegetable: Vegetable.NON_VEGETARIAN,
                    //   steps: [
                    //     'step1',
                    //     'step2 kek',
                    //   ],
                    //   stepImages: [
                    //     [], [],
                    //     // ['/storage/emulated/0/Download/recipeData/meat1.jpg'],
                    //     // [
                    //     //   '/storage/emulated/0/Download/recipeData/meat2.jpg',
                    //     // ],
                    //   ],
                    //   notes: 'Steak gegen die Faser in feine Tranchen schneiden.',
                    //   isFavorite: false,
                    //   categories: ['Hauptspeisen'],
                    // ); 
                    // var json = r.toMap();
                    // Recipe rrr = Recipe.fromMap(json);
                    // print(rrr.toString());
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

  Widget _getFloatingB(String page) {
    Color backgroundColor = Theme.of(context).primaryColor;
    //  Color foregroundColor = Theme.of(context).accentColor;
    if (page == 'recipes') {
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

  Color _getBackgroundColor(String page) {
    if (page == 'recipes') {
      return Theme.of(context).scaffoldBackgroundColor;
    } else if (page == 'favorites') {
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
    } else if (page == 'shopping cart') {
      return Theme.of(context).backgroundColor;
    } else if (page == 'roll the dice') {
      return Theme.of(context).backgroundColor;
    }
    return Theme.of(context).scaffoldBackgroundColor;
  }

  void _onItemTapped(MainPageNavigator mainPageNavigator, int index) {
    mainPageNavigator.changeIndex(index);
  }
}
