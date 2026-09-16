import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/new_recipe/general_info/general_info_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_tag_manager/recipe_tag_manager_bloc.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';
import 'package:my_recipe_book/screens/add_recipe/general_info_screen/recipe_tag_section.dart';

void main() {
  late AppDatabase database;
  late DriftRepository repository;
  late RecipeManagerBloc recipeManagerBloc;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRepository(database: database);
    await repository.initialize();
    recipeManagerBloc = RecipeManagerBloc(repository);
  });

  tearDown(() async {
    await recipeManagerBloc.close();
    await database.close();
  });

  test(
    'selection normalizes duplicates and catalog color, then removes by name',
    () async {
      const currentTag = StringIntTuple(text: 'Quick', number: 20);
      const staleTag = StringIntTuple(text: 'Quick', number: 10);
      await repository.addRecipeTag(currentTag.text, currentTag.number);
      final bloc = RecipeTagManagerBloc(
        recipeManagerBloc: recipeManagerBloc,
        repository: repository,
        selectedTags: const [staleTag, staleTag],
      );
      addTearDown(bloc.close);

      final initialized = _nextLoaded(bloc, (state) => true);
      bloc.add(InitializeRecipeTagManager());
      final initialState = await initialized;

      expect(initialState.selectedTags, const [currentTag]);

      final unselected = _nextLoaded(
        bloc,
        (state) => state.selectedTags.isEmpty,
      );
      bloc.add(const UnselectRecipeTag(currentTag));
      expect((await unselected).selectedTags, isEmpty);
    },
  );

  test('selecting the same tag repeatedly is idempotent', () async {
    const tag = StringIntTuple(text: 'Quick', number: 20);
    await repository.addRecipeTag(tag.text, tag.number);
    final bloc = RecipeTagManagerBloc(
      recipeManagerBloc: recipeManagerBloc,
      repository: repository,
    );
    addTearDown(bloc.close);

    final initialized = _nextLoaded(bloc, (state) => true);
    bloc.add(InitializeRecipeTagManager());
    await initialized;

    final selected = _nextLoaded(
      bloc,
      (state) => state.selectedTags.length == 1,
    );
    bloc
      ..add(const SelectRecipeTag(tag))
      ..add(const SelectRecipeTag(tag));
    await selected;
    await Future<void>.delayed(Duration.zero);

    expect((bloc.state as LoadedRecipeTagManager).selectedTags, const [tag]);
  });

  test(
    'saving an empty selected-tag snapshot clears the editing draft',
    () async {
      const tag = StringIntTuple(text: 'Quick', number: 20);
      await repository.saveTmpEditingRecipe(
        Recipe(name: 'Soup', tags: const [tag]),
      );
      final bloc = GeneralInfoBloc(repository);
      addTearDown(bloc.close);

      final saved = bloc.stream
          .where((state) => state is GSaved)
          .cast<GSaved>()
          .first;
      bloc.add(
        FinishedEditing(
          'Soup',
          true,
          false,
          0,
          0,
          0,
          null,
          const [],
          const [],
          '',
          null,
          null,
          Vegetable.NON_VEGETARIAN,
          5,
        ),
      );

      expect((await saved).recipe.tags, isEmpty);
      expect(repository.getTmpEditingRecipe()!.tags, isEmpty);
    },
  );

  testWidgets('recipe tag chip is controlled by its selected property', (
    tester,
  ) async {
    const tag = StringIntTuple(text: 'Quick', number: 20);
    bool? selection;

    Future<void> pumpChip(bool isSelected) => tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyRecipeTagFilterChip(
            recipeTag: tag,
            isSelected: isSelected,
            onSelected: (value) => selection = value,
          ),
        ),
      ),
    );

    await pumpChip(true);
    expect(tester.widget<FilterChip>(find.byType(FilterChip)).selected, isTrue);

    await tester.tap(find.byType(FilterChip));
    expect(selection, isFalse);

    await pumpChip(false);
    expect(
      tester.widget<FilterChip>(find.byType(FilterChip)).selected,
      isFalse,
    );
  });
}

Future<LoadedRecipeTagManager> _nextLoaded(
  RecipeTagManagerBloc bloc,
  bool Function(LoadedRecipeTagManager state) predicate,
) {
  final current = bloc.state;
  if (current is LoadedRecipeTagManager && predicate(current)) {
    return Future.value(current);
  }
  return bloc.stream
      .where((state) => state is LoadedRecipeTagManager)
      .cast<LoadedRecipeTagManager>()
      .firstWhere(predicate);
}
