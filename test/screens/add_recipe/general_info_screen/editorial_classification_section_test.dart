import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';
import 'package:my_recipe_book/screens/add_recipe/general_info_screen/editorial_classification_section.dart';
import 'package:my_recipe_book/screens/add_recipe/general_info_screen/recipe_tag_section.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_theme.dart';
import 'package:my_recipe_book/widgets/recipe_editor/editorial_editor_shell.dart';

void main() {
  testWidgets('tag pill colors stay restrained across editor themes', (
    tester,
  ) async {
    const tag = StringIntTuple(text: 'SlowCook', number: 0xFFFF5722);
    final cases = [
      (ThemeData.light(), CulinaryEditorialPalette.light),
      (ThemeData.dark(), CulinaryEditorialPalette.dark),
      (
        ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
        CulinaryEditorialPalette.oled,
      ),
    ];

    for (final (baseTheme, palette) in cases) {
      await tester.pumpWidget(
        MaterialApp(
          theme: culinaryEditorialTheme(baseTheme, palette),
          home: Scaffold(
            body: MyRecipeTagFilterChip(
              recipeTag: tag,
              isSelected: true,
              onSelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final chip = tester.widget<FilterChip>(find.byType(FilterChip));
      final tagColor = Color(tag.number);
      expect(
        chip.backgroundColor,
        Color.alphaBlend(
          tagColor.withValues(alpha: .16),
          palette.surfaceContainer,
        ),
      );
      expect(
        chip.selectedColor,
        Color.alphaBlend(
          tagColor.withValues(alpha: .28),
          palette.surfaceContainer,
        ),
      );
      expect(chip.labelStyle?.color, palette.onSurface);
      expect(chip.backgroundColor, isNot(tagColor));
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('empty classification section keeps its actions available', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditorialClassificationSection(
            title: 'Select recipe tags',
            addTooltip: 'Add tag',
            manageTooltip: 'Manage tags',
            onAdd: () {},
            onManage: () {},
            children: const [],
          ),
        ),
      ),
    );

    expect(find.text('Select recipe tags'), findsOneWidget);
    expect(find.byType(IconButton), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'classification sections align headings and chips in German OLED at 130%',
    (tester) async {
      tester.view.physicalSize = const Size(468, 1014);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final baseTheme = ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      );
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('de', 'DE'),
          theme: culinaryEditorialTheme(
            baseTheme,
            CulinaryEditorialPalette.oled,
          ),
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
            child: Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    EditorialCard(
                      child: EditorialClassificationSection(
                        title: 'Kategorien auswählen',
                        addTooltip: 'Kategorie hinzufügen',
                        manageTooltip: 'Kategorien verwalten',
                        onAdd: () {},
                        onManage: () {},
                        children: [
                          FilterChip(
                            key: const ValueKey('first-category'),
                            label: const Text('Schnelle Feierabendgerichte'),
                            selected: false,
                            onSelected: (_) {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    EditorialCard(
                      child: EditorialClassificationSection(
                        title: 'Tags auswählen',
                        addTooltip: 'Tag hinzufügen',
                        manageTooltip: 'Tags verwalten',
                        onAdd: () {},
                        onManage: () {},
                        children: [
                          MyRecipeTagFilterChip(
                            recipeTag: const StringIntTuple(
                              text: 'Langsam geschmortes Lieblingsgericht',
                              number: 0xFFFF5722,
                            ),
                            isSelected: true,
                            onSelected: (_) {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final categoryTitleX = tester
          .getTopLeft(find.text('Kategorien auswählen'))
          .dx;
      final categoryChipX = tester
          .getTopLeft(find.byKey(const ValueKey('first-category')))
          .dx;
      final tagTitleX = tester.getTopLeft(find.text('Tags auswählen')).dx;
      final tagChipX = tester
          .getTopLeft(
            find.byKey(
              const ValueKey('recipe-tag-Langsam geschmortes Lieblingsgericht'),
            ),
          )
          .dx;

      expect(categoryChipX, categoryTitleX);
      expect(tagChipX, tagTitleX);
      for (final iconButton in tester.widgetList<IconButton>(
        find.byType(IconButton),
      )) {
        expect(iconButton.tooltip, isNotEmpty);
      }
      for (final iconButtonFinder in find.byType(IconButton).evaluate()) {
        expect(
          tester.getSize(find.byWidget(iconButtonFinder.widget)).width,
          48,
        );
        expect(
          tester.getSize(find.byWidget(iconButtonFinder.widget)).height,
          48,
        );
      }
      expect(tester.takeException(), isNull);
    },
  );
}
