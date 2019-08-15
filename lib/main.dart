import 'package:flutter/material.dart';
import 'package:my_recipe_book/SplashScreen.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/recipe.dart';
import 'recipe_overview/r_category_overview.dart';
import 'shopping_cart/shopping_cart.dart';
import 'recipe_overview/add_recipe_screen/add_recipe.dart';
import 'package:flutter/rendering.dart';
import './favortie_screen/favorite_screen.dart';

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
        'recipeCategoryOverview': (context) => RecipeCategoryOverview(),
        'addRecipe': (context) => AddRecipeForm(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final List<Widget> pages = [
    RecipeCategoryOverview(key: PageStorageKey('Page1')),
    FavoriteScreen(key: PageStorageKey('Page2')),
    ShoppingCartScreen(key: PageStorageKey('Page3')),
    Center(child: Text('This page is not yet implemented')),
  ];
  String title;
  int _selectedIndex = 0;

  MyHomePageState({Key key, String title});

  AppBar buildAppBar(String title) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            DBProvider.db.getRecipeNames().then((recipeNames) {
              showSearch(context: context, delegate: RecipeSearch(recipeNames));
            });
          },
        )
      ],
    );
  }

  Widget getFloatingB(String page) {
    if (page == 'recipes') {
      return FloatingActionButton(
          backgroundColor: Color(0xFF790604),
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, 'addRecipe');
          });
    }
    return null;
  }

  Color getBackgroundColor(String page) {
    if (page == 'recipes')
      return Color(0xffFEF3E1);
    else if (page == 'favorites') return Color(0xffFFCDD9);
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    if (title == null) {
      title = "recipes";
    }

    return Scaffold(
      appBar: buildAppBar(title),
      floatingActionButton: getFloatingB(title),
      /*body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),*/
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
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
