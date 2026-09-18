import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/recipe_calendar/recipe_calendar_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/recipe.dart';

void main() {
  late AppDatabase database;
  late DriftRepository repository;
  late RecipeManagerBloc manager;
  late RecipeCalendarBloc calendar;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRepository(database: database);
    await repository.initialize();
    await repository.saveRecipe(Recipe(name: 'Soup'));
    manager = RecipeManagerBloc(repository);
    calendar = RecipeCalendarBloc(manager, repository);
  });

  tearDown(() async {
    await calendar.close();
    await manager.close();
    await database.close();
  });

  test('loads an ordered Monday-to-Sunday week and navigates weeks', () async {
    final loaded = _nextLoaded(calendar);
    calendar.add(LoadRecipeCalendarEvent());
    final current = await loaded;

    expect(current.weekStart.weekday, DateTime.monday);
    expect(current.recipes.keys.length, 7);
    expect(
      current.recipes.keys.last,
      current.weekStart.add(const Duration(days: 6)),
    );

    final next = _nextLoaded(calendar);
    calendar.add(const ChangeCalendarWeek(1));
    expect(
      (await next).weekStart,
      current.weekStart.add(const Duration(days: 7)),
    );

    final restored = _nextLoaded(calendar);
    calendar.add(GoToCurrentCalendarWeek());
    expect((await restored).weekStart, current.weekStart);
  });

  test('removes one exact occurrence while preserving a duplicate', () async {
    final date = RecipeCalendarBloc.startOfWeek(DateTime.now())
        .add(const Duration(hours: 18));
    await repository.addRecipeToCalendar(date, 'Soup');
    await repository.addRecipeToCalendar(date, 'Soup');

    final loaded = _nextLoaded(calendar);
    calendar.add(LoadRecipeCalendarEvent());
    expect((await loaded).recipeCount, 2);

    final removed = _nextLoaded(calendar);
    calendar.add(RemoveRecipeFromDateEvent(date, 'Soup'));
    final state = await removed;
    expect(state.recipeCount, 1);
    expect(state.removedRecipe?.item2, 'Soup');
  });

  test(
    'keeps duplicate occurrences through rename and clears deletion',
    () async {
      final date = RecipeCalendarBloc.startOfWeek(DateTime.now())
          .add(const Duration(hours: 18));
      await repository.addRecipeToCalendar(date, 'Soup');
      await repository.addRecipeToCalendar(date, 'Soup');
      await repository.modifyRecipe('Soup', Recipe(name: 'Stew'));

      final renamed = _nextLoaded(calendar);
      calendar.add(const UpdateRecipeEvent('Soup', 'Stew'));
      final renamedState = await renamed;
      expect(renamedState.recipeCount, 2);
      expect(
        renamedState.recipes.values
            .expand((recipes) => recipes)
            .map((entry) => entry.item2.name),
        everyElement('Stew'),
      );

      await repository.deleteRecipe('Stew');
      final deleted = _nextLoaded(calendar);
      calendar.add(const RemoveRecipeFromCalendarEvent('Stew'));
      expect((await deleted).recipeCount, 0);
      expect(
        (await repository.getRecipeCalendar()).values.expand((names) => names),
        isNot(contains('Stew')),
      );
    },
  );

  test('reports a load failure and succeeds when retry recovers', () async {
    final gatedRepository = _CalendarGateRepository(repository)..fail = true;
    final gatedManager = RecipeManagerBloc(gatedRepository);
    final gatedCalendar = RecipeCalendarBloc(gatedManager, gatedRepository);
    addTearDown(gatedCalendar.close);
    addTearDown(gatedManager.close);

    final failed = gatedCalendar.stream.firstWhere(
      (state) => state is FailedRecipeCalendar,
    );
    gatedCalendar.add(LoadRecipeCalendarEvent());
    expect(await failed, isA<FailedRecipeCalendar>());

    gatedRepository.fail = false;
    final recovered = _nextLoaded(gatedCalendar);
    gatedCalendar.add(LoadRecipeCalendarEvent());
    expect((await recovered).recipes.keys, hasLength(7));
  });
}

Future<LoadedRecipeCalendarWeek> _nextLoaded(RecipeCalendarBloc bloc) => bloc
    .stream
    .where((state) => state is LoadedRecipeCalendarWeek)
    .cast<LoadedRecipeCalendarWeek>()
    .first;

class _CalendarGateRepository implements LocalRepository {
  _CalendarGateRepository(this.delegate);

  final LocalRepository delegate;
  bool fail = false;

  @override
  Future<Map<DateTime, List<String>>> getRecipeCalendar() {
    if (fail) return Future.error(StateError('calendar unavailable'));
    return delegate.getRecipeCalendar();
  }

  @override
  Future<Recipe?> getRecipeByName(String name) =>
      delegate.getRecipeByName(name);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
