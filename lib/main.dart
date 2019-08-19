import 'package:flutter/material.dart';
import 'package:my_recipe_book/SplashScreen.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/recipe_overview/category_manager_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'recipe_overview/r_category_overview.dart';
import 'shopping_cart/shopping_cart.dart';
import 'recipe_overview/add_recipe_screen/add_recipe.dart';
import './favortie_screen/favorite_screen.dart';
import './search.dart';

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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final appTitle = 'Drawer Demo';

  MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF790604), // maybe brown[700]
        /* canvasColor: Color(0xFF43403D),
         textSelectionColor: Colors.white,
         backgroundColor: Color(0xFF43403D),
         hintColor: Colors.white,
         textSelectionHandleColor: Colors.white, */
        iconTheme: IconThemeData(color: Colors.grey[700]),
        /*textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              )*/
      ),
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

  @override
  void initState() {
    super.initState();
    prefs = SharedPreferences.getInstance();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
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
                        });
                      });
                      recipeCatOverview = false;
                    } else {
                      prefs.setBool('recipeCatOverview', true).then((_) {
                        setState(() {
                          recipeCatOverview = true;
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
                        Icon(_controller.isDismissed ? Icons.add : Icons.close),
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
      return Color(0xffFEF3E1);
    else if (page == 'favorites') return Color(0xffFFE3FC);
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    if (title == null) {
      title = "recipes";
    }
    print(recipeCatOverview.toString());
    return Scaffold(
      appBar: buildAppBar(title),
      floatingActionButton: getFloatingB(title),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          CategoryOverview(
            recipeCatOverview: recipeCatOverview,
          ),
          FavoriteScreen(key: PageStorageKey('Page2')),
          ShoppingCartScreen(key: PageStorageKey('Page3')),
          Center(child: Text('This page is not yet implemented')),
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
