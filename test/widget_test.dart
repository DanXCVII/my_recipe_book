import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/theming.dart';

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
}
