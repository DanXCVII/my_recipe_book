import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/widgets/floating_home_navigation_bar.dart';

void main() {
  testWidgets('shows all destinations and reports every selection', (
    tester,
  ) async {
    final selected = <int>[];
    await _pumpBar(
      tester,
      width: 412,
      selectedIndex: 2,
      onSelected: selected.add,
    );

    expect(find.text('Recipes'), findsOneWidget);
    expect(find.text('Bookmarks'), findsOneWidget);
    expect(find.text('Shopping'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    for (var index = 0; index < 5; index++) {
      await tester.tap(
        find.byKey(ValueKey('home-navigation-destination-$index')),
      );
      await tester.pump();
    }

    expect(selected, [0, 1, 2, 3, 4]);
  });

  testWidgets(
    'uses the compact label treatment at 130% without shrinking tap targets',
    (tester) async {
      await _pumpBar(
        tester,
        width: 412,
        selectedIndex: 4,
        locale: const Locale('de', 'DE'),
        textScale: 1.3,
      );

      expect(find.text('Allgemein'), findsOneWidget);
      expect(find.text('Rezepte'), findsNothing);
      expect(find.text('Favoriten'), findsNothing);
      expect(find.text('Lesezeichen'), findsNothing);

      for (var index = 0; index < 5; index++) {
        final size = tester.getSize(
          find.byKey(ValueKey('home-navigation-destination-$index')),
        );
        expect(size.width, greaterThanOrEqualTo(48));
        expect(size.height, greaterThanOrEqualTo(48));
      }

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('renders against light, dark, and OLED themes', (tester) async {
    for (final background in [
      const Color(0xFFFAF7F2),
      const Color(0xFF1C181B),
      Colors.black,
    ]) {
      await _pumpBar(
        tester,
        width: 412,
        selectedIndex: 0,
        scaffoldBackgroundColor: background,
      );
      expect(find.byType(FloatingHomeNavigationBar), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}

Future<void> _pumpBar(
  WidgetTester tester, {
  required double width,
  required int selectedIndex,
  Locale locale = const Locale('en'),
  double textScale = 1,
  Color scaffoldBackgroundColor = const Color(0xFFFAF7F2),
  ValueChanged<int>? onSelected,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 800);
  addTearDown(tester.view.reset);

  final brightness = scaffoldBackgroundColor.computeLuminance() < .2
      ? Brightness.dark
      : Brightness.light;
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        brightness: brightness,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
      ),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        );
      },
      home: Builder(
        builder: (context) => Scaffold(
          bottomNavigationBar: FloatingHomeNavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: onSelected ?? (_) {},
            destinations: [
              FloatingHomeNavigationDestination(
                icon: MdiIcons.notebook,
                label: S.of(context).recipes,
              ),
              FloatingHomeNavigationDestination(
                icon: Icons.bookmark_rounded,
                label: S.of(context).favorites,
              ),
              FloatingHomeNavigationDestination(
                icon: Icons.shopping_basket,
                label: S.of(context).basket,
              ),
              FloatingHomeNavigationDestination(
                icon: MdiIcons.diceMultiple,
                label: S.of(context).explore,
              ),
              FloatingHomeNavigationDestination(
                icon: Icons.settings,
                label: S.of(context).settings,
              ),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
