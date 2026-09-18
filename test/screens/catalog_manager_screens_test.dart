import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/category_manager/category_manager_bloc.dart';
import 'package:my_recipe_book/blocs/nutrition_manager/nutrition_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_tag_manager/recipe_tag_manager_bloc.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/nutrition.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';
import 'package:my_recipe_book/screens/category_manager.dart';
import 'package:my_recipe_book/screens/nutrition_manager.dart';
import 'package:my_recipe_book/screens/recipe_tag_manager_screen.dart';
import 'package:my_recipe_book/theming.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_theme.dart';

void main() {
  late AppDatabase database;
  late DriftRepository repository;
  late RecipeManagerBloc recipeManager;
  late CategoryManagerBloc categoryManager;
  late NutritionManagerBloc nutritionManager;
  late RecipeTagManagerBloc tagManager;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRepository(database: database);
    await repository.initializeFresh();
    recipeManager = RecipeManagerBloc(repository);
    categoryManager = CategoryManagerBloc(
      recipeManagerBloc: recipeManager,
      repository: repository,
      selectedCategories: const [],
    );
    nutritionManager = NutritionManagerBloc(repository);
    tagManager = RecipeTagManagerBloc(
      recipeManagerBloc: recipeManager,
      repository: repository,
    );
  });

  tearDown(() async {
    await categoryManager.close();
    await nutritionManager.close();
    await tagManager.close();
    await recipeManager.close();
    await database.close();
  });

  testWidgets('category empty state validates and adds a trimmed name', (
    tester,
  ) async {
    categoryManager.add(InitializeCategoryManager());
    await _pumpManager(
      tester,
      providers: [
        BlocProvider<RecipeManagerBloc>.value(value: recipeManager),
        BlocProvider<CategoryManagerBloc>.value(value: categoryManager),
      ],
      child: const CategoryManager(),
    );

    expect(find.text('No categories yet'), findsOneWidget);
    expect(find.text('no category'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('catalog-empty-add')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('catalog-name-field')),
      '   ',
    );
    await tester.tap(find.byKey(const ValueKey('catalog-sheet-save')));
    await tester.pumpAndSettle();
    expect(find.text('Field must not be empty'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('catalog-name-field')),
      '  Dinner  ',
    );
    await tester.tap(find.byKey(const ValueKey('catalog-sheet-save')));
    await _pumpUntil(
      tester,
      () =>
          categoryManager.state is LoadedCategoryManager &&
          (categoryManager.state as LoadedCategoryManager).categories.contains(
            'Dinner',
          ),
    );

    expect(find.byKey(const ValueKey('category-row-Dinner')), findsOneWidget);
    expect(repository.getCategoryNames(), ['Dinner', noCategoryName]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('categories reorder with final indices and delete explicitly', (
    tester,
  ) async {
    await repository.addCategory('Breakfast');
    await repository.addCategory('Dinner');
    categoryManager.add(InitializeCategoryManager());
    await _pumpManager(
      tester,
      providers: [
        BlocProvider<RecipeManagerBloc>.value(value: recipeManager),
        BlocProvider<CategoryManagerBloc>.value(value: categoryManager),
      ],
      child: const CategoryManager(),
    );

    final reorderable = tester.widget<SliverReorderableList>(
      find.byType(SliverReorderableList),
    );
    reorderable.onReorderItem!(0, 1);
    await _pumpUntil(
      tester,
      () =>
          categoryManager.state is LoadedCategoryManager &&
          (categoryManager.state as LoadedCategoryManager).categories
                  .take(2)
                  .join(',') ==
              'Dinner,Breakfast',
    );
    expect(repository.getCategoryNames(), [
      'Dinner',
      'Breakfast',
      noCategoryName,
    ]);

    await tester.tap(find.byTooltip('More actions for Dinner'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Recipes will stay in your cookbook'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('category-row-Dinner')), findsOneWidget);

    await tester.tap(find.byTooltip('More actions for Dinner'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('catalog-confirm-delete')));
    await _pumpUntil(
      tester,
      () =>
          categoryManager.state is LoadedCategoryManager &&
          !(categoryManager.state as LoadedCategoryManager).categories.contains(
            'Dinner',
          ),
    );
    expect(find.byKey(const ValueKey('category-row-Dinner')), findsNothing);
    expect(repository.getCategoryNames(), ['Breakfast', noCategoryName]);
  });

  testWidgets(
    'nutrition empty state validates, adds, rejects duplicates, and edits',
    (tester) async {
      nutritionManager.add(LoadNutritionManager());
      await _pumpManager(
        tester,
        providers: [
          BlocProvider<NutritionManagerBloc>.value(value: nutritionManager),
        ],
        child: const NutritionManager(),
        themeKey: MyThemeKeys.DARK,
      );

      expect(find.text('No nutrition labels yet'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('catalog-empty-add')));
      await tester.pumpAndSettle();

      final sheetTheme = Theme.of(
        tester.element(find.byKey(const ValueKey('catalog-name-field'))),
      );
      expect(
        sheetTheme.colorScheme.primary,
        CulinaryEditorialPalette.dark.primary,
      );
      expect(
        sheetTheme.textTheme.bodyLarge?.fontFamily,
        CulinaryEditorialType.bodyFamily,
      );

      await tester.enterText(
        find.byKey(const ValueKey('catalog-name-field')),
        '   ',
      );
      await tester.tap(find.byKey(const ValueKey('catalog-sheet-save')));
      await tester.pumpAndSettle();
      expect(find.text('Field must not be empty'), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey('catalog-name-field')),
        '  Protein  ',
      );
      await tester.tap(find.byKey(const ValueKey('catalog-sheet-save')));
      await _pumpUntil(
        tester,
        () =>
            nutritionManager.state is LoadedNutritionManager &&
            (nutritionManager.state as LoadedNutritionManager).nutritions
                .contains('Protein'),
      );
      expect(repository.getNutritions(), ['Protein']);
      expect(
        find.byKey(const ValueKey('nutrition-row-Protein')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const ValueKey('catalog-fab-add')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('catalog-name-field')),
        'Protein',
      );
      await tester.tap(find.byKey(const ValueKey('catalog-sheet-save')));
      await tester.pumpAndSettle();
      expect(find.text('Nutrition already exists'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('nutrition-row-Protein')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('catalog-name-field')),
        'Dietary protein',
      );
      await tester.tap(find.byKey(const ValueKey('catalog-sheet-save')));
      await _pumpUntil(
        tester,
        () =>
            nutritionManager.state is LoadedNutritionManager &&
            (nutritionManager.state as LoadedNutritionManager).nutritions
                .contains('Dietary protein'),
      );

      expect(repository.getNutritions(), ['Dietary protein']);
      expect(
        find.byKey(const ValueKey('nutrition-row-Dietary protein')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'nutrition reorder and delete preserve values stored on recipes',
    (tester) async {
      await repository.addNutrition('Protein');
      await repository.addNutrition('Fiber');
      await repository.saveRecipe(
        Recipe(
          name: 'Soup',
          nutritions: const [Nutrition(name: 'Protein', amountUnit: '12 g')],
        ),
      );
      nutritionManager.add(LoadNutritionManager());
      await _pumpManager(
        tester,
        providers: [
          BlocProvider<NutritionManagerBloc>.value(value: nutritionManager),
        ],
        child: const NutritionManager(),
      );

      await tester.tap(find.byKey(const ValueKey('nutrition-row-Protein')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('catalog-name-field')),
        'Protein total',
      );
      await tester.tap(find.byKey(const ValueKey('catalog-sheet-save')));
      await _pumpUntil(
        tester,
        () =>
            nutritionManager.state is LoadedNutritionManager &&
            (nutritionManager.state as LoadedNutritionManager)
                    .nutritions
                    .first ==
                'Protein total',
      );

      var savedRecipe = await repository.getRecipeByName('Soup');
      expect(savedRecipe?.nutritions, const [
        Nutrition(name: 'Protein', amountUnit: '12 g'),
      ]);

      final reorderable = tester.widget<SliverReorderableList>(
        find.byType(SliverReorderableList),
      );
      reorderable.onReorderItem!(0, 1);
      await _pumpUntil(
        tester,
        () =>
            nutritionManager.state is LoadedNutritionManager &&
            (nutritionManager.state as LoadedNutritionManager).nutritions.join(
                  ',',
                ) ==
                'Fiber,Protein total',
      );
      expect(repository.getNutritions(), ['Fiber', 'Protein total']);

      await tester.tap(find.byTooltip('More actions for Protein total'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete').last);
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Existing recipes keep their saved'),
        findsOneWidget,
      );
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('nutrition-row-Protein total')),
        findsOneWidget,
      );

      await tester.tap(find.byTooltip('More actions for Protein total'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('catalog-confirm-delete')));
      await _pumpUntil(
        tester,
        () =>
            nutritionManager.state is LoadedNutritionManager &&
            !(nutritionManager.state as LoadedNutritionManager).nutritions
                .contains('Protein total'),
      );

      expect(repository.getNutritions(), ['Fiber']);
      savedRecipe = await repository.getRecipeByName('Soup');
      expect(savedRecipe?.nutritions, const [
        Nutrition(name: 'Protein', amountUnit: '12 g'),
      ]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('German OLED nutrition empty state handles tablet large text', (
    tester,
  ) async {
    nutritionManager.add(LoadNutritionManager());
    await _pumpManager(
      tester,
      providers: [
        BlocProvider<NutritionManagerBloc>.value(value: nutritionManager),
      ],
      child: const NutritionManager(),
      size: const Size(1024, 900),
      locale: const Locale('de', 'DE'),
      textScale: 1.3,
      themeKey: MyThemeKeys.OLEDBLACK,
    );

    expect(find.text('Nährwerte verwalten'), findsWidgets);
    expect(find.text('Noch keine Nährwertangaben'), findsOneWidget);
    expect(find.text('Nährwertangabe hinzufügen'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tag sheet updates name and color with a live preview', (
    tester,
  ) async {
    await repository.addRecipeTag('Quick', Colors.orange.toARGB32());
    tagManager.add(InitializeRecipeTagManager());
    await _pumpManager(
      tester,
      providers: [
        BlocProvider<RecipeManagerBloc>.value(value: recipeManager),
        BlocProvider<RecipeTagManagerBloc>.value(value: tagManager),
      ],
      child: const RecipeTagManager(),
      themeKey: MyThemeKeys.DARK,
    );

    await tester.tap(find.byKey(const ValueKey('tag-row-Quick')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('tag-color-preview')), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('catalog-name-field')),
      'Fast',
    );
    await tester.tap(find.byKey(const ValueKey('tag-color-6')));
    await tester.tap(find.byKey(const ValueKey('catalog-sheet-save')));
    await _pumpUntil(
      tester,
      () =>
          tagManager.state is LoadedRecipeTagManager &&
          (tagManager.state as LoadedRecipeTagManager).recipeTags.any(
            (tag) => tag.text == 'Fast',
          ),
    );

    expect(find.byKey(const ValueKey('tag-row-Fast')), findsOneWidget);
    expect(repository.getRecipeTags(), const [
      StringIntTuple(text: 'Fast', number: 0xFF00838F),
    ]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('German OLED empty state handles tablet width and large text', (
    tester,
  ) async {
    tagManager.add(InitializeRecipeTagManager());
    await _pumpManager(
      tester,
      providers: [
        BlocProvider<RecipeManagerBloc>.value(value: recipeManager),
        BlocProvider<RecipeTagManagerBloc>.value(value: tagManager),
      ],
      child: const RecipeTagManager(),
      size: const Size(1024, 900),
      locale: const Locale('de', 'DE'),
      textScale: 1.3,
      themeKey: MyThemeKeys.OLEDBLACK,
    );

    expect(find.text('Tags verwalten'), findsWidgets);
    expect(find.text('Noch keine Rezept-Tags'), findsOneWidget);
    expect(find.text('Tag hinzufügen'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('add sheets keep the editorial theme in dark and OLED modes', (
    tester,
  ) async {
    await repository.addCategory('Dinner');
    categoryManager.add(InitializeCategoryManager());
    await _pumpManager(
      tester,
      providers: [
        BlocProvider<RecipeManagerBloc>.value(value: recipeManager),
        BlocProvider<CategoryManagerBloc>.value(value: categoryManager),
      ],
      child: const CategoryManager(),
      themeKey: MyThemeKeys.DARK,
    );

    await tester.tap(find.byKey(const ValueKey('catalog-fab-add')));
    await tester.pumpAndSettle();
    var sheetTheme = Theme.of(
      tester.element(find.byKey(const ValueKey('catalog-name-field'))),
    );
    expect(
      sheetTheme.colorScheme.primary,
      CulinaryEditorialPalette.dark.primary,
    );
    expect(
      sheetTheme.textTheme.bodyLarge?.fontFamily,
      CulinaryEditorialType.bodyFamily,
    );
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    tagManager.add(InitializeRecipeTagManager());
    await _pumpManager(
      tester,
      providers: [
        BlocProvider<RecipeManagerBloc>.value(value: recipeManager),
        BlocProvider<RecipeTagManagerBloc>.value(value: tagManager),
      ],
      child: const RecipeTagManager(),
      themeKey: MyThemeKeys.OLEDBLACK,
    );
    await tester.tap(find.byKey(const ValueKey('catalog-empty-add')));
    await tester.pumpAndSettle();
    sheetTheme = Theme.of(
      tester.element(find.byKey(const ValueKey('catalog-name-field'))),
    );
    expect(
      sheetTheme.colorScheme.primary,
      CulinaryEditorialPalette.oled.primary,
    );
    expect(
      sheetTheme.textTheme.bodyLarge?.fontFamily,
      CulinaryEditorialType.bodyFamily,
    );
  });

  testWidgets('tablet title and add action align to the content column', (
    tester,
  ) async {
    await repository.addCategory('Dinner');
    categoryManager.add(InitializeCategoryManager());
    await _pumpManager(
      tester,
      providers: [
        BlocProvider<RecipeManagerBloc>.value(value: recipeManager),
        BlocProvider<CategoryManagerBloc>.value(value: categoryManager),
      ],
      child: const CategoryManager(),
      size: const Size(1024, 900),
    );

    final titleRect = tester.getRect(
      find.byKey(const ValueKey('catalog-title')).last,
    );
    final introductionRect = tester.getRect(
      find.byKey(const ValueKey('catalog-introduction')),
    );
    final fabRect = tester.getRect(
      find.byKey(const ValueKey('catalog-fab-add')),
    );
    expect(titleRect.left, closeTo(introductionRect.left, 1));
    expect(fabRect.right, closeTo(introductionRect.right, 1));
  });
}

Future<void> _pumpManager(
  WidgetTester tester, {
  required List<BlocProvider> providers,
  required Widget child,
  Size size = const Size(430, 900),
  Locale locale = const Locale('en'),
  double textScale = 1,
  MyThemeKeys themeKey = MyThemeKeys.LIGHT,
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    CustomTheme(
      initialThemeKey: themeKey,
      child: Builder(
        builder: (context) => MaterialApp(
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
          home: MediaQuery(
            data: MediaQueryData(
              size: size,
              textScaler: TextScaler.linear(textScale),
            ),
            child: MultiBlocProvider(providers: providers, child: child),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpUntil(WidgetTester tester, bool Function() condition) async {
  var completed = false;
  await tester.runAsync(() async {
    for (var attempt = 0; attempt < 100; attempt++) {
      if (condition()) {
        completed = true;
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
  });
  if (!completed) {
    fail('Timed out waiting for the catalog manager state to update.');
  }
  await tester.pumpAndSettle();
}
