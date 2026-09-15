import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/new_recipe/ingredients/ingredients_bloc.dart'
    as ingredients_bloc;
import 'package:my_recipe_book/blocs/new_recipe/ingredients_section/ingredients_section_bloc.dart';
import 'package:my_recipe_book/blocs/new_recipe/step_images/step_images_bloc.dart';
import 'package:my_recipe_book/blocs/nutrition_manager/nutrition_manager_bloc.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/screens/add_recipe/steps_screen/steps_section.dart';
import 'package:my_recipe_book/widgets/ingredients_section.dart';

void main() {
  test('step add, remove, and reorder keep assignments aligned', () async {
    final bloc = StepImagesBloc();
    addTearDown(bloc.close);

    final initialized = _nextState(bloc, (state) => state.steps.length == 2);
    bloc.add(
      InitializeStepImages(
        ['Chop', 'Cook'],
        ['', ''],
        stepImages: const [[], []],
        stepIngredientIds: const [
          ['onion'],
          ['oil'],
        ],
      ),
    );
    await initialized;

    final moved = _nextState(bloc, (state) => state.steps.first == 'Cook');
    bloc.add(MoveStep(0, 1));
    expect((await moved).stepIngredientIds, const [
      ['oil'],
      ['onion'],
    ]);

    final updated = _nextState(
      bloc,
      (state) => state.stepIngredientIds.first.contains('onion'),
    );
    bloc.add(const UpdateStepIngredients(0, ['oil', 'onion']));
    expect((await updated).stepIngredientIds.first, ['oil', 'onion']);

    final removed = _nextState(bloc, (state) => state.steps.length == 1);
    bloc.add(RemoveStep('tmp', DateTime(2026), stepNumber: 0));
    expect((await removed).stepIngredientIds.single, ['onion']);

    final added = _nextState(bloc, (state) => state.steps.length == 2);
    bloc.add(AddStep('Serve', DateTime(2026)));
    expect((await added).stepIngredientIds.last, isEmpty);
  });

  test('ingredient deletion prunes every step reference', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftRepository(database: database);
    await repository.initialize();
    await repository.saveTmpRecipe(
      Recipe(
        name: 'Soup',
        ingredients: const [
          [
            Ingredient(id: 'keep', name: 'Water'),
            Ingredient(id: 'remove', name: 'Salt'),
          ],
        ],
        steps: const ['Mix', 'Taste'],
        stepIngredientIds: const [
          ['keep', 'remove'],
          ['remove'],
        ],
      ),
    );
    final bloc = ingredients_bloc.IngredientsBloc(repository);
    addTearDown(bloc.close);

    final saved = bloc.stream
        .where((state) => state is ingredients_bloc.ISaved)
        .cast<ingredients_bloc.ISaved>()
        .first;
    bloc.add(
      ingredients_bloc.FinishedEditing(
        false,
        false,
        null,
        null,
        const [
          [Ingredient(id: 'keep', name: 'Water')],
        ],
        const ['Main'],
        Vegetable.VEGAN,
      ),
    );

    expect((await saved).recipe.stepIngredientIds, const [
      ['keep'],
      [],
    ]);
  });

  test('nutrition reorder persists the visible final order', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftRepository(database: database);
    await repository.initialize();
    for (final name in ['Energy', 'Protein', 'Fiber']) {
      await repository.addNutrition(name);
    }
    final bloc = NutritionManagerBloc(repository);
    addTearDown(bloc.close);
    final loaded = bloc.stream
        .where((state) => state is LoadedNutritionManager)
        .cast<LoadedNutritionManager>()
        .first;
    bloc.add(LoadNutritionManager());
    await loaded;

    final moved = bloc.stream
        .where((state) => state is LoadedNutritionManager)
        .cast<LoadedNutritionManager>()
        .firstWhere(
          (state) => state.nutritions.join(',') == 'Protein,Fiber,Energy',
        );
    bloc.add(const MoveNutrition(0, 2));
    expect((await moved).nutritions, ['Protein', 'Fiber', 'Energy']);
    expect(repository.getNutritions(), ['Protein', 'Fiber', 'Energy']);
  });

  testWidgets('assignment sheet distinguishes duplicate ingredient names', (
    tester,
  ) async {
    final bloc = StepImagesBloc();
    addTearDown(bloc.close);
    final initialized = _nextState(bloc, (state) => state.steps.isNotEmpty);
    bloc.add(
      InitializeStepImages(
        ['Layer both onions'],
        ['Finish'],
        stepImages: const [[]],
      ),
    );
    await initialized;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          body: BlocProvider.value(
            value: bloc,
            child: Steps(
              ingredients: const [
                [Ingredient(id: 'red', name: 'Onion', amount: 1)],
                [Ingredient(id: 'green', name: 'Onion', amount: 2)],
              ],
              ingredientGlossary: const ['Sauce', 'Garnish'],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Assign ingredients'));
    await tester.pumpAndSettle();

    expect(find.byType(Checkbox), findsNWidgets(2));
    await tester.tap(find.byType(Checkbox).at(0));
    await tester.tap(find.byType(Checkbox).at(1));
    await tester.tap(find.text('done'));
    await tester.pumpAndSettle();

    expect((bloc.state as LoadedStepImages).stepIngredientIds.single, [
      'red',
      'green',
    ]);
  });

  testWidgets('ingredient cards remain usable at narrow German 130% text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final bloc = IngredientsSectionBloc();
    addTearDown(bloc.close);
    final initialized = bloc.stream
        .where((state) => state is LoadedIngredientsSection)
        .cast<LoadedIngredientsSection>()
        .firstWhere((state) => state.ingredients.single.isNotEmpty);
    bloc.add(
      const InitializeIngredientsSection(
        ['Sauce'],
        [
          [Ingredient(id: 'tomato', name: 'Tomate', amount: 2, unit: 'Stk.')],
        ],
      ),
    );
    await initialized;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de', 'DE'),
        theme: ThemeData.dark(),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(420, 900),
            textScaler: TextScaler.linear(1.3),
          ),
          child: Scaffold(
            body: SingleChildScrollView(
              child: BlocProvider.value(
                value: bloc,
                child: Ingredients(
                  TextEditingController(),
                  TextEditingController(),
                  const ['Tomate', 'Zwiebel'],
                  showServings: false,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tomate'), findsOneWidget);
    expect(find.text('Sauce'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<LoadedStepImages> _nextState(
  StepImagesBloc bloc,
  bool Function(LoadedStepImages state) predicate,
) => bloc.stream
    .where((state) => state is LoadedStepImages)
    .cast<LoadedStepImages>()
    .firstWhere(predicate);
