import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/random_recipe_explorer/random_recipe_explorer_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_calendar/recipe_calendar_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/constants/routes.dart';
import 'package:my_recipe_book/constants/global_settings.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';
import 'package:my_recipe_book/screens/random_recipe.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

late AppDatabase database;
late DriftRepository repository;
late RecipeManagerBloc manager;
late RandomRecipeExplorerBloc explorer;
late ShoppingCartBloc shoppingCart;
late RecipeCalendarBloc calendar;

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    GlobalSettings().enableAnimations(false);
    GlobalSettings().disableStandby(false);
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRepository(database: database);
    await repository.initialize();
    await repository.addCategory('Dinner');
    await repository.addRecipeTag('Fast', 0xFFA83211);
    manager = RecipeManagerBloc(repository);
    explorer = RandomRecipeExplorerBloc(
      recipeManagerBloc: manager,
      repository: repository,
      random: Random(2),
    );
    shoppingCart = ShoppingCartBloc(manager, repository);
    calendar = RecipeCalendarBloc(manager, repository);
  });

  tearDown(() async {
    await explorer.close();
    await shoppingCart.close();
    await calendar.close();
    await manager.close();
    await database.close();
    GlobalSettings().enableAnimations(true);
    GlobalSettings().disableStandby(true);
  });

  testWidgets('renders the editorial deck without removed controls', (
    tester,
  ) async {
    await _saveRecipe(repository, name: 'Tomato Pasta', withSteps: true);
    await _pumpExplore(tester);

    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('SWIPE & DISCOVER'), findsOneWidget);
    expect(find.text('Card 1 of 1'), findsOneWidget);
    expect(find.byKey(const Key('explore-filter-button')), findsOneWidget);
    expect(find.byKey(const Key('explore-rewind')), findsOneWidget);
    expect(find.byKey(const Key('explore-pass')), findsOneWidget);
    expect(find.byKey(const Key('explore-save')), findsOneWidget);
    expect(find.byKey(const Key('explore-cook')), findsOneWidget);
    expect(
      find.byKey(const Key('explore-category-Tomato Pasta')),
      findsOneWidget,
    );
    expect(find.text('DINNER'), findsOneWidget);
    expect(find.text('INGREDIENTS SNAPSHOT'), findsOneWidget);
    expect(find.text('Grid'), findsNothing);
    expect(find.textContaining('Swipe Left'), findsNothing);
    expect(find.byIcon(Icons.info), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('content panel wraps recipes without notes', (tester) async {
    await _saveRecipe(repository, name: 'Pasta With Notes', withSteps: true);
    await _saveRecipe(
      repository,
      name: 'Pasta Without Notes',
      withSteps: true,
      notes: '',
    );
    await _pumpExplore(tester);

    final withNotes = tester.getSize(
      find.byKey(const Key('explore-card-content-Pasta With Notes')),
    );
    final withoutNotes = tester.getSize(
      find.byKey(const Key('explore-card-content-Pasta Without Notes')),
    );

    expect(withoutNotes.height, lessThan(withNotes.height));
    expect(
      find.byKey(const Key('explore-category-Pasta Without Notes')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('filter sheet selects one category or tag', (tester) async {
    await _saveRecipe(repository, name: 'Tomato Pasta', withSteps: true);
    await repository.saveRecipe(Recipe(name: 'Plain Soup'));
    await _pumpExplore(tester);

    await tester.tap(find.byKey(const Key('explore-filter-button')));
    await _pumpFor(tester);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Tags'), findsOneWidget);
    await tester.tap(find.text('Fast'));
    await _waitForLoaded(tester, const ExploreFilter.tag('Fast'));

    expect(find.text('#Fast'), findsWidgets);
    expect(find.text('Card 1 of 1'), findsOneWidget);
  });

  testWidgets('save persists a bookmark and rewind restores the prior card', (
    tester,
  ) async {
    await _saveRecipe(repository, name: 'Tomato Pasta', withSteps: true);
    await repository.saveRecipe(Recipe(name: 'Plain Soup'));
    await _pumpExplore(tester);

    final firstRecipe =
        (explorer.state as LoadedRandomRecipeExplorer).randomRecipes.first;
    await tester.tap(find.byKey(const Key('explore-save')));
    await _pumpFor(tester);
    await _waitForFavorite(tester, firstRecipe.name);

    final saved = await repository.getRecipeByName(firstRecipe.name);
    expect(saved?.isFavorite, isTrue);
    expect(find.text('Card 2 of 2'), findsOneWidget);

    await tester.tap(find.byKey(const Key('explore-rewind')));
    await _pumpFor(tester);
    expect(find.text('Card 1 of 2'), findsOneWidget);
    expect(
      (await repository.getRecipeByName(firstRecipe.name))?.isFavorite,
      isTrue,
    );
  });

  testWidgets('left, up, and right drags follow the direction contract', (
    tester,
  ) async {
    await _saveRecipe(repository, name: 'Tomato Pasta', withSteps: true);
    await _saveRecipe(repository, name: 'Mushroom Soup', withSteps: true);
    await _saveRecipe(repository, name: 'Bean Stew', withSteps: true);
    await _pumpExplore(tester);

    final order = (explorer.state as LoadedRandomRecipeExplorer).randomRecipes;
    final swiper = find.byKey(const Key('explore-card-swiper'));

    await tester.drag(swiper, const Offset(-360, 0));
    await _pumpFor(tester);
    expect(find.text('Card 2 of 3'), findsOneWidget);
    expect(
      (await repository.getRecipeByName(order.first.name))?.isFavorite,
      isFalse,
    );

    await tester.drag(swiper, const Offset(0, -360));
    await _pumpFor(tester);
    await _waitForFavorite(tester, order[1].name);
    expect(find.text('Card 3 of 3'), findsOneWidget);

    await tester.drag(swiper, const Offset(360, 0));
    await _pumpFor(tester);
    expect(find.byKey(const Key('cook-mode-route')), findsOneWidget);
  });

  testWidgets('pass reaches the end state and restart rebuilds the deck', (
    tester,
  ) async {
    await _saveRecipe(repository, name: 'Tomato Pasta', withSteps: true);
    await _pumpExplore(tester);

    await tester.tap(find.byKey(const Key('explore-pass')));
    await _pumpFor(tester);
    expect(find.byKey(const Key('explore-complete')), findsOneWidget);
    expect(find.text('You’ve explored the whole deck'), findsOneWidget);

    await tester.tap(find.text('Shuffle & restart'));
    await tester.pump();
    await _waitForLoaded(tester, const ExploreFilter.all());
    expect(find.text('Card 1 of 1'), findsOneWidget);
    expect(find.byKey(const Key('explore-complete')), findsNothing);
  });

  testWidgets('shows a dedicated no-results state', (tester) async {
    await _pumpExplore(tester);

    expect(find.text('Nothing to explore here yet'), findsOneWidget);
    expect(find.text('Change filter'), findsOneWidget);
    expect(find.byKey(const Key('explore-card-swiper')), findsNothing);
  });

  testWidgets('right action opens cook mode when steps exist', (tester) async {
    await _saveRecipe(repository, name: 'Tomato Pasta', withSteps: true);
    await _pumpExplore(tester);

    await tester.tap(find.byKey(const Key('explore-cook')));
    await _pumpFor(tester);
    expect(find.byKey(const Key('cook-mode-route')), findsOneWidget);
  });

  testWidgets('right action falls back to recipe detail without steps', (
    tester,
  ) async {
    await _saveRecipe(repository, name: 'Tomato Pasta', withSteps: false);
    await _pumpExplore(tester);

    await tester.tap(find.byKey(const Key('explore-cook')));
    await _pumpFor(tester);
    expect(find.byKey(const Key('recipe-detail-route')), findsOneWidget);
  });

  testWidgets('expand opens detail without consuming the card', (tester) async {
    await _saveRecipe(repository, name: 'Tomato Pasta', withSteps: true);
    await _pumpExplore(tester);

    await tester.tap(find.byKey(const Key('explore-open-Tomato Pasta')));
    await _pumpFor(tester);
    expect(find.byKey(const Key('recipe-detail-route')), findsOneWidget);
    Navigator.of(tester.element(find.byKey(const Key('recipe-detail-route'))))
        .pop();
    await _pumpFor(tester);
    expect(find.text('Card 1 of 1'), findsOneWidget);
  });

  testWidgets('layout remains stable with large text on a compact phone', (
    tester,
  ) async {
    await _saveRecipe(
      repository,
      name: 'A very long weeknight tomato pasta',
      withSteps: true,
    );
    await _pumpExplore(
      tester,
      size: const Size(360, 700),
      textScaler: const TextScaler.linear(1.3),
    );

    expect(find.byKey(const Key('explore-card-swiper')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports German copy and image fallback', (tester) async {
    await _saveRecipe(
      repository,
      name: 'Tomatenpasta',
      withSteps: true,
      imagePath: '/missing/explore-image.jpg',
    );
    await _pumpExplore(tester, locale: const Locale('de', 'DE'));

    expect(find.text('Zufällig'), findsOneWidget);
    expect(find.text('WISCHEN & ENTDECKEN'), findsOneWidget);
    expect(find.text('Karte 1 von 1'), findsOneWidget);
    await _pumpFor(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('remains stable on rail width in dark and OLED themes', (
    tester,
  ) async {
    await _saveRecipe(repository, name: 'Tomato Pasta', withSteps: true);
    for (final palette in const [
      CulinaryEditorialPalette.dark,
      CulinaryEditorialPalette.oled,
    ]) {
      await _pumpExplore(tester, size: const Size(1000, 760), palette: palette);
      expect(find.byKey(const Key('explore-card-swiper')), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}

Future<void> _saveRecipe(
  DriftRepository repository, {
  required String name,
  required bool withSteps,
  String imagePath = 'images/randomFood.jpg',
  String notes = 'A bright, simple dinner for busy evenings.',
}) {
  return repository.saveRecipe(
    Recipe(
      name: name,
      imagePath: imagePath,
      categories: const ['Dinner'],
      tags: const [StringIntTuple(text: 'Fast', number: 0xFFA83211)],
      ingredients: const [
        [Ingredient(name: 'Tomato', amount: 2, unit: 'pcs')],
      ],
      totalTime: 25,
      effort: 3,
      notes: notes,
      steps: withSteps ? const ['Cook until tender.'] : const [],
    ),
  );
}

Future<void> _pumpExplore(
  WidgetTester tester, {
  Size size = const Size(430, 900),
  TextScaler textScaler = TextScaler.noScaling,
  Locale locale = const Locale('en'),
  CulinaryEditorialPalette palette = CulinaryEditorialPalette.light,
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: manager),
        BlocProvider.value(value: explorer),
        BlocProvider.value(value: shoppingCart),
        BlocProvider.value(value: calendar),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: locale,
        theme: culinaryEditorialTheme(
          palette == CulinaryEditorialPalette.light
              ? ThemeData.light(useMaterial3: true)
              : ThemeData.dark(useMaterial3: true),
          palette,
        ),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: textScaler),
          child: child!,
        ),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        onGenerateRoute: (settings) {
          if (settings.name == RouteNames.cookMode) {
            return MaterialPageRoute<void>(
              builder: (_) =>
                  const Scaffold(key: Key('cook-mode-route'), body: SizedBox()),
            );
          }
          if (settings.name == RouteNames.recipeScreen) {
            return MaterialPageRoute<void>(
              builder: (_) => const Scaffold(
                key: Key('recipe-detail-route'),
                body: SizedBox(),
              ),
            );
          }
          return null;
        },
        home: const Scaffold(body: SwypingCardsScreen()),
      ),
    ),
  );
  await tester.runAsync(() async {
    final loaded = explorer.stream
        .where((state) => state is LoadedRandomRecipeExplorer)
        .first;
    explorer.add(const InitializeRandomRecipeExplorer());
    await loaded;
  });
  await tester.pump(const Duration(milliseconds: 50));
}

Future<void> _waitForLoaded(WidgetTester tester, ExploreFilter filter) async {
  await tester.runAsync(() async {
    if (explorer.state case LoadedRandomRecipeExplorer state
        when state.filter == filter) {
      return;
    }
    await explorer.stream
        .where(
          (state) =>
              state is LoadedRandomRecipeExplorer && state.filter == filter,
        )
        .first;
  });
  await tester.pump(const Duration(milliseconds: 50));
}

Future<void> _waitForFavorite(WidgetTester tester, String recipeName) async {
  await tester.runAsync(() async {
    for (var i = 0; i < 30; i++) {
      if ((await repository.getRecipeByName(recipeName))?.isFavorite == true) {
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    fail('$recipeName was not saved');
  });
  await tester.pump(const Duration(milliseconds: 50));
}

Future<void> _pumpFor(
  WidgetTester tester, [
  Duration duration = const Duration(milliseconds: 500),
]) async {
  final frames = (duration.inMilliseconds / 50).ceil();
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}
