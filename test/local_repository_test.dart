import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/nutrition.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_sort.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

void main() {
  late AppDatabase database;
  late DriftRepository repository;
  late bool databaseClosed;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    databaseClosed = false;
    repository = DriftRepository(database: database);
    await repository.initialize();
  });

  tearDown(() async {
    if (!databaseClosed) await database.close();
  });

  test('ingredient identities and step assignments round-trip', () async {
    final recipe = Recipe(
      name: 'Duplicate onions',
      ingredientsGlossary: const ['Sauce', 'Garnish'],
      ingredients: const [
        [Ingredient(id: 'sauce-onion', name: 'Onion', amount: 1)],
        [Ingredient(id: 'garnish-onion', name: 'Onion', amount: .5)],
      ],
      steps: const ['Cook the sauce', 'Finish and serve'],
      stepImages: const [[], []],
      stepTitles: const ['', ''],
      stepIngredientIds: const [
        ['sauce-onion'],
        ['sauce-onion', 'garnish-onion'],
      ],
    );

    await repository.saveRecipe(recipe);
    final loaded = await repository.getRecipeByName(recipe.name);

    expect(loaded, recipe);
    expect(loaded!.ingredients[0].single.id, 'sauce-onion');
    expect(loaded.ingredients[1].single.id, 'garnish-onion');
    expect(loaded.stepIngredientIds, recipe.stepIngredientIds);

    final sauceRow = await (database.select(
      database.storedIngredients,
    )..where((row) => row.opaqueId.equals('sauce-onion'))).getSingle();
    await (database.delete(
      database.storedIngredients,
    )..where((row) => row.id.equals(sauceRow.id))).go();
    expect(
      await database.select(database.storedStepIngredients).get(),
      hasLength(1),
    );
  });

  test('recipe JSON remains legacy-compatible and prunes dangling links', () {
    final legacy = Recipe.fromMap({
      'name': 'Legacy',
      'image': 'images/randomFood.jpg',
      'imagePreviewPath': 'images/randomFood.jpg',
      'preperationTime': 0,
      'cookingTime': 0,
      'totalTime': 0,
      'servings': null,
      'categories': <String>[],
      'ingredientsGlossary': ['Main'],
      'ingredients': [
        [
          {'name': 'Salt', 'amount': 1, 'unit': 'tsp'},
        ],
      ],
      'vegetable': Vegetable.VEGETARIAN.toString(),
      'steps': ['Season'],
      'stepImages': [[]],
      'notes': '',
      'nutritions': <Map<String, dynamic>>[],
      'lastModified': firstModified,
      'source': null,
    }, keepDateTime: true);

    expect(legacy.stepIngredientIds, isEmpty);
    final identified = legacy.ensureIngredientIds();
    final ingredientId = identified.ingredients.single.single.id!;
    final imported = Recipe.fromMap({
      ...identified.toMap(),
      'stepIngredientIds': [
        [ingredientId, 'missing-id'],
      ],
    }, keepDateTime: true).ensureIngredientIds();

    expect(imported.stepIngredientIds, [
      [ingredientId],
    ]);
    expect(Recipe.fromMap(imported.toMap(), keepDateTime: true), imported);
  });

  test('legacy snapshot round-trips all user-visible state', () async {
    final recipe = Recipe(
      name: 'Crème brûlée',
      imagePath: '/recipes/creme/image.jpg',
      imagePreviewPath: '/recipes/creme/preview.jpg',
      preperationTime: 10.5,
      cookingTime: 40,
      totalTime: 50.5,
      servings: 4,
      servingName: 'portions',
      categories: const ['Dessert'],
      ingredientsGlossary: const ['Custard', 'Topping'],
      ingredients: const [
        [Ingredient(name: 'Cream', amount: 500, unit: 'ml')],
        [],
      ],
      vegetable: Vegetable.VEGETARIAN,
      steps: const ['Mix', 'Bake'],
      stepTitles: const ['Prepare', 'Cook'],
      stepImages: const [
        [],
        ['/recipes/creme/step.jpg'],
      ],
      notes: 'Keep chilled',
      nutritions: const [Nutrition(name: 'Energy', amountUnit: '200 kcal')],
      effort: 2,
      lastModified: '2026-09-13 12:34:56.789',
      rating: 9,
      tags: const [StringIntTuple(text: 'Sweet', number: 0xFFFFA000)],
      source: 'Family recipe',
    );
    final draft = Recipe(name: 'Unfinished', notes: 'draft note');
    final deletedAt = '2026-09-12 10:00:00.000';

    await repository.importLegacySnapshot(
      LegacySnapshot(
        recipes: [recipe],
        favoriteNames: {'Crème brûlée'},
        categories: [
          LegacyCategory('Dessert', RSort(RecipeSort.BY_EFFORT, false)),
          LegacyCategory(noCategoryName, RSort(RecipeSort.BY_NAME, true)),
        ],
        tags: const [StringIntTuple(text: 'Sweet', number: 0xFFFFA000)],
        ingredientCatalog: const ['Cream', 'Vanilla'],
        nutritionCatalog: const ['Energy'],
        calendar: const [
          LegacyCalendarValue('2026-09-20T18:00:00.000', 'Crème brûlée', 12),
        ],
        shoppingSources: const [
          LegacyShoppingSource(shoppingSummaryName, shoppingSummaryName, [
            CheckableIngredient('Cream', 500, 'ml', true),
          ], isSummary: true),
          LegacyShoppingSource('Crème brûlée', 'Crème brûlée', [
            CheckableIngredient('Cream', 500, 'ml', true),
          ]),
        ],
        deletions: {'Old recipe': deletedAt},
        backupFiles: const [],
        issues: const {},
        newDraft: draft,
      ),
    );

    final loaded = await repository.getRecipeByName('Crème brûlée');
    expect(loaded, recipe.copyWith(isFavorite: true));
    expect(repository.getCategoryNames(), ['Dessert', noCategoryName]);
    expect(await repository.getCategoryRecipes('Dessert'), [
      recipe.copyWith(isFavorite: true),
    ]);
    expect(await repository.getRecipeTagRecipes('Sweet'), [
      recipe.copyWith(isFavorite: true),
    ]);
    expect(await repository.getFavoriteRecipes(), [
      recipe.copyWith(isFavorite: true),
    ]);
    expect(
      await repository.getSortOrder('Dessert'),
      RSort(RecipeSort.BY_EFFORT, false),
    );
    expect(repository.getIngredientNames(), ['Cream', 'Vanilla']);
    expect(repository.getNutritions(), ['Energy']);
    expect(repository.getTmpRecipe(), draft);
    expect(repository.getDeletionDate('Old recipe'), DateTime.parse(deletedAt));
    expect(await repository.getRecipeCalendar(), {
      DateTime.parse('2026-09-20T18:00:00.000'): ['Crème brûlée'],
    });
    expect(
      repository.checkForRecipeIngredient(
        'Crème brûlée',
        const Ingredient(name: 'Cream', amount: 400, unit: 'ml'),
      ),
      isTrue,
    );
    expect(await repository.hasCompletedLegacyMigration(), isTrue);
  });

  test('failed snapshot import rolls back without completion marker', () async {
    final invalid = LegacySnapshot(
      recipes: [Recipe(name: 'Should roll back')],
      favoriteNames: const {},
      categories: [
        LegacyCategory('Duplicate', RSort(RecipeSort.BY_NAME, true)),
        LegacyCategory('Duplicate', RSort(RecipeSort.BY_NAME, true)),
      ],
      tags: const [],
      ingredientCatalog: const [],
      nutritionCatalog: const [],
      calendar: const [],
      shoppingSources: const [],
      deletions: const {},
      backupFiles: const [],
      issues: const {},
    );

    await expectLater(
      repository.importLegacySnapshot(invalid),
      throwsA(anything),
    );
    expect(await repository.hasCompletedLegacyMigration(), isFalse);
    expect(await repository.getAllRecipes(), isEmpty);
  });

  test('parallel collection presence and duplicate links round-trip', () async {
    final tag = const StringIntTuple(text: 'Repeated', number: 7);
    final recipe = Recipe(
      name: 'Parallel lists',
      categories: const ['A', 'A'],
      tags: const [
        StringIntTuple(text: 'Repeated', number: 7),
        StringIntTuple(text: 'Repeated', number: 7),
      ],
      ingredients: const [
        [],
        [Ingredient(name: 'Only second group')],
      ],
      ingredientsGlossary: const ['First', 'Second', 'Glossary only'],
      steps: const ['One'],
      stepImages: const [
        [],
        ['image-only-group.jpg'],
      ],
      stepTitles: const [],
    );

    await repository.importLegacySnapshot(
      LegacySnapshot(
        recipes: [recipe],
        favoriteNames: const {},
        categories: [LegacyCategory('A', RSort(RecipeSort.BY_NAME, true))],
        tags: [tag],
        ingredientCatalog: const ['Only second group'],
        nutritionCatalog: const [],
        calendar: const [],
        shoppingSources: const [],
        deletions: const {},
        backupFiles: const [],
        issues: const {},
      ),
    );

    expect(await repository.getRecipeByName(recipe.name), recipe);
  });

  test(
    'fresh initialization keeps seeding retryable until acknowledged',
    () async {
      await repository.initializeFresh();
      expect(await repository.isFreshSeedPending(), isTrue);

      await repository.markFreshSeedComplete();
      expect(await repository.isFreshSeedPending(), isFalse);
    },
  );

  test(
    'recipe mutations refresh queries, catalogs, favorites, and tombstones',
    () async {
      final first = Recipe(
        name: 'Soup',
        categories: const ['Dinner'],
        tags: const [StringIntTuple(text: 'Warm', number: 12)],
        ingredients: const [
          [Ingredient(name: 'Carrot', amount: 2, unit: 'pc')],
        ],
        nutritions: const [Nutrition(name: 'Fiber', amountUnit: '4 g')],
        vegetable: Vegetable.VEGAN,
      );
      await repository.saveRecipe(first);

      expect(repository.getRecipeNames(), ['Soup']);
      expect(repository.getCategoryNames(), ['Dinner']);
      expect(repository.getRecipeAmountCategory('Dinner'), 1);
      expect(repository.getIngredientNames(), ['Carrot']);
      expect(repository.getNutritions(), ['Fiber']);
      expect(
        (await repository.getRecipeTagRecipes('Warm')).single.name,
        'Soup',
      );
      expect(
        (await repository.getVegetableRecipes(Vegetable.VEGAN)).single.name,
        'Soup',
      );

      await repository.addToFavorites(first);
      expect(repository.isRecipeFavorite('Soup'), isTrue);
      expect((await repository.getFavoriteRecipes()).single.name, 'Soup');

      final renamed = first.copyWith(name: 'Stew', categories: const []);
      await repository.modifyRecipe('Soup', renamed);
      expect(repository.getRecipeNames(), ['Stew']);
      expect(repository.getRecipeAmountCategory('Dinner'), 0);
      expect(repository.wasDeletedBefore('Soup'), isTrue);

      await repository.deleteRecipe(
        'Stew',
        deletionDate: '2026-01-02T03:04:05.000',
      );
      expect(await repository.getAllRecipes(), isEmpty);
      expect(
        repository.getDeletionDate('Stew'),
        DateTime.parse('2026-01-02T03:04:05.000'),
      );
    },
  );

  test('catalog order and cache snapshots survive reload', () async {
    await repository.initializeFresh();
    await repository.addCategory('Breakfast');
    await repository.addCategory('Dinner');
    await repository.moveCategory(1, 0);
    await repository.changeSortOrder(
      RSort(RecipeSort.BY_EFFORT, false),
      'Breakfast',
    );
    await repository.addRecipeTag('Quick', 10);
    await repository.updateRecipeTag('Quick', 'Fast', 20);
    await repository.addNutrition('Protein');
    await repository.addNutrition('Energy');
    await repository.moveNutrition(1, 0);

    await repository.reopenBoxes();
    expect(repository.getCategoryNames(), [
      'Dinner',
      'Breakfast',
      noCategoryName,
    ]);
    expect(
      await repository.getSortOrder('Breakfast'),
      RSort(RecipeSort.BY_EFFORT, false),
    );
    expect(repository.getRecipeTags(), const [
      StringIntTuple(text: 'Fast', number: 20),
    ]);
    expect(repository.getNutritions(), ['Energy', 'Protein']);
    expect(
      () => repository.getCategoryNames().add('mutable'),
      throwsUnsupportedError,
    );
  });

  test(
    'calendar preserves duplicates and removes one matching entry',
    () async {
      final date = DateTime(2026, 9, 20, 18);
      await repository.addRecipeToCalendar(date, 'Soup');
      await repository.addRecipeToCalendar(date, 'Soup');
      await repository.addRecipeToCalendar(date, 'Stew');
      expect((await repository.getRecipeCalendar())[date], [
        'Soup',
        'Soup',
        'Stew',
      ]);

      await repository.removeRecipeFromDateCalendar(date, 'Soup');
      expect((await repository.getRecipeCalendar())[date], ['Soup', 'Stew']);
      await repository.removeRecipeFromCalendar('Soup');
      expect((await repository.getRecipeCalendar())[date], ['Stew']);
    },
  );

  test('drafts and shopping cart persist through cache reload', () async {
    const carrot = Ingredient(name: 'Carrot', amount: 2, unit: 'pc');
    await repository.saveTmpRecipe(Recipe(name: 'Draft'));
    await repository.saveTmpEditingRecipe(Recipe(name: 'Editing'));
    await repository.addSingleIngredientToCart('Soup', carrot);
    await repository.reopenBoxes();

    expect(repository.getTmpRecipe()?.name, 'Draft');
    expect(repository.getTmpEditingRecipe()?.name, 'Editing');
    expect(repository.checkForRecipeIngredient('Soup', carrot), isTrue);
    final cart = await repository.getShoppingCart();
    expect(
      cart.keys.map((recipe) => recipe.name),
      containsAll(['summary', 'Soup']),
    );

    await repository.checkIngredient(
      'Soup',
      const CheckableIngredient('Carrot', 2, 'pc', true),
    );
    final checkedCart = await repository.getShoppingCart();
    expect(
      checkedCart.values.expand((items) => items).every((item) => item.checked),
      isTrue,
    );
    await repository.removeRecipeFromCart('Soup');
    expect(repository.checkForRecipeIngredient('Soup', carrot), isFalse);
    await repository.deleteTmpEditingRecipe();
    expect(repository.getTmpEditingRecipe(), isNull);
  });

  test(
    'shopping sources retain servings and scale only numeric contributions',
    () async {
      await repository.saveRecipe(Recipe(name: 'Soup', servings: 4));
      await repository.saveRecipe(Recipe(name: 'Bread', servings: 2));
      await repository.addMultipleIngredientsToCart('Soup', const [
        Ingredient(name: 'Carrot', amount: 2, unit: 'pc'),
        Ingredient(name: 'Salt'),
      ], servings: 2);
      await repository.addMultipleIngredientsToCart('Bread', const [
        Ingredient(name: 'Carrot', amount: 1, unit: 'pc'),
      ], servings: 2);
      await repository.checkIngredient(
        'Soup',
        const CheckableIngredient('Carrot', 2, 'pc', true),
      );

      await repository.updateShoppingCartServings('Soup', 3.5);
      await repository.reopenBoxes();

      final cart = await repository.getShoppingCartData();
      final soup = cart.recipeSources.singleWhere(
        (source) => source.key == 'Soup',
      );
      final bread = cart.recipeSources.singleWhere(
        (source) => source.key == 'Bread',
      );
      expect(soup.currentServings, 3.5);
      expect(
        soup.items.singleWhere((item) => item.name == 'Carrot'),
        const CheckableIngredient('Carrot', 3.5, 'pc', true),
      );
      expect(
        soup.items.singleWhere((item) => item.name == 'Salt').amount,
        isNull,
      );
      expect(
        bread.items.singleWhere((item) => item.name == 'Carrot').amount,
        1,
      );
      expect(
        cart.consolidatedItems
            .singleWhere((item) => item.name == 'Carrot')
            .amount,
        4.5,
      );
    },
  );

  test(
    'first serving adjustment assumes and then persists recipe default',
    () async {
      await repository.saveRecipe(Recipe(name: 'Pasta', servings: 4));
      await repository.addMultipleIngredientsToCart('Pasta', const [
        Ingredient(name: 'Pasta', amount: 400, unit: 'g'),
      ]);

      var source =
          (await repository.getShoppingCartData()).recipeSources.single;
      expect(source.currentServings, isNull);
      expect(source.effectiveServings, 4);

      await repository.updateShoppingCartServings('Pasta', 5);
      await repository.reopenBoxes();
      source = (await repository.getShoppingCartData()).recipeSources.single;
      expect(source.currentServings, 5);
      expect(source.items.single.amount, 500);
    },
  );

  test('bulk removal retains unchecked duplicate contributions and restores exactly', () async {
    await repository.addMultipleIngredientsToCart('Soup', const [
      Ingredient(name: 'Carrot', amount: 2, unit: 'pc'),
      Ingredient(name: 'Salt'),
    ]);
    await repository.addMultipleIngredientsToCart('Stew', const [
      Ingredient(name: 'Carrot', amount: 3, unit: 'pc'),
      Ingredient(name: 'Salt'),
    ]);
    await repository.addSingleIngredientToCart(
      shoppingSummaryName,
      const Ingredient(name: 'Napkins', amount: 1, unit: 'pack'),
    );
    await repository.checkIngredient(
      'Soup',
      const CheckableIngredient('Carrot', 2, 'pc', true),
    );
    await repository.checkIngredient(
      'Soup',
      const CheckableIngredient('Salt', null, null, true),
    );
    await repository.checkIngredient(
      shoppingSummaryName,
      const CheckableIngredient('Napkins', 1, 'pack', true),
    );
    final before = (await repository.getShoppingCartData()).snapshot();

    final undo = await repository.removeCheckedShoppingCartItems();
    final after = await repository.getShoppingCartData();

    expect(undo, before);
    expect(
      after.consolidatedItems
          .singleWhere((item) => item.name == 'Carrot')
          .amount,
      3,
    );
    expect(
      after.consolidatedItems.singleWhere((item) => item.name == 'Salt'),
      const CheckableIngredient('Salt', null, null, false),
    );
    expect(
      after.consolidatedItems.where((item) => item.name == 'Napkins'),
      isEmpty,
    );
    expect(
      after.recipeSources.singleWhere((source) => source.key == 'Stew').items,
      const [
        CheckableIngredient('Carrot', 3, 'pc', false),
        CheckableIngredient('Salt', null, null, false),
      ],
    );

    await repository.restoreShoppingCart(undo!);
    expect(await repository.getShoppingCartData(), before);
  });

  test('schema v1 cart rows migrate without data loss', () async {
    final directory = await Directory.systemTemp.createTemp('cart-schema-v1-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/legacy.sqlite');
    final legacy = sqlite3.sqlite3.open(file.path);
    legacy.execute('''
      CREATE TABLE shopping_sources (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        source_key TEXT NOT NULL UNIQUE,
        display_name TEXT NOT NULL,
        is_summary INTEGER NOT NULL DEFAULT 0 CHECK (is_summary IN (0, 1)),
        position INTEGER NOT NULL
      );
      INSERT INTO shopping_sources
        (source_key, display_name, is_summary, position)
        VALUES ('summary', 'summary', 1, 0), ('Soup', 'Soup', 0, 1);
      PRAGMA user_version = 1;
    ''');
    legacy.close();

    await database.close();
    databaseClosed = true;
    final migrated = AppDatabase(NativeDatabase(file));
    addTearDown(migrated.close);
    final sources = await migrated.select(migrated.shoppingSources).get();

    expect(sources.map((source) => source.sourceKey), ['summary', 'Soup']);
    expect(sources.every((source) => source.currentServings == null), isTrue);
  });

  test(
    'schema v2 creates ingredient identities and assignment table',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'recipe-schema-v2-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/legacy.sqlite');
      final legacy = sqlite3.sqlite3.open(file.path);
      legacy.execute('''
      CREATE TABLE stored_ingredient_groups (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
      );
      CREATE TABLE stored_ingredients (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        group_id INTEGER NOT NULL,
        position INTEGER NOT NULL,
        name TEXT NOT NULL,
        amount REAL NULL,
        unit TEXT NULL
      );
      CREATE TABLE stored_step_groups (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
      );
      PRAGMA user_version = 2;
    ''');
      legacy.close();

      await database.close();
      databaseClosed = true;
      final migrated = AppDatabase(NativeDatabase(file));
      addTearDown(migrated.close);
      await migrated.customSelect('SELECT 1').get();

      final ingredientColumns = await migrated
          .customSelect('PRAGMA table_info(stored_ingredients)')
          .get();
      final assignmentTables = await migrated
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'stored_step_ingredients'",
          )
          .get();
      expect(
        ingredientColumns.map((row) => row.read<String>('name')),
        contains('opaque_id'),
      );
      expect(assignmentTables, hasLength(1));
    },
  );

  test(
    'migration issues can be recovered without overwriting recipes',
    () async {
      await repository.importLegacySnapshot(
        LegacySnapshot(
          recipes: const [],
          favoriteNames: const {},
          categories: const [],
          tags: const [],
          ingredientCatalog: const [],
          nutritionCatalog: const [],
          calendar: const [],
          shoppingSources: const [],
          deletions: const {},
          backupFiles: const [],
          issues: const {'legacy-key': 'unreadable_recipe'},
        ),
      );
      expect(await repository.unresolvedMigrationIssueCount(), 1);
      expect(
        await repository.recoverLegacyRecipe(
          'legacy-key',
          Recipe(name: 'Recovered'),
        ),
        isTrue,
      );
      expect(await repository.unresolvedMigrationIssueCount(), 0);
      expect(
        await repository.recoverLegacyRecipe(
          'legacy-key',
          Recipe(name: 'Recovered'),
        ),
        isFalse,
      );
    },
  );
}
