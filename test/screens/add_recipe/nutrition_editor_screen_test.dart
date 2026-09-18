import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/new_recipe/nutritions/nutritions_bloc.dart';
import 'package:my_recipe_book/blocs/nutrition_manager/nutrition_manager_bloc.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/nutrition.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/screens/add_recipe/nutritions.dart';

void main() {
  testWidgets('nutrition stage renders long German rows in OLED at 130%', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(468, 1014);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftRepository(database: database);
    await repository.initialize();
    for (final name in ['Energie', 'Gesättigte Fettsäuren', 'Ballaststoffe']) {
      await repository.addNutrition(name);
    }
    final manager = NutritionManagerBloc(repository)
      ..add(LoadNutritionManager());
    final save = NutritionsBloc(repository);
    addTearDown(manager.close);
    addTearDown(save.close);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de', 'DE'),
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(468, 1014),
            textScaler: TextScaler.linear(1.3),
          ),
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: manager),
              BlocProvider.value(value: save),
            ],
            child: AddRecipeNutritions(
              modifiedRecipe: Recipe(
                name: 'Kartoffelgratin',
                nutritions: const [
                  Nutrition(name: 'Energie', amountUnit: '580 kcal'),
                  Nutrition(name: 'Gesättigte Fettsäuren', amountUnit: '12 g'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Schritt 4 von 4'), findsOneWidget);
    expect(find.text('Gesättigte Fettsäuren'), findsOneWidget);
    expect(find.text('580 kcal'), findsOneWidget);
    expect(find.text('Rezept speichern'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
