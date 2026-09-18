import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/constants/global_settings.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/screens/intro_screen.dart';

void main() {
  setUp(() => GlobalSettings().enableAnimations(false));
  tearDown(() => GlobalSettings().enableAnimations(true));

  testWidgets('presents four truthful pages and dismisses at the end', (
    tester,
  ) async {
    await _pumpIntro(tester);

    expect(find.text('My RecipeBible'), findsOneWidget);
    expect(find.text('Choose a recipe that fits your energy.'), findsOneWidget);
    expect(find.text('Automatic calibration'), findsNothing);
    expect(find.text('Aisle-Sorted'), findsNothing);
    expect(find.text('Sign In'), findsNothing);

    await _next(tester);
    expect(find.text('Never lose your place at the stove.'), findsOneWidget);

    await _next(tester);
    expect(
      find.text('Cook with what you have. Shop for what you need.'),
      findsOneWidget,
    );
    expect(find.text('PRO FEATURE'), findsOneWidget);

    await _next(tester);
    expect(find.text('Swipe until dinner feels obvious.'), findsOneWidget);
    expect(find.text('Open my cookbook'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding-next')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('onboarding-screen')), findsNothing);
    expect(find.byKey(const Key('intro-launcher')), findsOneWidget);
  });

  testWidgets('skip and system Back preserve the existing route behavior', (
    tester,
  ) async {
    await _pumpIntro(tester);
    await _next(tester);
    expect(find.text('Never lose your place at the stove.'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.text('Choose a recipe that fits your energy.'), findsOneWidget);
    expect(find.byKey(const Key('onboarding-screen')), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding-skip')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('onboarding-screen')), findsNothing);
  });

  testWidgets('effort preview updates its sample and rating', (tester) async {
    await _pumpIntro(tester);

    await tester.tap(find.byKey(const Key('onboarding-effort-8')));
    await tester.pump();

    expect(find.text('LEVEL 8 / 10'), findsOneWidget);
    expect(find.text('Ambitious'), findsWidgets);
    expect(find.text('Slow-roasted vegetable pasta'), findsOneWidget);
  });

  testWidgets('cook timer is disposable and pauses off-page', (tester) async {
    await _pumpIntro(tester);
    await _next(tester);

    await tester.ensureVisible(
      find.byKey(const Key('onboarding-timer-toggle')),
    );
    await tester.tap(find.byKey(const Key('onboarding-timer-add')));
    await tester.pump();
    expect(find.text('09:30'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding-timer-toggle')));
    await tester.pump(const Duration(milliseconds: 1100));
    final runningValue = tester.widget<Text>(
      find.byKey(const Key('onboarding-timer-value')),
    );
    expect(runningValue.data, isNot('09:30'));

    await _next(tester);
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.byKey(const Key('onboarding-back')));
    await tester.pump();
    final pausedValue = tester.widget<Text>(
      find.byKey(const Key('onboarding-timer-value')),
    );
    expect(pausedValue.data, runningValue.data);
  });

  testWidgets('pantry and shopping previews keep changes local', (
    tester,
  ) async {
    await _pumpIntro(tester);
    await _next(tester);
    await _next(tester);

    expect(find.text('3/3 INGREDIENTS MATCH'), findsOneWidget);
    await tester.tap(find.byKey(const Key('onboarding-pantry-chip-1')));
    await tester.pump();
    expect(find.text('2/3 INGREDIENTS MATCH'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const Key('onboarding-shopping-item-1')),
    );
    await tester.tap(find.byKey(const Key('onboarding-shopping-item-1')));
    await tester.pump();
    final garlic = tester.widget<Text>(find.text('Garlic'));
    expect(garlic.style?.decoration, TextDecoration.lineThrough);
  });

  testWidgets(
    'Explore preview supports actions and rewind without navigation',
    (tester) async {
      await _pumpIntro(tester);
      await _next(tester);
      await _next(tester);
      await _next(tester);

      await tester.ensureVisible(
        find.byKey(const Key('onboarding-explore-save')),
      );
      await tester.tap(find.byKey(const Key('onboarding-explore-save')));
      await tester.pumpAndSettle();
      expect(find.text('Saved for later'), findsOneWidget);
      expect(find.text('Card 2 of 3'), findsOneWidget);
      expect(find.byKey(const Key('onboarding-screen')), findsOneWidget);

      await tester.tap(find.byKey(const Key('onboarding-explore-rewind')));
      await tester.pumpAndSettle();
      expect(find.text('Card 1 of 3'), findsOneWidget);

      await tester.tap(find.byKey(const Key('onboarding-explore-cook')));
      await tester.pumpAndSettle();
      expect(find.text('Cook tonight'), findsOneWidget);
      expect(find.byKey(const Key('onboarding-screen')), findsOneWidget);
    },
  );

  testWidgets('German copy and enlarged text fit compact dark layout', (
    tester,
  ) async {
    await _pumpIntro(
      tester,
      locale: const Locale('de', 'DE'),
      size: const Size(360, 720),
      textScale: 1.3,
      brightness: Brightness.dark,
      disableAnimations: true,
    );

    expect(
      find.text('Wähle ein Rezept, das zu deiner Energie passt.'),
      findsOneWidget,
    );
    await _next(tester);
    await _next(tester);
    expect(find.text('PRO-FUNKTION'), findsOneWidget);
    await _next(tester);
    expect(find.text('Mein Kochbuch öffnen'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('OLED tablet layout remains centered and overflow-free', (
    tester,
  ) async {
    await _pumpIntro(
      tester,
      size: const Size(1024, 900),
      brightness: Brightness.dark,
      oled: true,
    );
    await _next(tester);
    await _next(tester);
    await _next(tester);

    expect(find.text('Swipe until dinner feels obvious.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _next(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('onboarding-next')));
  await tester.pump();
}

Future<void> _pumpIntro(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
  Size size = const Size(430, 900),
  double textScale = 1,
  Brightness brightness = Brightness.light,
  bool oled = false,
  bool disableAnimations = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final base = ThemeData(
    brightness: brightness,
    scaffoldBackgroundColor: oled
        ? Colors.black
        : brightness == Brightness.dark
        ? const Color(0xFF1C181B)
        : const Color(0xFFFAF7F2),
  );

  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: base,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
          disableAnimations: disableAnimations,
        ),
        child: child!,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: FilledButton(
              key: const Key('intro-launcher'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const IntroScreen()),
              ),
              child: const Text('Open intro'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.byKey(const Key('intro-launcher')));
  await tester.pumpAndSettle();
}
