import 'dart:io';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/blocs/recipe_mods/recipe_mods_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../ad_related/ad.dart';
import '../blocs/ad_manager/ad_manager_bloc.dart';
import '../blocs/app/app_bloc.dart';
import '../blocs/import_recipe/import_recipe_bloc.dart';
import '../blocs/recipe_bubble/recipe_bubble_bloc.dart';
import '../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as GC;
import '../constants/routes.dart';
import '../generated/l10n.dart';
import '../local_storage/hive.dart';
import '../local_storage/io_operations.dart' as IO;
import '../util/my_wrapper.dart';
import '../widgets/dialogs/import_dialog.dart';
import '../widgets/dialogs/info_dialog.dart';
import '../widgets/dialogs/shopping_cart_add_dialog.dart';
import '../widgets/recipe_bubble.dart';
import '../widgets/recipe_calendar_floating.dart';
import '../widgets/search.dart';
import '../widgets/shopping_cart_floating.dart';
import '../widgets/spinning_sync_icon.dart';
import '../widgets/vertical_side_bar.dart';
import 'add_recipe/general_info_screen/general_info_screen.dart';
import 'category_gridview.dart';
import 'favorite_screen.dart';
import 'import_from_website.dart';
import 'ingredient_search.dart';
import 'r_category_overview.dart';
import 'random_recipe.dart';
import 'recipe_calendar_screen.dart';
import 'settings_screen.dart';
import 'shopping_cart_fancy.dart';

RateMyApp _rateMyApp = RateMyApp(
  preferencesPrefix: 'rateMyApp_',
  minDays: 7,
  minLaunches: 10,
  remindDays: 2,
  remindLaunches: 2,
  googlePlayIdentifier: 'com.release.my_recipe_book',
  // appStoreIdentifier: '1491556149',
);

class MyHomePageArguments {
  final bool? showIntro;
  final BuildContext context;
  final bool? showShoppingCartSummary;
  final bool? recipeCategoryOverview;

  MyHomePageArguments(
    this.showIntro,
    this.context,
    this.showShoppingCartSummary,
    this.recipeCategoryOverview,
  );
}

class MyHomePage extends StatefulWidget {
  final bool? showIntro;

  MyHomePage({this.showIntro});

  @override
  MyHomePageState createState() => MyHomePageState(showIntro: showIntro);
}

class MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  Future<SharedPreferences>? prefs;
  Image? shoppingCartImage;
  GlobalKey _introKeyOne = GlobalKey();
  GlobalKey _introKeyTwo = GlobalKey();
  GlobalKey _introKeyThree = GlobalKey();
  MyBooleanWrapper? showIntro;
  bool _intentFailedImporting = false;

  Flushbar? _flush;

  static const platform = const MethodChannel('app.channel.shared.data');

  MyHomePageState({
    String? title,
    bool? showIntro,
    Key? key,
  }) {
    this.showIntro = MyBooleanWrapper(showIntro);
  }

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
    var intentSharedText = await getIntentData();
    if (intentSharedText == null) return;

    // if error occured writing the import file
    if (intentSharedText == "failedFileCreation" ||
        intentSharedText == "failedWriting" ||
        intentSharedText == "failedClosing") {
      // if error occured even though the storage permission is granted
      if (await Permission.storage.isGranted) {
        String error = intentSharedText == "failedFileCreation"
            ? "Error #1:"
            : intentSharedText == "failedWriting"
                ? "Error #2:"
                : "Error #3:";
        _showFlushInfo(S.of(context).failed_import,
            "$error" + S.of(context).failed_import_desc);
      } // if error occured and the storage permission is not granted and not set to neverShowAgain
      else if (await Permission.storage.isDenied) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => InfoDialog(
            title: S.of(context).need_to_access_storage,
            body: S.of(context).need_to_access_storage_desc,
            onPressedOk: () async {
              Permission.storage.request().then((updatedPermissions) {
                if (updatedPermissions.isGranted) {
                  if (_intentFailedImporting == false) {
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
    else if (File(intentSharedText.toString()).existsSync() &&
        intentSharedText != null) {
      BuildContext importRecipeBlocContext = context;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => BlocProvider<ImportRecipeBloc>.value(
            value: BlocProvider.of<ImportRecipeBloc>(importRecipeBlocContext)
              ..add(StartImportRecipes(File(intentSharedText.toString()),
                  delay: Duration(milliseconds: 300))),
            child: ImportDialog(closeAfterFinished: false)),
      );
    } else if (intentSharedText != null) {
      BlocProvider.of<AdManagerBloc>(context).add(LoadVideo());
      Navigator.pushNamed(
        context,
        RouteNames.importFromWebsite,
        arguments: ImportFromWebsiteArguments(
            BlocProvider.of<ShoppingCartBloc>(context),
            BlocProvider.of<RecipeCalendarBloc>(context),
            BlocProvider.of<AdManagerBloc>(context),
            initialWebsite: intentSharedText.toString()),
      ).then((_) => Ads.hideBottomBannerAd());
    } else {
      _intentFailedImporting = false;
    }
  }

  getIntentData() async {
    if (Platform.isAndroid) {
      var sharedData = await platform.invokeMethod("getSharedText");
      return sharedData == null ? null : sharedData;
    }
  }

  void _showFlushInfo(String title, String body) {
    if (_flush != null && _flush!.isShowing()) {
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
        mainButton: TextButton(
          onPressed: () {
            _flush!.dismiss(true); // result = true
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
    return RateMyAppBuilder(
      rateMyApp: _rateMyApp,
      onInitialized: (context, rateMyApp) {
        rateMyApp.conditions.forEach((condition) {
          if (condition is DebuggableCondition) {
            print(condition
                .valuesAsString); // We iterate through our list of conditions and we print all debuggable ones.
          }
        });

        print('Are all conditions met ? ' +
            (rateMyApp.shouldOpenDialog ? 'Yes' : 'No'));

        if (rateMyApp.shouldOpenDialog) {
          rateMyApp.showRateDialog(
            context,
            title: S.of(context).rate_this_app,
            message: S.of(context).rate_this_app_desc,
            laterButton: S.of(context).maybe_later,
            rateButton: S.of(context).rate,
            noButton: S.of(context).no_thanks,
          );
        }
      },
      builder: (context) => Stack(
        children: [
          BlocBuilder<AppBloc, AppState>(
            builder: (context, appBlocState) {
              if (appBlocState is LoadingState) {
                return _getSplashScreen();
              } else if (appBlocState is LoadedState) {
                return Scaffold(
                  appBar: _buildAppBar(appBlocState.selectedIndex,
                      appBlocState.recipeCategoryOverview, appBlocState.title),
                  floatingActionButton: appBlocState.selectedIndex == 0
                      ? BlocBuilder<RecipeModsBloc, RecipeModsState>(
                          builder: (context, recipeModsState) {
                          if (recipeModsState is UnblockModsState) {
                            return FloatingActionButtonMenu(
                              _introKeyOne,
                              _introKeyTwo,
                              _introKeyThree,
                              showIntro: showIntro,
                              shoppingCartAdd: appBlocState.selectedIndex == 2
                                  ? true
                                  : false,
                            );
                          } else {
                            return FloatingActionButton(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: SpinningSyncIcon(),
                              onPressed: () {},
                            );
                          }
                        })
                      : appBlocState.selectedIndex == 2
                          ? FloatingActionButton(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Icon(Icons.add_shopping_cart,
                                  color: Colors.white),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => BlocProvider.value(
                                    value: BlocProvider.of<ShoppingCartBloc>(
                                        context),
                                    child: ShoppingCartAddDialog(),
                                  ),
                                );
                              },
                            )
                          : null,
                  body: Row(
                    children: ([
                      MediaQuery.of(context).size.width > GC.sideBarWidth
                          ? VerticalSideBar(
                              appBlocState.selectedIndex == 2
                                  ? 0
                                  : appBlocState.selectedIndex,
                              appBlocState.shoppingCartOpen,
                              appBlocState.recipeCalendarOpen,
                            )
                          : null,
                      Expanded(
                        child: IndexedStack(
                          index: appBlocState.selectedIndex,
                          children: [
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              child: appBlocState.recipeCategoryOverview == true
                                  ? RecipeCategoryOverview()
                                  : CategoryGridView(),
                            ),
                            FavoriteScreen(),
                            MediaQuery.of(context).size.width <= GC.sideBarWidth
                                ? FancyShoppingCartScreen(shoppingCartImage)
                                : Container(),
                            SwypingCardsScreen(),
                            Settings(),
                          ],
                        ),
                      ),
                    ].whereType<Widget>().toList()),
                  ),
                  backgroundColor:
                      _getBackgroundColor(appBlocState.selectedIndex),
                  bottomNavigationBar: MediaQuery.of(context).size.width <=
                          GC.sideBarWidth
                      ? MediaQuery.of(context).size.width < 346
                          ? BottomNavigationBar(
                              backgroundColor: Color(0xff232323),
                              currentIndex: appBlocState.selectedIndex,
                              onTap: (index) => _onItemTapped(index, context),
                              items: [
                                BottomNavigationBarItem(
                                  icon: Icon(MdiIcons.notebook),
                                  label: S.of(context).recipes,
                                  activeIcon: Icon(
                                    MdiIcons.notebook,
                                    color: Colors.orange,
                                  ),
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.favorite),
                                  label: S.of(context).favorites,
                                  activeIcon: Icon(
                                    Icons.favorite,
                                    color: Colors.pink,
                                  ),
                                ),
                                BottomNavigationBarItem(
                                    icon: Icon(Icons.shopping_basket),
                                    label: S.of(context).basket,
                                    activeIcon: Icon(
                                      Icons.shopping_basket,
                                      color: Colors.brown[300],
                                    )),
                                BottomNavigationBarItem(
                                  icon: Icon(MdiIcons.diceMultiple),
                                  label: S.of(context).explore,
                                  activeIcon: Icon(
                                    MdiIcons.diceMultiple,
                                    color: Colors.green,
                                  ),
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.settings),
                                  label: S.of(context).settings,
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
                                selectedIndex: appBlocState.selectedIndex,
                                showElevation: true,
                                onItemSelected: (index) =>
                                    _onItemTapped(index, context),
                                items: [
                                  BottomNavyBarItem(
                                      icon: Icon(MdiIcons.notebook),
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
                                    icon: Icon(MdiIcons.diceMultiple),
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
                            )
                      : null,
                );
              } else {
                return Text(appBlocState.toString());
              }
            },
          ),
          RecipeBubbles(),
          MediaQuery.of(context).size.width > GC.sideBarWidth
              ? ShoppingCartFloating(
                  initialPosition: Offset(
                    200,
                    200,
                  ),
                )
              : null,
          MediaQuery.of(context).size.width > GC.recipeCalendarFloatingWidth
              ? RecipeCalendarFloating(
                  initialPosition: Offset(
                    200,
                    45,
                  ),
                )
              : null,
        ].whereType<Widget>().toList(),
      ),
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

  AppBar? _buildAppBar(
      int currentIndex, bool recipeCategoryOverview, String title) {
    // if shoppingCartPage with sliverAppBar

    if (currentIndex == 2) {
      return null;
    } else if (currentIndex == 3 && MediaQuery.of(context).size.height < 730)
      return null;
    else {
      return AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffAF1E1E), Color(0xff641414)]),
            ),
          ),
          title: Text(title),
          actions: ([
            MediaQuery.of(context).size.width > GC.sideBarWidth
                ? null
                : IconButton(
                    icon: Icon(Icons.calendar_today_rounded),
                    onPressed: () {
                      BlocProvider.of<RecipeCalendarBloc>(context)
                          .add(ChangeSelectedDateEvent(DateTime.now()));
                      if (MediaQuery.of(context).size.width >
                          GC.recipeCalendarFloatingWidth) {
                        BlocProvider.of<AppBloc>(context).add(
                          ChangeRecipeCalendarView(true),
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          RouteNames.recipeCalendar,
                          arguments: RecipeCalendarScreenArguments(
                            BlocProvider.of<RecipeCalendarBloc>(context),
                            BlocProvider.of<ShoppingCartBloc>(context),
                          ),
                        ).then((_) => Ads.hideBottomBannerAd());
                      }
                    }),
            IconButton(
              icon: Icon(MdiIcons.textBoxSearchOutline),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.ingredientSearch,
                  arguments: IngredientSearchScreenArguments(
                      BlocProvider.of<ShoppingCartBloc>(context),
                      BlocProvider.of<RecipeCalendarBloc>(context),
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
                      BlocProvider.of<RecipeCalendarBloc>(context),
                      HiveProvider().getRecipeTags(),
                      HiveProvider().getCategoryNames()..remove('no category'),
                    ));
              },
            ),
          ].whereType<Widget>().toList()));
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
      if (Theme.of(context).colorScheme.background == Colors.white) {
        return Theme.of(context).scaffoldBackgroundColor;
      } // if dark theme
      else if (Theme.of(context).colorScheme.background == Color(0xff212225)) {
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
  final GlobalKey _introKeyThree;
  final MyBooleanWrapper? showIntro;
  final bool shoppingCartAdd;

  FloatingActionButtonMenu(
    this._introKeyOne,
    this._introKeyTwo,
    this._introKeyThree, {
    this.shoppingCartAdd = false,
    this.showIntro,
    Key? key,
  }) : super(key: key);

  @override
  _FloatingActionButtonMenuState createState() =>
      _FloatingActionButtonMenuState();
}

class _FloatingActionButtonMenuState extends State<FloatingActionButtonMenu>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controllerFAB;
  static const List<IconData> icons = const [
    MdiIcons.apps,
    Icons.description,
  ];
  bool isOpen = false;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controllerFAB = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerFAB.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Column menu = Column(
        mainAxisSize: MainAxisSize.min,
        children: isOpen
            ? [
                Showcase.withWidget(
                  key: widget._introKeyThree,
                  height: 50,
                  width: 200,
                  container: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                              colors: [Colors.grey[300]!, Colors.white]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                              S.of(context).tap_here_to_manage_categories,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                  shapeBorder: CircleBorder(),
                  child: _getFloatingItem(() {
                    Navigator.pushNamed(
                      context,
                      RouteNames.manageCategories,
                    ).then((_) => Ads.hideBottomBannerAd());
                  }, Icon(MdiIcons.apps, color: Theme.of(context).primaryColor),
                      3, S.of(context).import_from_website),
                ),
                Showcase.withWidget(
                  key: widget._introKeyTwo,
                  height: 50,
                  width: 200,
                  container: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                              colors: [Colors.grey[300]!, Colors.white]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                              S.of(context).tap_here_to_import_recipe_online,
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
                        IO.clearCache();
                        Ads.loadRewardedVideo(true, () {}, () {}, () {});
                        Navigator.pushNamed(
                          context,
                          RouteNames.importFromWebsite,
                          arguments: ImportFromWebsiteArguments(
                            BlocProvider.of<ShoppingCartBloc>(context),
                            BlocProvider.of<RecipeCalendarBloc>(context),
                            BlocProvider.of<AdManagerBloc>(context),
                          ),
                        );
                      });
                    },
                    Icon(MdiIcons.cloudDownload,
                        color: Theme.of(context).primaryColor),
                    2,
                    S.of(context).manage_categories,
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
                              colors: [Colors.grey[300]!, Colors.white]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(S.of(context).tap_here_to_add_recipe,
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
                        IO.clearCache();
                        BlocProvider.of<AdManagerBloc>(context)
                            .add(LoadVideo());
                        Navigator.pushNamed(
                          context,
                          RouteNames.addRecipeGeneralInfo,
                          arguments: GeneralInfoArguments(
                            HiveProvider().getTmpRecipe(),
                            BlocProvider.of<ShoppingCartBloc>(context),
                            BlocProvider.of<RecipeCalendarBloc>(context),
                          ),
                        ).then((_) => Ads.hideBottomBannerAd());
                      });
                    },
                    Icon(Icons.edit, color: Theme.of(context).primaryColor),
                    1,
                    S.of(context).add_recipe,
                  ),
                ),
              ]
            : []);
    menu.children.add(
      FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        heroTag: null,
        child: AnimatedBuilder(
          animation: _controllerFAB,
          builder: (BuildContext context, Widget? child) {
            return Transform(
              transform: Matrix4.rotationZ(_controllerFAB.value * 0.5 * pi),
              alignment: FractionalOffset.center,
              child: Icon(
                _controllerFAB.isDismissed ? Icons.add : Icons.close,
                color: Colors.white,
              ),
            );
          },
        ),
        onPressed: () {
          if (_controller.isDismissed) {
            setState(() {
              if (widget.showIntro!.myBool!) {
                ShowCaseWidget.of(context).startShowCase([
                  widget._introKeyOne,
                  widget._introKeyTwo,
                  widget._introKeyThree,
                ]);
                widget.showIntro!.myBool = false;
              }
              isOpen = true;
              _controller.forward();
              _controllerFAB.forward();
            });
          } else {
            setState(() {
              _controller.reverse();
              _controllerFAB.reverse();
              Future.delayed(Duration(milliseconds: 300))
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
          curve:
              Interval(0.0, index / icons.length / 2.0, curve: Curves.easeOut),
        ),
        child: FloatingActionButton(
          tooltip: tooltip,
          heroTag: null,
          backgroundColor: Colors.white,
          mini: true,
          child: icon,
          onPressed: () {
            _controller.reverse();
            _controllerFAB.reverse();
            onTap();
          },
        ),
      ),
    );
  }
}

class RecipeBubbles extends StatelessWidget {
  const RecipeBubbles({Key? key}) : super(key: key);

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
  final Color? backgroundColor;
  final bool showElevation;
  final Duration animationDuration;
  final List<BottomNavyBarItem> items;
  final ValueChanged<int> onItemSelected;
  final MainAxisAlignment mainAxisAlignment;
  final double itemCornerRadius;
  final Curve curve;

  BottomNavyBar({
    Key? key,
    this.selectedIndex = 0,
    this.showElevation = true,
    this.iconSize = 24,
    this.backgroundColor,
    this.itemCornerRadius = 50,
    this.animationDuration = const Duration(milliseconds: 270),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    required this.items,
    required this.onItemSelected,
    this.curve = Curves.linear,
  }) {
    assert(items.length >= 2 && items.length <= 5);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = (backgroundColor == null)
        ? Theme.of(context).bottomAppBarTheme.color
        : backgroundColor;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.black87, Colors.grey[900]!],
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
                  backgroundColor: bgColor!,
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
    Key? key,
    required this.item,
    required this.isSelected,
    required this.backgroundColor,
    required this.animationDuration,
    required this.itemCornerRadius,
    required this.iconSize,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: isSelected ? 130 : 50,
      height: double.maxFinite,
      duration: animationDuration,
      curve: curve,
      decoration: BoxDecoration(
        color: isSelected
            ? item.activeColor!.withOpacity(0.2)
            : Colors.transparent,
        gradient: LinearGradient(
          colors: isSelected
              ? [
                  item.activeColor!,
                  item.activeColor!.withOpacity(0.8),
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
                      ? item.activeColor!.withOpacity(1)
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
  final Color? activeColor;
  final Color? inactiveColor;
  final TextAlign? textAlign;

  BottomNavyBarItem({
    required this.icon,
    required this.title,
    this.activeColor = Colors.blue,
    this.textAlign,
    this.inactiveColor,
  });
}
