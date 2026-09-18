import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/animated_stepper/animated_stepper_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_screen_ingredients/recipe_screen_ingredients_bloc.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/constants/routes.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/screens/cook_mode_screen.dart';
import 'package:my_recipe_book/theming.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_theme.dart';
import 'package:my_recipe_book/widgets/recipe_screen/editorial_ingredients_panel.dart';
import 'package:my_recipe_book/widgets/recipe_screen/editorial_recipe_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({'showStepsIntro': false});
  });

  testWidgets('compact detail switches between ingredients and instructions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final harness = await _Harness.create(_recipe());
    addTearDown(harness.dispose);
    await harness.pumpBody(tester);

    expect(find.text('Brown Butter Gnocchi'), findsOneWidget);
    expect(find.text('Effort calibration'), findsOneWidget);
    expect(find.text('Pantry checklist'), findsOneWidget);
    expect(find.byKey(const Key('recipe-detail-section-tabs')), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('recipe-start-cooking')))
          .onPressed,
      isNull,
    );

    await tester.tap(find.text('Directions (0)'));
    await tester.pumpAndSettle();

    expect(find.text('Preparation timeline'), findsOneWidget);
    expect(find.text('This recipe has no instructions yet.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('expanded detail shows ingredients and instructions together', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final harness = await _Harness.create(_recipe());
    addTearDown(harness.dispose);
    await harness.pumpBody(tester);

    expect(find.byKey(const Key('recipe-detail-section-tabs')), findsNothing);
    expect(find.text('Pantry checklist'), findsOneWidget);
    expect(find.text('Preparation timeline'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('start cooking passes the currently scaled ingredients', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final recipe = _recipe().copyWith(
      steps: const ['Brown the butter and add the gnocchi.'],
      stepTitles: const ['Brown the butter'],
      stepImages: const [[]],
      stepIngredientIds: const [
        ['flour', 'butter'],
      ],
    );
    final harness = await _Harness.create(recipe);
    addTearDown(harness.dispose);
    CookModeArguments? capturedArguments;
    String? capturedRoute;
    await harness.pumpBody(
      tester,
      onGenerateRoute: (settings) {
        capturedRoute = settings.name;
        capturedArguments = settings.arguments as CookModeArguments;
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const Scaffold(body: Text('Cook route opened')),
        );
      },
    );

    final scaled = harness.ingredientBloc.stream
        .where((state) => state is LoadedRecipeIngredients)
        .cast<LoadedRecipeIngredients>()
        .firstWhere((state) => state.servings == 4);
    harness.ingredientBloc.add(const UpdateServings(2, 4));
    await tester.runAsync(() => scaled);
    await tester.pump();

    final start = find.byKey(const Key('recipe-start-cooking'));
    await tester.ensureVisible(start);
    await tester.tap(start);
    await tester.pumpAndSettle();

    expect(capturedRoute, RouteNames.cookMode);
    expect(capturedArguments?.recipe, recipe);
    expect(capturedArguments?.effectiveIngredients.first[0].amount, 4);
    expect(capturedArguments?.effectiveIngredients.first[1].amount, 200);
  });

  testWidgets('bulk shopping action and serving changes stay synchronized', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final recipe = _recipe();
    final harness = await _Harness.create(recipe);
    addTearDown(harness.dispose);
    await harness.pumpIngredients(tester);

    final checked = harness.ingredientBloc.stream
        .where((state) => state is LoadedRecipeIngredients)
        .cast<LoadedRecipeIngredients>()
        .firstWhere(
          (state) => state.ingredients
              .expand((section) => section)
              .every((ingredient) => ingredient.checked),
        );
    await tester.tap(find.byKey(const Key('recipe-add-all-ingredients')));
    await tester.runAsync(() => checked);
    await tester.pumpAndSettle();

    final scaled = harness.ingredientBloc.stream
        .where((state) => state is LoadedRecipeIngredients)
        .cast<LoadedRecipeIngredients>()
        .firstWhere((state) => state.servings == 3);
    await tester.tap(find.byTooltip('Increase servings'));
    final scaledState = await tester.runAsync(() => scaled);
    await tester.pumpAndSettle();

    expect(scaledState!.ingredients.first.first.amount, 3);
    expect(find.textContaining('3 cups'), findsOneWidget);
    final cart = await harness.repository.getShoppingCartData();
    expect(
      cart.sources
          .firstWhere((source) => source.displayName == recipe.name)
          .currentServings,
      3,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('German copy and large text remain resilient in dark themes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final recipe = _recipe().copyWith(
      name: 'Knusprige Kartoffelgnocchi mit gebräunter Butter und Kräutern',
    );
    final harness = await _Harness.create(recipe);
    addTearDown(harness.dispose);

    for (final baseTheme in [MyThemes.darkTheme, MyThemes.oledblackTheme]) {
      final palette = baseTheme.scaffoldBackgroundColor == Colors.black
          ? CulinaryEditorialPalette.oled
          : CulinaryEditorialPalette.dark;
      await harness.pumpBody(
        tester,
        locale: const Locale('de', 'DE'),
        theme: culinaryEditorialTheme(baseTheme, palette),
        textScaler: const TextScaler.linear(1.3),
      );
      await tester.pumpAndSettle();

      expect(find.text('Zutatenliste'), findsOneWidget);
      expect(
        find.byKey(const Key('recipe-detail-section-tabs')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    }
  });
}

Recipe _recipe() => Recipe(
  name: 'Brown Butter Gnocchi',
  imagePath: 'images/randomFood.jpg',
  imagePreviewPath: 'images/randomFood.jpg',
  servings: 2,
  preperationTime: 15,
  cookingTime: 20,
  totalTime: 45,
  effort: 6,
  ingredients: const [
    [
      Ingredient(id: 'flour', name: 'Flour', amount: 2, unit: 'cups'),
      Ingredient(id: 'butter', name: 'Butter', amount: 100, unit: 'g'),
    ],
  ],
);

class _Harness {
  _Harness({
    required this.database,
    required this.repository,
    required this.manager,
    required this.cartBloc,
    required this.ingredientBloc,
    required this.stepperBloc,
    required this.recipe,
  });

  final AppDatabase database;
  final DriftRepository repository;
  final RecipeManagerBloc manager;
  final ShoppingCartBloc cartBloc;
  final RecipeScreenIngredientsBloc ingredientBloc;
  final AnimatedStepperBloc stepperBloc;
  final Recipe recipe;

  static Future<_Harness> create(Recipe recipe) async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = DriftRepository(database: database);
    await repository.initialize();
    await repository.saveRecipe(recipe);
    final manager = RecipeManagerBloc(repository);
    final cartBloc = ShoppingCartBloc(manager, repository);
    final ingredientBloc = RecipeScreenIngredientsBloc(
      shoppingCartBloc: cartBloc,
      repository: repository,
    );
    final stepperBloc = AnimatedStepperBloc(initialStep: 0);
    final loaded = ingredientBloc.stream
        .where((state) => state is LoadedRecipeIngredients)
        .first;
    ingredientBloc.add(
      InitializeIngredients(recipe.name, recipe.servings, recipe.ingredients),
    );
    await loaded;
    return _Harness(
      database: database,
      repository: repository,
      manager: manager,
      cartBloc: cartBloc,
      ingredientBloc: ingredientBloc,
      stepperBloc: stepperBloc,
      recipe: recipe,
    );
  }

  Future<void> pumpBody(
    WidgetTester tester, {
    Locale? locale,
    ThemeData? theme,
    TextScaler? textScaler,
    RouteFactory? onGenerateRoute,
  }) {
    final controller = ScrollController();
    final selected = ValueNotifier(RecipeDetailSection.ingredients);
    addTearDown(controller.dispose);
    addTearDown(selected.dispose);
    return _pump(
      tester,
      ValueListenableBuilder<RecipeDetailSection>(
        valueListenable: selected,
        builder: (context, value, _) {
          return EditorialRecipeDetailBody(
            recipe: recipe,
            scrollController: controller,
            selectedSection: value,
            onSectionChanged: (value) => selected.value = value,
          );
        },
      ),
      locale: locale,
      theme: theme,
      textScaler: textScaler,
      onGenerateRoute: onGenerateRoute,
    );
  }

  Future<void> pumpIngredients(WidgetTester tester) {
    return _pump(
      tester,
      Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [EditorialIngredientsPanel(recipe: recipe)],
        ),
      ),
    );
  }

  Future<void> _pump(
    WidgetTester tester,
    Widget child, {
    Locale? locale,
    ThemeData? theme,
    TextScaler? textScaler,
    RouteFactory? onGenerateRoute,
  }) {
    return tester.pumpWidget(
      RepositoryProvider<LocalRepository>.value(
        value: repository,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: manager),
            BlocProvider.value(value: cartBloc),
            BlocProvider.value(value: ingredientBloc),
            BlocProvider.value(value: stepperBloc),
          ],
          child: MaterialApp(
            locale: locale,
            theme: theme,
            builder: textScaler == null
                ? null
                : (context, child) {
                    final media = MediaQuery.of(context);
                    return MediaQuery(
                      data: media.copyWith(textScaler: textScaler),
                      child: child!,
                    );
                  },
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            onGenerateRoute: onGenerateRoute,
            home: Scaffold(body: child),
          ),
        ),
      ),
    );
  }

  Future<void> dispose() async {
    await ingredientBloc.close();
    await stepperBloc.close();
    await cartBloc.close();
    await manager.close();
    await database.close();
  }
}
