import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/constants/global_constants.dart' as constants;
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_collection_filters.dart';
import 'package:my_recipe_book/models/recipe_sort.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';

void main() {
  final quickVegan = Recipe(
    name: 'Green Curry',
    categories: const ['Dinner', 'Weeknight'],
    tags: const [StringIntTuple(text: 'Quick', number: 1)],
    vegetable: Vegetable.VEGAN,
    totalTime: 30,
    effort: 3,
    ingredients: const [
      [Ingredient(name: 'Coconut milk')],
    ],
  );
  final comfortMeat = Recipe(
    name: 'Beef Stew',
    categories: const ['Dinner'],
    tags: const [StringIntTuple(text: 'Comfort', number: 2)],
    vegetable: Vegetable.NON_VEGETARIAN,
    totalTime: 180,
    effort: 8,
  );
  final unknownValues = Recipe(
    name: 'Pantry Surprise',
    categories: const [],
    tags: const [StringIntTuple(text: 'Quick', number: 1)],
    vegetable: Vegetable.VEGETARIAN,
  );
  final recipes = [quickVegan, comfortMeat, unknownValues];

  test('matches any category and tag within groups, then combines groups', () {
    final matches = filterRecipeCollection(
      recipes: recipes,
      query: '',
      filters: const RecipeCollectionFilters(
        categories: ['Weeknight', constants.noCategory],
        tags: ['Quick', 'Comfort'],
      ),
    );

    expect(matches.map((recipe) => recipe.name), [
      'Green Curry',
      'Pantry Surprise',
    ]);
  });

  test('caps exclude unknown values and search includes ingredients', () {
    var matches = filterRecipeCollection(
      recipes: recipes,
      query: '',
      filters: const RecipeCollectionFilters(
        maxTotalTimeMinutes: 60,
        maxEffort: 5,
      ),
    );
    expect(matches.map((recipe) => recipe.name), ['Green Curry']);

    matches = filterRecipeCollection(
      recipes: recipes,
      query: 'coconut',
      filters: const RecipeCollectionFilters(),
    );
    expect(matches.single.name, 'Green Curry');
  });

  test(
    'options use collection values and normalization removes stale facets',
    () {
      final options = RecipeCollectionFilterOptions.fromRecipes(
        recipes,
        excludedCategory: 'Dinner',
        excludedTag: 'Comfort',
      );
      expect(options.categories, ['Weeknight', constants.noCategory]);
      expect(options.tags.map((tag) => tag.text), ['Quick']);

      final normalized = const RecipeCollectionFilters(
        categories: ['Dinner', 'Missing'],
        tags: ['Quick', 'Missing'],
        vegetable: Vegetable.VEGAN,
      ).normalizedFor(recipes, excludedCategory: 'Dinner');
      expect(normalized.categories, isEmpty);
      expect(normalized.tags, ['Quick']);
      expect(normalized.vegetable, Vegetable.VEGAN);
    },
  );

  test('shared sorter keeps null effort values last', () {
    final sorted = sortRecipeCollection(
      recipes,
      RSort(RecipeSort.BY_EFFORT, true),
    );
    expect(sorted.map((recipe) => recipe.name), [
      'Green Curry',
      'Beef Stew',
      'Pantry Surprise',
    ]);
  });
}
