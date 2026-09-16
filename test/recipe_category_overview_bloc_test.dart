import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/recipe_category_overview/recipe_category_overview_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/recipe.dart';

void main() {
  late AppDatabase database;
  late DriftRepository repository;
  late RecipeManagerBloc manager;
  late RecipeCategoryOverviewBloc overview;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRepository(database: database);
    await repository.initialize();
    await repository.addCategory('Dinner');
    await repository.addCategory('Comfort');
    await repository.saveRecipe(
      Recipe(name: 'Tomato soup', categories: const ['Dinner', 'Comfort']),
    );
    manager = RecipeManagerBloc(repository);
    overview = RecipeCategoryOverviewBloc(
      recipeManagerBloc: manager,
      repository: repository,
    );
  });

  tearDown(() async {
    await overview.close();
    await manager.close();
    await database.close();
  });

  test(
    'loads category order and updates favorite copies in every section',
    () async {
      final loaded = _nextLoaded(overview);
      overview.add(RCOLoadRecipeCategoryOverview());
      final initial = await loaded;

      expect(initial.rCategoryOverview.map((section) => section.item1), [
        'Dinner',
        'Comfort',
      ]);
      expect(
        initial.rCategoryOverview.expand((section) => section.item2),
        everyElement(isNot(predicate<Recipe>((recipe) => recipe.isFavorite))),
      );

      final favoriteUpdated = _nextLoaded(overview);
      manager.add(RMAddFavorite(initial.rCategoryOverview.first.item2.single));
      final updated = await favoriteUpdated;

      expect(
        updated.rCategoryOverview
            .expand((section) => section.item2)
            .where((recipe) => recipe.name == 'Tomato soup'),
        everyElement(predicate<Recipe>((recipe) => recipe.isFavorite)),
      );
    },
  );

  test('keeps category sections coherent through recipe changes', () async {
    final loaded = _nextLoaded(overview);
    overview.add(RCOLoadRecipeCategoryOverview());
    final initial = await loaded;
    final original = initial.rCategoryOverview.first.item2.single;
    final revised = original.copyWith(categories: const ['Comfort']);

    final changed = _nextLoaded(overview);
    overview.add(RCOUpdateRecipe(original, revised));
    final updated = await changed;
    expect(updated.rCategoryOverview.first.item2, isEmpty);
    expect(updated.rCategoryOverview[1].item2.single, revised);

    final deleted = _nextLoaded(overview);
    overview.add(RCODeleteRecipe(revised));
    expect(
      (await deleted).rCategoryOverview.expand((section) => section.item2),
      isEmpty,
    );
  });

  test('reports a load failure and recovers on retry', () async {
    final gated = _CategoryGateRepository(repository)..fail = true;
    final gatedManager = RecipeManagerBloc(gated);
    final gatedOverview = RecipeCategoryOverviewBloc(
      recipeManagerBloc: gatedManager,
      repository: gated,
    );
    addTearDown(gatedOverview.close);
    addTearDown(gatedManager.close);

    final failed = gatedOverview.stream.firstWhere(
      (state) => state is FailedRecipeCategoryOverviewState,
    );
    gatedOverview.add(RCOLoadRecipeCategoryOverview());
    expect(await failed, isA<FailedRecipeCategoryOverviewState>());

    gated.fail = false;
    final recovered = _nextLoaded(gatedOverview);
    gatedOverview.add(RCOLoadRecipeCategoryOverview());
    expect((await recovered).rCategoryOverview, hasLength(2));
  });
}

Future<LoadedRecipeCategoryOverview> _nextLoaded(
  RecipeCategoryOverviewBloc bloc,
) => bloc.stream
    .where((state) => state is LoadedRecipeCategoryOverview)
    .cast<LoadedRecipeCategoryOverview>()
    .first;

class _CategoryGateRepository implements LocalRepository {
  _CategoryGateRepository(this.delegate);

  final LocalRepository delegate;
  bool fail = false;

  @override
  List<String> getCategoryNames() => delegate.getCategoryNames();

  @override
  Future<List<Recipe>> getCategoryRecipes(String category) {
    if (fail) return Future.error(StateError('categories unavailable'));
    return delegate.getCategoryRecipes(category);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
