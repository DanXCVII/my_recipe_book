import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_overview/recipe_overview_bloc.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';

void main() {
  late AppDatabase database;
  late DriftRepository repository;
  late RecipeManagerBloc manager;
  late RecipeOverviewBloc overview;
  late Recipe curry;
  late Recipe stew;
  late Recipe tart;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRepository(database: database);
    await repository.initialize();
    await repository.addCategory('Dinner');
    await repository.addRecipeTag('Spicy', 0xFFE05A36);
    await repository.addRecipeTag('Slow', 0xFFE58A2B);
    await repository.addRecipeTag('Savory', 0xFF4A7C59);

    curry = Recipe(
      name: 'Green Curry',
      categories: const ['Dinner'],
      vegetable: Vegetable.VEGAN,
      totalTime: 45,
      effort: 3,
      lastModified: '2026-09-10 10:00:00.000',
      ingredients: const [
        [Ingredient(name: 'Curry paste'), Ingredient(name: 'Coconut milk')],
      ],
      tags: const [StringIntTuple(text: 'Spicy', number: 0xFFE05A36)],
    );
    stew = Recipe(
      name: 'Beef Stew',
      categories: const ['Dinner'],
      vegetable: Vegetable.NON_VEGETARIAN,
      totalTime: 180,
      effort: 8,
      lastModified: '2026-09-12 10:00:00.000',
      ingredients: const [
        [
          Ingredient(name: 'Beef'),
          Ingredient(name: 'Carrot'),
          Ingredient(name: 'Stock'),
        ],
      ],
      tags: const [StringIntTuple(text: 'Slow', number: 0xFFE58A2B)],
    );
    tart = Recipe(
      name: 'Mushroom Tart',
      categories: const ['Dinner'],
      vegetable: Vegetable.VEGETARIAN,
      totalTime: 30,
      lastModified: firstModified,
      ingredients: const [
        [Ingredient(name: 'Mushroom')],
      ],
      tags: const [StringIntTuple(text: 'Savory', number: 0xFF4A7C59)],
    );
    await repository.saveRecipe(curry);
    await repository.saveRecipe(stew);
    await repository.saveRecipe(tart);

    manager = RecipeManagerBloc(repository);
    overview = RecipeOverviewBloc(
      recipeManagerBloc: manager,
      repository: repository,
    );
  });

  tearDown(() async {
    await overview.close();
    await manager.close();
    await database.close();
  });

  test('query, dietary, and tag filters compose and clear together', () async {
    var state = await _dispatch(
      overview,
      const LoadCategoryRecipeOverview('Dinner'),
      (state) => state.allRecipes.length == 3,
    );
    expect(state.visibleRecipes, hasLength(3));

    state = await _dispatch(
      overview,
      const FilterRecipesQuery('spicy'),
      (state) => state.query == 'spicy',
    );
    expect(state.visibleRecipes.map((recipe) => recipe.name), ['Green Curry']);

    state = await _dispatch(
      overview,
      const FilterRecipesVegetable(Vegetable.VEGAN),
      (state) => state.selectedVegetable == Vegetable.VEGAN,
    );
    expect(state.visibleRecipes.map((recipe) => recipe.name), ['Green Curry']);

    state = await _dispatch(
      overview,
      const FilterRecipesTag(['Slow']),
      (state) => state.selectedRecipeTags.contains('Slow'),
    );
    expect(state.visibleRecipes, isEmpty);

    state = await _dispatch(
      overview,
      ClearRecipeFilters(),
      (state) => !state.hasActiveFilters,
    );
    expect(state.visibleRecipes, hasLength(3));
  });

  test('sorts every key in both directions and keeps nulls last', () async {
    await _dispatch(
      overview,
      const LoadCategoryRecipeOverview('Dinner'),
      (state) => state.allRecipes.length == 3,
    );

    var state = await _dispatch(
      overview,
      const ChangeRecipeSort(RecipeSort.BY_TOTAL_TIME),
      (state) => state.recipeSort.sort == RecipeSort.BY_TOTAL_TIME,
    );
    expect(state.visibleRecipes.map((recipe) => recipe.name), [
      'Mushroom Tart',
      'Green Curry',
      'Beef Stew',
    ]);

    state = await _dispatch(
      overview,
      const ChangeAscending(false),
      (state) => state.recipeSort.ascending == false,
    );
    expect(state.visibleRecipes.map((recipe) => recipe.name), [
      'Beef Stew',
      'Green Curry',
      'Mushroom Tart',
    ]);

    state = await _dispatch(
      overview,
      const ChangeRecipeSort(RecipeSort.BY_EFFORT),
      (state) => state.recipeSort.sort == RecipeSort.BY_EFFORT,
    );
    expect(state.visibleRecipes.map((recipe) => recipe.name), [
      'Beef Stew',
      'Green Curry',
      'Mushroom Tart',
    ]);

    state = await _dispatch(
      overview,
      const ChangeAscending(true),
      (state) => state.recipeSort.ascending == true,
    );
    expect(state.visibleRecipes.map((recipe) => recipe.name), [
      'Green Curry',
      'Beef Stew',
      'Mushroom Tart',
    ]);

    state = await _dispatch(
      overview,
      const ChangeRecipeSort(RecipeSort.BY_NAME),
      (state) => state.recipeSort.sort == RecipeSort.BY_NAME,
    );
    expect(state.visibleRecipes.map((recipe) => recipe.name), [
      'Beef Stew',
      'Green Curry',
      'Mushroom Tart',
    ]);
    state = await _dispatch(
      overview,
      const ChangeAscending(false),
      (state) => state.recipeSort.ascending == false,
    );
    expect(state.visibleRecipes.map((recipe) => recipe.name), [
      'Mushroom Tart',
      'Green Curry',
      'Beef Stew',
    ]);
    await _dispatch(
      overview,
      const ChangeAscending(true),
      (state) => state.recipeSort.ascending == true,
    );

    state = await _dispatch(
      overview,
      const ChangeRecipeSort(RecipeSort.BY_INGREDIENT_COUNT),
      (state) => state.recipeSort.sort == RecipeSort.BY_INGREDIENT_COUNT,
    );
    expect(state.visibleRecipes.map((recipe) => recipe.name), [
      'Mushroom Tart',
      'Green Curry',
      'Beef Stew',
    ]);
    state = await _dispatch(
      overview,
      const ChangeAscending(false),
      (state) => state.recipeSort.ascending == false,
    );
    expect(state.visibleRecipes.map((recipe) => recipe.name), [
      'Beef Stew',
      'Green Curry',
      'Mushroom Tart',
    ]);
    await _dispatch(
      overview,
      const ChangeAscending(true),
      (state) => state.recipeSort.ascending == true,
    );

    state = await _dispatch(
      overview,
      const ChangeRecipeSort(RecipeSort.BY_LAST_MODIFIED),
      (state) => state.recipeSort.sort == RecipeSort.BY_LAST_MODIFIED,
    );
    expect(state.visibleRecipes.map((recipe) => recipe.name), [
      'Mushroom Tart',
      'Green Curry',
      'Beef Stew',
    ]);
    state = await _dispatch(
      overview,
      const ChangeAscending(false),
      (state) => state.recipeSort.ascending == false,
    );
    expect(state.visibleRecipes.map((recipe) => recipe.name), [
      'Beef Stew',
      'Green Curry',
      'Mushroom Tart',
    ]);
  });

  test(
    'favorite updates and recipe mutations preserve active filters',
    () async {
      await _dispatch(
        overview,
        const LoadCategoryRecipeOverview('Dinner'),
        (state) => state.allRecipes.length == 3,
      );
      await _dispatch(
        overview,
        const FilterRecipesQuery('green'),
        (state) => state.query == 'green',
      );

      final favoriteFuture = overview.stream
          .where((state) => state is LoadedRecipeOverview)
          .cast<LoadedRecipeOverview>()
          .firstWhere(
            (state) =>
                state.visibleRecipes.length == 1 &&
                state.visibleRecipes.first.isFavorite,
          );
      manager.add(RMAddFavorite(curry));
      var state = await favoriteFuture;
      expect(state.query, 'green');
      expect(state.visibleRecipes.single.isFavorite, isTrue);

      final renamed = curry.copyWith(name: 'Green Coconut Curry');
      state = await _dispatch(
        overview,
        UpdateRecipe(curry, renamed),
        (state) =>
            state.visibleRecipes.length == 1 &&
            state.visibleRecipes.first.name == renamed.name,
      );
      expect(state.query, 'green');
      expect(state.visibleRecipes.single.name, renamed.name);
    },
  );
}

Future<LoadedRecipeOverview> _dispatch(
  RecipeOverviewBloc bloc,
  RecipeOverviewEvent event,
  bool Function(LoadedRecipeOverview state) predicate,
) {
  final result = bloc.stream
      .where((state) => state is LoadedRecipeOverview)
      .cast<LoadedRecipeOverview>()
      .firstWhere(predicate);
  bloc.add(event);
  return result;
}
