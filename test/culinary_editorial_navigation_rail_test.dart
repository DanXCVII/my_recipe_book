import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_navigation_rail.dart';
import 'package:my_recipe_book/widgets/home_navigation_destination.dart';

void main() {
  testWidgets('shows five destinations and reports every selection', (
    tester,
  ) async {
    final selected = <int>[];
    await _pumpRail(tester, selectedIndex: 2, onSelected: selected.add);

    expect(find.text('Recipes'), findsOneWidget);
    expect(find.text('Bookmarks'), findsOneWidget);
    expect(find.text('Shopping'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    for (var index = 0; index < 5; index++) {
      await tester.tap(find.text(_labels[index]));
      await tester.pump();
    }

    expect(selected, [0, 1, 2, 3, 4]);
    expect(
      tester
          .getSize(find.byKey(const Key('culinary-editorial-navigation-rail')))
          .width,
      CulinaryEditorialNavigationRail.width,
    );
  });

  testWidgets('calendar is an independent expanded utility action', (
    tester,
  ) async {
    var calendarTaps = 0;
    final selected = <int>[];
    await _pumpRail(
      tester,
      selectedIndex: 3,
      calendarOpen: true,
      onSelected: selected.add,
      onCalendarPressed: () => calendarTaps++,
    );

    final calendar = find.byKey(const Key('home-navigation-calendar'));
    expect(
      tester.getSemantics(calendar),
      matchesSemantics(
        label: 'Meal planner',
        isButton: true,
        hasTapAction: true,
        hasExpandedState: true,
        isExpanded: true,
      ),
    );

    await tester.tap(calendar);
    await tester.pump();

    expect(calendarTaps, 1);
    expect(selected, isEmpty);
    final size = tester.getSize(calendar);
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
  });

  testWidgets('supports keyboard activation', (tester) async {
    final selected = <int>[];
    await _pumpRail(tester, selectedIndex: 2, onSelected: selected.add);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(selected, [0]);
  });

  testWidgets('German labels fit at 130% in light, dark, and OLED themes', (
    tester,
  ) async {
    for (final background in [
      const Color(0xFFFAF7F2),
      const Color(0xFF1C181B),
      Colors.black,
    ]) {
      await _pumpRail(
        tester,
        selectedIndex: 4,
        locale: const Locale('de', 'DE'),
        textScale: 1.3,
        scaffoldBackgroundColor: background,
      );

      expect(find.text('Rezepte'), findsOneWidget);
      expect(find.text('Einkaufen'), findsOneWidget);
      expect(find.text('Essensplaner'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}

const _labels = ['Recipes', 'Bookmarks', 'Shopping', 'Explore', 'Settings'];

Future<void> _pumpRail(
  WidgetTester tester, {
  required int selectedIndex,
  bool calendarOpen = false,
  Locale locale = const Locale('en'),
  double textScale = 1,
  Color scaffoldBackgroundColor = const Color(0xFFFAF7F2),
  ValueChanged<int>? onSelected,
  VoidCallback? onCalendarPressed,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1100, 900);
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
        useMaterial3: true,
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
          body: Row(
            children: [
              CulinaryEditorialNavigationRail(
                selectedIndex: selectedIndex,
                destinations: [
                  HomeNavigationDestination(
                    icon: Icons.menu_book_rounded,
                    label: S.of(context).recipes,
                  ),
                  HomeNavigationDestination(
                    icon: Icons.bookmark_rounded,
                    label: S.of(context).favorites,
                  ),
                  HomeNavigationDestination(
                    icon: Icons.shopping_basket,
                    label: S.of(context).basket,
                  ),
                  HomeNavigationDestination(
                    icon: Icons.casino_rounded,
                    label: S.of(context).explore,
                  ),
                  HomeNavigationDestination(
                    icon: Icons.settings,
                    label: S.of(context).settings,
                  ),
                ],
                onDestinationSelected: onSelected ?? (_) {},
                calendarOpen: calendarOpen,
                onCalendarPressed: onCalendarPressed ?? () {},
                calendarLabel: S.of(context).recipe_planer,
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
