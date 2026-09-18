import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/tuple.dart';
import 'package:my_recipe_book/widgets/calendar/editorial_weekly_planner.dart';

void main() {
  test(
    'groups repeat recipes and scales consolidated ingredients by servings',
    () {
      final recipe = Recipe(
        name: 'Soup',
        servings: 4,
        ingredients: const [
          [Ingredient(name: 'Carrot', amount: 2, unit: 'pc')],
          [
            Ingredient(name: 'Carrot', amount: 1, unit: 'pc'),
            Ingredient(name: 'Salt'),
          ],
        ],
      );
      final monday = DateTime(2026, 9, 14);
      final drafts = buildCalendarExportDrafts({
        monday: [Tuple2(monday, recipe)],
        monday.add(const Duration(days: 2)): [
          Tuple2(monday.add(const Duration(days: 2)), recipe),
        ],
      });

      expect(drafts, hasLength(1));
      final draft = drafts.single;
      expect(draft.occurrenceCount, 2);
      expect(draft.totalServings, 8);
      expect(draft.ingredients, hasLength(2));
      expect(draft.selectedScaledIngredients.first.amount, 6);

      draft.totalServings = 12;
      draft.selected.remove(1);
      expect(draft.selectedScaledIngredients, hasLength(1));
      expect(draft.selectedScaledIngredients.single.amount, 9);
    },
  );

  test(
    'recipes without servings use occurrence scaling and retain null amounts',
    () {
      final recipe = Recipe(
        name: 'Toast',
        ingredients: const [
          [Ingredient(name: 'Bread', amount: 2, unit: 'slice')],
          [Ingredient(name: 'Salt')],
        ],
      );
      final monday = DateTime(2026, 9, 14);
      final draft = buildCalendarExportDrafts({
        monday: [Tuple2(monday, recipe), Tuple2(monday, recipe)],
      }).single;

      expect(draft.totalServings, isNull);
      expect(draft.selectedScaledIngredients.first.amount, 4);
      expect(draft.selectedScaledIngredients.last.amount, isNull);
    },
  );
}
