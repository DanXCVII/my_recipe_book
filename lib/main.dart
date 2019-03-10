import 'package:flutter/material.dart';
import 'recipe_overview/r_category_overview.dart';

/// TODO: Think about how to change the Appbar and body with using a 
/// StateLess widget for better performance maybe. One way of doing
/// it would be to make a custom stateful widget which builds an
/// AppBar and a custom stateful widget for the suitable body but
/// it turns out to be pretty much the same as a scaffold in a
/// stateful widget so.. dunno. 

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTitle = 'Drawer Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        'recipeCategoryOverview': (context) => RCategoryOverview(),
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
    if (page == "Category Overview") {
      return RCategoryOverview();
    }
    return Center(
      child: Text('Error occured'),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// title equals null only when we start the app
    /// otherwise, when a drawer item is selected, we set the new title
    /// via setState()
    if (title == null) {
      title = "Category Overview";
    }

    return Scaffold(
      appBar: buildAppBar(title),
      body: getSelectedDrawerPage(title),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Category Overview'),
              onTap: () {
                setState(() {
                  title = 'Category Overview';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Shopping Cart'),
              onTap: () {
                setState(() {
                  title = 'Shopping Cart';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
