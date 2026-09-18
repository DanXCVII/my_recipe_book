import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/ad_manager/ad_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_calendar/recipe_calendar_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/screens/ingredient_search.dart';
import 'package:my_recipe_book/screens/ingredient_search_preview_screen.dart';

void main() {
  testWidgets('shows an honest read-only product demonstration on phones', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var purchaseRequested = false;

    await _pumpPreview(tester, onPurchase: () => purchaseRequested = true);

    expect(
      find.byKey(const Key('ingredient-search-preview-phone')),
      findsOneWidget,
    );
    expect(find.text('Cook from what you have'), findsOneWidget);
    expect(find.text('Spinach'), findsOneWidget);
    expect(find.text('Pasta'), findsOneWidget);
    expect(find.text('Tomatoes'), findsOneWidget);
    expect(find.text('Vegetarian'), findsOneWidget);
    expect(find.text('≤ 30 min'), findsOneWidget);
    expect(find.text('Effort ≤5'), findsOneWidget);
    expect(find.text('EXAMPLE MATCH'), findsOneWidget);
    expect(find.text('Creamy spinach pasta'), findsOneWidget);
    expect(find.byType(InputChip), findsNothing);
    expect(find.byType(FilterChip), findsNothing);
    expect(find.textContaining('aisle'), findsNothing);
    expect(find.textContaining('shopping list'), findsNothing);

    await tester.tap(
      find.byKey(const Key('ingredient-search-preview-purchase')),
    );
    expect(purchaseRequested, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('scrolls on a short phone without moving the purchase action', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 600));
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(() {
      tester.binding.setSurfaceSize(null);
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    await _pumpPreview(tester);

    final purchaseButton = find.byKey(
      const Key('ingredient-search-preview-purchase'),
    );
    expect(purchaseButton, findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Also included with Pro'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Also included with Pro'), findsOneWidget);
    expect(purchaseButton, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses the two-pane layout in German dark mode at large text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 900));
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(() {
      tester.binding.setSurfaceSize(null);
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    await _pumpPreview(
      tester,
      locale: const Locale('de', 'DE'),
      theme: ThemeData.dark(),
    );

    expect(
      find.byKey(const Key('ingredient-search-preview-tablet')),
      findsOneWidget,
    );
    expect(find.text('Koche mit dem, was da ist'), findsOneWidget);
    expect(find.text('Cremige Spinatpasta'), findsOneWidget);
    expect(find.text('Zutatensuche freischalten'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses a true-black canvas in OLED mode', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pumpPreview(
      tester,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
    );

    final scaffold = tester.widget<Scaffold>(
      find.byKey(const Key('ingredient-search-preview-screen')),
    );
    expect(scaffold.backgroundColor, Colors.black);
    expect(tester.takeException(), isNull);
  });

  testWidgets('successful purchase swaps directly to ingredient search', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final database = AppDatabase(NativeDatabase.memory());
    final repository = DriftRepository(database: database);
    await repository.initialize();
    final recipeManager = RecipeManagerBloc(repository);
    final shoppingCart = ShoppingCartBloc(recipeManager, repository);
    final recipeCalendar = RecipeCalendarBloc(recipeManager, repository);
    final adManager = _TestAdManagerBloc();

    addTearDown(() async {
      await adManager.close();
      await shoppingCart.close();
      await recipeCalendar.close();
      await recipeManager.close();
      await database.close();
    });

    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<LocalRepository>.value(value: repository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<RecipeManagerBloc>.value(value: recipeManager),
            BlocProvider<Bloc<AdManagerEvent, AdManagerState>>.value(
              value: adManager,
            ),
          ],
          child: _LocalizedApp(
            home: IngredientSearchAccessGate(
              repository: repository,
              arguments: IngredientSearchScreenArguments(
                shoppingCart,
                recipeCalendar,
                adManager,
                false,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('ingredient-search-preview-screen')),
      findsOneWidget,
    );
    await tester.tap(
      find.byKey(const Key('ingredient-search-preview-purchase')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('ingredient-search-preview-screen')),
      findsNothing,
    );
    expect(find.byKey(const Key('ingredient-search-input')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpPreview(
  WidgetTester tester, {
  VoidCallback? onPurchase,
  Locale locale = const Locale('en'),
  ThemeData? theme,
}) async {
  await tester.pumpWidget(
    _LocalizedApp(
      locale: locale,
      theme: theme,
      home: IngredientSearchPreviewScreen(onPurchase: onPurchase ?? () {}),
    ),
  );
  await tester.pumpAndSettle();
}

class _LocalizedApp extends StatelessWidget {
  const _LocalizedApp({
    required this.home,
    this.locale = const Locale('en'),
    this.theme,
  });

  final Widget home;
  final Locale locale;
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      theme: theme ?? ThemeData.light(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: home,
    );
  }
}

class _TestAdManagerBloc extends Bloc<AdManagerEvent, AdManagerState> {
  _TestAdManagerBloc() : super(AdManagerInitial()) {
    on<PurchaseProVersion>((event, emit) => emit(IsPurchased()));
  }
}
