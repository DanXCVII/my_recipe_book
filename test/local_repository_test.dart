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

void main() {
  late AppDatabase database;
  late DriftRepository repository;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRepository(database: database);
    await repository.initialize();
  });

  tearDown(() => database.close());

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
