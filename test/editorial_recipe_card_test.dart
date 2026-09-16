import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';
import 'package:my_recipe_book/widgets/recipe_overview/editorial_recipe_card.dart';
import 'package:my_recipe_book/widgets/recipe_overview/recipe_overview_theme.dart';

void main() {
  testWidgets('uses HTML typography and keeps bookmark separate from open', (
    tester,
  ) async {
    var opened = false;
    var bookmarked = false;
    final recipe = Recipe(
      name: 'Wild Mushroom Pappardelle',
      totalTime: 45,
      effort: 5,
      vegetable: Vegetable.VEGETARIAN,
      tags: const [
        StringIntTuple(text: 'WildMushroom', number: 0),
        StringIntTuple(text: 'Handmade', number: 0),
        StringIntTuple(text: 'Earthy', number: 0),
        StringIntTuple(text: 'Pasta', number: 0),
      ],
    );

    await _pumpCard(
      tester,
      recipe: recipe,
      layout: RecipeOverviewCardLayout.grid,
      cardWidth: 180,
      onOpen: () => opened = true,
      onBookmarkToggle: () => bookmarked = true,
    );

    final title = tester.widget<Text>(find.text(recipe.name));
    expect(title.style?.fontFamily, 'PlayfairDisplay');
    expect(title.style?.fontWeight, FontWeight.w700);
    expect(title.maxLines, 2);
    expect(title.overflow, TextOverflow.ellipsis);

    final aspect = tester.widget<AspectRatio>(
      find.byKey(const Key('recipe-card-grid-aspect')),
    );
    expect(aspect.aspectRatio, 4 / 5);
    expect(
      tester.getSize(find.byKey(const Key('recipe-card-grid-aspect'))),
      const Size(180, 225),
    );
    expect(find.byKey(const Key('recipe-card-grid-hud')), findsOneWidget);
    expect(find.text('45m'), findsOneWidget);
    expect(find.text('5/10'), findsOneWidget);
    expect(find.text('Vegetarian'), findsOneWidget);
    expect(find.text('#WildMushroom'), findsOneWidget);
    expect(find.text('#Handmade'), findsOneWidget);
    expect(find.text('#Earthy'), findsNothing);
    expect(find.text('#Pasta'), findsNothing);
    expect(find.text('+1'), findsNothing);
    expect(
      tester.widget(
        find.byKey(const Key('recipe-card-grid-tag-#WildMushroom')),
      ),
      isA<Text>(),
    );
    expect(
      tester.getSize(find.byKey(const Key('recipe-card-grid-bookmark-action'))),
      const Size.square(48),
    );

    await tester.tap(find.byKey(const Key('recipe-card-grid-bookmark-action')));
    await tester.pump();
    expect(bookmarked, isTrue);
    expect(opened, isFalse);

    await tester.tap(find.text(recipe.name));
    await tester.pump();
    expect(opened, isTrue);
  });

  testWidgets('grid HUD adapts to dark and OLED themes at 130% text scale', (
    tester,
  ) async {
    final recipe = Recipe(
      name: 'Wild Mushroom Pappardelle with a long editorial title',
      totalTime: 125,
      effort: 8,
      vegetable: Vegetable.NON_VEGETARIAN,
    );

    await _pumpCard(
      tester,
      recipe: recipe,
      layout: RecipeOverviewCardLayout.grid,
      cardWidth: 180,
      textScaleFactor: 1.3,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: RecipeOverviewPalette.dark.background,
      ),
    );

    final darkHud = tester.widget<DecoratedBox>(
      find.byKey(const Key('recipe-card-grid-hud')),
    );
    expect(
      (darkHud.decoration as BoxDecoration).color,
      const Color(0xB31A1719),
    );
    expect(find.text('2h 5m'), findsOneWidget);
    expect(find.text('With meat'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await _pumpCard(
      tester,
      recipe: recipe,
      layout: RecipeOverviewCardLayout.grid,
      cardWidth: 180,
      textScaleFactor: 1.3,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
    );
    expect(find.byKey(const Key('recipe-card-grid-hud')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('falls back to the bundled placeholder for invalid images', (
    tester,
  ) async {
    final recipe = Recipe(
      name: 'Missing image recipe',
      imagePreviewPath: '/definitely/missing/recipe-preview.jpg',
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 180,
            child: EditorialRecipeCard(
              recipe: recipe,
              heroImageTag: 'missing-image',
              layout: RecipeOverviewCardLayout.grid,
              onOpen: () {},
              onBookmarkToggle: () {},
              onCookAction: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final image = tester.widget<Image>(find.byType(Image).first);
    expect(image.errorBuilder, isNotNull);
    final fallback = image.errorBuilder!(
      tester.element(find.byType(Image).first),
      StateError('missing preview'),
      StackTrace.empty,
    );
    expect(fallback, isA<Image>());
    expect((fallback as Image).image, isA<AssetImage>());
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'list layout matches the editorial reference and isolates actions',
    (tester) async {
      var opened = 0;
      var bookmarked = 0;
      var cooked = 0;
      final recipe = Recipe(
        name: 'Wild Mushroom Pappardelle with a very long editorial title',
        preperationTime: 15,
        cookingTime: 30,
        totalTime: 45,
        effort: 5,
        vegetable: Vegetable.VEGETARIAN,
        tags: const [
          StringIntTuple(text: 'WildMushroom', number: 0),
          StringIntTuple(text: 'Handmade', number: 0),
          StringIntTuple(text: 'Earthy', number: 0),
          StringIntTuple(text: 'Pasta', number: 0),
        ],
      );

      await _pumpCard(
        tester,
        recipe: recipe,
        layout: RecipeOverviewCardLayout.list,
        onOpen: () => opened++,
        onBookmarkToggle: () => bookmarked++,
        onCookAction: () => cooked++,
      );

      final title = tester.widget<Text>(find.text(recipe.name));
      expect(title.style?.fontFamily, 'PlayfairDisplay');
      expect(title.style?.fontWeight, FontWeight.w600);
      expect(title.maxLines, 1);
      expect(title.overflow, TextOverflow.ellipsis);

      final imageBox = tester.widget<SizedBox>(
        find.byKey(const Key('recipe-card-list-image')),
      );
      expect(imageBox.width, 96);
      expect(imageBox.height, 96);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is DecoratedBox &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).gradient != null,
        ),
        findsNothing,
      );

      expect(find.text('5/10 Effort'), findsOneWidget);
      expect(find.text('15m prep · 30m cook'), findsOneWidget);
      expect(find.text('Vegetarian'), findsOneWidget);
      expect(find.text('#WildMushroom'), findsOneWidget);
      expect(find.text('#Handmade'), findsOneWidget);
      expect(find.text('#Earthy'), findsOneWidget);
      expect(find.text('+1'), findsOneWidget);

      expect(
        tester.getSize(find.byKey(const Key('recipe-card-cook-action'))),
        const Size.square(48),
      );
      expect(
        tester.getSize(find.byKey(const Key('recipe-card-cook-visual'))),
        const Size.square(32),
      );
      expect(
        tester
            .getSize(
              find.byKey(const Key('recipe-card-list-tag-#WildMushroom')),
            )
            .height,
        32,
      );

      for (var index = 0; index < 10; index++) {
        expect(find.byKey(Key('recipe-effort-segment-$index')), findsOneWidget);
      }
      final activeSegment = tester.widget<DecoratedBox>(
        find.byKey(const Key('recipe-effort-segment-0')),
      );
      final inactiveSegment = tester.widget<DecoratedBox>(
        find.byKey(const Key('recipe-effort-segment-9')),
      );
      expect(
        (activeSegment.decoration as BoxDecoration).color,
        RecipeOverviewPalette.light.tertiary,
      );
      expect(
        (inactiveSegment.decoration as BoxDecoration).color,
        RecipeOverviewPalette.light.surfaceContainerHigh,
      );

      await tester.tap(find.byKey(const Key('recipe-card-bookmark-action')));
      await tester.pump();
      expect(bookmarked, 1);
      expect(opened, 0);
      expect(cooked, 0);

      await tester.tap(find.byKey(const Key('recipe-card-cook-action')));
      await tester.pump();
      expect(cooked, 1);
      expect(opened, 0);

      await tester.tap(find.text(recipe.name));
      await tester.pump();
      expect(opened, 1);
    },
  );

  testWidgets('list layout localizes time and falls back to total duration', (
    tester,
  ) async {
    final recipe = Recipe(
      name: 'Kartoffelsuppe',
      preperationTime: 10,
      totalTime: 40,
      effort: 2,
      vegetable: Vegetable.VEGAN,
    );

    await _pumpCard(
      tester,
      recipe: recipe,
      layout: RecipeOverviewCardLayout.list,
      locale: const Locale('de', 'DE'),
    );

    expect(find.text('2/10 Aufwand'), findsOneWidget);
    expect(find.text('40m gesamt'), findsOneWidget);
    expect(find.text('10m Vorbereitung'), findsNothing);
    expect(find.text('vegan'), findsOneWidget);
    expect(find.byType(Divider), findsNothing);
    expect(find.byKey(const Key('recipe-card-cook-action')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpCard(
  WidgetTester tester, {
  required Recipe recipe,
  required RecipeOverviewCardLayout layout,
  Locale locale = const Locale('en'),
  ThemeData? theme,
  double cardWidth = 390,
  double textScaleFactor = 1,
  VoidCallback? onOpen,
  VoidCallback? onBookmarkToggle,
  VoidCallback? onCookAction,
}) async {
  await tester.binding.setSurfaceSize(const Size(430, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      theme: theme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScaleFactor)),
        child: child!,
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: cardWidth,
            child: EditorialRecipeCard(
              recipe: recipe,
              heroImageTag: 'test-list-recipe',
              layout: layout,
              onOpen: onOpen ?? () {},
              onBookmarkToggle: onBookmarkToggle ?? () {},
              onCookAction: onCookAction ?? () {},
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
