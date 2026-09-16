import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/tuple.dart';
import 'package:my_recipe_book/widgets/category_overview/dish_of_the_day.dart';

void main() {
  test('selects one stable de-duplicated recipe for the local day', () {
    final apple = Recipe(name: 'Apple Tart');
    final broth = Recipe(name: 'Broth');
    final curry = Recipe(name: 'Curry');
    final sections = [
      Tuple2<String, List<Recipe>>('Dinner', [curry, broth]),
      Tuple2<String, List<Recipe>>('Favorites', [apple, curry]),
    ];
    final date = DateTime(2026, 9, 15, 23, 45);

    final first = selectDishOfTheDay(sections, date);
    final second = selectDishOfTheDay(sections, DateTime(2026, 9, 15, 1));
    final nextDay = selectDishOfTheDay(sections, DateTime(2026, 9, 16));

    expect(first, same(second));
    expect(nextDay, isNot(same(first)));
    expect([apple, broth, curry], contains(first));
  });

  test('returns null for an empty library and responds to library changes', () {
    final empty = [Tuple2<String, List<Recipe>>('Dinner', const [])];
    expect(selectDishOfTheDay(empty, DateTime(2026, 9, 15)), isNull);

    final recipe = Recipe(name: 'Only recipe');
    expect(
      selectDishOfTheDay([
        Tuple2<String, List<Recipe>>('Dinner', [recipe]),
      ], DateTime(2026, 9, 15)),
      same(recipe),
    );
  });
}
