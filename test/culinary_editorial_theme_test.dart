import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_theme.dart';

void main() {
  final cases = <String, CulinaryEditorialPalette>{
    'light': CulinaryEditorialPalette.light,
    'dark': CulinaryEditorialPalette.dark,
    'oled': CulinaryEditorialPalette.oled,
  };

  for (final entry in cases.entries) {
    test('${entry.key} theme replaces blue Material container roles', () {
      final palette = entry.value;
      final brightness = entry.key == 'light'
          ? Brightness.light
          : Brightness.dark;
      final base = ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: brightness,
        ),
      );
      final theme = culinaryEditorialTheme(base, palette);
      final scheme = theme.colorScheme;

      expect(scheme.primary, palette.primary);
      expect(scheme.primaryContainer, palette.primarySoft);
      expect(scheme.secondary, palette.secondary);
      expect(scheme.secondaryContainer, palette.primarySoft);
      expect(scheme.onSecondaryContainer, palette.primary);
      expect(scheme.surfaceContainer, palette.surfaceContainer);
      expect(scheme.surfaceContainerHigh, palette.surfaceContainerHigh);
      expect(scheme.surfaceContainerHighest, palette.surfaceContainerHigh);
      expect(scheme.onSurfaceVariant, palette.onSurfaceVariant);
      expect(scheme.outline, palette.outline);

      expect(theme.chipTheme.selectedColor, palette.primarySoft);
      expect(theme.chipTheme.checkmarkColor, palette.primary);

      final selected = <WidgetState>{WidgetState.selected};
      final segmentedStyle = theme.segmentedButtonTheme.style!;
      expect(
        segmentedStyle.backgroundColor!.resolve(selected),
        palette.primarySoft,
      );
      expect(
        segmentedStyle.foregroundColor!.resolve(selected),
        palette.primary,
      );
    });
  }
}
