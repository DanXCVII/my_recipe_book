import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_overview/recipe_overview_bloc.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';
import 'package:my_recipe_book/screens/recipe_overview.dart';
import 'package:my_recipe_book/theming.dart';
import 'package:my_recipe_book/widgets/recipe_overview/editorial_recipe_card.dart';

void main() {
  late AppDatabase database;
  late DriftRepository repository;
  late RecipeManagerBloc manager;
  late RecipeOverviewBloc overview;
  late bool databaseClosed;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    databaseClosed = false;
    repository = DriftRepository(database: database);
    await repository.initialize();
    await repository.addCategory('Weeknight favorites');
    await repository.addRecipeTag('Quick', 0xFFE05A36);
    await repository.addRecipeTag('Comfort', 0xFFE58A2B);

    await repository.saveRecipe(
      Recipe(
        name: 'Brown Butter Gnocchi',
        categories: const ['Weeknight favorites'],
        vegetable: Vegetable.VEGETARIAN,
        totalTime: 25,
        effort: 3,
        tags: const [
          StringIntTuple(text: 'Quick', number: 0xFFE05A36),
          StringIntTuple(text: 'Comfort', number: 0xFFE58A2B),
        ],
      ),
    );
    await repository.saveRecipe(
      Recipe(
        name: 'Classic Beef Stew',
        categories: const ['Weeknight favorites'],
        vegetable: Vegetable.NON_VEGETARIAN,
        totalTime: 180,
        effort: 8,
        tags: const [StringIntTuple(text: 'Comfort', number: 0xFFE58A2B)],
      ),
    );

    manager = RecipeManagerBloc(repository);
    overview = RecipeOverviewBloc(
      recipeManagerBloc: manager,
      repository: repository,
    );
  });

  tearDown(() async {
    await overview.close();
    await manager.close();
    if (!databaseClosed) await database.close();
  });

  testWidgets('category overview switches layouts and clears search filters', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpOverview(tester, manager: manager, overview: overview);
    await _dispatchAndPump(
      tester,
      overview,
      const LoadCategoryRecipeOverview('Weeknight favorites'),
      (state) =>
          state.category == 'Weeknight favorites' &&
          state.allRecipes.length == 2,
    );

    expect(find.text('Weeknight favorites'), findsOneWidget);
    expect(find.text('2 recipes • Avg effort 5.5'), findsOneWidget);
    expect(find.byKey(const Key('recipe-overview-search')), findsOneWidget);
    expect(find.byKey(const Key('recipe-overview-sort')), findsOneWidget);
    expect(find.byKey(const Key('recipe-overview-filters')), findsOneWidget);

    await tester.tap(find.byKey(const Key('recipe-overview-filters')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('recipe-overview-category-Weeknight favorites')),
      findsNothing,
    );
    expect(find.byKey(const Key('recipe-overview-diet-any')), findsOneWidget);
    Navigator.of(
      tester.element(find.byKey(const Key('recipe-overview-filter-sheet'))),
    ).pop();
    await tester.pumpAndSettle();
    expect(
      tester
          .widgetList<EditorialRecipeCard>(find.byType(EditorialRecipeCard))
          .every((card) => card.layout == RecipeOverviewCardLayout.grid),
      isTrue,
    );

    await tester.tap(find.byKey(const Key('recipe-overview-list-toggle')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widgetList<EditorialRecipeCard>(find.byType(EditorialRecipeCard))
          .every((card) => card.layout == RecipeOverviewCardLayout.list),
      isTrue,
    );

    final filtered = overview.stream
        .where((state) => state is LoadedRecipeOverview)
        .cast<LoadedRecipeOverview>()
        .firstWhere((state) => state.visibleRecipes.isEmpty);
    await tester.enterText(
      find.byKey(const Key('recipe-overview-search')),
      'not in this collection',
    );
    await tester.runAsync(() => filtered);
    await tester.pumpAndSettle();
    expect(find.text('No recipes match these filters'), findsOneWidget);

    final cleared = overview.stream
        .where((state) => state is LoadedRecipeOverview)
        .cast<LoadedRecipeOverview>()
        .firstWhere((state) => !state.hasActiveFilters);
    await tester.tap(find.text('Clear filters'));
    await tester.runAsync(() => cleared);
    await tester.pumpAndSettle();
    expect(find.byType(EditorialRecipeCard), findsNWidgets(2));
  });

  testWidgets('dietary and tag routes retain their pushed-screen titles', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pumpOverview(tester, manager: manager, overview: overview);
    await _dispatchAndPump(
      tester,
      overview,
      const LoadVegetableRecipeOverview(Vegetable.NON_VEGETARIAN),
      (state) =>
          state.vegetable == Vegetable.NON_VEGETARIAN &&
          state.allRecipes.length == 1,
    );
    expect(find.text('With meat'), findsWidgets);
    expect(find.byType(EditorialRecipeCard), findsOneWidget);
    await tester.tap(find.byKey(const Key('recipe-overview-filters')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('recipe-overview-diet-any')), findsNothing);
    Navigator.of(
      tester.element(find.byKey(const Key('recipe-overview-filter-sheet'))),
    ).pop();
    await tester.pumpAndSettle();

    await _dispatchAndPump(
      tester,
      overview,
      const LoadRecipeTagRecipeOverview(
        StringIntTuple(text: 'Quick', number: 0xFFE05A36),
      ),
      (state) => state.recipeTag?.text == 'Quick',
    );
    expect(find.text('Quick'), findsOneWidget);
    expect(find.byType(EditorialRecipeCard), findsOneWidget);
    await tester.tap(find.byKey(const Key('recipe-overview-filters')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('recipe-overview-filter-sheet')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('recipe-overview-tag-Comfort')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('recipe-overview-tag-Quick')), findsNothing);
    expect(find.text('Diet'), findsOneWidget);
  });

  testWidgets('shows skeletons and the contextual empty-library state', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpOverview(tester, manager: manager, overview: overview);

    expect(find.byType(AspectRatio), findsWidgets);

    await _dispatchAndPump(
      tester,
      overview,
      const LoadCategoryRecipeOverview('Empty collection'),
      (state) =>
          state.category == 'Empty collection' && state.allRecipes.isEmpty,
    );
    expect(find.text('No recipes here yet'), findsOneWidget);
    expect(find.text('Empty collection'), findsOneWidget);

    await _dispatchAndPump(
      tester,
      overview,
      const LoadVegetableRecipeOverview(Vegetable.VEGAN),
      (state) => state.vegetable == Vegetable.VEGAN,
    );
    expect(
      find.text('You have no recipes for this dietary selection'),
      findsOneWidget,
    );
  });

  testWidgets('renders the overview controls and summary in German', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpOverview(
      tester,
      manager: manager,
      overview: overview,
      locale: const Locale('de', 'DE'),
    );
    await _dispatchAndPump(
      tester,
      overview,
      const LoadCategoryRecipeOverview('Weeknight favorites'),
      (state) => state.allRecipes.length == 2,
    );

    expect(find.text('Raster'), findsOneWidget);
    expect(find.text('2 Rezepte • Ø Aufwand 5,5'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a localized retry state when loading fails', (
    tester,
  ) async {
    await _pumpOverview(tester, manager: manager, overview: overview);
    await database.close();
    databaseClosed = true;

    final failed = overview.stream.firstWhere(
      (state) => state is FailedRecipeOverview,
    );
    overview.add(const LoadCategoryRecipeOverview('Unavailable collection'));
    await tester.runAsync(() => failed);
    await tester.pumpAndSettle();

    expect(find.text("Recipes couldn't be loaded"), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}

Future<void> _dispatchAndPump(
  WidgetTester tester,
  RecipeOverviewBloc bloc,
  RecipeOverviewEvent event,
  bool Function(LoadedRecipeOverview state) predicate,
) async {
  final result = bloc.stream
      .where((state) => state is LoadedRecipeOverview)
      .cast<LoadedRecipeOverview>()
      .firstWhere(predicate);
  bloc.add(event);
  await tester.runAsync(() => result);
  await tester.pumpAndSettle();
}

Future<void> _pumpOverview(
  WidgetTester tester, {
  required RecipeManagerBloc manager,
  required RecipeOverviewBloc overview,
  Locale? locale,
}) async {
  await tester.pumpWidget(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: Builder(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: manager),
            BlocProvider.value(value: overview),
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
            home: const RecipeGridView(),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
