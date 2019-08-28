import 'package:flutter/material.dart';
import 'package:my_recipe_book/SplashScreen.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/recipe_overview/category_manager_screen.dart';
import 'package:my_recipe_book/recipe_overview/recipe_category_overview/category_gridview.dart';
import 'package:my_recipe_book/settings/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'recipe_overview/recipe_category_overview/r_category_overview.dart';
import 'shopping_cart/shopping_cart.dart';
import 'recipe_overview/add_recipe_screen/add_recipe.dart';
import './favortie_screen/favorite_screen.dart';
import './search.dart';
import './theming.dart';

import 'package:flutter/rendering.dart';
import 'dart:math';

/// TODO: Think about how to change the Appbar and body with using a
/// StateLess widget for better performance maybe. One way of doing
/// it would be to make a custom stateful widget which builds an
/// AppBar and a custom stateful widget for the suitable body but
/// it turns out to be pretty much the same as a scaffold in a
/// stateful widget so.. dunno.

void main() {
  debugPaintSizeEnabled = false;
  runApp(CustomTheme(initialThemeKey: MyThemeKeys.LIGHT, child: MyApp()));
}

class MyApp extends StatelessWidget {
  final appTitle = 'Drawer Demo';

  MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme.of(context),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        'addRecipe': (context) => AddRecipeForm(),
        'manageCategory': (context) => CategoryManager(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final bool recipeCatOverview;

  MyHomePage(this.recipeCatOverview);

  @override
  MyHomePageState createState() =>
      MyHomePageState(recipeCatOverview: recipeCatOverview);
}

class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Future<SharedPreferences> prefs;
  bool recipeCatOverview;
  String title;
  int _selectedIndex = 0;

  MyHomePageState({Key key, String title, @required this.recipeCatOverview});
  AnimationController _controller;
  static const List<IconData> icons = const [
    Icons.grid_on,
    Icons.description,
  ];
  Widget _animatedWidget;

  @override
  void initState() {
    super.initState();
    prefs = SharedPreferences.getInstance();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    recipeCatOverview == true
        ? _animatedWidget = RecipeCategoryOverview()
        : _animatedWidget = CategoryGridView();
  }

  AppBar buildAppBar(String title) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        _selectedIndex == 0
            ? IconButton(
                icon: Icon(Icons.swap_vertical_circle),
                onPressed: () {
                  prefs.then((prefs) {
                    if (recipeCatOverview) {
                      prefs.setBool('recipeCatOverview', false).then((_) {
                        setState(() {
                          recipeCatOverview = false;
                          _animatedWidget = CategoryGridView();
                        });
                      });
                    } else {
                      prefs.setBool('recipeCatOverview', true).then((_) {
                        setState(() {
                          recipeCatOverview = true;
                          _animatedWidget = RecipeCategoryOverview();
                        });
                      });
                    }
                  });
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
        IconButton(
          icon: Icon(Icons.adb),
          onPressed: () {
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
            // ); // TODO: Continue
            // var json = r.toMap();
            // Recipe rrr = Recipe.fromMap(json);
            // print(rrr.toString());
          },
        )
      ].where((child) => child != null).toList(),
    );
  }

  Widget getFloatingB(String page) {
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
                      ? Navigator.pushNamed(context, 'addRecipe')
                      : Navigator.pushNamed(context, 'manageCategory');
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
                    child:
                        Icon(_controller.isDismissed ? Icons.add : Icons.close, color: Colors.white,),
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

  Color getBackgroundColor(String page) {
    if (page == 'recipes')
      return Theme.of(context).backgroundColor == Colors.white
          ? Color(0xffFEF3E1)
          : Color(0xff202125);
    else if (page == 'favorites')
      return Theme.of(context).backgroundColor == Colors.white
          ? Color(0xffFFE3FC)
          : Color(0xffFF71C6);
    return Theme.of(context).backgroundColor == Colors.white
        ? Colors.white
        : Color(0xff202125);
  }

  @override
  Widget build(BuildContext context) {
    if (title == null) {
      title = "recipes";
    }
    return Scaffold(
      appBar: buildAppBar(title),
      floatingActionButton: getFloatingB(title),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: _animatedWidget,
          ),
          FavoriteScreen(key: PageStorageKey('Page2')),
          ShoppingCartScreen(key: PageStorageKey('Page3')),
          Center(child: Text('This page is not yet implemented')),
          Settings(),
        ],
      ),
      backgroundColor: getBackgroundColor(title),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.black87),
        child: BottomNavigationBar(
          fixedColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.fastfood), title: Text("recipes")),
            BottomNavigationBarItem(
                icon: _selectedIndex == 1
                    ? Icon(
                        Icons.favorite,
                        color: Colors.pink,
                      )
                    : Icon(Icons.favorite_border),
                title: Text("favorites")),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart,
                  color: _selectedIndex == 2 ? Colors.grey : Colors.white,
                ),
                title: Text("shopping cart")),

            /// Maybe remove calendar section and simply import the things to shop
            /// to the default calendar.
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), title: Text("calendar")),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text("settings"))
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        setState(() {
          _selectedIndex = index;
          title = "recipes";
        });
        return;
      case 1:
        setState(() {
          _selectedIndex = index;
          title = "favorites";
        });
        return;
      case 2:
        setState(() {
          _selectedIndex = index;
          title = "shopping cart";
        });
        return;
      case 3:
        setState(() {
          _selectedIndex = index;
          title = "calendar";
        });
        return;
      case 4:
        setState(() {
          _selectedIndex = index;
          title = "settings";
        });
        return;
      default:
        print('Selected a drawerItem which does not exist!');
        return;
    }
  }
}
