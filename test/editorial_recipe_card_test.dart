import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';
import 'package:my_recipe_book/widgets/recipe_overview/editorial_recipe_card.dart';

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
          body: Center(
            child: SizedBox(
              width: 180,
              child: EditorialRecipeCard(
                recipe: recipe,
                heroImageTag: 'test-recipe',
                layout: RecipeOverviewCardLayout.grid,
                onOpen: () => opened = true,
                onBookmarkToggle: () => bookmarked = true,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final title = tester.widget<Text>(find.text(recipe.name));
    expect(title.style?.fontFamily, 'PlayfairDisplay');
    expect(title.style?.fontWeight, FontWeight.w600);
    expect(find.text('+1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.bookmark_border_rounded));
    await tester.pump();
    expect(bookmarked, isTrue);
    expect(opened, isFalse);

    await tester.tap(find.text(recipe.name));
    await tester.pump();
    expect(opened, isTrue);
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
}
