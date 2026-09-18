import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_theme.dart';
import 'package:my_recipe_book/widgets/recipe_creation_fab_menu.dart';

void main() {
  testWidgets('shows an extended add button and exactly two recipe actions', (
    tester,
  ) async {
    await _pumpMenu(tester);

    expect(find.text('Add recipe'), findsOneWidget);
    final size = tester.getSize(
      find.byKey(const Key('recipe-creation-fab-semantics')),
    );
    expect(size.width, greaterThan(56));
    expect(size.height, greaterThanOrEqualTo(48));

    await _openMenu(tester);

    expect(find.text('Import from website'), findsOneWidget);
    expect(find.text('Create manually'), findsOneWidget);
    expect(find.textContaining('Manage categor'), findsNothing);
    expect(
      find.byKey(const Key('recipe-creation-import-action')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('recipe-creation-manual-action')),
      findsOneWidget,
    );
    expect(
      tester
          .widget<Opacity>(
            find.byKey(const Key('recipe-creation-anchor-visibility')),
          )
          .opacity,
      0,
    );

    for (final key in [
      const Key('recipe-creation-import-action'),
      const Key('recipe-creation-manual-action'),
      const Key('recipe-creation-close-action'),
    ]) {
      final targetSize = tester.getSize(find.byKey(key));
      expect(targetSize.width, greaterThanOrEqualTo(48));
      expect(targetSize.height, greaterThanOrEqualTo(48));
    }
  });

  testWidgets('dispatches the callback matching each visible action', (
    tester,
  ) async {
    var manualCalls = 0;
    var importCalls = 0;
    await _pumpMenu(
      tester,
      onCreateManually: () => manualCalls++,
      onImportFromWebsite: () => importCalls++,
    );

    await _openMenu(tester);
    await tester.tap(find.byKey(const Key('recipe-creation-manual-action')));
    await tester.pumpAndSettle();
    expect(manualCalls, 1);
    expect(importCalls, 0);
    expect(find.text('Create manually'), findsNothing);

    await _openMenu(tester);
    await tester.tap(find.byKey(const Key('recipe-creation-import-action')));
    await tester.pumpAndSettle();
    expect(manualCalls, 1);
    expect(importCalls, 1);
    expect(find.text('Import from website'), findsNothing);
  });

  testWidgets('dismisses with close, barrier, Back, and Escape', (
    tester,
  ) async {
    await _pumpMenu(tester);

    await _openMenu(tester);
    await tester.tap(find.byKey(const Key('recipe-creation-close-action')));
    await tester.pumpAndSettle();
    expect(find.text('Create manually'), findsNothing);

    await _openMenu(tester);
    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();
    expect(find.text('Create manually'), findsNothing);

    await _openMenu(tester);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Create manually'), findsNothing);

    await _openMenu(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Create manually'), findsNothing);
  });

  testWidgets('reports state, moves focus, and restores focus on dismissal', (
    tester,
  ) async {
    await _pumpMenu(tester);
    final toggle = find.byKey(const Key('recipe-creation-fab-semantics'));

    expect(
      tester.getSemantics(toggle),
      matchesSemantics(
        label: 'Recipe actions',
        value: 'Collapsed',
        hint: 'Shows ways to add a recipe',
        isButton: true,
        isEnabled: true,
        hasEnabledState: true,
        hasTapAction: true,
        hasExpandedState: true,
        isExpanded: false,
      ),
    );

    await _openMenu(tester);
    expect(
      tester.getSemantics(
        find.byKey(const Key('recipe-creation-close-action')),
      ),
      matchesSemantics(
        label: 'Recipe actions',
        value: 'Expanded',
        hint: 'Close recipe actions',
        isButton: true,
        isEnabled: true,
        hasEnabledState: true,
        hasTapAction: true,
        hasExpandedState: true,
        isExpanded: true,
      ),
    );
    expect(_focusIsInside(const Key('recipe-creation-manual-action')), isTrue);

    await tester.tap(find.byKey(const Key('recipe-creation-close-action')));
    await tester.pumpAndSettle();
    await tester.pump();
    expect(
      FocusManager.instance.primaryFocus?.debugLabel,
      'recipe-creation-fab',
    );
  });

  testWidgets('removes the menu before navigation and after returning', (
    tester,
  ) async {
    late BuildContext navigationContext;
    await _pumpMenu(
      tester,
      homeBuilder: (context, menu) {
        navigationContext = context;
        return Scaffold(floatingActionButton: menu);
      },
      onCreateManually: () {
        Navigator.of(navigationContext).push(
          MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('Recipe editor')),
          ),
        );
      },
    );

    await _openMenu(tester);
    await tester.tap(find.byKey(const Key('recipe-creation-manual-action')));
    await tester.pumpAndSettle();
    expect(find.text('Recipe editor'), findsOneWidget);
    expect(find.text('Create manually'), findsNothing);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Add recipe'), findsOneWidget);
    expect(find.text('Create manually'), findsNothing);
  });

  testWidgets('busy state is disabled and announces synchronization', (
    tester,
  ) async {
    var calls = 0;
    await _pumpMenu(
      tester,
      busy: true,
      busyLabel: 'Syncing recipes',
      onCreateManually: () => calls++,
      onImportFromWebsite: () => calls++,
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester.getSemantics(
        find.byKey(const Key('recipe-creation-fab-semantics')),
      ),
      matchesSemantics(
        label: 'Syncing recipes',
        isButton: true,
        isEnabled: false,
        hasEnabledState: true,
        hasExpandedState: true,
        isExpanded: false,
        isLiveRegion: true,
      ),
    );

    await tester.tap(
      find.byKey(const Key('recipe-creation-fab-semantics')),
      warnIfMissed: false,
    );
    await tester.pump();
    expect(calls, 0);
    expect(find.text('Create manually'), findsNothing);
  });

  testWidgets('uses zero-duration route motion when animations are disabled', (
    tester,
  ) async {
    await _pumpMenu(tester, disableAnimations: true);

    await tester.tap(find.text('Add recipe'));
    await tester.pump();
    expect(
      tester.getSize(find.byKey(const Key('recipe-creation-close-action'))),
      const Size(56, 56),
    );

    await tester.tap(find.byKey(const Key('recipe-creation-close-action')));
    await tester.pump();
    expect(find.text('Create manually'), findsNothing);
  });

  testWidgets('selects anchored and bottom-sheet presentations responsively', (
    tester,
  ) async {
    await _pumpMenu(tester, width: 412, height: 800);
    await _openMenu(tester);
    expect(
      find.byKey(const Key('recipe-creation-close-action')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('recipe-creation-sheet-close')), findsNothing);

    for (final configuration in [
      (width: 320.0, height: 800.0, textScale: 1.0),
      (width: 412.0, height: 460.0, textScale: 1.0),
      (width: 412.0, height: 800.0, textScale: 1.4),
    ]) {
      await _pumpMenu(
        tester,
        width: configuration.width,
        height: configuration.height,
        textScale: configuration.textScale,
      );
      await _openMenu(tester);
      expect(
        find.byKey(const Key('recipe-creation-sheet-close')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('recipe-creation-close-action')),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('fits English and German at supported text scales and palettes', (
    tester,
  ) async {
    for (final locale in [const Locale('en'), const Locale('de', 'DE')]) {
      for (final textScale in [1.0, 1.3, 2.0]) {
        await _pumpMenu(
          tester,
          locale: locale,
          textScale: textScale,
          palette: CulinaryEditorialPalette.light,
        );
        await _openMenu(tester);
        expect(
          find.byKey(const Key('recipe-creation-manual-action')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('recipe-creation-import-action')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      }
    }

    for (final palette in [
      CulinaryEditorialPalette.light,
      CulinaryEditorialPalette.dark,
      CulinaryEditorialPalette.oled,
    ]) {
      await _pumpMenu(tester, palette: palette);
      await _openMenu(tester);
      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byKey(const Key('recipe-creation-manual-action')),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(material.color, palette.primarySoft);
      expect(material.color, isNot(Colors.white));
      expect(tester.takeException(), isNull);
    }
  });
}

Future<void> _openMenu(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('recipe-creation-fab-semantics')));
  await tester.pumpAndSettle();
}

bool _focusIsInside(Key key) {
  final focusContext = FocusManager.instance.primaryFocus?.context;
  if (focusContext == null) return false;

  var found = false;
  final element = focusContext as Element;
  if (element.widget.key == key) return true;
  element.visitAncestorElements((ancestor) {
    if (ancestor.widget.key == key) {
      found = true;
      return false;
    }
    return true;
  });
  return found;
}

Future<void> _pumpMenu(
  WidgetTester tester, {
  double width = 412,
  double height = 800,
  double textScale = 1,
  bool disableAnimations = false,
  bool busy = false,
  String? busyLabel,
  Locale locale = const Locale('en'),
  CulinaryEditorialPalette palette = CulinaryEditorialPalette.light,
  VoidCallback? onCreateManually,
  VoidCallback? onImportFromWebsite,
  Widget Function(BuildContext context, Widget menu)? homeBuilder,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.reset);

  final brightness = identical(palette, CulinaryEditorialPalette.light)
      ? Brightness.light
      : Brightness.dark;
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: palette.background,
  );

  await tester.pumpWidget(
    MaterialApp(
      key: UniqueKey(),
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: culinaryEditorialTheme(base, palette),
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            textScaler: TextScaler.linear(textScale),
            disableAnimations: disableAnimations,
          ),
          child: child!,
        );
      },
      home: Builder(
        builder: (context) {
          final menu = RecipeCreationFabMenu(
            busy: busy,
            busyLabel: busyLabel,
            onCreateManually: onCreateManually ?? () {},
            onImportFromWebsite: onImportFromWebsite ?? () {},
          );
          return homeBuilder?.call(context, menu) ??
              Scaffold(floatingActionButton: menu);
        },
      ),
    ),
  );
  await tester.pump();
}
