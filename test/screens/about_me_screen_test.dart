import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/screens/about_me.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';

const _packageInfoChannel = MethodChannel(
  'dev.fluttercommunity.plus/package_info',
);
const _urlLauncherChannel = MethodChannel('plugins.flutter.io/url_launcher');
const _shareChannel = MethodChannel('dev.fluttercommunity.plus/share');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows a quiet fallback when package metadata is unavailable', (
    tester,
  ) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          _packageInfoChannel,
          (_) => throw PlatformException(code: 'unavailable'),
        );
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_packageInfoChannel, null),
    );

    await _pumpAbout(tester);

    expect(find.text('Unavailable'), findsOneWidget);
    expect(find.byKey(const Key('about-version-loading')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders the complete editorial profile on a phone', (
    tester,
  ) async {
    _setPackageInfo();
    await _pumpAbout(tester);

    expect(find.text('About & support'), findsOneWidget);
    expect(
      find.text('Your personal cookbook—offline, organized, and yours.'),
      findsOneWidget,
    );
    expect(find.text('Share this app'), findsOneWidget);
    expect(find.text('Rate on Google Play'), findsOneWidget);
    expect(find.text('Email the developer'), findsOneWidget);
    expect(find.text('1.5.0 (145)'), findsOneWidget);
    expect(find.text('Open-source licenses'), findsOneWidget);
    expect(find.text('Disclaimer'), findsOneWidget);
    expect(find.text('Made with care in Münster.'), findsOneWidget);

    final heroCenter = tester
        .getRect(find.byKey(const Key('about-hero')))
        .center
        .dx;
    final identityCenter = tester
        .getRect(find.byKey(const Key('about-identity-lockup')))
        .center
        .dx;
    expect(identityCenter, closeTo(heroCenter, 0.5));

    for (final key in const [
      Key('about-share-action'),
      Key('about-rate-action'),
      Key('about-contact-action'),
      Key('about-licenses-action'),
      Key('about-disclaimer-action'),
    ]) {
      final size = tester.getSize(find.byKey(key));
      expect(size.height, greaterThanOrEqualTo(48));
      expect(size.width, greaterThanOrEqualTo(48));
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens the disclaimer as a phone bottom sheet', (tester) async {
    _setPackageInfo();
    await _pumpAbout(tester);

    final disclaimer = find.byKey(const Key('about-disclaimer-action'));
    await tester.ensureVisible(disclaimer);
    await tester.tap(disclaimer);
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(
      find.textContaining('100% responsible for whatever you do'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('about-disclaimer-close')));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
  });

  testWidgets('opens the themed Flutter license page', (tester) async {
    _setPackageInfo();
    await _pumpAbout(tester);

    final licenses = find.byKey(const Key('about-licenses-action'));
    await tester.ensureVisible(licenses);
    await tester.tap(licenses);
    await tester.pumpAndSettle();

    expect(find.byType(LicensePage), findsOneWidget);
    expect(find.text('My RecipeBible'), findsWidgets);
    expect(find.text('1.5.0 (145)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adapts to German tablet copy and a dialog disclaimer', (
    tester,
  ) async {
    _setPackageInfo();
    await _pumpAbout(
      tester,
      locale: const Locale('de', 'DE'),
      size: const Size(1024, 900),
      textScale: 1.3,
    );

    expect(find.text('Info & Support'), findsOneWidget);
    expect(
      find.text(
        'Dein persönliches Kochbuch – offline, übersichtlich und ganz deins.',
      ),
      findsOneWidget,
    );
    expect(find.text('Mit Sorgfalt in Münster entwickelt.'), findsOneWidget);

    final disclaimer = find.byKey(const Key('about-disclaimer-action'));
    await tester.ensureVisible(disclaimer);
    await tester.pumpAndSettle();
    await tester.tap(disclaimer);
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Haftungsausschluss'), findsWidgets);
    expect(find.textContaining('die volle Verantwortung'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('preserves tonal separation in light, dark, and OLED themes', (
    tester,
  ) async {
    _setPackageInfo();
    final variants = <(Brightness, bool, CulinaryEditorialPalette)>[
      (Brightness.light, false, CulinaryEditorialPalette.light),
      (Brightness.dark, false, CulinaryEditorialPalette.dark),
      (Brightness.dark, true, CulinaryEditorialPalette.oled),
    ];

    for (final (brightness, oled, palette) in variants) {
      await _pumpAbout(tester, brightness: brightness, oled: oled);

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      final hero = tester.widget<Container>(
        find.byKey(const Key('about-hero')),
      );
      final decoration = hero.decoration! as BoxDecoration;
      expect(scaffold.backgroundColor, palette.background);
      expect(decoration.color, palette.surface);
      expect(decoration.color, isNot(scaffold.backgroundColor));
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('reports failures from share, rating, and email actions', (
    tester,
  ) async {
    _setPackageInfo();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_urlLauncherChannel, (_) async => false);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          _shareChannel,
          (_) => throw PlatformException(code: 'unavailable'),
        );
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_urlLauncherChannel, null);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_shareChannel, null);
    });

    await _pumpAbout(tester);

    await _tapAndExpectSnackbar(
      tester,
      const Key('about-share-action'),
      'Couldn’t open the share sheet. Please try again.',
    );
    await _tapAndExpectSnackbar(
      tester,
      const Key('about-rate-action'),
      'Couldn’t open Google Play. Check your connection and try again.',
    );
    await _tapAndExpectSnackbar(
      tester,
      const Key('about-contact-action'),
      'Couldn’t open your email app. Please try again.',
    );
  });
}

void _setPackageInfo() {
  PackageInfo.setMockInitialValues(
    appName: 'My RecipeBible',
    packageName: 'com.release.my_recipe_book',
    version: '1.5.0',
    buildNumber: '145',
    buildSignature: '',
  );
}

Future<void> _tapAndExpectSnackbar(
  WidgetTester tester,
  Key key,
  String message,
) async {
  final target = find.byKey(key);
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
  expect(find.text(message), findsOneWidget);

  final scaffoldContext = tester.element(find.byType(Scaffold).first);
  ScaffoldMessenger.of(scaffoldContext).clearSnackBars();
  await tester.pumpAndSettle();
}

Future<void> _pumpAbout(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
  Size size = const Size(430, 900),
  double textScale = 1,
  Brightness brightness = Brightness.light,
  bool oled = false,
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
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: const AboutMeScreen(),
    ),
  );
  await tester.pumpAndSettle();
}
