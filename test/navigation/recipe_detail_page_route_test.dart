import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/navigation/recipe_detail_page_route.dart';

void main() {
  testWidgets('uses a delayed fade instead of spatial page movement', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const SizedBox();
          },
        ),
      ),
    );

    final route = RecipeDetailPageRoute<void>(
      motionEnabled: true,
      builder: (_) => const Text('Recipe detail'),
    );
    const child = Text('Recipe detail');
    final transition = route.transitionsBuilder(
      context,
      const AlwaysStoppedAnimation(0.45),
      const AlwaysStoppedAnimation(0),
      child,
    );

    expect(route.transitionDuration, const Duration(milliseconds: 400));
    expect(route.reverseTransitionDuration, const Duration(milliseconds: 300));
    expect(transition, isA<FadeTransition>());
    expect(transition, isNot(isA<SlideTransition>()));
    expect(
      (transition as FadeTransition).opacity.value,
      inExclusiveRange(0, 1),
    );
  });

  testWidgets('removes route motion when animations are disabled', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const SizedBox();
          },
        ),
      ),
    );

    const child = Text('Recipe detail');
    final route = RecipeDetailPageRoute<void>(
      motionEnabled: false,
      builder: (_) => child,
    );
    final transition = route.transitionsBuilder(
      context,
      const AlwaysStoppedAnimation(0.45),
      const AlwaysStoppedAnimation(0),
      child,
    );

    expect(route.transitionDuration, Duration.zero);
    expect(route.reverseTransitionDuration, Duration.zero);
    expect(identical(transition, child), isTrue);
  });
}
