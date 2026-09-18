import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/random_recipe_explorer/random_recipe_explorer_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';

void main() {
  late AppDatabase database;
  late DriftRepository repository;
  late RecipeManagerBloc manager;
  late RandomRecipeExplorerBloc explorer;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRepository(database: database);
    await repository.initialize();
    await repository.addCategory('Dinner');
    await repository.addCategory('Lunch');
    await repository.addCategory('Empty');
    await repository.addRecipeTag('Fast', 0xFFA83211);
    await repository.saveRecipe(
      Recipe(
        name: 'Tomato Pasta',
        categories: const ['Dinner'],
        tags: const [StringIntTuple(text: 'Fast', number: 0xFFA83211)],
      ),
    );
    await repository.saveRecipe(
      Recipe(name: 'Mushroom Soup', categories: const ['Lunch']),
    );
    manager = RecipeManagerBloc(repository);
    explorer = RandomRecipeExplorerBloc(
      recipeManagerBloc: manager,
      repository: repository,
      random: Random(4),
    );
  });

  tearDown(() async {
    await explorer.close();
    await manager.close();
    await database.close();
  });

  test('loads a unique, bounded deck and filters by category or tag', () async {
    explorer.add(const InitializeRandomRecipeExplorer());
    var loaded = await _nextLoaded(explorer);

    expect(loaded.randomRecipes.map((recipe) => recipe.name).toSet(), {
      'Tomato Pasta',
      'Mushroom Soup',
    });
    expect(loaded.randomRecipes, hasLength(2));

    explorer.add(const ChangeExploreFilter(ExploreFilter.category('Dinner')));
    loaded = await _nextLoaded(explorer);
    expect(loaded.filter, const ExploreFilter.category('Dinner'));
    expect(loaded.randomRecipes.single.name, 'Tomato Pasta');

    explorer.add(const ChangeExploreFilter(ExploreFilter.tag('Fast')));
    loaded = await _nextLoaded(explorer);
    expect(loaded.filter, const ExploreFilter.tag('Fast'));
    expect(loaded.randomRecipes.single.name, 'Tomato Pasta');
  });

  test(
    'falls back to all recipes when the selected filter disappears',
    () async {
      explorer.add(
        const InitializeRandomRecipeExplorer(
          filter: ExploreFilter.category('Dinner'),
        ),
      );
      await _nextLoaded(explorer);

      await repository.deleteCategory('Dinner');
      explorer.add(const ReloadRandomRecipeExplorer());
      final loaded = await _nextLoaded(explorer);

      expect(loaded.filter, const ExploreFilter.all());
      expect(loaded.randomRecipes, hasLength(2));
    },
  );

  test('keeps favorite changes in the current deck', () async {
    explorer.add(const InitializeRandomRecipeExplorer());
    await _nextLoaded(explorer);

    final recipe = await repository.getRecipeByName('Tomato Pasta');
    expect(recipe, isNotNull);
    manager.add(RMAddFavorite(recipe!));

    final loaded = await explorer.stream
        .where((state) => state is LoadedRandomRecipeExplorer)
        .cast<LoadedRandomRecipeExplorer>()
        .firstWhere(
          (state) => state.randomRecipes.any(
            (item) => item.name == 'Tomato Pasta' && item.isFavorite,
          ),
        );
    expect(
      loaded.randomRecipes
          .singleWhere((item) => item.name == 'Tomato Pasta')
          .isFavorite,
      isTrue,
    );
  });

  test('reload creates a fresh shuffled deck revision', () async {
    await explorer.close();
    explorer = RandomRecipeExplorerBloc(
      recipeManagerBloc: manager,
      repository: repository,
      random: _SequenceRandom([0, 1]),
    );
    explorer.add(const InitializeRandomRecipeExplorer());
    final first = await _nextLoaded(explorer);

    explorer.add(const ReloadRandomRecipeExplorer());
    final second = await _nextLoaded(explorer);

    expect(second.revision, greaterThan(first.revision));
    expect(
      second.randomRecipes.map((recipe) => recipe.name).toList(),
      isNot(equals(first.randomRecipes.map((recipe) => recipe.name).toList())),
    );
  });

  test('emits an empty deck for a valid filter with no recipes', () async {
    explorer.add(
      const InitializeRandomRecipeExplorer(
        filter: ExploreFilter.category('Empty'),
      ),
    );
    final loaded = await _nextLoaded(explorer);

    expect(loaded.filter, const ExploreFilter.category('Empty'));
    expect(loaded.randomRecipes, isEmpty);
  });

  test('reconciles recipe deletion and category metadata changes', () async {
    explorer.add(const InitializeRandomRecipeExplorer());
    await _nextLoaded(explorer);

    manager.add(const RMDeleteRecipe('Mushroom Soup', deleteFiles: false));
    final afterDelete = await explorer.stream
        .where((state) => state is LoadedRandomRecipeExplorer)
        .cast<LoadedRandomRecipeExplorer>()
        .firstWhere(
          (state) => state.randomRecipes.every(
            (recipe) => recipe.name != 'Mushroom Soup',
          ),
        );
    expect(afterDelete.randomRecipes, hasLength(1));

    manager.add(const RMAddCategories(['Seasonal']));
    final afterCategory = await explorer.stream
        .where((state) => state is LoadedRandomRecipeExplorer)
        .cast<LoadedRandomRecipeExplorer>()
        .firstWhere((state) => state.categories.contains('Seasonal'));
    expect(afterCategory.categories, contains('Seasonal'));
  });
}

Future<LoadedRandomRecipeExplorer> _nextLoaded(RandomRecipeExplorerBloc bloc) {
  return bloc.stream
      .where((state) => state is LoadedRandomRecipeExplorer)
      .cast<LoadedRandomRecipeExplorer>()
      .first;
}

class _SequenceRandom implements Random {
  _SequenceRandom(this.values);

  final List<int> values;
  var _index = 0;

  @override
  bool nextBool() => nextInt(2) == 0;

  @override
  double nextDouble() => nextInt(1 << 20) / (1 << 20);

  @override
  int nextInt(int max) => values[_index++ % values.length] % max;
}
