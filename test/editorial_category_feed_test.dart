import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';
import 'package:my_recipe_book/models/tuple.dart';
import 'package:my_recipe_book/theming.dart';
import 'package:my_recipe_book/widgets/category_overview/editorial_category_feed.dart';

void main() {
  final featured = Recipe(
    name: 'Slow roasted tomato soup',
    categories: const ['Dinner'],
    preperationTime: 20,
    cookingTime: 45,
    totalTime: 65,
    effort: 5,
    vegetable: Vegetable.VEGETARIAN,
    tags: const [
      StringIntTuple(text: 'Cozy', number: 0xFFE05A36),
      StringIntTuple(text: 'Soup', number: 0xFFE58A2B),
      StringIntTuple(text: 'Weeknight', number: 0xFF4A7C59),
      StringIntTuple(text: 'Batch', number: 0xFF4A7C59),
    ],
  );
  final second = Recipe(
    name: 'Herb toast',
    categories: const ['Dinner'],
    totalTime: 12,
    effort: 2,
    vegetable: Vegetable.VEGAN,
  );
  final sections = [
    Tuple2<String, List<Recipe>>('Dinner', [featured, second]),
    Tuple2<String, List<Recipe>>('Weekend', const []),
  ];

  testWidgets('renders real recipe data and keeps actions independent', (
    tester,
  ) async {
    Recipe? opened;
    Recipe? favorited;
    String? openedCategory;
    await _pumpFeed(
      tester,
      sections: sections,
      featured: featured,
      onOpenRecipe: (recipe, heroTag) => opened = recipe,
      onToggleFavorite: (recipe) => favorited = recipe,
      onOpenCategory: (category) => openedCategory = category,
    );

    expect(find.text('DISH OF THE DAY'), findsOneWidget);
    expect(find.text('Slow roasted tomato soup'), findsWidgets);
    expect(find.text('Effort: 5/10'), findsOneWidget);
    expect(find.text('Moderate'), findsNothing);
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('See all (2)'), findsOneWidget);

    final effort = find.byKey(const Key('category-featured-effort'));
    final time = find.byKey(const Key('category-featured-time'));
    expect(
      find.descendant(of: time, matching: find.text('Prep 20m • Cook 45m')),
      findsOneWidget,
    );
    expect(effort, findsOneWidget);

    final featuredCard = find.byKey(const Key('category-featured-card'));
    expect(tester.getSize(featuredCard), const Size(390, 351));
    final openButton = find.byKey(const Key('category-featured-open'));
    expect(tester.getSize(openButton).height, 48);
    expect(
      find.descendant(of: featuredCard, matching: find.text('#Cozy')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: featuredCard, matching: find.text('#Soup')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: featuredCard, matching: find.text('+2')),
      findsOneWidget,
    );

    final gridCard = find.byKey(const ValueKey('category-card-0-0'));
    expect(tester.getSize(gridCard), const Size(192, 216));
    expect(
      find.descendant(
        of: gridCard,
        matching: find.byKey(const Key('recipe-card-grid-aspect')),
      ),
      findsOneWidget,
    );

    final gridTitle = tester.widget<Text>(
      find.descendant(
        of: gridCard,
        matching: find.text('Slow roasted tomato soup'),
      ),
    );
    expect(gridTitle.maxLines, 2);
    expect(gridTitle.overflow, TextOverflow.ellipsis);
    expect(
      find.descendant(of: gridCard, matching: find.text('1h 5m')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: gridCard, matching: find.text('5/10')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: gridCard, matching: find.text('Vegetarian')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(
        const ValueKey('category-featured-favorite-Slow roasted tomato soup'),
      ),
    );
    await tester.pump();
    expect(favorited, featured);
    expect(opened, isNull);

    favorited = null;
    await tester.tap(
      find.descendant(
        of: gridCard,
        matching: find.byKey(const Key('recipe-card-grid-bookmark-action')),
      ),
    );
    await tester.pump();
    expect(favorited, featured);
    expect(opened, isNull);

    await tester.tap(find.byKey(const Key('category-featured-open')));
    await tester.pump();
    expect(opened, featured);

    opened = null;
    await tester.tap(gridCard);
    await tester.pump();
    expect(opened, featured);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('category-see-all-Dinner')),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const ValueKey('category-see-all-Dinner')));
    expect(openedCategory, 'Dinner');
  });

  testWidgets('collapses, expands, and keeps state through parent rebuilds', (
    tester,
  ) async {
    Recipe? opened;
    await _pumpFeed(
      tester,
      sections: sections,
      featured: featured,
      onOpenRecipe: (recipe, heroTag) => opened = recipe,
    );

    expect(find.byKey(const Key('category-featured-card')), findsOneWidget);
    expect(
      find.byKey(const Key('category-featured-collapsed-card')),
      findsNothing,
    );

    await tester.tap(find.byKey(const Key('category-featured-collapse')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('category-featured-card')), findsNothing);
    expect(
      find.byKey(const Key('category-featured-collapsed-card')),
      findsOneWidget,
    );
    expect(find.text('Start'), findsNothing);
    expect(opened, isNull);

    await _pumpFeed(
      tester,
      sections: sections,
      featured: featured,
      onOpenRecipe: (recipe, heroTag) => opened = recipe,
    );
    expect(
      find.byKey(const Key('category-featured-collapsed-card')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('category-featured-expand')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('category-featured-card')), findsOneWidget);
    expect(opened, isNull);
  });

  testWidgets('lets phone category rows scroll to the screen edges', (
    tester,
  ) async {
    final third = Recipe(
      name: 'Crispy potatoes',
      categories: const ['Dinner'],
      totalTime: 35,
    );
    await _pumpFeed(
      tester,
      sections: [
        Tuple2<String, List<Recipe>>('Dinner', [featured, second, third]),
      ],
      featured: featured,
      size: const Size(430, 900),
    );

    final sectionsPadding = tester.widget<SliverPadding>(
      find.byKey(const Key('category-feed-sections-padding')),
    );
    expect(sectionsPadding.padding, const EdgeInsets.only(bottom: 36));

    final categoryRow = tester.widget<ListView>(
      find.byKey(const PageStorageKey('category-row-Dinner')),
    );
    expect(categoryRow.padding, const EdgeInsets.symmetric(horizontal: 20));

    await tester.drag(
      find.byKey(const PageStorageKey('category-row-Dinner')),
      const Offset(-100, 0),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('category-card-0-0'))).dx,
      lessThan(1),
    );
  });

  testWidgets('localizes the editorial feed in German', (tester) async {
    await _pumpFeed(
      tester,
      sections: sections,
      featured: featured,
      locale: const Locale('de', 'DE'),
    );

    expect(find.text('GERICHT DES TAGES'), findsOneWidget);
    expect(find.text('Aufwand: 5/10'), findsOneWidget);
    expect(find.text('Vorb. 20m • Garen 45m'), findsOneWidget);
    expect(find.text('Starten'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Gericht des Tages einklappen'),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.text('Alle ansehen (2)'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Alle ansehen (2)'), findsOneWidget);
  });

  testWidgets('shows library and category empty states', (tester) async {
    await _pumpFeed(
      tester,
      sections: [Tuple2<String, List<Recipe>>('Dinner', const [])],
      featured: null,
    );
    expect(find.text('Your cookbook is ready'), findsOneWidget);
    expect(
      find.text(
        'Add your first recipe with the + button and it will appear here.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('adapts at large text on phone and wide layouts', (tester) async {
    final longRecipe = featured.copyWith(
      name: 'A very long inherited family recipe title that still has to fit',
      categories: const ['A particularly descriptive dinner collection'],
      tags: const [
        StringIntTuple(text: 'Long descriptive tag', number: 0xFFE05A36),
        StringIntTuple(text: 'Another long tag', number: 0xFFE58A2B),
        StringIntTuple(text: 'Third long tag', number: 0xFF4A7C59),
      ],
    );
    final longSections = [
      Tuple2<String, List<Recipe>>(
        'A particularly descriptive dinner collection',
        [longRecipe, second],
      ),
      Tuple2<String, List<Recipe>>('Weekend', [featured]),
    ];

    await _pumpFeed(
      tester,
      sections: longSections,
      featured: longRecipe,
      textScale: 1.3,
      size: const Size(430, 900),
    );
    expect(tester.takeException(), isNull);

    await _pumpFeed(
      tester,
      sections: longSections,
      featured: longRecipe,
      textScale: 1.3,
      size: const Size(320, 900),
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.byKey(const Key('category-featured-collapse')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _pumpFeed(
      tester,
      sections: longSections,
      featured: longRecipe,
      textScale: 1.3,
      size: const Size(1200, 900),
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.byKey(const Key('category-featured-expand')));
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byKey(const Key('category-featured-card'))).height,
      444,
    );
    expect(find.byKey(const ValueKey('category-card-1-0')), findsOneWidget);
  });

  testWidgets(
    'keeps the final recipe section above an overlaid navigation bar',
    (tester) async {
      await _pumpFeed(
        tester,
        sections: sections,
        featured: featured,
        bottomPadding: 104,
      );

      final sectionsPadding = tester.widget<SliverPadding>(
        find.byKey(const Key('category-feed-sections-padding')),
      );
      final padding = sectionsPadding.padding as EdgeInsets;
      expect(padding.bottom, 140);
    },
  );

  testWidgets('handles missing metadata and dark theme variants', (
    tester,
  ) async {
    final bareRecipe = Recipe(
      name: 'Pantry pasta',
      imagePath: '/missing/hero.jpg',
      imagePreviewPath: '/missing/preview.jpg',
    );
    final bareSections = [
      Tuple2<String, List<Recipe>>('Dinner', [bareRecipe]),
    ];

    await _pumpFeed(
      tester,
      sections: bareSections,
      featured: bareRecipe,
      themeKey: MyThemeKeys.DARK,
    );
    expect(find.text('Effort not set'), findsWidgets);
    expect(tester.takeException(), isNull);

    final totalOnlyRecipe = bareRecipe.copyWith(totalTime: 15);
    await _pumpFeed(
      tester,
      sections: [
        Tuple2<String, List<Recipe>>('Dinner', [totalOnlyRecipe]),
      ],
      featured: totalOnlyRecipe,
      themeKey: MyThemeKeys.DARK,
    );
    expect(find.text('Total: 15m'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await _pumpFeed(
      tester,
      sections: bareSections,
      featured: bareRecipe,
      themeKey: MyThemeKeys.OLEDBLACK,
    );
    expect(find.text('Pantry pasta'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpFeed(
  WidgetTester tester, {
  required List<Tuple2<String, List<Recipe>>> sections,
  required Recipe? featured,
  Locale locale = const Locale('en'),
  Size size = const Size(430, 900),
  double textScale = 1,
  double bottomPadding = 0,
  MyThemeKeys themeKey = MyThemeKeys.LIGHT,
  OpenOverviewRecipe? onOpenRecipe,
  ToggleOverviewFavorite? onToggleFavorite,
  OpenOverviewCategory? onOpenCategory,
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    CustomTheme(
      initialThemeKey: themeKey,
      child: Builder(
        builder: (context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: CustomTheme.of(context),
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
              padding: EdgeInsets.only(bottom: bottomPadding),
              textScaler: TextScaler.linear(textScale),
            ),
            child: Scaffold(
              body: EditorialCategoryFeed(
                sections: sections,
                featuredRecipe: featured,
                onOpenRecipe: onOpenRecipe ?? (recipe, heroTag) {},
                onToggleFavorite: onToggleFavorite ?? (recipe) {},
                onOpenCategory: onOpenCategory ?? (category) {},
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
