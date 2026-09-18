import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/ingredient_search/ingredient_search_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';
import 'package:my_recipe_book/models/tuple.dart';

void main() {
  late AppDatabase database;
  late _ControllableRepository repository;
  late RecipeManagerBloc recipeManager;
  late IngredientSearchBloc bloc;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = _ControllableRepository(database: database);
    await repository.initialize();
    await _seedRepository(repository);
    recipeManager = RecipeManagerBloc(repository);
    bloc = IngredientSearchBloc(
      repository: repository,
      recipeManagerBloc: recipeManager,
    );
  });

  tearDown(() async {
    await bloc.close();
    await recipeManager.close();
    await database.close();
  });

  test(
    'combines ingredient, diet, category, tag, time, and effort filters',
    () async {
      const criteria = IngredientSearchCriteria(
        ingredients: ['spinach', 'pasta'],
        categories: ['Dinner'],
        recipeTags: [StringIntTuple(text: 'Quick', number: 0xFFE05A36)],
        vegetable: Vegetable.VEGAN,
        maxTotalTimeMinutes: 30,
        maxEffort: 3,
      );

      final result = await _search(bloc, criteria);

      expect(result.results, hasLength(1));
      expect(result.results.single.recipe.name, 'Green Pasta');
      expect(result.results.single.matchedIngredientCount, 2);
    },
  );

  test('filters all recipes without ingredients and excludes unknown capped values', () async {
    final result = await _search(
      bloc,
      const IngredientSearchCriteria(
        vegetable: Vegetable.VEGETARIAN,
        maxTotalTimeMinutes: 45,
        maxEffort: 5,
      ),
    );

    expect(result.results.map((entry) => entry.recipe.name), ['Garden Pie']);
    expect(result.results.single.matchedIngredientCount, 0);
  });

  test('supports best-match, time, effort, and name sorting', () async {
    final bestMatch = await _search(
      bloc,
      const IngredientSearchCriteria(
        ingredients: ['potato', 'chicken'],
        categories: ['Dinner'],
      ),
    );
    expect(bestMatch.results.first.recipe.name, 'Chicken Stew');

    final shortest = await _search(
      bloc,
      const IngredientSearchCriteria(
        categories: ['Dinner'],
        sort: IngredientSearchSort.shortestTime,
      ),
    );
    expect(shortest.results.map((entry) => entry.recipe.name), [
      'Green Pasta',
      'Garden Pie',
      'Chicken Stew',
      'Mystery Toast',
    ]);

    final effort = await _search(
      bloc,
      const IngredientSearchCriteria(
        categories: ['Dinner'],
        sort: IngredientSearchSort.lowestEffort,
      ),
    );
    expect(effort.results.map((entry) => entry.recipe.name), [
      'Green Pasta',
      'Garden Pie',
      'Chicken Stew',
      'Mystery Toast',
    ]);

    final name = await _search(
      bloc,
      const IngredientSearchCriteria(
        categories: ['Dinner'],
        sort: IngredientSearchSort.name,
      ),
    );
    expect(name.results.map((entry) => entry.recipe.name), [
      'Chicken Stew',
      'Garden Pie',
      'Green Pasta',
      'Mystery Toast',
    ]);
  });

  test('keeps an empty criteria set in the instructional state', () async {
    bloc.add(const UpdateIngredientSearch(IngredientSearchCriteria()));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state, isA<IngredientSearchInitial>());
  });

  test(
    'exposes a retryable failure and recovers with the same criteria',
    () async {
      const criteria = IngredientSearchCriteria(ingredients: ['spinach']);
      repository.failNextIngredientSearch = true;
      final failure = bloc.stream
          .where((state) => state is IngredientSearchFailure)
          .cast<IngredientSearchFailure>()
          .first;

      bloc.add(const UpdateIngredientSearch(criteria));
      expect((await failure).criteria, criteria);

      final recovered = bloc.stream
          .where((state) => state is IngredientSearchMatches)
          .cast<IngredientSearchMatches>()
          .firstWhere((state) => state.criteria == criteria);
      bloc.add(const RetryIngredientSearch(criteria));

      expect(
        (await recovered).results.map((entry) => entry.recipe.name),
        contains('Green Pasta'),
      );
    },
  );

  test(
    'synchronizes favorite changes without losing the active search',
    () async {
      final result = await _search(
        bloc,
        const IngredientSearchCriteria(categories: ['Dinner']),
      );
      final recipe = result.results.first.recipe;
      final updated = bloc.stream
          .where((state) => state is IngredientSearchMatches)
          .cast<IngredientSearchMatches>()
          .firstWhere(
            (state) => state.results.any(
              (entry) =>
                  entry.recipe.name == recipe.name && entry.recipe.isFavorite,
            ),
          );

      recipeManager.add(RMAddFavorite(recipe));
      final favoriteState = await updated;

      expect(favoriteState.criteria, result.criteria);
    },
  );

  test('publishes only the newest asynchronous search', () async {
    final firstSearchStarted = Completer<void>();
    final releaseFirstSearch = Completer<void>();
    repository.nextSearchStarted = firstSearchStarted;
    repository.nextSearchRelease = releaseFirstSearch;

    bloc.add(
      const UpdateIngredientSearch(
        IngredientSearchCriteria(ingredients: ['spinach']),
      ),
    );
    await firstSearchStarted.future;
    final latest = _search(
      bloc,
      const IngredientSearchCriteria(ingredients: ['chicken']),
    );
    final latestResult = await latest;
    releaseFirstSearch.complete();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(latestResult.results.single.recipe.name, 'Chicken Stew');
    expect(
      (bloc.state as IngredientSearchMatches).results.single.recipe.name,
      'Chicken Stew',
    );
  });
}

Future<IngredientSearchMatches> _search(
  IngredientSearchBloc bloc,
  IngredientSearchCriteria criteria,
) {
  final result = bloc.stream
      .where((state) => state is IngredientSearchMatches)
      .cast<IngredientSearchMatches>()
      .firstWhere((state) => state.criteria == criteria);
  bloc.add(UpdateIngredientSearch(criteria));
  return result;
}

Future<void> _seedRepository(DriftRepository repository) async {
  await repository.addCategory('Dinner');
  await repository.addRecipeTag('Quick', 0xFFE05A36);
  await repository.addRecipeTag('Comfort', 0xFFE58A2B);
  await repository.saveRecipe(
    Recipe(
      name: 'Green Pasta',
      ingredients: const [
        [Ingredient(name: 'Spinach'), Ingredient(name: 'Pasta')],
      ],
      categories: const ['Dinner'],
      tags: const [StringIntTuple(text: 'Quick', number: 0xFFE05A36)],
      vegetable: Vegetable.VEGAN,
      totalTime: 25,
      effort: 3,
    ),
  );
  await repository.saveRecipe(
    Recipe(
      name: 'Garden Pie',
      ingredients: const [
        [Ingredient(name: 'Spinach'), Ingredient(name: 'Pastry')],
      ],
      categories: const ['Dinner'],
      tags: const [StringIntTuple(text: 'Comfort', number: 0xFFE58A2B)],
      vegetable: Vegetable.VEGETARIAN,
      totalTime: 40,
      effort: 4,
    ),
  );
  await repository.saveRecipe(
    Recipe(
      name: 'Chicken Stew',
      ingredients: const [
        [Ingredient(name: 'Chicken'), Ingredient(name: 'Potato')],
      ],
      categories: const ['Dinner'],
      tags: const [StringIntTuple(text: 'Comfort', number: 0xFFE58A2B)],
      vegetable: Vegetable.NON_VEGETARIAN,
      totalTime: 90,
      effort: 7,
    ),
  );
  await repository.saveRecipe(
    Recipe(
      name: 'Mystery Toast',
      ingredients: const [
        [Ingredient(name: 'Bread')],
      ],
      categories: const ['Dinner'],
      vegetable: Vegetable.VEGETARIAN,
    ),
  );
}

class _ControllableRepository extends DriftRepository {
  _ControllableRepository({required super.database});

  bool failNextIngredientSearch = false;
  Completer<void>? nextSearchStarted;
  Completer<void>? nextSearchRelease;

  @override
  Future<List<Tuple2<int, Recipe>>> getRecipesWithIngredients(
    List<String> values,
  ) async {
    final started = nextSearchStarted;
    final release = nextSearchRelease;
    nextSearchStarted = null;
    nextSearchRelease = null;
    started?.complete();
    if (release != null) await release.future;
    if (failNextIngredientSearch) {
      failNextIngredientSearch = false;
      throw StateError('Synthetic ingredient-search failure');
    }
    return super.getRecipesWithIngredients(values);
  }
}
