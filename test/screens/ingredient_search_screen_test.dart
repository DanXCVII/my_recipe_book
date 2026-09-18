import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/ingredient_search/ingredient_search_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_calendar/recipe_calendar_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/constants/routes.dart';
import 'package:my_recipe_book/screens/ingredient_search.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_theme.dart';

void main() {
  late AppDatabase database;
  late DriftRepository repository;
  late RecipeManagerBloc recipeManager;
  late IngredientSearchBloc searchBloc;
  late ShoppingCartBloc shoppingCartBloc;
  late RecipeCalendarBloc recipeCalendarBloc;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRepository(database: database);
    await repository.initialize();
    await repository.addCategory('Dinner');
    await repository.addRecipeTag('Quick', 0xFFE05A36);
    await repository.addIngredient('Spinach');
    await repository.addIngredient('Chicken');
    await repository.saveRecipe(
      Recipe(
        name: 'Green Pasta',
        ingredients: const [
          [Ingredient(name: 'Spinach'), Ingredient(name: 'Pasta')],
        ],
        categories: const ['Dinner'],
        vegetable: Vegetable.VEGAN,
        totalTime: 25,
        effort: 3,
      ),
    );
    await repository.saveRecipe(
      Recipe(
        name: 'Slow Chicken',
        ingredients: const [
          [Ingredient(name: 'Chicken')],
        ],
        categories: const ['Dinner'],
        vegetable: Vegetable.NON_VEGETARIAN,
        totalTime: 120,
        effort: 8,
      ),
    );
    recipeManager = RecipeManagerBloc(repository);
    searchBloc = IngredientSearchBloc(
      repository: repository,
      recipeManagerBloc: recipeManager,
    );
    shoppingCartBloc = ShoppingCartBloc(recipeManager, repository);
    recipeCalendarBloc = RecipeCalendarBloc(recipeManager, repository);
  });

  tearDown(() async {
    await searchBloc.close();
    await shoppingCartBloc.close();
    await recipeCalendarBloc.close();
    await recipeManager.close();
    await database.close();
  });

  testWidgets('adds, deduplicates, removes, and clears ingredient chips', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpSearch(
      tester,
      repository: repository,
      recipeManager: recipeManager,
      searchBloc: searchBloc,
      shoppingCartBloc: shoppingCartBloc,
      recipeCalendarBloc: recipeCalendarBloc,
    );

    await tester.enterText(
      find.byKey(const Key('ingredient-search-input')),
      'Spinach',
    );
    await tester.tap(find.byKey(const Key('ingredient-search-add')));
    await _waitForMatches(tester, searchBloc);

    expect(find.byKey(const Key('ingredient-chip-Spinach')), findsOneWidget);
    expect(searchBloc.state, isA<IngredientSearchMatches>());

    await tester.enterText(
      find.byKey(const Key('ingredient-search-input')),
      ' spinach ',
    );
    await tester.tap(find.byKey(const Key('ingredient-search-add')));
    await tester.pumpAndSettle();
    expect(find.byType(InputChip), findsOneWidget);

    await tester.tap(find.byTooltip('Remove Spinach'));
    await _waitForInitial(tester, searchBloc);
    expect(find.byType(InputChip), findsNothing);

    await tester.enterText(
      find.byKey(const Key('ingredient-search-input')),
      'Spinach',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await _waitForMatches(tester, searchBloc);
    expect(find.byKey(const Key('ingredient-chip-Spinach')), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.text('Green Pasta'), findsOneWidget);
    expect(find.text('1/1 ingredients'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const Key('ingredient-search-clear')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('ingredient-search-clear')));
    await _waitForInitial(tester, searchBloc);
    expect(find.byType(InputChip), findsNothing);
    expect(searchBloc.state, isA<IngredientSearchInitial>());
  });

  testWidgets('applies time and effort limits live from the filter sheet', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpSearch(
      tester,
      repository: repository,
      recipeManager: recipeManager,
      searchBloc: searchBloc,
      shoppingCartBloc: shoppingCartBloc,
      recipeCalendarBloc: recipeCalendarBloc,
    );

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(-180, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Meat'));
    await _waitForMatches(tester, searchBloc);
    expect(
      (searchBloc.state as IngredientSearchMatches).results.single.recipe.name,
      'Slow Chicken',
    );

    await tester.tap(find.byKey(const Key('ingredient-search-filters')));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch).first);
    await _waitForMatches(tester, searchBloc);

    expect(find.text('≤ 30 min'), findsWidgets);
    expect((searchBloc.state as IngredientSearchMatches).results, isEmpty);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.text('No recipes match yet'), findsOneWidget);
  });

  testWidgets(
    'category and tag filters stay distinct in light and dark themes',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      Future<void> expectFilterColors(CulinaryEditorialPalette palette) async {
        await tester.tap(find.byKey(const Key('ingredient-search-filters')));
        await tester.pumpAndSettle();

        final categoryFinder = find.byKey(
          const Key('ingredient-search-category-Dinner'),
        );
        final tagFinder = find.byKey(const Key('ingredient-search-tag-Quick'));
        final categoryChipFinder = find.descendant(
          of: categoryFinder,
          matching: find.byType(FilterChip),
        );
        final tagChipFinder = find.descendant(
          of: tagFinder,
          matching: find.byType(FilterChip),
        );
        var categoryChip = tester.widget<FilterChip>(categoryChipFinder);
        final tagChip = tester.widget<FilterChip>(tagChipFinder);
        final offSwitch = tester.widget<Switch>(find.byType(Switch).first);

        expect(categoryChip.backgroundColor, palette.surfaceContainer);
        expect(categoryChip.labelStyle?.color, palette.onSurface);
        expect(tagChip.backgroundColor, palette.surfaceContainer);
        expect(tagChip.labelStyle?.color, palette.onSurface);
        expect(
          offSwitch.trackColor?.resolve(const <WidgetState>{}),
          palette.surfaceContainerHigh,
        );
        expect(
          offSwitch.thumbColor?.resolve(const <WidgetState>{}),
          palette.onSurfaceVariant,
        );
        expect(
          offSwitch.trackOutlineColor?.resolve(const <WidgetState>{}),
          palette.outline.withValues(alpha: .72),
        );

        await tester.tap(categoryFinder);
        await _waitForMatches(tester, searchBloc);
        categoryChip = tester.widget<FilterChip>(categoryChipFinder);
        expect(categoryChip.selected, isTrue);
        expect(categoryChip.selectedColor, palette.primarySoft);
        expect(categoryChip.labelStyle?.color, palette.primary);

        await tester.tap(categoryFinder);
        await _waitForInitial(tester, searchBloc);
        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();
      }

      await _pumpSearch(
        tester,
        repository: repository,
        recipeManager: recipeManager,
        searchBloc: searchBloc,
        shoppingCartBloc: shoppingCartBloc,
        recipeCalendarBloc: recipeCalendarBloc,
      );
      await expectFilterColors(CulinaryEditorialPalette.light);

      await _pumpSearch(
        tester,
        repository: repository,
        recipeManager: recipeManager,
        searchBloc: searchBloc,
        shoppingCartBloc: shoppingCartBloc,
        recipeCalendarBloc: recipeCalendarBloc,
        theme: ThemeData.dark(),
      );
      await expectFilterColors(CulinaryEditorialPalette.dark);
    },
  );

  testWidgets('bookmark action does not open the recipe', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpSearch(
      tester,
      repository: repository,
      recipeManager: recipeManager,
      searchBloc: searchBloc,
      shoppingCartBloc: shoppingCartBloc,
      recipeCalendarBloc: recipeCalendarBloc,
    );

    await tester.enterText(
      find.byKey(const Key('ingredient-search-input')),
      'Spinach',
    );
    await tester.tap(find.byKey(const Key('ingredient-search-add')));
    await _waitForMatches(tester, searchBloc);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('ingredient-search-bookmark-Green Pasta')),
    );
    await _waitForFavorite(tester, searchBloc, 'Green Pasta');

    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sort selection refreshes results and open action navigates', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpSearch(
      tester,
      repository: repository,
      recipeManager: recipeManager,
      searchBloc: searchBloc,
      shoppingCartBloc: shoppingCartBloc,
      recipeCalendarBloc: recipeCalendarBloc,
      recipeDestination: const Text('Recipe destination'),
    );

    await tester.tap(find.byKey(const Key('ingredient-search-filters')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dinner'));
    await _waitForMatches(tester, searchBloc);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('ingredient-search-sort')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Name A–Z').last);
    await _waitForCriteria(
      tester,
      searchBloc,
      (criteria) => criteria.sort == IngredientSearchSort.name,
    );
    expect(
      (searchBloc.state as IngredientSearchMatches).results.map(
        (entry) => entry.recipe.name,
      ),
      ['Green Pasta', 'Slow Chicken'],
    );

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('ingredient-search-open-Green Pasta')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Recipe destination'), findsOneWidget);
  });

  testWidgets('renders the two-pane OLED layout in German at large text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 900));
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(() {
      tester.binding.setSurfaceSize(null);
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });
    await _pumpSearch(
      tester,
      repository: repository,
      recipeManager: recipeManager,
      searchBloc: searchBloc,
      shoppingCartBloc: shoppingCartBloc,
      recipeCalendarBloc: recipeCalendarBloc,
      locale: const Locale('de', 'DE'),
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
    );

    expect(find.text('Koche mit dem, was da ist'), findsOneWidget);
    expect(find.text('Passende Rezepte'), findsOneWidget);
    expect(find.byType(VerticalDivider), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpSearch(
  WidgetTester tester, {
  required LocalRepository repository,
  required RecipeManagerBloc recipeManager,
  required IngredientSearchBloc searchBloc,
  required ShoppingCartBloc shoppingCartBloc,
  required RecipeCalendarBloc recipeCalendarBloc,
  Locale locale = const Locale('en'),
  ThemeData? theme,
  Widget? recipeDestination,
}) async {
  await tester.pumpWidget(
    MultiRepositoryProvider(
      providers: [RepositoryProvider<LocalRepository>.value(value: repository)],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RecipeManagerBloc>.value(value: recipeManager),
          BlocProvider<IngredientSearchBloc>.value(value: searchBloc),
          BlocProvider<ShoppingCartBloc>.value(value: shoppingCartBloc),
          BlocProvider<RecipeCalendarBloc>.value(value: recipeCalendarBloc),
        ],
        child: MaterialApp(
          locale: locale,
          theme: theme ?? ThemeData.light(),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          onGenerateRoute: recipeDestination == null
              ? null
              : (settings) {
                  if (settings.name == RouteNames.recipeScreen) {
                    return MaterialPageRoute<void>(
                      settings: settings,
                      builder: (context) => Scaffold(body: recipeDestination),
                    );
                  }
                  return null;
                },
          home: const IngredientSearchScreen(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _waitForCriteria(
  WidgetTester tester,
  IngredientSearchBloc bloc,
  bool Function(IngredientSearchCriteria criteria) matches,
) async {
  bool isMatchingResult(IngredientSearchState state) =>
      state is IngredientSearchMatches && matches(state.criteria);
  if (!isMatchingResult(bloc.state)) {
    await tester.runAsync(() => bloc.stream.firstWhere(isMatchingResult));
  }
  await tester.pumpAndSettle();
}

Future<IngredientSearchMatches> _waitForMatches(
  WidgetTester tester,
  IngredientSearchBloc bloc,
) async {
  final current = bloc.state;
  final IngredientSearchMatches result;
  if (current is IngredientSearchMatches) {
    result = current;
  } else {
    result = (await tester.runAsync(
      () => bloc.stream
          .where((state) => state is IngredientSearchMatches)
          .cast<IngredientSearchMatches>()
          .first,
    ))!;
  }
  await tester.pumpAndSettle();
  return result;
}

Future<void> _waitForInitial(
  WidgetTester tester,
  IngredientSearchBloc bloc,
) async {
  if (bloc.state is! IngredientSearchInitial) {
    await tester.runAsync(
      () => bloc.stream.firstWhere((state) => state is IngredientSearchInitial),
    );
  }
  await tester.pumpAndSettle();
}

Future<void> _waitForFavorite(
  WidgetTester tester,
  IngredientSearchBloc bloc,
  String recipeName,
) async {
  bool isFavorite(IngredientSearchState state) =>
      state is IngredientSearchMatches &&
      state.results.any(
        (entry) => entry.recipe.name == recipeName && entry.recipe.isFavorite,
      );
  if (!isFavorite(bloc.state)) {
    await tester.runAsync(() => bloc.stream.firstWhere(isFavorite));
  }
  await tester.pumpAndSettle();
}
