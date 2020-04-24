import 'dart:io';
import 'dart:math';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcase.dart';
import 'package:showcaseview/showcase_widget.dart';

import '../ad_related/ad.dart';
import '../blocs/ad_manager/ad_manager_bloc.dart';
import '../blocs/app/app_bloc.dart';
import '../blocs/import_recipe/import_recipe_bloc.dart';
import '../blocs/recipe_bubble/recipe_bubble_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/routes.dart';
import '../generated/i18n.dart';
import '../local_storage/hive.dart';
import '../my_wrapper.dart';
import '../widgets/dialogs/import_dialog.dart';
import '../widgets/dialogs/info_dialog.dart';
import '../widgets/recipe_bubble.dart';
import '../widgets/search.dart';
import '../widgets/shopping_cart_floating.dart';
import '../widgets/vertical_side_bar.dart';
import 'add_recipe/general_info_screen/general_info_screen.dart';
import 'category_gridview.dart';
import 'favorite_screen.dart';
import 'ingredient_search.dart';
import 'r_category_overview.dart';
import 'random_recipe.dart';
import 'settings_screen.dart';
import 'shopping_cart_fancy.dart';

class MyHomePage extends StatefulWidget {
  final bool showIntro;

  MyHomePage({this.showIntro});

  @override
  MyHomePageState createState() => MyHomePageState(showIntro: showIntro);
}

class MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  Future<SharedPreferences> prefs;
  Image shoppingCartImage;
  GlobalKey _introKeyOne = GlobalKey();
  GlobalKey _introKeyTwo = GlobalKey();
  MyBooleanWrapper showIntro;
  bool _intentFailedImporting = false;

  Flushbar _flush;

  static const platform = const MethodChannel('app.channel.shared.data');

  MyHomePageState({
    String title,
    bool showIntro,
    Key key,
  }) {
    this.showIntro = MyBooleanWrapper(showIntro);
  }

  static const List<IconData> icons = const [
    MdiIcons.apps,
    Icons.description,
  ];

  @override
  void initState() {
    super.initState();
    shoppingCartImage = Image.asset(
      'images/cuisine.jpg',
      fit: BoxFit.cover,
    );
    initializeIntent();

    // Listen to lifecycle events.
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      initializeIntent();
    }
  }

  Future<void> initializeIntent() async {
    var importZipFilePath = await getIntentPath();
    if (importZipFilePath == null) return;

    // if error occured writing the import file
    if (importZipFilePath == "failedFileCreation" ||
        importZipFilePath == "failedWriting" ||
        importZipFilePath == "failedClosing") {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      // if error occured even though the storage permission is granted
      if (permission == PermissionStatus.granted) {
        String error = importZipFilePath == "failedFileCreation"
            ? "Error #1:"
            : importZipFilePath == "failedWriting" ? "Error #2:" : "Error #3:";
        _showFlushInfo(I18n.of(context).failed_import,
            "$error" + I18n.of(context).failed_import_desc);
      } // if error occured and the storage permission is not granted and not set to neverShowAgain
      else if (permission == PermissionStatus.denied ||
          permission == PermissionStatus.unknown) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => InfoDialog(
            title: I18n.of(context).need_to_access_storage,
            body: I18n.of(context).need_to_access_storage_desc,
            onPressedOk: () async {
              PermissionHandler().requestPermissions(
                  [PermissionGroup.storage]).then((updatedPermissions) {
                if (updatedPermissions[PermissionGroup.storage] ==
                    PermissionStatus.granted) {
                  if (_intentFailedImporting = false) {
                    _intentFailedImporting = true;

                    initializeIntent().then((_) {});
                  }
                }
              });
            },
          ),
        );
      }
    } // if import was successfull
    else {
      if (importZipFilePath != null) {
        BuildContext importRecipeBlocContext = context;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => BlocProvider<ImportRecipeBloc>.value(
              value: BlocProvider.of<ImportRecipeBloc>(importRecipeBlocContext)
                ..add(StartImportRecipes(File(importZipFilePath.toString()),
                    delay: Duration(milliseconds: 300))),
              child: ImportDialog(closeAfterFinished: false)),
        );
      }
      _intentFailedImporting = false;
    }
  }

  getIntentPath() async {
    if (Platform.isAndroid) {
      var sharedData = await platform.invokeMethod("getSharedText");
      return sharedData == null ? null : sharedData;
    }
  }

  void _showFlushInfo(String title, String body) {
    if (_flush != null && _flush.isShowing()) {
    } else {
      _flush = Flushbar<bool>(
        animationDuration: Duration(milliseconds: 300),
        leftBarIndicatorColor: Colors.blue[300],
        title: title,
        message: body,
        icon: Icon(
          Icons.info_outline,
          color: Colors.blue,
        ),
        mainButton: FlatButton(
          onPressed: () {
            _flush.dismiss(true); // result = true
          },
          child: Text(
            "OK",
            style: TextStyle(color: Colors.amber),
          ),
        ),
      ) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
        ..show(context).then((result) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
      BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return _getSplashScreen();
          } else if (state is LoadedState) {
            return Scaffold(
              appBar: _buildAppBar(state.selectedIndex,
                  state.recipeCategoryOverview, state.title),
              floatingActionButton: state.selectedIndex == 0
                  ? FloatingActionButtonMenu(_introKeyOne, _introKeyTwo,
                      showIntro: showIntro)
                  : null,
              body: Row(
                children: <Widget>[
                  MediaQuery.of(context).size.width > 900
                      ? VerticalSideBar(
                          state.selectedIndex == 2 ? 0 : state.selectedIndex,
                          state.shoppingCartOpen,
                        )
                      : null,
                  Expanded(
                    child: IndexedStack(
                      index: state.selectedIndex,
                      children: [
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 200),
                          child: state.recipeCategoryOverview == true
                              ? RecipeCategoryOverview()
                              : CategoryGridView(),
                        ),
                        FavoriteScreen(),
                        MediaQuery.of(context).size.width <= 900
                            ? FancyShoppingCartScreen(shoppingCartImage)
                            : Container(),
                        SwypingCardsScreen(),
                        Settings(),
                      ],
                    ),
                  ),
                ]..removeWhere((item) => item == null),
              ),
              backgroundColor: _getBackgroundColor(state.selectedIndex),
              bottomNavigationBar: MediaQuery.of(context).size.width <= 900
                  ? MediaQuery.of(context).size.width < 346
                      ? BottomNavigationBar(
                          backgroundColor: Color(0xff232323),
                          currentIndex: state.selectedIndex,
                          onTap: (index) => _onItemTapped(index, context),
                          items: [
                            BottomNavigationBarItem(
                              icon: Icon(MdiIcons.notebook),
                              title: Text(
                                I18n.of(context).recipes,
                                style: TextStyle(color: Colors.orange),
                              ),
                              activeIcon: Icon(
                                MdiIcons.notebook,
                                color: Colors.orange,
                              ),
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.favorite),
                              title: Text(
                                I18n.of(context).favorites,
                                style: TextStyle(color: Colors.pink),
                              ),
                              activeIcon: Icon(
                                Icons.favorite,
                                color: Colors.pink,
                              ),
                            ),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.shopping_basket),
                                title: Text(
                                  I18n.of(context).basket,
                                  style: TextStyle(color: Colors.brown[300]),
                                ),
                                activeIcon: Icon(
                                  Icons.shopping_basket,
                                  color: Colors.brown[300],
                                )),
                            BottomNavigationBarItem(
                              icon: Icon(MdiIcons.diceMultiple),
                              title: Text(
                                I18n.of(context).explore,
                                style: TextStyle(color: Colors.green),
                              ),
                              activeIcon: Icon(
                                MdiIcons.diceMultiple,
                                color: Colors.green,
                              ),
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.settings),
                              title: Text(
                                I18n.of(context).settings,
                                style: TextStyle(color: Colors.grey),
                              ),
                              activeIcon: Icon(
                                Icons.settings,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      : Theme(
                          data: Theme.of(context)
                              .copyWith(canvasColor: Colors.black87),
                          child: BottomNavyBar(
                            backgroundColor: Color(0xff232323),
                            animationDuration: Duration(milliseconds: 150),
                            selectedIndex: state.selectedIndex,
                            showElevation: true,
                            onItemSelected: (index) =>
                                _onItemTapped(index, context),
                            items: [
                              BottomNavyBarItem(
                                  icon: Icon(MdiIcons.notebook),
                                  title: Text(I18n.of(context).recipes),
                                  activeColor: Colors.orange,
                                  inactiveColor: Colors.white),
                              BottomNavyBarItem(
                                icon: Icon(Icons.favorite),
                                title: Text(I18n.of(context).favorites),
                                activeColor: Colors.pink,
                                inactiveColor: Colors.white,
                              ),
                              BottomNavyBarItem(
                                  icon: Icon(Icons.shopping_basket),
                                  title: Text(I18n.of(context).basket),
                                  activeColor: Colors.brown[300],
                                  inactiveColor: Colors.white),
                              BottomNavyBarItem(
                                icon: Icon(MdiIcons.diceMultiple),
                                title: Text(I18n.of(context).explore),
                                activeColor: Colors.green,
                                inactiveColor: Colors.white,
                              ),
                              BottomNavyBarItem(
                                  icon: Icon(Icons.settings),
                                  title: Text(I18n.of(context).settings),
                                  activeColor: Colors.grey[100],
                                  inactiveColor: Colors.white)
                            ],
                          ),
                        )
                  : null,
            );
          } else {
            return Text(state.toString());
          }
        },
      ),
      RecipeBubbles(),
      MediaQuery.of(context).size.width > 900
          ? ShoppingCartFloating(
              initialPosition: Offset(
                200,
                200,
              ),
            )
          : null,
    ]..removeWhere((item) => item == null));
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

  GradientAppBar _buildAppBar(
      int currentIndex, bool recipeCategoryOverview, String title) {
    // if shoppingCartPage with sliverAppBar

    if (currentIndex == 2) {
      return null;
    } else if (currentIndex == 3 && MediaQuery.of(context).size.height < 730)
      return null;
    else {
      return GradientAppBar(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAF1E1E), Color(0xff641414)],
          ),
          title: Text(title),
          actions: <Widget>[
            currentIndex == 0
                ? IconButton(
                    icon: Icon(Icons.help_outline),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => InfoDialog(
                            title: I18n.of(context).recipes_not_showing_up,
                            body: I18n.of(context).recipes_not_showing_up_desc),
                      );
                    })
                : null,
            IconButton(
              icon: Icon(MdiIcons.fileDocumentBoxSearchOutline),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.ingredientSearch,
                  arguments: IngredientSearchScreenArguments(
                      BlocProvider.of<ShoppingCartBloc>(context),
                      BlocProvider.of<AdManagerBloc>(context),
                      BlocProvider.of<AdManagerBloc>(context).state
                          is IsPurchased),
                );
              },
            ),
            currentIndex == 0
                ? IconButton(
                    icon: Icon(recipeCategoryOverview
                        ? Icons.grid_off
                        : Icons.grid_on),
                    onPressed: () {
                      _changeMainPageOverview(recipeCategoryOverview);
                    },
                  )
                : null,
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: RecipeSearch(
                      HiveProvider().getRecipeNames(),
                      BlocProvider.of<ShoppingCartBloc>(context),
                      HiveProvider().getRecipeTags(),
                      HiveProvider().getCategoryNames()..remove('no category'),
                    ));
              },
            ),
          ]..removeWhere((item) => item == null));
    }
  }

  void _changeMainPageOverview(bool rCatOverview) {
    bool recipeCategoryOverview = false;
    if (rCatOverview == false) {
      recipeCategoryOverview = true;
    }

    BlocProvider.of<AppBloc>(context)
      ..add(ChangeCategoryOverview(recipeCategoryOverview));
  }

  Color _getBackgroundColor(int selectedIndex) {
    if (selectedIndex == 0) {
      return Theme.of(context).scaffoldBackgroundColor;
    } else if (selectedIndex == 1) {
      // if bright theme
      if (Theme.of(context).backgroundColor == Colors.white) {
        return Theme.of(context).scaffoldBackgroundColor;
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

class FloatingActionButtonMenu extends StatefulWidget {
  final GlobalKey _introKeyOne;
  final GlobalKey _introKeyTwo;
  final MyBooleanWrapper showIntro;

  FloatingActionButtonMenu(
    this._introKeyOne,
    this._introKeyTwo, {
    this.showIntro,
    Key key,
  }) : super(key: key);

  @override
  _FloatingActionButtonMenuState createState() =>
      _FloatingActionButtonMenuState();
}

class _FloatingActionButtonMenuState extends State<FloatingActionButtonMenu>
    with TickerProviderStateMixin {
  AnimationController _controller;
  static const List<IconData> icons = const [
    MdiIcons.apps,
    Icons.description,
  ];
  bool isOpen = false;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Column menu = Column(
        mainAxisSize: MainAxisSize.min,
        children: isOpen
            ? [
                Showcase.withWidget(
                  key: widget._introKeyTwo,
                  height: 50,
                  width: 200,
                  container: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                              colors: [Colors.grey[300], Colors.white]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                              I18n.of(context).tap_here_to_manage_categories,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                  shapeBorder: CircleBorder(),
                  child: _getFloatingItem(
                    () {
                      Navigator.pushNamed(
                        context,
                        RouteNames.manageCategories,
                      ).then((_) => Ads.hideBottomBannerAd());
                    },
                    Icon(MdiIcons.apps, color: Theme.of(context).primaryColor),
                    2,
                    I18n.of(context).manage_categories,
                  ),
                ),
                Showcase.withWidget(
                  key: widget._introKeyOne,
                  height: 50,
                  width: 200,
                  container: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                              colors: [Colors.grey[300], Colors.white]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(I18n.of(context).tap_here_to_add_recipe,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                  shapeBorder: CircleBorder(),
                  child: _getFloatingItem(
                    () {
                      getTemporaryDirectory().then((dir) {
                        dir.delete(recursive: true);
                        Navigator.pushNamed(
                          context,
                          RouteNames.addRecipeGeneralInfo,
                          arguments: GeneralInfoArguments(
                            HiveProvider().getTmpRecipe(),
                            BlocProvider.of<ShoppingCartBloc>(context),
                          ),
                        ).then((_) => Ads.hideBottomBannerAd());
                      });
                    },
                    Icon(Icons.description,
                        color: Theme.of(context).primaryColor),
                    1,
                    I18n.of(context).add_recipe,
                  ),
                ),
              ]
            : []);
    menu.children.add(
      FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
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
            setState(() {
              if (widget.showIntro.myBool) {
                ShowCaseWidget.of(context)
                    .startShowCase([widget._introKeyOne, widget._introKeyTwo]);
                widget.showIntro.myBool = false;
              }
              isOpen = true;
              _controller.forward();
            });
          } else {
            setState(() {
              _controller.reverse();
              Future.delayed(Duration(milliseconds: 100))
                  .then((_) => setState(() {
                        isOpen = false;
                      }));
            });
          }
        },
      ),
    );
    return menu;
  }

  Widget _getFloatingItem(
      void Function() onTap, Icon icon, int index, String tooltip) {
    return Container(
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
          tooltip: tooltip,
          heroTag: null,
          backgroundColor: Colors.white,
          mini: true,
          child: icon,
          onPressed: () {
            _controller.reverse();
            onTap();
          },
        ),
      ),
    );
  }
}

class RecipeBubbles extends StatelessWidget {
  const RecipeBubbles({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBubbleBloc, RecipeBubbleState>(
      builder: (context, state) {
        if (state is LoadedRecipeBubbles) {
          return Stack(
            children: List<Widget>.generate(
              state.recipes.length,
              (index) => RecipeBubble(
                recipe: state.recipes[index],
                initialPosition: Offset(
                  MediaQuery.of(context).size.width - 60,
                  90 - (index.toDouble() * 20),
                ),
              ),
            )..reversed,
          );
        } else {
          return Text("unknown state");
        }
      },
    );
  }
}

// ---------------------

class BottomNavyBar extends StatelessWidget {
  final int selectedIndex;
  final double iconSize;
  final Color backgroundColor;
  final bool showElevation;
  final Duration animationDuration;
  final List<BottomNavyBarItem> items;
  final ValueChanged<int> onItemSelected;
  final MainAxisAlignment mainAxisAlignment;
  final double itemCornerRadius;
  final Curve curve;

  BottomNavyBar({
    Key key,
    this.selectedIndex = 0,
    this.showElevation = true,
    this.iconSize = 24,
    this.backgroundColor,
    this.itemCornerRadius = 50,
    this.animationDuration = const Duration(milliseconds: 270),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    @required this.items,
    @required this.onItemSelected,
    this.curve = Curves.linear,
  }) {
    assert(items != null);
    assert(items.length >= 2 && items.length <= 5);
    assert(onItemSelected != null);
    assert(curve != null);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = (backgroundColor == null)
        ? Theme.of(context).bottomAppBarColor
        : backgroundColor;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.black87, Colors.grey[900]],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight),
        boxShadow: [
          if (showElevation)
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
            ),
        ],
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: 56,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: items.map((item) {
              var index = items.indexOf(item);
              return GestureDetector(
                onTap: () => onItemSelected(index),
                child: _ItemWidget(
                  item: item,
                  iconSize: iconSize,
                  isSelected: index == selectedIndex,
                  backgroundColor: bgColor,
                  itemCornerRadius: itemCornerRadius,
                  animationDuration: animationDuration,
                  curve: curve,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final double iconSize;
  final bool isSelected;
  final BottomNavyBarItem item;
  final Color backgroundColor;
  final double itemCornerRadius;
  final Duration animationDuration;
  final Curve curve;

  const _ItemWidget({
    Key key,
    @required this.item,
    @required this.isSelected,
    @required this.backgroundColor,
    @required this.animationDuration,
    @required this.itemCornerRadius,
    @required this.iconSize,
    this.curve = Curves.linear,
  })  : assert(isSelected != null),
        assert(item != null),
        assert(backgroundColor != null),
        assert(animationDuration != null),
        assert(itemCornerRadius != null),
        assert(iconSize != null),
        assert(curve != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: isSelected ? 130 : 50,
      height: double.maxFinite,
      duration: animationDuration,
      curve: curve,
      decoration: BoxDecoration(
        color:
            isSelected ? item.activeColor.withOpacity(0.2) : Colors.transparent,
        gradient: LinearGradient(
          colors: isSelected
              ? [
                  item.activeColor,
                  item.activeColor.withOpacity(0.8),
                ]
              : [Colors.transparent, Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(itemCornerRadius),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          width: isSelected ? 130 : 50,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconTheme(
                data: IconThemeData(
                  size: iconSize,
                  color: isSelected
                      ? item.activeColor.withOpacity(1)
                      : item.inactiveColor == null
                          ? item.activeColor
                          : item.inactiveColor,
                ),
                child: item.icon,
              ),
              if (isSelected)
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: DefaultTextStyle.merge(
                      style: TextStyle(
                        color: item.activeColor,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      textAlign: item.textAlign,
                      child: item.title,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavyBarItem {
  final Icon icon;
  final Text title;
  final Color activeColor;
  final Color inactiveColor;
  final TextAlign textAlign;

  BottomNavyBarItem({
    @required this.icon,
    @required this.title,
    this.activeColor = Colors.blue,
    this.textAlign,
    this.inactiveColor,
  }) {
    assert(icon != null);
    assert(title != null);
  }
}
