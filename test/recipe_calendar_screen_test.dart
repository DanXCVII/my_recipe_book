import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/recipe_calendar/recipe_calendar_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/screens/recipe_calendar_screen.dart';
import 'package:my_recipe_book/theming.dart';

void main() {
  late AppDatabase database;
  late DriftRepository repository;
  late RecipeManagerBloc manager;
  late RecipeCalendarBloc calendar;
  late ShoppingCartBloc cart;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRepository(database: database);
    await repository.initialize();
    await repository.saveRecipe(
      Recipe(
        name: 'Long simmered vegetable soup',
        servings: 4,
        effort: 3,
        totalTime: 45,
        vegetable: Vegetable.VEGAN,
        ingredients: const [
          [
            Ingredient(name: 'Carrot', amount: 2, unit: 'pc'),
            Ingredient(name: 'Salt'),
          ],
        ],
      ),
    );
    final monday = RecipeCalendarBloc.startOfWeek(DateTime.now());
    await repository.addRecipeToCalendar(
      monday.add(const Duration(hours: 18)),
      'Long simmered vegetable soup',
    );
    manager = RecipeManagerBloc(repository);
    calendar = RecipeCalendarBloc(manager, repository);
    cart = ShoppingCartBloc(manager, repository);
    final loaded = calendar.stream.firstWhere(
      (state) => state is LoadedRecipeCalendarWeek,
    );
    calendar.add(LoadRecipeCalendarEvent());
    await loaded;
  });

  tearDown(() async {
    await cart.close();
    await calendar.close();
    await manager.close();
    await database.close();
  });

  testWidgets('renders the editorial week and review-first export', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpCalendar(
      tester,
      repository: repository,
      manager: manager,
      calendar: calendar,
      cart: cart,
    );

    expect(find.text('Plan recipe'), findsOneWidget);
    expect(find.text('Long simmered vegetable soup'), findsOneWidget);
    expect(find.textContaining('1 meal'), findsWidgets);
    expect(find.text('Review & export'), findsOneWidget);

    await tester.tap(find.byKey(const Key('calendar-review-export')));
    await tester.pumpAndSettle();
    expect(find.text('Review shopping list'), findsOneWidget);
    expect(find.textContaining('Carrot'), findsOneWidget);
    expect(find.textContaining('Salt'), findsOneWidget);
    expect(find.text('2 ingredients selected'), findsOneWidget);

    await tester.tap(find.textContaining('Salt'));
    await tester.pump();
    expect(find.text('1 ingredient selected'), findsOneWidget);

    await tester.tap(find.textContaining('Carrot'));
    await tester.pump();
    expect(find.text('No ingredients selected'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('calendar-export-confirm')),
          )
          .onPressed,
      isNull,
    );
    await tester.tap(find.textContaining('Carrot'));
    await tester.pump();

    final exported = cart.stream
        .where((state) => state is LoadedShoppingCart)
        .cast<LoadedShoppingCart>()
        .first;
    await tester.tap(find.byKey(const Key('calendar-export-confirm')));
    await tester.runAsync(() => exported);
    await tester.pumpAndSettle();
    final source =
        (await repository.getShoppingCartData()).recipeSources.single;
    expect(source.items.map((item) => item.name), ['Carrot']);
    expect(find.text('Review shopping list'), findsNothing);
  });

  testWidgets('German OLED layout survives 130 percent text scale', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpCalendar(
      tester,
      repository: repository,
      manager: manager,
      calendar: calendar,
      cart: cart,
      locale: const Locale('de', 'DE'),
      themeKey: MyThemeKeys.OLEDBLACK,
      textScale: 1.3,
    );

    expect(find.text('Rezept einplanen'), findsOneWidget);
    expect(find.text('Prüfen & exportieren'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('floating calendar fits its 420 dp panel', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 750));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpCalendar(
      tester,
      repository: repository,
      manager: manager,
      calendar: calendar,
      cart: cart,
      embedded: true,
    );

    expect(find.text('Plan recipe'), findsOneWidget);
    expect(find.text('Review & export'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpCalendar(
  WidgetTester tester, {
  required LocalRepository repository,
  required RecipeManagerBloc manager,
  required RecipeCalendarBloc calendar,
  required ShoppingCartBloc cart,
  Locale? locale,
  MyThemeKeys themeKey = MyThemeKeys.LIGHT,
  double textScale = 1,
  bool embedded = false,
}) async {
  await tester.pumpWidget(
    CustomTheme(
      initialThemeKey: themeKey,
      child: Builder(
        builder: (context) => RepositoryProvider<LocalRepository>.value(
          value: repository,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: manager),
              BlocProvider.value(value: calendar),
              BlocProvider.value(value: cart),
            ],
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
              home: embedded
                  ? const Scaffold(
                      body: Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: 420,
                          height: 720,
                          child: RecipeCalendarContent(embedded: true),
                        ),
                      ),
                    )
                  : const RecipeCalendarScreen(),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
