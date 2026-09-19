import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/favorite_recipes/favorite_recipes_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_collection_filters.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';

void main() {
  late AppDatabase database;
  late DriftRepository repository;
  late RecipeManagerBloc manager;
  late FavoriteRecipesBloc favorites;

  final older = Recipe(
    name: 'Tomato Pasta',
    categories: const ['Weeknight'],
    vegetable: Vegetable.VEGETARIAN,
    ingredients: const [
      [Ingredient(name: 'San Marzano tomatoes')],
    ],
    tags: const [StringIntTuple(text: 'Comfort', number: 0xFFA83211)],
    lastModified: '2026-09-10 10:00:00.000',
    isFavorite: true,
  );
  final newer = Recipe(
    name: 'Mushroom Broth',
    vegetable: Vegetable.VEGAN,
    ingredients: const [
      [Ingredient(name: 'Shiitake mushrooms')],
    ],
    tags: const [StringIntTuple(text: 'Umami', number: 0xFF376847)],
    lastModified: '2026-09-14 10:00:00.000',
    isFavorite: true,
  );

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRepository(database: database);
    await repository.initialize();
    await repository.addCategory('Weeknight');
    await repository.addRecipeTag('Comfort', 0xFFA83211);
    await repository.addRecipeTag('Umami', 0xFF376847);
    await repository.saveRecipe(older);
    await repository.saveRecipe(newer);
    await repository.addToFavorites(older);
    await repository.addToFavorites(newer);
    manager = RecipeManagerBloc(repository);
    favorites = FavoriteRecipesBloc(
      recipeManagerBloc: manager,
      repository: repository,
    );
  });

  tearDown(() async {
    await favorites.close();
    await manager.close();
    await database.close();
  });

  test('loads bookmarks and defaults to latest modified first', () async {
    final loaded = _nextLoaded(favorites);
    favorites.add(const LoadFavorites());
    final state = await loaded;

    expect(state.visibleRecipes.map((recipe) => recipe.name), [
      'Mushroom Broth',
      'Tomato Pasta',
    ]);
    expect(state.recipeSort.sort, RecipeSort.BY_LAST_MODIFIED);
    expect(state.recipeSort.ascending, isFalse);
  });

  test(
    'combines ingredient search, category, diet, and clear filters',
    () async {
      final loaded = _nextLoaded(favorites);
      favorites.add(const LoadFavorites());
      await loaded;

      var next = _nextLoaded(favorites, (state) => state.query == 'tomatoes');
      favorites.add(const FilterFavoritesQuery('tomatoes'));
      var state = await next;
      expect(state.visibleRecipes.single.name, 'Tomato Pasta');

      next = _nextLoaded(
        favorites,
        (state) => state.filters.categories.contains('Weeknight'),
      );
      favorites.add(
        const UpdateFavoriteFilters(
          RecipeCollectionFilters(categories: ['Weeknight']),
        ),
      );
      state = await next;
      expect(state.visibleRecipes.single.name, 'Tomato Pasta');

      next = _nextLoaded(
        favorites,
        (state) => state.filters.vegetable == Vegetable.VEGAN,
      );
      favorites.add(
        const UpdateFavoriteFilters(
          RecipeCollectionFilters(
            categories: ['Weeknight'],
            vegetable: Vegetable.VEGAN,
          ),
        ),
      );
      state = await next;
      expect(state.visibleRecipes, isEmpty);

      next = _nextLoaded(favorites, (state) => !state.hasActiveFilters);
      favorites.add(ClearFavoriteFilters());
      state = await next;
      expect(state.visibleRecipes, hasLength(2));
    },
  );

  test('searches tags and synchronizes bookmark removal', () async {
    final loaded = _nextLoaded(favorites);
    favorites.add(const LoadFavorites());
    await loaded;

    var next = _nextLoaded(favorites, (state) => state.query == 'umami');
    favorites.add(const FilterFavoritesQuery('umami'));
    var state = await next;
    expect(state.visibleRecipes.single.name, 'Mushroom Broth');

    next = _nextLoaded(favorites, (state) => state.allRecipes.length == 1);
    manager.add(RMRemoveFavorite(newer));
    state = await next;
    expect(state.allRecipes.single.name, 'Tomato Pasta');
    expect(state.visibleRecipes, isEmpty);
  });

  test('removes stale collection filters after bookmark removal', () async {
    await _dispatch(
      favorites,
      const LoadFavorites(),
      (state) => state.allRecipes.length == 2,
    );
    await _dispatch(
      favorites,
      const UpdateFavoriteFilters(
        RecipeCollectionFilters(categories: ['Weeknight']),
      ),
      (state) => state.filters.categories.contains('Weeknight'),
    );

    final normalized = _nextLoaded(
      favorites,
      (state) =>
          state.allRecipes.length == 1 && state.filters.categories.isEmpty,
    );
    manager.add(RMRemoveFavorite(older));
    final state = await normalized;

    expect(state.visibleRecipes.single.name, 'Mushroom Broth');
  });
}

Future<LoadedFavorites> _dispatch(
  FavoriteRecipesBloc bloc,
  FavoriteRecipesEvent event,
  bool Function(LoadedFavorites state) predicate,
) {
  final result = _nextLoaded(bloc, predicate);
  bloc.add(event);
  return result;
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
