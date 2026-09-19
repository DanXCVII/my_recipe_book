import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/splash_screen/splash_screen_bloc.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/local_storage/storage_migration.dart';
import 'package:my_recipe_book/screens/splash_screen.dart';
import 'package:my_recipe_book/theming.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_theme.dart';

void main() {
  testWidgets(
    'renders the editorial startup state with indeterminate progress',
    (tester) async {
      await _pumpSplash(tester, state: InitializingData(), version: 'v1.5.0');

      expect(find.text('EST. 2024'), findsOneWidget);
      expect(find.text('My RecipeBible'), findsOneWidget);
      expect(find.text('your personal recipe collection'), findsOneWidget);
      expect(find.text('Warming the stove…'), findsOneWidget);
      expect(find.text('v1.5.0'), findsOneWidget);

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byKey(const Key('splash-progress-bar')),
      );
      expect(indicator.value, isNull);
      expect(find.byKey(const Key('splash-progress-percentage')), findsNothing);

      final loadingIcon = find.byKey(const Key('splash-static-loading-icon'));
      expect(loadingIcon, findsOneWidget);
      expect(
        find.ancestor(
          of: loadingIcon,
          matching: find.byType(RotationTransition),
        ),
        findsNothing,
      );
      expect(find.text('Parchment, copper & hearth'), findsNothing);
      expect(find.textContaining('Culinary Edition'), findsNothing);
      expect(find.textContaining('Volume II'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('shows real migration progress with localized German copy', (
    tester,
  ) async {
    await _pumpSplash(
      tester,
      state: const MigratingData(
        StorageMigrationProgress(
          StorageMigrationStage.writingDriftData,
          current: 3,
          total: 4,
        ),
      ),
      version: 'v2.4.0',
      locale: const Locale('de', 'DE'),
      size: const Size(1024, 900),
      textScale: 1.3,
    );

    expect(find.text('SEIT 2024'), findsOneWidget);
    expect(find.text('deine persönliche Rezeptsammlung'), findsOneWidget);
    expect(find.text('Rezeptspeicher wird aktualisiert…'), findsOneWidget);
    expect(find.text('75%'), findsOneWidget);
    expect(find.text('v2.4.0'), findsOneWidget);
    final indicator = tester.widget<LinearProgressIndicator>(
      find.byKey(const Key('splash-progress-bar')),
    );
    expect(indicator.value, 0.75);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps migration recovery actions usable on a short phone', (
    tester,
  ) async {
    var retryCount = 0;
    var shareCount = 0;
    await _pumpSplash(
      tester,
      state: const StorageMigrationFailed('test_failure'),
      version: 'v1.5.0',
      size: const Size(320, 560),
      textScale: 1.3,
      onRetry: () => retryCount++,
      onShareReport: () => shareCount++,
    );

    expect(
      find.text(
        'Your recipes are safe. The storage upgrade needs to be retried.',
      ),
      findsOneWidget,
    );
    final retry = find.byKey(const Key('splash-retry-action'));
    final share = find.byKey(const Key('splash-share-action'));
    await tester.ensureVisible(retry);
    await tester.tap(retry);
    await tester.ensureVisible(share);
    await tester.tap(share);
    expect(retryCount, 1);
    expect(shareCount, 1);
    expect(tester.getSize(retry).height, greaterThanOrEqualTo(48));
    expect(tester.getSize(share).height, greaterThanOrEqualTo(48));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'adapts background and foreground colors to dark and OLED themes',
    (tester) async {
      await _pumpSplash(
        tester,
        state: InitializingData(),
        version: 'v1.5.0',
        theme: MyThemes.darkTheme,
      );

      var scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(
        scaffold.backgroundColor,
        CulinaryEditorialPalette.dark.background,
      );
      var title = tester.widget<Text>(find.text('My RecipeBible'));
      expect(title.style?.color, CulinaryEditorialPalette.dark.onSurface);
      var progress = tester.widget<LinearProgressIndicator>(
        find.byKey(const Key('splash-progress-bar')),
      );
      expect(
        progress.backgroundColor,
        CulinaryEditorialPalette.dark.surfaceContainerHigh,
      );
      var overlay = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
        find.byKey(const Key('splash-system-overlay')),
      );
      expect(overlay.value.statusBarIconBrightness, Brightness.light);

      await _pumpSplash(
        tester,
        state: InitializingData(),
        version: 'v1.5.0',
        theme: MyThemes.oledblackTheme,
      );

      scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(
        scaffold.backgroundColor,
        CulinaryEditorialPalette.oled.background,
      );
      title = tester.widget<Text>(find.text('My RecipeBible'));
      expect(title.style?.color, CulinaryEditorialPalette.oled.onSurface);
      progress = tester.widget<LinearProgressIndicator>(
        find.byKey(const Key('splash-progress-bar')),
      );
      expect(
        progress.backgroundColor,
        CulinaryEditorialPalette.oled.surfaceContainerHigh,
      );
      overlay = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
        find.byKey(const Key('splash-system-overlay')),
      );
      expect(overlay.value.systemNavigationBarColor, Colors.black);
      expect(tester.takeException(), isNull);
    },
  );
}

Future<void> _pumpSplash(
  WidgetTester tester, {
  required SplashScreenState state,
  required String version,
  Locale locale = const Locale('en'),
  Size size = const Size(390, 844),
  double textScale = 1,
  ThemeData? theme,
  VoidCallback? onRetry,
  VoidCallback? onShareReport,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      key: ValueKey(theme?.scaffoldBackgroundColor),
      theme: theme,
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(
          size: size,
          textScaler: TextScaler.linear(textScale),
        ),
        child: SplashScreenView(
          state: state,
          version: version,
          onRetry: onRetry,
          onShareReport: onShareReport,
        ),
      ),
    ),
  );
  await tester.pump();
}
