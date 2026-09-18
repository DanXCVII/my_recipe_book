import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/cook_mode/cook_mode_cubit.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/screens/cook_mode_screen.dart';
import 'package:my_recipe_book/services/cook_mode_completion_effects.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_theme.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:wakelock_plus_platform_interface/wakelock_plus_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late WakelockPlusPlatformInterface originalWakelock;
  late _TestWakelock testWakelock;

  setUp(() {
    originalWakelock = wakelockPlusPlatformInstance;
    testWakelock = _TestWakelock();
    wakelockPlusPlatformInstance = testWakelock;
  });

  tearDown(() {
    wakelockPlusPlatformInstance = originalWakelock;
  });

  testWidgets('shows real step data and keeps timer pinned while scrolling', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final cubit = CookModeCubit(stepCount: 2);
    final effects = _TestCompletionEffects();
    addTearDown(cubit.close);
    await _pumpCookMode(tester, cubit: cubit, effects: effects);

    expect(find.text('Toast the spices'), findsOneWidget);
    expect(find.text('4 cups Flour'), findsOneWidget);
    expect(find.byKey(const Key('cook-mode-timer-card')), findsOneWidget);
    expect(find.byKey(const Key('cook-mode-step-segment-0')), findsOneWidget);
    expect(find.byKey(const Key('cook-mode-step-segment-1')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('cook-mode-step-progress')),
        matching: find.byType(LinearProgressIndicator),
      ),
      findsNothing,
    );

    final firstSegment = tester.widget<AnimatedContainer>(
      find.byKey(const Key('cook-mode-step-segment-0')),
    );
    final secondSegment = tester.widget<AnimatedContainer>(
      find.byKey(const Key('cook-mode-step-segment-1')),
    );
    expect(
      (firstSegment.decoration as BoxDecoration).color,
      CulinaryEditorialPalette.light.primary,
    );
    expect(
      (secondSegment.decoration as BoxDecoration).color,
      CulinaryEditorialPalette.light.surfaceContainerHigh,
    );

    await tester.tap(find.byKey(const Key('cook-ingredient-flour')));
    await tester.pump();
    expect(cubit.state.preparedIngredientIds, contains('flour'));

    final timerTop = tester
        .getTopLeft(find.byKey(const Key('cook-mode-timer-card')))
        .dy;
    await tester.drag(
      find.byKey(const Key('cook-mode-scroll-view')),
      const Offset(0, -350),
    );
    await tester.pumpAndSettle();
    final scrollable = find.descendant(
      of: find.byKey(const Key('cook-mode-scroll-view')),
      matching: find.byType(Scrollable),
    );
    expect(
      tester.state<ScrollableState>(scrollable.first).position.pixels,
      greaterThan(0),
    );
    expect(
      tester.getTopLeft(find.byKey(const Key('cook-mode-timer-card'))).dy,
      timerTop,
    );

    await tester.tap(find.byKey(const Key('cook-mode-next')));
    await tester.pumpAndSettle();
    expect(find.text('Simmer'), findsOneWidget);
    expect(find.text('Step 2 of 2'), findsOneWidget);
    expect(
      (tester
                  .widget<AnimatedContainer>(
                    find.byKey(const Key('cook-mode-step-segment-1')),
                  )
                  .decoration
              as BoxDecoration)
          .color,
      CulinaryEditorialPalette.light.primary,
    );
    expect(
      tester
          .state<ScrollableState>(
            find
                .descendant(
                  of: find.byKey(const Key('cook-mode-scroll-view')),
                  matching: find.byType(Scrollable),
                )
                .first,
          )
          .position
          .pixels,
      0,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('timer setup starts manually and completion signals once', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var now = DateTime(2026, 1, 1, 12);
    final cubit = CookModeCubit(
      stepCount: 2,
      clock: () => now,
      timerFactory: (_, __) => Timer(const Duration(days: 1), () {}),
    );
    final effects = _TestCompletionEffects();
    addTearDown(cubit.close);
    await _pumpCookMode(tester, cubit: cubit, effects: effects);

    await tester.tap(find.byKey(const Key('cook-mode-set-timer')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('cook-timer-hours')), '0');
    await tester.enterText(find.byKey(const Key('cook-timer-minutes')), '1');
    await tester.tap(find.byKey(const Key('cook-timer-save')));
    await tester.pumpAndSettle();

    expect(cubit.state.timerStatus, CookTimerStatus.idle);
    expect(cubit.state.remaining, const Duration(minutes: 1));
    await tester.tap(find.byKey(const Key('cook-mode-toggle-timer')));
    await tester.pump();
    expect(cubit.state.timerStatus, CookTimerStatus.running);

    now = now.add(const Duration(minutes: 1));
    cubit.syncTimer();
    await tester.pumpAndSettle();
    expect(effects.signalCount, 1);
    expect(find.byKey(const Key('cook-timer-complete-banner')), findsOneWidget);

    cubit.syncTimer();
    await tester.pump();
    expect(effects.signalCount, 1);

    cubit.setKeepAwake(!cubit.state.keepAwake);
    await tester.pump();
    expect(effects.signalCount, 1);
  });

  testWidgets('active timer protects exit and keep-awake is session scoped', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final cubit = CookModeCubit(stepCount: 2, keepAwake: true);
    addTearDown(cubit.close);
    await _pumpCookMode(
      tester,
      cubit: cubit,
      effects: _TestCompletionEffects(),
    );
    await tester.pump();
    expect(testWakelock.enabledValue, isTrue);

    cubit.setTimer(const Duration(minutes: 2));
    cubit.startTimer();
    await tester.pump();
    await tester.tap(find.byKey(const Key('cook-mode-close')));
    await tester.pumpAndSettle();
    expect(find.text('End cook mode?'), findsOneWidget);
    expect(find.text('Keep cooking'), findsOneWidget);
    await tester.tap(find.text('Keep cooking'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('cook-mode-screen')), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('End cook mode?'), findsOneWidget);
    await tester.tap(find.text('Keep cooking'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('cook-mode-keep-awake')));
    await tester.pump();
    expect(cubit.state.keepAwake, isFalse);
    expect(testWakelock.enabledValue, isFalse);
    cubit.cancelTimer();
  });

  testWidgets('leaving restores the wakelock state from before the session', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    testWakelock.enabledValue = true;

    final cubit = CookModeCubit(stepCount: 2, keepAwake: false);
    addTearDown(cubit.close);
    await _pumpCookMode(
      tester,
      cubit: cubit,
      effects: _TestCompletionEffects(),
    );
    await tester.pump();
    expect(testWakelock.enabledValue, isFalse);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(testWakelock.enabledValue, isTrue);
  });

  testWidgets('finishing the final step stops an active timer', (tester) async {
    tester.view.physicalSize = const Size(430, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final cubit = CookModeCubit(stepCount: 2);
    addTearDown(cubit.close);
    await _pumpCookMode(
      tester,
      cubit: cubit,
      effects: _TestCompletionEffects(),
    );
    cubit.selectStep(1);
    cubit.setTimer(const Duration(minutes: 2));
    cubit.startTimer();
    await tester.pump();

    await tester.tap(find.byKey(const Key('cook-mode-next')));
    await tester.pumpAndSettle();
    expect(find.text('Cooking complete'), findsOneWidget);
    expect(find.text('Finish and stop timer'), findsOneWidget);

    await tester.tap(find.text('Finish and stop timer'));
    await tester.pumpAndSettle();
    expect(cubit.state.hasConfiguredTimer, isFalse);
    expect(cubit.state.timerStatus, CookTimerStatus.idle);
    expect(find.byKey(const Key('cook-mode-screen')), findsNothing);
  });

  testWidgets('600 dp is the exact wide-layout breakpoint', (tester) async {
    tester.view.physicalSize = const Size(599, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final cubit = CookModeCubit(stepCount: 2);
    addTearDown(cubit.close);
    await _pumpCookMode(
      tester,
      cubit: cubit,
      effects: _TestCompletionEffects(),
    );
    expect(find.byKey(const Key('cook-mode-compact-layout')), findsOneWidget);
    expect(find.byKey(const Key('cook-mode-wide-layout')), findsNothing);

    tester.view.physicalSize = const Size(600, 1000);
    await tester.pump();
    expect(find.byKey(const Key('cook-mode-wide-layout')), findsOneWidget);
    expect(find.byKey(const Key('cook-mode-compact-layout')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wide layout and German large text remain overflow free', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final cubit = CookModeCubit(stepCount: 2);
    addTearDown(cubit.close);
    await _pumpCookMode(
      tester,
      cubit: cubit,
      effects: _TestCompletionEffects(),
      locale: const Locale('de', 'DE'),
      textScaler: const TextScaler.linear(1.3),
      palette: CulinaryEditorialPalette.dark,
    );

    expect(find.text('Kochmodus'), findsOneWidget);
    expect(find.text('Schritt 1 von 2'), findsOneWidget);
    expect(find.text('4 cups Flour'), findsOneWidget);
    tester.takeException(); // Ignore Flutter's locale-delegate warning.
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpCookMode(
  WidgetTester tester, {
  required CookModeCubit cubit,
  required CookModeCompletionEffects effects,
  Locale locale = const Locale('en'),
  TextScaler textScaler = TextScaler.noScaling,
  CulinaryEditorialPalette palette = CulinaryEditorialPalette.light,
}) {
  final recipe = Recipe(
    name: 'Braised vegetables',
    imagePath: 'images/randomFood.jpg',
    imagePreviewPath: 'images/randomFood.jpg',
    steps: const [
      'Toast the spices in a dry pan until fragrant.\n\nStir constantly.',
      'Add the vegetables and simmer until tender.',
    ],
    stepTitles: const ['Toast the spices', 'Simmer'],
    stepImages: const [[], []],
    ingredients: const [
      [
        Ingredient(id: 'flour', name: 'Flour', amount: 2, unit: 'cups'),
        Ingredient(id: 'garlic', name: 'Garlic', amount: 3, unit: 'cloves'),
      ],
    ],
    stepIngredientIds: const [
      ['flour'],
      ['garlic'],
    ],
  );
  final theme = culinaryEditorialTheme(
    ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.primary,
        brightness: palette == CulinaryEditorialPalette.light
            ? Brightness.light
            : Brightness.dark,
      ),
      scaffoldBackgroundColor: palette.background,
    ),
    palette,
  );
  return tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: theme,
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaler: textScaler),
          child: child!,
        );
      },
      home: CookModeScreen(
        arguments: CookModeArguments(
          recipe: recipe,
          effectiveIngredients: const [
            [
              Ingredient(id: 'flour', name: 'Flour', amount: 4, unit: 'cups'),
              Ingredient(
                id: 'garlic',
                name: 'Garlic',
                amount: 6,
                unit: 'cloves',
              ),
            ],
          ],
        ),
        cubit: cubit,
        completionEffects: effects,
      ),
    ),
  );
}

class _TestCompletionEffects implements CookModeCompletionEffects {
  int signalCount = 0;

  @override
  Future<void> signalCompletion() async => signalCount++;

  @override
  Future<void> dispose() async {}
}

class _TestWakelock extends WakelockPlusPlatformInterface {
  bool enabledValue = false;

  @override
  Future<bool> get enabled async => enabledValue;

  @override
  Future<void> toggle({required bool enable}) async {
    enabledValue = enable;
  }
}
