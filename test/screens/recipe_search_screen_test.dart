import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';
import 'package:my_recipe_book/screens/recipe_search_screen.dart';
import 'package:my_recipe_book/widgets/culinary_editorial_theme.dart';

void main() {
  testWidgets('starts with a focused invitation and clears back to it', (
    tester,
  ) async {
    await _pumpSearch(tester);

    expect(find.text('What would you like to cook?'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('What would you like to cook?')).dy,
      lessThan(260),
    );
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Recipes'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Tags'), findsOneWidget);
    expect(find.bySemanticsLabel('Recipes: 2'), findsOneWidget);
    final promptHeading = tester.widget<Semantics>(
      find
          .ancestor(
            of: find.text('What would you like to cook?'),
            matching: find.byType(Semantics),
          )
          .first,
    );
    expect(promptHeading.properties.header, isTrue);
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
      isTrue,
    );

    await tester.enterText(
      find.byKey(const Key('recipe-search-field')),
      'quick',
    );
    await tester.pump();
    expect(find.byKey(const Key('recipe-search-results')), findsOneWidget);

    await tester.tap(find.byKey(const Key('recipe-search-clear')));
    await tester.pump();
    expect(find.byKey(const Key('recipe-search-prompt')), findsOneWidget);
    expect(find.text('What would you like to cook?'), findsOneWidget);
  });

  testWidgets('groups matches and dispatches each result type', (tester) async {
    String? openedRecipe;
    String? openedCategory;
    StringIntTuple? openedTag;
    await _pumpSearch(
      tester,
      onOpenRecipe: (name) async {
        openedRecipe = name;
        return true;
      },
      onOpenCategory: (category) => openedCategory = category,
      onOpenTag: (tag) => openedTag = tag,
    );

    await tester.enterText(
      find.byKey(const Key('recipe-search-field')),
      'QUICK',
    );
    await tester.pump();

    expect(find.text('Recipes'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Tags'), findsOneWidget);
    expect(find.text('Quick curry'), findsOneWidget);
    expect(find.text('Quick dinners'), findsOneWidget);
    expect(find.text('#Quick'), findsOneWidget);
    expect(find.text('Slow stew'), findsNothing);

    await tester.tap(find.byKey(const Key('recipe-search-recipe-Quick curry')));
    await tester.pump();
    await tester.tap(
      find.byKey(const Key('recipe-search-category-Quick dinners')),
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('recipe-search-tag-Quick')));
    await tester.pump();

    expect(openedRecipe, 'Quick curry');
    expect(openedCategory, 'Quick dinners');
    expect(openedTag?.text, 'Quick');
  });

  testWidgets('shows useful no-match and unavailable-recipe feedback', (
    tester,
  ) async {
    await _pumpSearch(tester, onOpenRecipe: (_) async => false);

    await tester.enterText(
      find.byKey(const Key('recipe-search-field')),
      'missing',
    );
    await tester.pump();
    expect(find.text('No results for “missing”'), findsOneWidget);
    final noResultsHeading = tester.widget<Semantics>(
      find
          .ancestor(
            of: find.text('No results for “missing”'),
            matching: find.byType(Semantics),
          )
          .first,
    );
    expect(noResultsHeading.properties.header, isTrue);
    expect(
      find.text('Try another recipe name, category, or tag.'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const Key('recipe-search-field')),
      'curry',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('recipe-search-recipe-Quick curry')));
    await tester.pump();
    expect(find.text('This recipe is no longer available.'), findsOneWidget);
  });

  testWidgets('returns with the native back affordance', (tester) async {
    await tester.pumpWidget(
      _localizedApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(builder: (_) => _screen()),
                ),
                child: const Text('Open search'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open search'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('recipe-search-screen')), findsOneWidget);

    await tester.tap(find.byKey(const Key('recipe-search-back')));
    await tester.pumpAndSettle();
    expect(find.text('Open search'), findsOneWidget);
  });

  testWidgets('fits German copy at 130% in light, dark, and OLED themes', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 720);
    addTearDown(tester.view.reset);

    for (final background in [
      CulinaryEditorialPalette.light.background,
      CulinaryEditorialPalette.dark.background,
      Colors.black,
    ]) {
      await tester.pumpWidget(
        _localizedApp(
          locale: const Locale('de', 'DE'),
          scaffoldBackgroundColor: background,
          textScale: 1.3,
          home: _screen(),
        ),
      );
      await tester.pump();

      expect(find.text('Was möchtest du kochen?'), findsOneWidget);
      expect(tester.takeException(), isNull);
      final scaffold = tester.widget<Scaffold>(
        find.byKey(const Key('recipe-search-screen')),
      );
      expect(
        scaffold.backgroundColor,
        background == Colors.black
            ? CulinaryEditorialPalette.oled.background
            : background,
      );
    }
  });
}

Future<void> _pumpSearch(
  WidgetTester tester, {
  OpenRecipeSearchResult? onOpenRecipe,
  OpenCategorySearchResult? onOpenCategory,
  OpenTagSearchResult? onOpenTag,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(430, 900);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    _localizedApp(
      home: _screen(
        onOpenRecipe: onOpenRecipe,
        onOpenCategory: onOpenCategory,
        onOpenTag: onOpenTag,
      ),
    ),
  );
  await tester.pump();
}

RecipeSearchScreen _screen({
  OpenRecipeSearchResult? onOpenRecipe,
  OpenCategorySearchResult? onOpenCategory,
  OpenTagSearchResult? onOpenTag,
}) {
  return RecipeSearchScreen(
    recipeNames: const ['Quick curry', 'Slow stew'],
    categories: const ['Quick dinners'],
    tags: const [StringIntTuple(text: 'Quick', number: 0xFFA83211)],
    onOpenRecipe: onOpenRecipe ?? (_) async => true,
    onOpenCategory: onOpenCategory ?? (_) {},
    onOpenTag: onOpenTag ?? (_) {},
  );
}

MaterialApp _localizedApp({
  required Widget home,
  Locale locale = const Locale('en'),
  double textScale = 1,
  Color scaffoldBackgroundColor = const Color(0xFFFAF7F2),
}) {
  final brightness = scaffoldBackgroundColor.computeLuminance() < .2
      ? Brightness.dark
      : Brightness.light;
  return MaterialApp(
    key: ValueKey(scaffoldBackgroundColor),
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
        data: media.copyWith(
          textScaler: TextScaler.linear(textScale),
          disableAnimations: true,
        ),
        child: child!,
      );
    },
    home: home,
  );
}
