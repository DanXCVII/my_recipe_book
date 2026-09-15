import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/widgets/recipe_editor/editorial_editor_shell.dart';

void main() {
  testWidgets('fourth editor stage is usable in German at 130% text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(468, 1014);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de', 'DE'),
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
          child: EditorialEditorShell(
            stage: 4,
            recipe: Recipe(
              name: 'Pilz-Pappardelle',
              ingredients: [
                [Ingredient(name: 'Pilze')],
              ],
            ),
            title: 'Nährwerte',
            primaryLabel: 'Rezept speichern',
            onBack: () {},
            onPrimary: () {},
            body: const EditorialCard(
              child: Text('Optionale Nährwerte pro Portion'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Schritt 4 von 4'), findsOneWidget);
    expect(find.text('Rezept speichern'), findsOneWidget);
    expect(find.text('1 Zutat'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('editor body is width constrained on tablet', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: EditorialEditorShell(
          stage: 2,
          recipe: Recipe(name: 'Soup'),
          title: 'Ingredients',
          primaryLabel: 'Continue',
          onBack: () {},
          onPrimary: () {},
          body: const EditorialCard(child: Text('Card content')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.getSize(find.text('Card content')).width, lessThan(760));
    expect(tester.takeException(), isNull);
  });
}
