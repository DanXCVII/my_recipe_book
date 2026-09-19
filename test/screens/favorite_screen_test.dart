import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/favorite_recipes/favorite_recipes_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_calendar/recipe_calendar_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/constants/routes.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';
import 'package:my_recipe_book/screens/favorite_screen.dart';
import 'package:my_recipe_book/theming.dart';
import 'package:my_recipe_book/widgets/recipe_overview/editorial_recipe_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase database;
  late DriftRepository repository;
  late RecipeManagerBloc manager;
  late FavoriteRecipesBloc favorites;
  late ShoppingCartBloc shoppingCart;
  late RecipeCalendarBloc calendar;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRepository(database: database);
    await repository.initialize();
    await repository.addCategory('Weeknight');
    await repository.addRecipeTag('Quick', 0xFFA83211);
    final recipes = [
      Recipe(
        name: 'Tomato Pasta',
        categories: const ['Weeknight'],
        vegetable: Vegetable.VEGETARIAN,
        ingredients: const [
          [Ingredient(name: 'Tomato')],
        ],
        tags: const [StringIntTuple(text: 'Quick', number: 0xFFA83211)],
        isFavorite: true,
        lastModified: '2026-09-10 10:00:00.000',
      ),
      Recipe(
        name: 'Mushroom Broth',
        vegetable: Vegetable.VEGAN,
        ingredients: const [
          [Ingredient(name: 'Mushroom')],
        ],
        isFavorite: true,
        lastModified: '2026-09-12 10:00:00.000',
      ),
    ];
    for (final recipe in recipes) {
      await repository.saveRecipe(recipe);
      await repository.addToFavorites(recipe);
    }
    manager = RecipeManagerBloc(repository);
    favorites = FavoriteRecipesBloc(
      recipeManagerBloc: manager,
      repository: repository,
    );
    shoppingCart = ShoppingCartBloc(manager, repository);
    calendar = RecipeCalendarBloc(manager, repository);
  });

  tearDown(() async {
    await favorites.close();
    await shoppingCart.close();
    await calendar.close();
    await manager.close();
    await database.close();
  });

  testWidgets('renders the editorial screen and persists layout changes', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _loadAndPump(
      tester,
      manager: manager,
      favorites: favorites,
      shoppingCart: shoppingCart,
      calendar: calendar,
    );

    expect(find.text('Bookmarked Recipes'), findsOneWidget);
    expect(find.text('My RecipeBible'), findsNothing);
    expect(
      tester.getTopLeft(find.text('Bookmarked Recipes')).dx,
      moreOrLessEquals(20, epsilon: 0.01),
    );
    expect(find.text('2 saved recipes'), findsOneWidget);
    expect(find.textContaining('collection'), findsNothing);
    expect(find.byKey(const Key('bookmarks-new-collection')), findsNothing);
    expect(find.byKey(const Key('bookmarks-search')), findsOneWidget);
    expect(find.byKey(const Key('bookmarks-sort')), findsOneWidget);
    expect(find.byKey(const Key('bookmarks-filters')), findsOneWidget);
    expect(find.byKey(const Key('bookmarks-search-toggle')), findsNothing);
    expect(
      tester
          .widgetList<EditorialRecipeCard>(find.byType(EditorialRecipeCard))
          .every((card) => card.layout == RecipeOverviewCardLayout.list),
      isTrue,
    );

    await tester.tap(find.byKey(const Key('bookmarks-grid-toggle')));
    await tester.pump(const Duration(milliseconds: 250));
    expect(
      tester
          .widgetList<EditorialRecipeCard>(find.byType(EditorialRecipeCard))
          .every((card) => card.layout == RecipeOverviewCardLayout.grid),
      isTrue,
    );
    final preferences = await tester.runAsync(SharedPreferences.getInstance);
    expect(preferences, isNotNull);
    expect(preferences!.getString('favoriteRecipeCardLayout'), 'grid');
  });

  testWidgets('searches real recipe fields', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _loadAndPump(
      tester,
      manager: manager,
      favorites: favorites,
      shoppingCart: shoppingCart,
      calendar: calendar,
    );

    final filtered = _nextLoaded(
      favorites,
      (state) => state.query == 'mushroom',
    );
    await tester.enterText(
      find.byKey(const Key('bookmarks-search')),
      'mushroom',
    );
    await tester.runAsync(() => filtered);
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Mushroom Broth'), findsOneWidget);
    expect(find.text('Tomato Pasta'), findsNothing);

    expect(find.byKey(const Key('bookmarks-new-collection')), findsNothing);
  });

  testWidgets('applies bookmark category and tag filters live from the sheet', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _loadAndPump(
      tester,
      manager: manager,
      favorites: favorites,
      shoppingCart: shoppingCart,
      calendar: calendar,
    );

    await tester.tap(find.byKey(const Key('bookmarks-filters')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('bookmarks-filter-sheet')), findsOneWidget);
    expect(find.byKey(const Key('bookmarks-tag-Quick')), findsOneWidget);

    final filtered = _nextLoaded(
      favorites,
      (state) => state.filters.categories.contains('Weeknight'),
    );
    await tester.tap(find.byKey(const Key('bookmarks-category-Weeknight')));
    await tester.runAsync(() => filtered);
    await tester.pumpAndSettle();

    expect(find.text('Filters (1)'), findsOneWidget);
    await tester.drag(
      find.byKey(const Key('bookmarks-filter-sheet')),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('bookmarks-filter-done')));
    await tester.pumpAndSettle();
    expect(find.text('Tomato Pasta'), findsOneWidget);
    expect(find.text('Mushroom Broth'), findsNothing);
  });

  testWidgets('removing a bookmark does not open the recipe', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _loadAndPump(
      tester,
      manager: manager,
      favorites: favorites,
      shoppingCart: shoppingCart,
      calendar: calendar,
    );

    final updated = _nextLoaded(
      favorites,
      (state) => state.allRecipes.length == 1,
    );
    await tester.tap(
      find.byKey(const Key('recipe-card-bookmark-action')).first,
    );
    await tester.runAsync(() => updated);
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byType(EditorialRecipeCard), findsOneWidget);
    expect(find.byKey(const Key('recipe-route')), findsNothing);
  });
}

Future<void> _loadAndPump(
  WidgetTester tester, {
  required RecipeManagerBloc manager,
  required FavoriteRecipesBloc favorites,
  required ShoppingCartBloc shoppingCart,
  required RecipeCalendarBloc calendar,
}) async {
  final loaded = _nextLoaded(favorites);
  favorites.add(const LoadFavorites());
  await tester.runAsync(() => loaded);
  await tester.pumpWidget(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: Builder(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: manager),
            BlocProvider.value(value: favorites),
            BlocProvider.value(value: shoppingCart),
            BlocProvider.value(value: calendar),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: CustomTheme.of(context),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            onGenerateRoute: (settings) {
              if (settings.name == RouteNames.manageCategories) {
                return MaterialPageRoute<void>(
                  builder: (_) =>
                      const Scaffold(key: Key('category-manager-route')),
                );
              }
              if (settings.name == RouteNames.recipeScreen) {
                return MaterialPageRoute<void>(
                  builder: (_) => const Scaffold(key: Key('recipe-route')),
                );
              }
              return null;
            },
            home: const Scaffold(body: FavoriteScreen()),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
}

Future<LoadedFavorites> _nextLoaded(
  FavoriteRecipesBloc bloc, [
  bool Function(LoadedFavorites state)? predicate,
]) {
  return bloc.stream
      .where((state) => state is LoadedFavorites)
      .cast<LoadedFavorites>()
      .firstWhere(predicate ?? (_) => true);
}
