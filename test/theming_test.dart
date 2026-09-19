import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/theming.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_theme.dart';

void main() {
  testWidgets('provides the selected application theme', (
    WidgetTester tester,
  ) async {
    late ThemeData selectedTheme;

    await tester.pumpWidget(
      CustomTheme(
        initialThemeKey: MyThemeKeys.LIGHT,
        child: Builder(
          builder: (context) {
            selectedTheme = CustomTheme.of(context)!;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(selectedTheme, same(MyThemes.lightTheme));
  });

  test('primary actions use the culinary palette in every theme mode', () {
    final variants = <(ThemeData, CulinaryEditorialPalette)>[
      (MyThemes.lightTheme, CulinaryEditorialPalette.light),
      (MyThemes.darkTheme, CulinaryEditorialPalette.dark),
      (MyThemes.oledblackTheme, CulinaryEditorialPalette.oled),
    ];

    for (final (theme, palette) in variants) {
      expect(theme.primaryColor, palette.primary);
      expect(theme.colorScheme.primary, palette.primary);
      expect(theme.colorScheme.onPrimary, palette.onPrimary);

      final buttonStyle = theme.filledButtonTheme.style!;
      expect(buttonStyle.backgroundColor?.resolve({}), isNull);
      expect(buttonStyle.foregroundColor?.resolve({}), isNull);
      expect(
        buttonStyle.backgroundColor?.resolve({WidgetState.disabled}),
        palette.surfaceContainerHigh,
      );
      expect(
        buttonStyle.foregroundColor?.resolve({WidgetState.disabled}),
        palette.onSurfaceVariant,
      );
    }
  });
}
