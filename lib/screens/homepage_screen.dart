import 'dart:io';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:my_recipe_book/blocs/recipe_mods/recipe_mods_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:showcaseview/showcaseview.dart';

import '../ad_related/ad.dart';
import '../blocs/ad_manager/ad_manager_bloc.dart';
import '../blocs/app/app_bloc.dart';
import '../blocs/g_drive/g_drive_sign_in/g_drive_sign_in_bloc.dart';
import '../blocs/g_drive/g_drive_sync/g_drive_bloc.dart';
import '../blocs/import_recipe/import_recipe_bloc.dart';
import '../blocs/recipe_bubble/recipe_bubble_bloc.dart';
import '../blocs/recipe_calendar/recipe_calendar_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as GC;
import '../constants/routes.dart';
import '../generated/l10n.dart';
import '../local_storage/local_repository.dart';
import '../local_storage/io_operations.dart' as IO;
import '../util/my_wrapper.dart';
import '../widgets/dialogs/import_dialog.dart';
import '../widgets/dialogs/info_dialog.dart';
import '../widgets/culinary_editorial_theme.dart';
import '../widgets/floating_home_navigation_bar.dart';
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

  MyHomePageState({String? title, bool? showIntro, Key? key}) {
    this.showIntro = MyBooleanWrapper(showIntro);
  }

  @override
  void initState() {
    super.initState();
    ShowcaseView.register();
    shoppingCartImage = Image.asset('images/cuisine.jpg', fit: BoxFit.cover);
    initializeIntent();

    // Listen to lifecycle events.
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ShowcaseView.get().unregister();
    super.dispose();
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
        _showFlushInfo(
          S.of(context).failed_import,
          "$error" + S.of(context).failed_import_desc,
        );
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
            ..add(
              StartImportRecipes(
                File(intentSharedText.toString()),
                delay: Duration(milliseconds: 300),
              ),
            ),
          child: ImportDialog(closeAfterFinished: false),
        ),
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
          initialWebsite: intentSharedText.toString(),
        ),
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
      _flush =
          Flushbar<bool>(
              animationDuration: Duration(milliseconds: 300),
              leftBarIndicatorColor: Colors.blue[300],
              title: title,
              message: body,
              icon: Icon(Icons.info_outline, color: Colors.blue),
              mainButton: TextButton(
                onPressed: () {
                  _flush!.dismiss(true); // result = true
                },
                child: Text("OK", style: TextStyle(color: Colors.amber)),
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
            print(condition.toString()); // We iterate through our list of conditions and we print all debuggable ones.
          }
        });

        print(
          'Are all conditions met ? ' +
              (rateMyApp.shouldOpenDialog ? 'Yes' : 'No'),
        );

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
                final isCompactLayout =
                    MediaQuery.sizeOf(context).width <= GC.sideBarWidth;
                return Scaffold(
                  extendBody: isCompactLayout,
                  appBar: _buildAppBar(
                    appBlocState.selectedIndex,
                    appBlocState.recipeCategoryOverview,
                    appBlocState.title,
                  ),
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
                          },
                        )
                      : null,
                  body: Row(
                    children: ([
                      !isCompactLayout
                          ? SafeArea(
                              left: false,
                              right: false,
                              bottom: false,
                              top: appBlocState.selectedIndex == 4,
                              child: VerticalSideBar(
                                appBlocState.selectedIndex == 2
                                    ? 0
                                    : appBlocState.selectedIndex,
                                appBlocState.shoppingCartOpen,
                                appBlocState.recipeCalendarOpen,
                              ),
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
                            isCompactLayout
                                ? FancyShoppingCartScreen(shoppingCartImage)
                                : Container(),
                            SwypingCardsScreen(),
                            Settings(),
                          ],
                        ),
                      ),
                    ].whereType<Widget>().toList()),
                  ),
                  backgroundColor: _getBackgroundColor(
                    appBlocState.selectedIndex,
                  ),
                  bottomNavigationBar: isCompactLayout
                      ? FloatingHomeNavigationBar(
                          selectedIndex: appBlocState.selectedIndex,
                          onDestinationSelected: (index) =>
                              _onItemTapped(index, context),
                          destinations: [
                            FloatingHomeNavigationDestination(
                              icon: MdiIcons.notebook,
                              label: S.of(context).recipes,
                            ),
                            FloatingHomeNavigationDestination(
                              icon: Icons.bookmark_rounded,
                              label: S.of(context).favorites,
                            ),
                            FloatingHomeNavigationDestination(
                              icon: Icons.shopping_basket,
                              label: S.of(context).basket,
                            ),
                            FloatingHomeNavigationDestination(
                              icon: MdiIcons.diceMultiple,
                              label: S.of(context).explore,
                            ),
                            FloatingHomeNavigationDestination(
                              icon: Icons.settings,
                              label: S.of(context).settings,
                            ),
                          ],
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
              ? ShoppingCartFloating(initialPosition: Offset(200, 200))
              : null,
          MediaQuery.of(context).size.width > GC.recipeCalendarFloatingWidth
              ? RecipeCalendarFloating(initialPosition: Offset(200, 45))
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
        ),
      ),
    );
  }

  AppBar? _buildAppBar(
    int currentIndex,
    bool recipeCategoryOverview,
    String title,
  ) {
    // if shoppingCartPage with sliverAppBar

    if (currentIndex == 1 || currentIndex == 2 || currentIndex == 4) {
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
              colors: [Color(0xffAF1E1E), Color(0xff641414)],
            ),
          ),
        ),
        title: Text(title),
        actions: ([
          BlocBuilder<GDriveSignInBloc, GDriveSignInState>(
            builder: (context, state) {
              if (state is GDriveSignedIn) {
                return BlocBuilder<GDriveSyncBloc, GDriveSyncState>(
                  builder: (context, state) {
                    if (state is GDriveIdle ||
                        state is GDriveSuccessfullySynced) {
                      return IconButton(
                        icon: Icon(Icons.sync),
                        onPressed: () {
                          BlocProvider.of<GDriveSyncBloc>(context)
                              .add(GDriveStartSync(DateTime.now()));
                        },
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SpinningSyncIcon(),
                      );
                    }
                  },
                );
              } else {
                return Container();
              }
            },
          ),
          MediaQuery.of(context).size.width > GC.sideBarWidth
              ? null
              : IconButton(
                  icon: Icon(Icons.calendar_today_rounded),
                  onPressed: () {
                    if (MediaQuery.of(context).size.width >
                        GC.recipeCalendarFloatingWidth) {
                      BlocProvider.of<AppBloc>(context)
                          .add(ChangeRecipeCalendarView(true));
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
                  },
                ),
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
                  BlocProvider.of<AdManagerBloc>(context).state is IsPurchased,
                ),
              );
            },
          ),
          currentIndex == 0
              ? IconButton(
                  icon: Icon(
                    recipeCategoryOverview ? Icons.grid_off : Icons.grid_on,
                  ),
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
                  context.read<LocalRepository>().getRecipeNames(),
                  BlocProvider.of<ShoppingCartBloc>(context),
                  BlocProvider.of<RecipeCalendarBloc>(context),
                  context.read<LocalRepository>().getRecipeTags(),
                  context.read<LocalRepository>().getCategoryNames()
                    ..remove('no category'),
                ),
              );
            },
          ),
        ].whereType<Widget>().toList()),
      );
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
      return CulinaryEditorialPalette.of(context).background;
    } else if (selectedIndex == 2) {
      return Theme.of(context).scaffoldBackgroundColor;
    } else if (selectedIndex == 4) {
      return CulinaryEditorialPalette.of(context).background;
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
  static List<IconData> icons = [MdiIcons.apps, Icons.description];
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
                container: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          colors: [Colors.grey[300]!, Colors.white],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          S.of(context).tap_here_to_manage_categories,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // shapeBorder: CircleBorder(),
                child: _getFloatingItem(
                  () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.manageCategories,
                    ).then((_) => Ads.hideBottomBannerAd());
                  },
                  Icon(MdiIcons.apps, color: Theme.of(context).primaryColor),
                  3,
                  S.of(context).import_from_website,
                ),
              ),
              Showcase.withWidget(
                key: widget._introKeyTwo,
                container: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: LinearGradient(
                          colors: [Colors.grey[300]!, Colors.white],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          S.of(context).tap_here_to_import_recipe_online,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // shapeBorder: CircleBorder(),
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
                  Icon(
                    MdiIcons.cloudDownload,
                    color: Theme.of(context).primaryColor,
                  ),
                  2,
                  S.of(context).manage_categories,
                ),
              ),
              Showcase.withWidget(
                key: widget._introKeyOne,
                container: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: LinearGradient(
                          colors: [Colors.grey[300]!, Colors.white],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          S.of(context).tap_here_to_add_recipe,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // shapeBorder: CircleBorder(),
                child: _getFloatingItem(
                  () {
                    getTemporaryDirectory().then((dir) {
                      IO.clearCache();
                      BlocProvider.of<AdManagerBloc>(context).add(LoadVideo());
                      Navigator.pushNamed(
                        context,
                        RouteNames.addRecipeGeneralInfo,
                        arguments: GeneralInfoArguments(
                          context.read<LocalRepository>().getTmpRecipe(),
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
          : [],
    );
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
                ShowcaseView.get().startShowCase([
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
              Future.delayed(Duration(milliseconds: 300)).then(
                (_) => setState(() {
                  isOpen = false;
                }),
              );
            });
          }
        },
      ),
    );
    return menu;
  }

  Widget _getFloatingItem(
    void Function() onTap,
    Icon icon,
    int index,
    String tooltip,
  ) {
    return Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.0,
            index / icons.length / 2.0,
            curve: Curves.easeOut,
          ),
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
