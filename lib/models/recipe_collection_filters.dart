import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../constants/global_constants.dart' as constants;
import '../util/helper.dart';
import 'enums.dart';
import 'recipe.dart';
import 'recipe_sort.dart';
import 'string_int_tuple.dart';

const Object _unchangedFilterValue = Object();

class RecipeCollectionFilters extends Equatable {
  const RecipeCollectionFilters({
    this.vegetable,
    this.categories = const [],
    this.tags = const [],
    this.maxTotalTimeMinutes,
    this.maxEffort,
  });

  final Vegetable? vegetable;
  final List<String> categories;
  final List<String> tags;
  final int? maxTotalTimeMinutes;
  final int? maxEffort;

  bool get isEmpty => activeCount == 0;

  int get activeCount =>
      categories.length +
      tags.length +
      (vegetable == null ? 0 : 1) +
      (maxTotalTimeMinutes == null ? 0 : 1) +
      (maxEffort == null ? 0 : 1);

  RecipeCollectionFilters copyWith({
    Object? vegetable = _unchangedFilterValue,
    List<String>? categories,
    List<String>? tags,
    Object? maxTotalTimeMinutes = _unchangedFilterValue,
    Object? maxEffort = _unchangedFilterValue,
  }) {
    return RecipeCollectionFilters(
      vegetable: identical(vegetable, _unchangedFilterValue)
          ? this.vegetable
          : vegetable as Vegetable?,
      categories: List.unmodifiable(categories ?? this.categories),
      tags: List.unmodifiable(tags ?? this.tags),
      maxTotalTimeMinutes: identical(maxTotalTimeMinutes, _unchangedFilterValue)
          ? this.maxTotalTimeMinutes
          : maxTotalTimeMinutes as int?,
      maxEffort: identical(maxEffort, _unchangedFilterValue)
          ? this.maxEffort
          : maxEffort as int?,
    );
  }

  RecipeCollectionFilters normalizedFor(
    List<Recipe> recipes, {
    String? excludedCategory,
    String? excludedTag,
    bool includeVegetable = true,
  }) {
    final options = RecipeCollectionFilterOptions.fromRecipes(
      recipes,
      excludedCategory: excludedCategory,
      excludedTag: excludedTag,
      includeVegetable: includeVegetable,
    );
    final categoryNames = options.categories.toSet();
    final tagNames = options.tags.map((tag) => tag.text).toSet();
    return RecipeCollectionFilters(
      vegetable: includeVegetable && options.vegetables.contains(vegetable)
          ? vegetable
          : null,
      categories: List.unmodifiable(categories.where(categoryNames.contains)),
      tags: List.unmodifiable(tags.where(tagNames.contains)),
      maxTotalTimeMinutes: maxTotalTimeMinutes,
      maxEffort: maxEffort,
    );
  }

  @override
  List<Object?> get props => [
    vegetable,
    categories,
    tags,
    maxTotalTimeMinutes,
    maxEffort,
  ];
}

class RecipeCollectionFilterOptions extends Equatable {
  const RecipeCollectionFilterOptions({
    required this.vegetables,
    required this.categories,
    required this.tags,
  });

  factory RecipeCollectionFilterOptions.fromRecipes(
    Iterable<Recipe> recipes, {
    String? excludedCategory,
    String? excludedTag,
    bool includeVegetable = true,
  }) {
    final vegetables = <Vegetable>{};
    final categories = <String>{};
    final tags = LinkedHashMap<String, StringIntTuple>();
    var includesUncategorized = false;

    for (final recipe in recipes) {
      if (includeVegetable) vegetables.add(recipe.vegetable);
      if (recipe.categories.isEmpty) {
        includesUncategorized = true;
      } else {
        categories.addAll(recipe.categories);
      }
      for (final tag in recipe.tags) {
        tags.putIfAbsent(tag.text, () => tag);
      }
    }

    if (excludedCategory != null &&
        excludedCategory != constants.allCategories) {
      categories.remove(excludedCategory);
      if (excludedCategory == constants.noCategory) {
        includesUncategorized = false;
      }
    }
    if (excludedTag != null) tags.remove(excludedTag);

    final sortedCategories = categories.toList()
      ..sort(
        (first, second) => first.toLowerCase().compareTo(second.toLowerCase()),
      );
    if (includesUncategorized) sortedCategories.add(constants.noCategory);

    final sortedTags = tags.values.toList()
      ..sort(
        (first, second) =>
            first.text.toLowerCase().compareTo(second.text.toLowerCase()),
      );
    final sortedVegetables = vegetables.toList()
      ..sort((first, second) => first.index.compareTo(second.index));

    return RecipeCollectionFilterOptions(
      vegetables: List.unmodifiable(sortedVegetables),
      categories: List.unmodifiable(sortedCategories),
      tags: List.unmodifiable(sortedTags),
    );
  }

  final List<Vegetable> vegetables;
  final List<String> categories;
  final List<StringIntTuple> tags;

  @override
  List<Object> get props => [vegetables, categories, tags];
}

List<Recipe> filterRecipeCollection({
  required Iterable<Recipe> recipes,
  required String query,
  required RecipeCollectionFilters filters,
}) {
  final normalizedQuery = query.trim().toLowerCase();
  return recipes.where((recipe) {
    if (filters.vegetable != null && recipe.vegetable != filters.vegetable) {
      return false;
    }

    if (filters.categories.isNotEmpty) {
      final matchesCategory = filters.categories.any((category) {
        if (category == constants.noCategory) return recipe.categories.isEmpty;
        return recipe.categories.contains(category);
      });
      if (!matchesCategory) return false;
    }

    if (filters.tags.isNotEmpty) {
      final recipeTags = recipe.tags.map((tag) => tag.text).toSet();
      if (!filters.tags.any(recipeTags.contains)) return false;
    }

    final maxTime = filters.maxTotalTimeMinutes;
    if (maxTime != null &&
        (recipe.totalTime <= 0 || recipe.totalTime > maxTime)) {
      return false;
    }

    final maxEffort = filters.maxEffort;
    if (maxEffort != null &&
        (recipe.effort == null || recipe.effort! > maxEffort)) {
      return false;
    }

    if (normalizedQuery.isEmpty) return true;
    if (recipe.name.toLowerCase().contains(normalizedQuery)) return true;
    if (recipe.tags.any(
      (tag) => tag.text.toLowerCase().contains(normalizedQuery),
    )) {
      return true;
    }
    return recipe.ingredients
        .expand((section) => section)
        .any(
          (ingredient) =>
              ingredient.name.toLowerCase().contains(normalizedQuery),
        );
  }).toList();
}

List<Recipe> sortRecipeCollection(Iterable<Recipe> source, RSort recipeSort) {
  final recipes = List<Recipe>.from(source);
  final ascending = recipeSort.ascending ?? true;
  recipes.sort((first, second) {
    final int result;
    switch (recipeSort.sort) {
      case RecipeSort.BY_NAME:
        result = first.name.toLowerCase().compareTo(second.name.toLowerCase());
      case RecipeSort.BY_EFFORT:
        return _compareNullable(
          first.effort,
          second.effort,
          ascending: ascending,
        );
      case RecipeSort.BY_INGREDIENT_COUNT:
        result = getIngredientCount(first.ingredients)
            .compareTo(getIngredientCount(second.ingredients));
      case RecipeSort.BY_LAST_MODIFIED:
        return _compareNullable(
          DateTime.tryParse(first.lastModified),
          DateTime.tryParse(second.lastModified),
          ascending: ascending,
        );
      case RecipeSort.BY_TOTAL_TIME:
        result = first.totalTime.compareTo(second.totalTime);
    }
    return ascending ? result : -result;
  });
  return recipes;
}

int _compareNullable<T extends Comparable<Object?>>(
  T? first,
  T? second, {
  required bool ascending,
}) {
  if (first == null && second == null) return 0;
  if (first == null) return 1;
  if (second == null) return -1;
  final result = first.compareTo(second);
  return ascending ? result : -result;
}
