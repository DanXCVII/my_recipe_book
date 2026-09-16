import 'package:flutter/material.dart';

class CulinaryEditorialPalette {
  const CulinaryEditorialPalette({
    required this.background,
    required this.surface,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.outline,
    required this.primary,
    required this.onPrimary,
    required this.primarySoft,
    required this.secondary,
    required this.secondarySoft,
    required this.tertiary,
    required this.tertiarySoft,
    required this.shadow,
  });

  final Color background;
  final Color surface;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color outline;
  final Color primary;
  final Color onPrimary;
  final Color primarySoft;
  final Color secondary;
  final Color secondarySoft;
  final Color tertiary;
  final Color tertiarySoft;
  final Color shadow;

  static CulinaryEditorialPalette of(BuildContext context) {
    final theme = Theme.of(context);
    if (theme.brightness == Brightness.light) return light;
    if (theme.scaffoldBackgroundColor == Colors.black) return oled;
    return dark;
  }

  static const light = CulinaryEditorialPalette(
    background: Color(0xFFFAF7F2),
    surface: Color(0xFFFFFDF9),
    surfaceContainer: Color(0xFFF3ECE2),
    surfaceContainerHigh: Color(0xFFEAE0D4),
    onSurface: Color(0xFF1B1B21),
    onSurfaceVariant: Color(0xFF59413B),
    outline: Color(0xFF6F554F),
    primary: Color(0xFFA83211),
    onPrimary: Color(0xFFFFFFFF),
    primarySoft: Color(0xFFFFDBD1),
    secondary: Color(0xFF376847),
    secondarySoft: Color(0xFFB9EFC5),
    tertiary: Color(0xFF8B4C00),
    tertiarySoft: Color(0xFFFFDCC1),
    shadow: Color(0x14543E2D),
  );

  static const dark = CulinaryEditorialPalette(
    background: Color(0xFF1C181B),
    surface: Color(0xFF292429),
    surfaceContainer: Color(0xFF332D33),
    surfaceContainerHigh: Color(0xFF403940),
    onSurface: Color(0xFFF5EEF2),
    onSurfaceVariant: Color(0xFFDEC8C1),
    outline: Color(0xFFB69A92),
    primary: Color(0xFFFFB49F),
    onPrimary: Color(0xFF581500),
    primarySoft: Color(0xFF5F2113),
    secondary: Color(0xFFA0D5AD),
    secondarySoft: Color(0xFF244A31),
    tertiary: Color(0xFFFFB775),
    tertiarySoft: Color(0xFF5B3515),
    shadow: Color(0x66000000),
  );

  static const oled = CulinaryEditorialPalette(
    background: Color(0xFF000000),
    surface: Color(0xFF151215),
    surfaceContainer: Color(0xFF211D21),
    surfaceContainerHigh: Color(0xFF302A30),
    onSurface: Color(0xFFF9F0F5),
    onSurfaceVariant: Color(0xFFE1C9C1),
    outline: Color(0xFFB99B92),
    primary: Color(0xFFFFB49F),
    onPrimary: Color(0xFF581500),
    primarySoft: Color(0xFF5B1D0F),
    secondary: Color(0xFFA2D8AF),
    secondarySoft: Color(0xFF1D452A),
    tertiary: Color(0xFFFFB775),
    tertiarySoft: Color(0xFF54300F),
    shadow: Color(0xCC000000),
  );
}

class CulinaryEditorialType {
  const CulinaryEditorialType._();

  static const headlineFamily = 'PlayfairDisplay';
  static const bodyFamily = 'PlusJakartaSans';

  static TextStyle headline(
    CulinaryEditorialPalette palette, {
    double size = 26,
    FontWeight weight = FontWeight.w700,
    double height = 1.23,
  }) {
    return TextStyle(
      color: palette.onSurface,
      fontFamily: headlineFamily,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: -0.35,
    );
  }

  static TextStyle body(
    CulinaryEditorialPalette palette, {
    double size = 13,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double height = 1.35,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: color ?? palette.onSurface,
      fontFamily: bodyFamily,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}

ThemeData culinaryEditorialTheme(
  ThemeData base,
  CulinaryEditorialPalette palette,
) {
  final bodyText = base.textTheme.apply(
    fontFamily: CulinaryEditorialType.bodyFamily,
    bodyColor: palette.onSurface,
    displayColor: palette.onSurface,
  );
  final colorScheme = base.colorScheme.copyWith(
    primary: palette.primary,
    onPrimary: palette.onPrimary,
    primaryContainer: palette.primarySoft,
    onPrimaryContainer: palette.primary,
    secondary: palette.secondary,
    onSecondary: palette.background,
    secondaryContainer: palette.primarySoft,
    onSecondaryContainer: palette.primary,
    tertiary: palette.tertiary,
    onTertiary: palette.background,
    tertiaryContainer: palette.tertiarySoft,
    onTertiaryContainer: palette.tertiary,
    surface: palette.surface,
    onSurface: palette.onSurface,
    onSurfaceVariant: palette.onSurfaceVariant,
    surfaceDim: palette.background,
    surfaceBright: palette.surface,
    surfaceContainerLowest: palette.background,
    surfaceContainerLow: palette.surface,
    surfaceContainer: palette.surfaceContainer,
    surfaceContainerHigh: palette.surfaceContainerHigh,
    surfaceContainerHighest: palette.surfaceContainerHigh,
    outline: palette.outline,
    outlineVariant: palette.outline.withValues(alpha: .45),
    inverseSurface: palette.onSurface,
    onInverseSurface: palette.surface,
    inversePrimary: palette.primarySoft,
    shadow: palette.shadow,
    scrim: Colors.black,
    surfaceTint: Colors.transparent,
  );

  return base.copyWith(
    scaffoldBackgroundColor: palette.background,
    colorScheme: colorScheme,
    textTheme: bodyText.copyWith(
      displayLarge: bodyText.displayLarge?.copyWith(
        fontFamily: CulinaryEditorialType.headlineFamily,
      ),
      displayMedium: bodyText.displayMedium?.copyWith(
        fontFamily: CulinaryEditorialType.headlineFamily,
      ),
      headlineLarge: bodyText.headlineLarge?.copyWith(
        fontFamily: CulinaryEditorialType.headlineFamily,
      ),
      headlineMedium: bodyText.headlineMedium?.copyWith(
        fontFamily: CulinaryEditorialType.headlineFamily,
      ),
      headlineSmall: bodyText.headlineSmall?.copyWith(
        fontFamily: CulinaryEditorialType.headlineFamily,
      ),
      titleLarge: bodyText.titleLarge?.copyWith(
        fontFamily: CulinaryEditorialType.headlineFamily,
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: palette.surfaceContainer,
      selectedColor: palette.primarySoft,
      disabledColor: palette.surfaceContainerHigh,
      checkmarkColor: palette.primary,
      deleteIconColor: palette.onSurfaceVariant,
      labelStyle: CulinaryEditorialType.body(
        palette,
        size: 13,
        color: palette.onSurfaceVariant,
      ),
      secondaryLabelStyle: CulinaryEditorialType.body(
        palette,
        size: 13,
        weight: FontWeight.w700,
        color: palette.primary,
      ),
      side: BorderSide(color: palette.outline.withValues(alpha: .45)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        minimumSize: const Size(0, 48),
        backgroundColor: Colors.transparent,
        foregroundColor: palette.onSurface,
        selectedBackgroundColor: palette.primarySoft,
        selectedForegroundColor: palette.primary,
        side: BorderSide(color: palette.outline.withValues(alpha: .65)),
        textStyle: CulinaryEditorialType.body(
          palette,
          size: 14,
          weight: FontWeight.w700,
        ),
      ),
    ),
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      filled: true,
      fillColor: palette.surfaceContainer,
      labelStyle: CulinaryEditorialType.body(
        palette,
        size: 14,
        color: palette.onSurfaceVariant,
      ),
      hintStyle: CulinaryEditorialType.body(
        palette,
        size: 14,
        color: palette.onSurfaceVariant.withValues(alpha: .78),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: palette.outline.withValues(alpha: .45)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: palette.primary, width: 2),
      ),
    ),
    iconTheme: base.iconTheme.copyWith(color: palette.onSurfaceVariant),
    dividerColor: palette.outline.withValues(alpha: .22),
  );
}
