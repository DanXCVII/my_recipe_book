// ignore_for_file: depend_on_referenced_packages

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/app/app_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_calendar/recipe_calendar_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/screens/shopping_cart_fancy.dart';
import 'package:my_recipe_book/theming.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:wakelock_plus_platform_interface/wakelock_plus_platform_interface.dart';

void main() {
  late _CartHarness harness;
  late WakelockPlusPlatformInterface originalWakelock;
  late _TestWakelock testWakelock;

  void setTestView(WidgetTester tester, Size size) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'shoppingCartSummary': true,
      'recipeCalendarIsVertical': false,
    });
    originalWakelock = wakelockPlusPlatformInstance;
    testWakelock = _TestWakelock();
    wakelockPlusPlatformInstance = testWakelock;
    harness = await _CartHarness.create();
  });

  tearDown(() async {
    wakelockPlusPlatformInstance = originalWakelock;
    await harness.close();
  });

  testWidgets(
    'renders real cart data and supports view, serving, and quick add',
    (tester) async {
      await harness.seedPopulatedCart();
      setTestView(tester, const Size(430, 900));
      await harness.pump(tester);

      expect(find.text('Shopping list'), findsOneWidget);
      expect(find.text('Gathering for 2 recipes'), findsOneWidget);
      expect(find.text('0 of 2 items gathered'), findsOneWidget);
      expect(find.text('Carrot'), findsOneWidget);

      final recipeView = harness.app.stream
          .where((state) => state is LoadedState)
          .cast<LoadedState>()
          .firstWhere((state) => !state.showShoppingCartSummary);
      await tester.tap(find.byKey(const Key('shopping-cart-recipe-view')));
      await tester.runAsync(() => recipeView);
      await tester.pumpAndSettle();
      expect(find.text('Soup'), findsAtLeastNWidgets(2));
      expect(find.text('Bread'), findsAtLeastNWidgets(2));

      await tester.tap(find.byKey(const Key('shopping-cart-adjust-servings')));
      await tester.pumpAndSettle();
      expect(find.text('Adjust servings'), findsNWidgets(2));
      final updated = harness.cart.stream
          .where((state) => state is LoadedShoppingCart)
          .cast<LoadedShoppingCart>()
          .firstWhere(
            (state) =>
                state.data.recipeSources
                    .singleWhere((source) => source.key == 'Soup')
                    .currentServings ==
                3,
          );
      await tester.tap(find.byTooltip('Increase servings').first);
      await tester.runAsync(() => updated);
      await tester.pumpAndSettle();
      expect(
        (await harness.repository.getShoppingCartData()).recipeSources
            .singleWhere((source) => source.key == 'Soup')
            .currentServings,
        3,
      );
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('shopping-cart-plain-view')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('shopping-cart-quick-add')),
        'Olive oil',
      );
      await tester.pump();
      final added = harness.cart.stream
          .where((state) => state is LoadedShoppingCart)
          .cast<LoadedShoppingCart>()
          .firstWhere(
            (state) => state.data.consolidatedItems.any(
              (item) => item.name == 'Olive oil',
            ),
          );
      await tester.tap(find.text('Add'));
      await tester.runAsync(() => added);
      await tester.pumpAndSettle();
      expect(find.text('Olive oil'), findsOneWidget);
      expect(find.text('0 of 3 items gathered'), findsOneWidget);
      final oneOffItem = find.ancestor(
        of: find.text('Olive oil'),
        matching: find.byType(Dismissible),
      );
      expect(
        tester.getCenter(find.text('Olive oil')).dy,
        closeTo(tester.getCenter(oneOffItem).dy, 0.5),
      );

      await tester.tap(find.byTooltip('More shopping-list actions'));
      await tester.pumpAndSettle();
      expect(find.text('Search recipes'), findsOneWidget);
      expect(find.text('Shoppingcart help'), findsOneWidget);
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byTooltip('Add ingredient with amount, unit, or recipe'),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('shopping-cart-add-sheet')), findsOneWidget);
      expect(find.text('Add ingredient'), findsOneWidget);
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'detailed add recommends local data and keeps the selected recipe for repeat entry',
    (tester) async {
      await harness.seedPopulatedCart();
      setTestView(tester, const Size(430, 900));
      await harness.pump(tester);

      await tester.tap(
        find.byTooltip('Add ingredient with amount, unit, or recipe'),
      );
      await tester.pumpAndSettle();

      final ingredientField = find.byKey(const Key('shopping-cart-add-name'));
      await tester.enterText(ingredientField, 'arr');
      await tester.pump();
      expect(
        find.byKey(const ValueKey('shopping-suggestion-Carrot')),
        findsOneWidget,
      );

      await tester.enterText(ingredientField, 'Flat-leaf parsley');
      final recipeField = find.byKey(const Key('shopping-cart-add-recipe'));
      await tester.ensureVisible(recipeField);
      await tester.enterText(recipeField, 'so');
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('shopping-suggestion-Soup')));
      await tester.pump();
      expect(find.text('LINKED RECIPE'), findsOneWidget);

      final added = harness.cart.stream
          .where((state) => state is LoadedShoppingCart)
          .cast<LoadedShoppingCart>()
          .firstWhere(
            (state) => state.data.recipeSources.any(
              (source) =>
                  source.key == 'Soup' &&
                  source.items.any((item) => item.name == 'Flat-leaf parsley'),
            ),
          );
      final addAnother = find.byKey(const Key('shopping-cart-add-another'));
      await tester.ensureVisible(addAnother);
      await tester.tap(addAnother);
      await tester.runAsync(() => added);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('shopping-cart-add-sheet')), findsOneWidget);
      expect(
        find.text('Added Flat-leaf parsley to your shopping list'),
        findsOneWidget,
      );
      expect(find.text('LINKED RECIPE'), findsOneWidget);
      expect(
        tester.widget<TextFormField>(ingredientField).controller!.text,
        isEmpty,
      );
      expect(
        tester.widget<TextFormField>(recipeField).controller!.text,
        'Soup',
      );
    },
  );

  testWidgets(
    'detailed add validates amount and requires selecting a saved recipe',
    (tester) async {
      await harness.seedPopulatedCart();
      setTestView(tester, const Size(430, 900));
      await harness.pump(tester);

      await tester.tap(
        find.byTooltip('Add ingredient with amount, unit, or recipe'),
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('shopping-cart-add-name')),
        'Olives',
      );
      await tester.enterText(
        find.byKey(const Key('shopping-cart-add-amount')),
        'many',
      );
      final submit = find.byKey(const Key('shopping-cart-add-submit'));
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pump();
      expect(find.text('No valid number'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('shopping-cart-add-amount')),
        '2',
      );
      await tester.enterText(
        find.byKey(const Key('shopping-cart-add-recipe')),
        'Invented recipe',
      );
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pump();
      expect(
        find.text(
          'Select a saved recipe from the suggestions or clear this field',
        ),
        findsOneWidget,
      );
      expect(find.byKey(const Key('shopping-cart-add-sheet')), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('shopping-cart-add-recipe')),
        '',
      );
      final added = harness.cart.stream
          .where((state) => state is LoadedShoppingCart)
          .cast<LoadedShoppingCart>()
          .firstWhere(
            (state) => state.data.consolidatedItems.any(
              (item) => item.name == 'Olives' && item.amount == 2,
            ),
          );
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.runAsync(() => added);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('shopping-cart-add-sheet')), findsNothing);
      expect(
        (await harness.repository.getShoppingCartData()).recipeSources.any(
          (source) => source.displayName == 'Invented recipe',
        ),
        isFalse,
      );
    },
  );

  testWidgets('detailed add uses a dialog at expanded widths', (tester) async {
    setTestView(tester, const Size(800, 900));
    await harness.pump(tester);

    await tester.tap(
      find.byTooltip('Add ingredient with amount, unit, or recipe'),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('shopping-cart-add-dialog')), findsOneWidget);
    expect(find.byKey(const Key('shopping-cart-add-sheet')), findsNothing);
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
  });

  testWidgets('German detailed add remains usable at narrow 130% text', (
    tester,
  ) async {
    setTestView(tester, const Size(320, 780));
    await harness.pump(
      tester,
      locale: const Locale('de', 'DE'),
      textScale: 1.3,
    );

    await tester.tap(
      find.byTooltip('Zutat mit Menge, Einheit oder Rezept hinzufügen'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Zutat hinzufügen'), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(const Key('shopping-cart-add-another')),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('removes checked items with confirmation and immediate undo', (
    tester,
  ) async {
    await harness.seedPopulatedCart();
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await harness.pump(tester);

    final checked = harness.cart.stream
        .where((state) => state is LoadedShoppingCart)
        .cast<LoadedShoppingCart>()
        .firstWhere((state) => state.data.consolidatedItems.first.checked);
    await tester.tap(find.text('Carrot'));
    await tester.runAsync(() => checked);
    await tester.pumpAndSettle();
    expect(find.text('1 of 2 items gathered'), findsOneWidget);
    final progressTrack = tester.getRect(
      find.byKey(const Key('shopping-cart-progress-track')),
    );
    final progressFill = tester.getRect(
      find.byKey(const Key('shopping-cart-progress-fill')),
    );
    expect(progressFill.left, closeTo(progressTrack.left, 0.01));
    expect(progressFill.width, closeTo(progressTrack.width / 2, 0.5));

    await tester.tap(find.byTooltip('Remove checked items'));
    await tester.pumpAndSettle();
    expect(find.text('Remove gathered items?'), findsOneWidget);
    final removed = harness.cart.stream
        .where((state) => state is LoadedShoppingCart)
        .cast<LoadedShoppingCart>()
        .firstWhere((state) => state.undoSnapshot != null);
    await tester.tap(find.text('Remove checked items').last);
    await tester.runAsync(() => removed);
    await tester.pumpAndSettle();
    expect(find.text('Carrot'), findsNothing);
    expect(find.text('1 item removed'), findsOneWidget);

    final restored = harness.cart.stream
        .where((state) => state is LoadedShoppingCart)
        .cast<LoadedShoppingCart>()
        .firstWhere(
          (state) =>
              state.undoSnapshot == null &&
              state.data.consolidatedItems.any((item) => item.name == 'Carrot'),
        );
    await tester.tap(find.text('Undo'));
    await tester.runAsync(() => restored);
    await tester.pumpAndSettle();
    expect(find.text('Carrot'), findsOneWidget);
  });

  testWidgets('empty German layout remains usable at narrow 130% text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 780));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await harness.pump(
      tester,
      locale: const Locale('de', 'DE'),
      textScale: 1.3,
    );

    expect(find.text('EINKAUFSPLAN'), findsNothing);
    expect(find.text('Einkaufsliste'), findsOneWidget);
    expect(find.text('Deine Einkaufsliste ist leer'), findsOneWidget);
    expect(find.text('Einfache Liste'), findsOneWidget);
    expect(find.text('Nach Rezept'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('empty cart does not scroll when its content fits', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await harness.pump(tester);

    final scrollable = tester.state<ScrollableState>(
      find
          .descendant(
            of: find.byKey(const PageStorageKey('culinary-shopping-cart')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(scrollable.position.maxScrollExtent, 0);
  });

  testWidgets('keep-awake is released when leaving the shopping tab', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await harness.pump(tester);

    await tester.tap(find.byKey(const Key('shopping-cart-keep-awake')));
    await tester.pumpAndSettle();
    expect(testWakelock.enabledValue, isTrue);

    final context = tester.element(find.byType(FancyShoppingCartScreen));
    final leftShopping = harness.app.stream
        .where((state) => state is LoadedState)
        .cast<LoadedState>()
        .firstWhere((state) => state.selectedIndex == 0);
    harness.app.add(ChangeView(0, context));
    await tester.runAsync(() => leftShopping);
    await tester.pumpAndSettle();
    expect(testWakelock.enabledValue, isFalse);
  });

  testWidgets('populated cart supports dark and OLED themes', (tester) async {
    await harness.seedPopulatedCart();
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    for (final theme in [MyThemeKeys.DARK, MyThemeKeys.OLEDBLACK]) {
      await harness.pump(tester, themeKey: theme);
      expect(find.text('Shopping list'), findsOneWidget);
      expect(find.text('Carrot'), findsOneWidget);

      await tester.tap(
        find.byTooltip('Add ingredient with amount, unit, or recipe'),
      );
      await tester.pumpAndSettle();
      final palette = theme == MyThemeKeys.DARK
          ? CulinaryEditorialPalette.dark
          : CulinaryEditorialPalette.oled;
      for (final key in const [
        'shopping-cart-add-name',
        'shopping-cart-add-amount',
        'shopping-cart-add-unit',
        'shopping-cart-add-recipe',
      ]) {
        final editable = tester.widget<EditableText>(
          find.descendant(
            of: find.byKey(Key(key)),
            matching: find.byType(EditableText),
          ),
        );
        expect(editable.style.color, palette.onSurface);
        expect(editable.cursorColor, palette.primary);
      }
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('shows retry UI when initial cart loading fails', (tester) async {
    await harness.seedPopulatedCart();
    await harness.closeDatabase();
    await harness.pump(tester);

    expect(find.text('Your shopping list could not be loaded'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}

class _CartHarness {
  _CartHarness({
    required this.repository,
    required this.database,
    required this.manager,
    required this.cart,
    required this.calendar,
    required this.app,
  });

  final LocalRepository repository;
  final AppDatabase? database;
  final RecipeManagerBloc manager;
  final ShoppingCartBloc cart;
  final RecipeCalendarBloc calendar;
  final AppBloc app;
  bool _closed = false;
  bool _databaseClosed = false;

  static Future<_CartHarness> create() async {
    final database = AppDatabase(NativeDatabase.memory());
    final actualRepository = DriftRepository(database: database);
    await actualRepository.initialize();
    final manager = RecipeManagerBloc(actualRepository);
    return _CartHarness(
      repository: actualRepository,
      database: database,
      manager: manager,
      cart: ShoppingCartBloc(manager, actualRepository),
      calendar: RecipeCalendarBloc(manager, actualRepository),
      app: AppBloc(),
    );
  }

  Future<void> seedPopulatedCart() async {
    await repository.saveRecipe(Recipe(name: 'Soup', servings: 4));
    await repository.saveRecipe(Recipe(name: 'Bread', servings: 2));
    await repository.addIngredient('Carrot');
    await repository.addIngredient('Salt');
    await repository.addMultipleIngredientsToCart('Soup', const [
      Ingredient(name: 'Carrot', amount: 2, unit: 'pc'),
      Ingredient(name: 'Salt'),
    ], servings: 2);
    await repository.addMultipleIngredientsToCart('Bread', const [
      Ingredient(name: 'Carrot', amount: 1, unit: 'pc'),
    ], servings: 2);
  }

  Future<void> pump(
    WidgetTester tester, {
    Locale? locale,
    double textScale = 1,
    MyThemeKeys themeKey = MyThemeKeys.LIGHT,
  }) async {
    await tester.pumpWidget(
      CustomTheme(
        key: ValueKey(themeKey),
        initialThemeKey: themeKey,
        child: Builder(
          builder: (context) => RepositoryProvider<LocalRepository>.value(
            value: repository,
            child: BlocProvider.value(
              value: manager,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: CustomTheme.of(context),
                locale: locale,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(textScale)),
                  child: child!,
                ),
                home: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: cart),
                    BlocProvider.value(value: calendar),
                    BlocProvider.value(value: app),
                  ],
                  child: const Scaffold(body: FancyShoppingCartScreen(null)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    final context = tester.element(find.byType(FancyShoppingCartScreen));
    final initialized = app.stream
        .where((state) => state is LoadedState)
        .cast<LoadedState>()
        .first;
    app.add(InitializeData(context, true, true));
    await tester.runAsync(
      () => initialized.timeout(
        const Duration(seconds: 3),
        onTimeout: () => throw StateError('App initialization timed out'),
      ),
    );
    final shoppingTab = app.stream
        .where((state) => state is LoadedState)
        .cast<LoadedState>()
        .firstWhere((state) => state.selectedIndex == 2);
    app.add(ChangeView(2, context));
    await tester.runAsync(
      () => shoppingTab.timeout(
        const Duration(seconds: 3),
        onTimeout: () => throw StateError('Shopping-tab selection timed out'),
      ),
    );
    final loaded = cart.stream.firstWhere(
      (state) => state is LoadedShoppingCart || state is FailedShoppingCart,
    );
    cart.add(LoadShoppingCart());
    await tester.runAsync(
      () => loaded.timeout(
        const Duration(seconds: 3),
        onTimeout: () => throw StateError('Cart loading timed out'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await cart.close();
    await calendar.close();
    await manager.close();
    await app.close();
    if (!_databaseClosed) await database?.close();
  }

  Future<void> closeDatabase() async {
    if (_databaseClosed) return;
    await database!.close();
    _databaseClosed = true;
  }
}

class _TestWakelock extends WakelockPlusPlatformInterface {
  bool enabledValue = false;

  @override
  Future<bool> get enabled async => enabledValue;

  @override
  Future<void> toggle({required bool enable}) async {
    enabledValue = enable;
  }
}
