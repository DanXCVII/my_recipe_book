import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/screens/export_recipes_screen.dart';
import 'package:my_recipe_book/screens/import_pc_info.dart';
import 'package:my_recipe_book/theming.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_theme.dart';

void main() {
  late AppDatabase database;
  late DriftRepository repository;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftRepository(database: database);
    await repository.initialize();
  });

  tearDown(() => database.close());

  testWidgets('backup screen selects recipes in the editorial shell', (
    tester,
  ) async {
    await repository.saveRecipe(Recipe(name: 'Tomato soup'));
    expect(repository.getRecipeNames(), ['Tomato soup']);
    await _pumpScreen(
      tester,
      repository: repository,
      child: const ExportRecipes(),
    );

    expect(find.byType(ExportRecipes), findsOneWidget);
    expect(find.text('Tomato soup'), findsOneWidget);
    final initialButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey('export-share-button')),
    );
    expect(initialButton.onPressed, isNull);

    await tester.tap(find.byKey(const ValueKey('export-recipe-Tomato soup')));
    await tester.pump();
    final selectedButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey('export-share-button')),
    );
    expect(selectedButton.onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('PC import instructions use editorial typography and surfaces', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      repository: repository,
      child: const ImportPcInfo(),
    );

    expect(find.byKey(const ValueKey('pc-import-screen-title')), findsWidgets);
    expect(find.textContaining('How do I create a recipe'), findsOneWidget);
    expect(find.textContaining('danxcvii.github.io'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('pc-import-open-web-editor')),
      findsOneWidget,
    );
    final title = tester.widget<Text>(
      find.textContaining('How do I create a recipe'),
    );
    expect(title.style?.fontFamily, CulinaryEditorialType.headlineFamily);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpScreen(
  WidgetTester tester, {
  required DriftRepository repository,
  required Widget child,
}) async {
  const size = Size(430, 900);
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: Builder(
        builder: (context) => MaterialApp(
          theme: CustomTheme.of(context),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: RepositoryProvider<LocalRepository>.value(
            value: repository,
            child: MediaQuery(
              data: const MediaQueryData(size: size),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
