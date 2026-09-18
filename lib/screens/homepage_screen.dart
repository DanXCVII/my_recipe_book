import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:my_recipe_book/blocs/recipe_mods/recipe_mods_bloc.dart';
import 'package:rate_my_app/rate_my_app.dart';

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
import '../constants/brand_assets.dart';
import '../constants/routes.dart';
import '../generated/l10n.dart';
import '../local_storage/local_repository.dart';
import '../local_storage/io_operations.dart' as IO;
import '../models/import_candidate.dart';
import '../services/import_file_stager.dart';
import '../services/incoming_content_service.dart';
import '../widgets/dialogs/import_dialog.dart';
import '../widgets/culinary_editorial_theme.dart';
import '../widgets/culinary_editorial_navigation_rail.dart';
import '../widgets/editorial_home_app_bar.dart';
import '../widgets/floating_home_navigation_bar.dart';
import '../widgets/home_navigation_destination.dart';
import '../widgets/recipe_bubble.dart';
import '../widgets/recipe_calendar_floating.dart';
import '../widgets/recipe_creation_fab_menu.dart';
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
import 'recipe_search_screen.dart';

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
  final BuildContext context;
  final bool? showShoppingCartSummary;
  final bool? recipeCategoryOverview;

  MyHomePageArguments(
    this.context,
    this.showShoppingCartSummary,
    this.recipeCategoryOverview,
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    this.incomingContentService,
    this.importFileStager,
  });

  final IncomingContentService? incomingContentService;
  final ImportFileStager? importFileStager;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  Future<SharedPreferences>? prefs;
  Image? shoppingCartImage;

  Flushbar? _flush;
  late final IncomingContentService _incomingContentService;
  late final ImportFileStager _importFileStager;
  StreamSubscription<List<IncomingContent>>? _incomingContentSubscription;
  Future<void> _incomingContentQueue = Future<void>.value();
  final Map<String, DateTime> _recentIncomingContent = {};

  @override
  void initState() {
    super.initState();
    shoppingCartImage = Image.asset('images/cuisine.jpg', fit: BoxFit.cover);
    _incomingContentService =
        widget.incomingContentService ?? ReceiveSharingIncomingContentService();
    _importFileStager = widget.importFileStager ?? ImportFileStager();
    _incomingContentSubscription = _incomingContentService.contentStream.listen(
      _enqueueIncomingContent,
      onError: (_) => _showIncomingContentError(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialIncomingContent();
    });
  }

  @override
  void dispose() {
    _incomingContentSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialIncomingContent() async {
    try {
      _enqueueIncomingContent(
        await _incomingContentService.getInitialContent(),
      );
    } catch (_) {
      _showIncomingContentError();
    }
  }

  void _enqueueIncomingContent(List<IncomingContent> content) {
    if (content.isEmpty) return;
    _incomingContentQueue = _incomingContentQueue
        .then((_) => _processIncomingContent(content))
        .catchError((_) => _showIncomingContentError());
  }

  Future<void> _processIncomingContent(List<IncomingContent> content) async {
    try {
      for (final item in content) {
        if (!mounted || _isDuplicateIncomingContent(item)) continue;
        switch (item.type) {
          case IncomingContentType.recipeFile:
            await _openIncomingRecipeFile(item);
          case IncomingContentType.websiteUrl:
            await _openIncomingWebsite(item.value);
          case IncomingContentType.unsupported:
            _showIncomingContentError();
        }
      }
    } finally {
      await _incomingContentService.reset();
    }
  }

  bool _isDuplicateIncomingContent(IncomingContent content) {
    final now = DateTime.now();
    _recentIncomingContent.removeWhere(
      (_, receivedAt) =>
          now.difference(receivedAt) > const Duration(seconds: 5),
    );
    if (_recentIncomingContent.containsKey(content.identity)) return true;
    _recentIncomingContent[content.identity] = now;
    return false;
  }

  Future<void> _openIncomingRecipeFile(IncomingContent content) async {
    try {
      final candidate = await _importFileStager.stage(
        sourcePath: content.value,
        originalFileName: content.originalFileName,
        mimeType: content.mimeType,
        source: ImportSource.externalApp,
      );
      if (!mounted) return;
      final importRecipeBloc = context.read<ImportRecipeBloc>()
        ..add(
          StartImportRecipes(
            candidate,
            delay: const Duration(milliseconds: 300),
          ),
        );
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => BlocProvider<ImportRecipeBloc>.value(
          value: importRecipeBloc,
          child: ImportDialog(closeAfterFinished: false),
        ),
      );
    } catch (_) {
      _showIncomingContentError();
    }
  }

  Future<void> _openIncomingWebsite(String website) async {
    if (!mounted) return;
    BlocProvider.of<AdManagerBloc>(context).add(LoadVideo());
    await Navigator.pushNamed(
      context,
      RouteNames.importFromWebsite,
      arguments: ImportFromWebsiteArguments(
        BlocProvider.of<ShoppingCartBloc>(context),
        BlocProvider.of<RecipeCalendarBloc>(context),
        BlocProvider.of<AdManagerBloc>(context),
        initialWebsite: website,
      ),
    );
    Ads.hideBottomBannerAd();
  }

  void _showIncomingContentError() {
    if (!mounted) return;
    _showFlushInfo(
      S.of(context).failed_import,
      S.of(context).no_valid_import_file,
    );
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
                final isCompactLayout = !GC.usesHomeNavigationRail(
                  MediaQuery.sizeOf(context).width,
                );
                final destinations = _homeNavigationDestinations(context);
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
                            return RecipeCreationFabMenu(
                              busy: recipeModsState is! UnblockModsState,
                              busyLabel: S.of(context).syncing_recipes_drive,
                              onCreateManually: _createRecipeManually,
                              onImportFromWebsite: _importRecipeFromWebsite,
                            );
                          },
                        )
                      : null,
                  body: Row(
                    children: ([
                      !isCompactLayout
                          ? CulinaryEditorialNavigationRail(
                              selectedIndex: appBlocState.selectedIndex,
                              destinations: destinations,
                              onDestinationSelected: (index) =>
                                  _onItemTapped(index, context),
                              calendarOpen: appBlocState.recipeCalendarOpen,
                              onCalendarPressed: () =>
                                  context.read<AppBloc>().add(
                                    ChangeRecipeCalendarView(
                                      !appBlocState.recipeCalendarOpen,
                                    ),
                                  ),
                              calendarLabel: S.of(context).recipe_planer,
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
                            FancyShoppingCartScreen(shoppingCartImage),
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
                          destinations: destinations,
                        )
                      : null,
                );
              } else {
                return Text(appBlocState.toString());
              }
            },
          ),
          RecipeBubbles(),
          GC.usesHomeNavigationRail(MediaQuery.sizeOf(context).width)
              ? RecipeCalendarFloating(initialPosition: Offset(200, 45))
              : null,
        ].whereType<Widget>().toList(),
      ),
    );
  }

  Widget _getSplashScreen() {
    return Container(
      color: const Color(0xFF8E0038),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              BrandAssets.simplifiedLogo,
              fit: BoxFit.cover,
              height: 150,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(
    int currentIndex,
    bool recipeCategoryOverview,
    String title,
  ) {
    if (currentIndex == 1 ||
        currentIndex == 2 ||
        currentIndex == 3 ||
        currentIndex == 4) {
      return null;
    }

    return _HomeEditorialAppBar(
      title: title,
      showLayoutToggle: currentIndex == 0,
      categoryOverview: recipeCategoryOverview,
      showMealPlanner: !GC.usesHomeNavigationRail(
        MediaQuery.sizeOf(context).width,
      ),
      onSearch: _showRecipeSearch,
      onToggleLayout: () => _changeMainPageOverview(recipeCategoryOverview),
      onOpenMealPlanner: _openMealPlanner,
      onOpenIngredientSearch: _openIngredientSearch,
      onStartDriveSync: () =>
          context.read<GDriveSyncBloc>().add(GDriveStartSync(DateTime.now())),
    );
  }

  void _openMealPlanner() {
    Navigator.pushNamed(
      context,
      RouteNames.recipeCalendar,
      arguments: RecipeCalendarScreenArguments(
        context.read<RecipeCalendarBloc>(),
        context.read<ShoppingCartBloc>(),
      ),
    ).then((_) => Ads.hideBottomBannerAd());
  }

  void _openIngredientSearch() {
    Navigator.pushNamed(
      context,
      RouteNames.ingredientSearch,
      arguments: IngredientSearchScreenArguments(
        context.read<ShoppingCartBloc>(),
        context.read<RecipeCalendarBloc>(),
        context.read<AdManagerBloc>(),
        context.read<AdManagerBloc>().state is IsPurchased,
      ),
    );
  }

  void _showRecipeSearch() {
    openRecipeSearch(context);
  }

  void _createRecipeManually() {
    IO.clearCache();
    context.read<AdManagerBloc>().add(LoadVideo());
    Navigator.pushNamed(
      context,
      RouteNames.addRecipeGeneralInfo,
      arguments: GeneralInfoArguments(
        context.read<LocalRepository>().getTmpRecipe(),
        context.read<ShoppingCartBloc>(),
        context.read<RecipeCalendarBloc>(),
      ),
    ).then((_) => Ads.hideBottomBannerAd());
  }

  void _importRecipeFromWebsite() {
    IO.clearCache();
    Ads.loadRewardedVideo(true, () {}, () {}, () {});
    Navigator.pushNamed(
      context,
      RouteNames.importFromWebsite,
      arguments: ImportFromWebsiteArguments(
        context.read<ShoppingCartBloc>(),
        context.read<RecipeCalendarBloc>(),
        context.read<AdManagerBloc>(),
      ),
    );
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

  List<HomeNavigationDestination> _homeNavigationDestinations(
    BuildContext context,
  ) {
    return [
      HomeNavigationDestination(
        icon: MdiIcons.notebook,
        label: S.of(context).recipes,
      ),
      HomeNavigationDestination(
        icon: Icons.bookmark_rounded,
        label: S.of(context).favorites,
      ),
      HomeNavigationDestination(
        icon: Icons.shopping_basket,
        label: S.of(context).basket,
      ),
      HomeNavigationDestination(
        icon: MdiIcons.diceMultiple,
        label: S.of(context).explore,
      ),
      HomeNavigationDestination(
        icon: Icons.settings,
        label: S.of(context).settings,
      ),
    ];
  }
}

class _HomeEditorialAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _HomeEditorialAppBar({
    required this.title,
    required this.showLayoutToggle,
    required this.categoryOverview,
    required this.showMealPlanner,
    required this.onSearch,
    required this.onToggleLayout,
    required this.onOpenMealPlanner,
    required this.onOpenIngredientSearch,
    required this.onStartDriveSync,
  });

  final String title;
  final bool showLayoutToggle;
  final bool categoryOverview;
  final bool showMealPlanner;
  final VoidCallback onSearch;
  final VoidCallback onToggleLayout;
  final VoidCallback onOpenMealPlanner;
  final VoidCallback onOpenIngredientSearch;
  final VoidCallback onStartDriveSync;

  @override
  Size get preferredSize =>
      const Size.fromHeight(EditorialHomeAppBar.toolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GDriveSignInBloc, GDriveSignInState>(
      builder: (context, signInState) {
        return BlocBuilder<GDriveSyncBloc, GDriveSyncState>(
          builder: (context, syncState) {
            final signedIn = signInState is GDriveSignedIn;
            final syncing = _isSyncInProgress(syncState);
            return EditorialHomeAppBar(
              title: title,
              syncInProgress: signedIn && syncing,
              overflowTooltip: signedIn && syncing
                  ? S.of(context).syncing_recipes_drive
                  : S.of(context).recipe_more_actions,
              visibleActions: [
                EditorialHomeAppBarAction(
                  key: const Key('editorial-home-search'),
                  icon: Icons.search_rounded,
                  tooltip: S.of(context).shopping_search_recipes,
                  onPressed: onSearch,
                ),
                if (showLayoutToggle)
                  EditorialHomeAppBarAction(
                    key: const Key('editorial-home-layout-toggle'),
                    icon: categoryOverview
                        ? Icons.grid_view_rounded
                        : Icons.view_agenda_rounded,
                    tooltip: categoryOverview
                        ? S.of(context).grid_view
                        : S.of(context).show_overview,
                    onPressed: onToggleLayout,
                  ),
              ],
              overflowActions: [
                if (showMealPlanner)
                  EditorialHomeOverflowAction(
                    key: const Key('editorial-home-meal-planner'),
                    icon: Icons.calendar_today_rounded,
                    label: S.of(context).recipe_planer,
                    onSelected: onOpenMealPlanner,
                  ),
                EditorialHomeOverflowAction(
                  key: const Key('editorial-home-ingredient-search'),
                  icon: MdiIcons.textBoxSearchOutline,
                  label: S.of(context).ingredient_search_title,
                  onSelected: onOpenIngredientSearch,
                ),
                if (signedIn)
                  EditorialHomeOverflowAction(
                    key: const Key('editorial-home-drive-sync'),
                    icon: Icons.sync_rounded,
                    label: syncing
                        ? S.of(context).syncing_recipes_drive
                        : S.of(context).sync_recipes_drive,
                    onSelected: syncing ? null : onStartDriveSync,
                  ),
              ],
            );
          },
        );
      },
    );
  }

  bool _isSyncInProgress(GDriveSyncState state) {
    return state is GDriveSyncing ||
        state is GDriveImporting ||
        state is GDriveUploading ||
        state is GDriveCloudDeleting ||
        state is GDriveLocalDeleting ||
        state is GDriveCancellingSync;
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
