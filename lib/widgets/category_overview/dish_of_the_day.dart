import '../../models/recipe.dart';
import '../../models/tuple.dart';

/// Returns one stable recipe for the user's local calendar day.
///
/// Recipes may occur in multiple category sections, so names are de-duplicated
/// before a deterministic sort and day-based selection are applied.
Recipe? selectDishOfTheDay(
  Iterable<Tuple2<String, List<Recipe>>> sections,
  DateTime localDate,
) {
  final recipesByName = <String, Recipe>{};
  for (final section in sections) {
    for (final recipe in section.item2) {
      recipesByName.putIfAbsent(recipe.name, () => recipe);
    }
  }

  final recipes = recipesByName.values.toList(growable: false)
    ..sort((a, b) {
      final normalized = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      return normalized == 0 ? a.name.compareTo(b.name) : normalized;
    });
  if (recipes.isEmpty) return null;

  // Constructing UTC from the local date parts keeps daylight-saving changes
  // from shifting the day index while still following the user's calendar.
  final dayIndex =
      DateTime.utc(
        localDate.year,
        localDate.month,
        localDate.day,
      ).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;
  return recipes[dayIndex % recipes.length];
}
