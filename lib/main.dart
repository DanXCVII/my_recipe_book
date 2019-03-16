import 'package:flutter/material.dart';
import 'recipe_overview/r_category_overview.dart';
import 'recipe_overview/add_recipe.dart';
import 'package:flutter/rendering.dart';

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
        primaryColor: Colors.red, // maybe brown[700]
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
        '/': (context) => MyHomePage(),
        'recipeCategoryOverview': (context) => RCategoryOverview(),
        'addRecipe': (context) => AddRecipe(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String title;
  int _selectedIndex = 0;

  MyHomePageState({Key key, String title});

  AppBar buildAppBar(String title) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        )
      ],
    );
  }

  Widget getSelectedDrawerPage(String page) {
    switch (page) {
      case 'recipes':
        return RCategoryOverview();
      case 'favorites':
      case 'shopping cart':
      case 'calendar':
      default:
        return Center(child: Text('This page is not yet implemented'));
    }
  }

  Widget getFloating(String page) {
    if (page == 'recipes') {
      return FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, 'addRecipe');
          });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    /// title equals null only when we start the app
    /// otherwise, when a drawer item is selected, we set the new title
    /// via setState()
    if (title == null) {
      title = "recipes";
    }

    return Scaffold(
      appBar: buildAppBar(title),
      floatingActionButton: getFloating(title),
      body: getSelectedDrawerPage(title),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.black87),
        child: BottomNavigationBar(
          fixedColor: Colors.brown[800],
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.fastfood), title: Text("recipes")),
            BottomNavigationBarItem(
                icon: _selectedIndex == 1
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                title: Text("favorites")),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), title: Text("shopping cart")),

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
