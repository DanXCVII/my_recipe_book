import 'dart:io';
import 'dart:math';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/app/app_bloc.dart';
import '../blocs/app/app_event.dart';
import '../blocs/app/app_state.dart';
import '../blocs/import_recipe/import_recipe_bloc.dart';
import '../blocs/import_recipe/import_recipe_event.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../database.dart';
import '../generated/i18n.dart';
import '../hive.dart';
import '../random_recipe/random_recipe.dart';
import '../routes.dart';
import '../search.dart';
import '../settings/settings_screen.dart';
import 'add_recipe/general_info_screen/general_info_screen.dart';
import 'category_gridview.dart';
import 'favorite_screen.dart';
import 'r_category_overview.dart';
import 'shopping_cart_fancy.dart';

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
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return _getSplashScreen();
        } else if (state is LoadedState) {
          return Scaffold(
            appBar: _buildAppBar(
                state.selectedIndex, state.recipeCategoryOverview, state.title),
            floatingActionButton: _getFloatingB(state.selectedIndex, context),
            body: IndexedStack(
              index: state.selectedIndex,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: state.recipeCategoryOverview == true
                      ? RecipeCategoryOverview()
                      : CategoryGridView(),
                ),
                FavoriteScreen(),
                FancyShoppingCartScreen(),
                SwypingCardsScreen(),
                Settings(),
              ],
            ),
            backgroundColor: _getBackgroundColor(state.selectedIndex),
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.black87),
              child: BottomNavyBar(
                backgroundColor: Color(0xff232323),
                animationDuration: Duration(milliseconds: 150),
                selectedIndex: state.selectedIndex,
                showElevation: true,
                onItemSelected: (index) => _onItemTapped(index, context),
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
                ],
              ),
            ),
          );
        } else {
          return Text(state.toString());
        }
      },
    );
  }

  Widget _getSplashScreen() {
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

  // TODO: fix open zip with recipe app to work again
  initializeIntent() async {
    var importZipFile = await getIntentPath();
    if (importZipFile != null) {
      // TODO: add recipe to hive and notify blocs when importing
      showDialog(
        context: context,
        builder: (context) => BlocProvider<ImportRecipeBloc>(
          create:
              (context) => // TODO: probably wrong context and need context of initState()
                  ImportRecipeBloc(BlocProvider.of<RecipeManagerBloc>(context)),
          child: getImportRecipeDialog(importZipFile),
        ),
      );
    }
  }

  static const platform = const MethodChannel('app.channel.shared.data');

  getIntentPath() async {
    // var sharedData = await platform.invokeMethod("getSharedText");
    // return sharedData == null ? null : sharedData;
  }

  Widget getImportRecipeDialog(File importZipFile) {
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
            BlocProvider.of<ImportRecipeBloc>(context)
                .add(ImportRecipes(importZipFile));
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  AppBar _buildAppBar(
      int currentIndex, bool recipeCategoryOverview, String title) {
    // if shoppingCartPage with sliverAppBar

    if (currentIndex == 2) {
      return null;
    }
    return AppBar(
        title: Text(title),
        actions: <Widget>[
          currentIndex == 0
              ? IconButton(
                  icon: Icon(
                      recipeCategoryOverview ? Icons.grid_off : Icons.grid_on),
                  onPressed: () {
                    _changeMainPageOverview(recipeCategoryOverview);
                  },
                )
              : null,
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              DBProvider.db.getRecipeNames().then((recipeNames) {
                showSearch(
                    context: context, delegate: RecipeSearch(recipeNames));
              });
            },
          ),
        ]..removeWhere((item) => item == null));
  }

  void _changeMainPageOverview(bool rCatOverview) {
    prefs.then((prefs) {
      bool recipeCategoryOverview = false;
      if (rCatOverview == false) {
        recipeCategoryOverview = true;
      }

      BlocProvider.of<AppBloc>(context)
        ..add(ChangeCategoryOverview(recipeCategoryOverview));
    });
  }

  Widget _getFloatingB(int selectedIndex, BuildContext homePageContext) {
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
                      ? Navigator.pushNamed(
                          context,
                          RouteNames.addRecipeGeneralInfo,
                          arguments: GeneralInfoArguments(
                              HiveProvider().getTmpEditingRecipe()),
                        )
                      : Navigator.pushNamed(
                          context,
                          RouteNames.manageCategories,
                        );
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

  void _onItemTapped(int index, BuildContext context) {
    BlocProvider.of<AppBloc>(context)..add(ChangeView(index, context));
  }
}
