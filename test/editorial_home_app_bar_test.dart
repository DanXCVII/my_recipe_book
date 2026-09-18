import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_theme.dart';
import 'package:my_recipe_book/widgets/editorial_home_app_bar.dart';

void main() {
  testWidgets(
    'keeps recipe search and layout visible and dispatches overflow',
    (tester) async {
      var searchTaps = 0;
      var layoutTaps = 0;
      var plannerTaps = 0;
      var ingredientTaps = 0;
      var syncTaps = 0;

      await _pumpHeader(
        tester,
        onSearch: () => searchTaps++,
        onLayout: () => layoutTaps++,
        onPlanner: () => plannerTaps++,
        onIngredientSearch: () => ingredientTaps++,
        onSync: () => syncTaps++,
      );

      expect(find.text('Recipes'), findsOneWidget);
      expect(find.byKey(const Key('editorial-home-search')), findsOneWidget);
      expect(
        find.byKey(const Key('editorial-home-layout-toggle')),
        findsOneWidget,
      );
      expect(find.byTooltip('Search recipes'), findsOneWidget);
      expect(find.byTooltip('Grid'), findsOneWidget);

      for (final key in [
        const Key('editorial-home-search'),
        const Key('editorial-home-layout-toggle'),
        const Key('editorial-home-overflow'),
      ]) {
        final size = tester.getSize(find.byKey(key));
        expect(size.width, greaterThanOrEqualTo(48));
        expect(size.height, greaterThanOrEqualTo(48));
      }

      await tester.tap(find.byKey(const Key('editorial-home-search')));
      await tester.tap(find.byKey(const Key('editorial-home-layout-toggle')));
      expect(searchTaps, 1);
      expect(layoutTaps, 1);

      await tester.tap(find.byKey(const Key('editorial-home-overflow')));
      await tester.pumpAndSettle();
      expect(find.text('Meal planner'), findsOneWidget);
      expect(find.text('Ingredient search'), findsOneWidget);
      expect(find.text('Sync recipes with Google Drive'), findsOneWidget);

      await tester.tap(find.byKey(const Key('editorial-home-meal-planner')));
      await tester.pumpAndSettle();
      expect(plannerTaps, 1);

      await tester.tap(find.byKey(const Key('editorial-home-overflow')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('editorial-home-ingredient-search')),
      );
      await tester.pumpAndSettle();
      expect(ingredientTaps, 1);

      await tester.tap(find.byKey(const Key('editorial-home-overflow')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('editorial-home-drive-sync')));
      await tester.pumpAndSettle();
      expect(syncTaps, 1);
    },
  );

  testWidgets(
    'adapts the visible and overflow actions for Explore and wide UI',
    (tester) async {
      await _pumpHeader(
        tester,
        title: 'Roll the dice',
        showLayoutToggle: false,
        showMealPlanner: false,
        showDriveSync: false,
      );

      expect(find.text('Roll the dice'), findsOneWidget);
      expect(find.byKey(const Key('editorial-home-search')), findsOneWidget);
      expect(
        find.byKey(const Key('editorial-home-layout-toggle')),
        findsNothing,
      );

      await tester.tap(find.byKey(const Key('editorial-home-overflow')));
      await tester.pumpAndSettle();
      expect(find.text('Ingredient search'), findsOneWidget);
      expect(find.text('Meal planner'), findsNothing);
      expect(find.text('Sync recipes with Google Drive'), findsNothing);
    },
  );

  testWidgets('describes the destination when switching category layouts', (
    tester,
  ) async {
    await _pumpHeader(tester);
    expect(find.byTooltip('Grid'), findsOneWidget);

    await _pumpHeader(tester, categoryOverview: false);
    expect(find.byTooltip('Show overview'), findsOneWidget);
  });

  testWidgets('shows Drive progress and disables a duplicate sync request', (
    tester,
  ) async {
    var syncTaps = 0;
    await _pumpHeader(tester, syncInProgress: true, onSync: () => syncTaps++);

    expect(
      find.byKey(const Key('editorial-home-sync-progress')),
      findsOneWidget,
    );
    expect(find.byTooltip('Syncing recipes with Google Drive'), findsOneWidget);

    await tester.tap(find.byKey(const Key('editorial-home-overflow')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    final syncItem = tester.widget<PopupMenuItem<int>>(
      find.byKey(const Key('editorial-home-drive-sync')),
    );
    expect(syncItem.enabled, isFalse);
    await tester.tap(find.text('Syncing recipes with Google Drive'));
    await tester.pump();
    expect(syncTaps, 0);
  });

  testWidgets('fits German text at 130% in light, dark, and OLED themes', (
    tester,
  ) async {
    for (final background in [
      CulinaryEditorialPalette.light.background,
      CulinaryEditorialPalette.dark.background,
      Colors.black,
    ]) {
      await _pumpHeader(
        tester,
        locale: const Locale('de', 'DE'),
        textScale: 1.3,
        width: 320,
        scaffoldBackgroundColor: background,
      );

      expect(find.text('Rezepte'), findsOneWidget);
      expect(tester.takeException(), isNull);
      final appBar = tester.widget<AppBar>(
        find.byKey(const Key('editorial-home-app-bar')),
      );
      expect(
        appBar.backgroundColor,
        background == Colors.black
            ? CulinaryEditorialPalette.oled.background
            : background,
      );
    }
  });
}

Future<void> _pumpHeader(
  WidgetTester tester, {
  String? title,
  bool showLayoutToggle = true,
  bool categoryOverview = true,
  bool showMealPlanner = true,
  bool showDriveSync = true,
  bool syncInProgress = false,
  Locale locale = const Locale('en'),
  double textScale = 1,
  double width = 430,
  Color scaffoldBackgroundColor = const Color(0xFFFAF7F2),
  VoidCallback? onSearch,
  VoidCallback? onLayout,
  VoidCallback? onPlanner,
  VoidCallback? onIngredientSearch,
  VoidCallback? onSync,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 900);
  addTearDown(tester.view.reset);

  final brightness = scaffoldBackgroundColor.computeLuminance() < .2
      ? Brightness.dark
      : Brightness.light;
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        brightness: brightness,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
      ),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        );
      },
      home: Builder(
        builder: (context) => Scaffold(
          appBar: EditorialHomeAppBar(
            title: title ?? S.of(context).recipes,
            syncInProgress: syncInProgress,
            overflowTooltip: syncInProgress
                ? S.of(context).syncing_recipes_drive
                : S.of(context).recipe_more_actions,
            visibleActions: [
              EditorialHomeAppBarAction(
                key: const Key('editorial-home-search'),
                icon: Icons.search_rounded,
                tooltip: S.of(context).shopping_search_recipes,
                onPressed: onSearch ?? () {},
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
                  onPressed: onLayout ?? () {},
                ),
            ],
            overflowActions: [
              if (showMealPlanner)
                EditorialHomeOverflowAction(
                  key: const Key('editorial-home-meal-planner'),
                  icon: Icons.calendar_today_rounded,
                  label: S.of(context).recipe_planer,
                  onSelected: onPlanner ?? () {},
                ),
              EditorialHomeOverflowAction(
                key: const Key('editorial-home-ingredient-search'),
                icon: MdiIcons.textBoxSearchOutline,
                label: S.of(context).ingredient_search_title,
                onSelected: onIngredientSearch ?? () {},
              ),
              if (showDriveSync)
                EditorialHomeOverflowAction(
                  key: const Key('editorial-home-drive-sync'),
                  icon: Icons.sync_rounded,
                  label: syncInProgress
                      ? S.of(context).syncing_recipes_drive
                      : S.of(context).sync_recipes_drive,
                  onSelected: syncInProgress ? null : onSync ?? () {},
                ),
            ],
          ),
        ),
      ),
    ),
  );
  if (syncInProgress) {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  } else {
    await tester.pumpAndSettle();
  }
}
