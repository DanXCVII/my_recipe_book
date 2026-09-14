import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../models/recipe_sort.dart';
import '../../models/string_int_tuple.dart';

class LegacyCategory {
  const LegacyCategory(this.name, this.sort);
  final String name;
  final RSort sort;
}

class LegacyShoppingSource {
  const LegacyShoppingSource(
    this.key,
    this.displayName,
    this.items, {
    this.isSummary = false,
  });
  final String key;
  final String displayName;
  final List<CheckableIngredient> items;
  final bool isSummary;
}

class LegacyCalendarValue {
  const LegacyCalendarValue(this.scheduledAt, this.recipeName, this.position);
  final String scheduledAt;
  final String recipeName;
  final int position;
}

class LegacyBackupValue {
  const LegacyBackupValue(this.path, this.byteLength, this.sha256Digest);
  final String path;
  final int byteLength;
  final String sha256Digest;
}

class LegacySnapshot {
  LegacySnapshot({
    required this.recipes,
    required this.favoriteNames,
    required this.categories,
    required this.tags,
    required this.ingredientCatalog,
    required this.nutritionCatalog,
    required this.calendar,
    required this.shoppingSources,
    required this.deletions,
    required this.backupFiles,
    required this.issues,
    this.repairedEntries = 0,
    this.newDraft,
    this.editingDraft,
  });

  final List<Recipe> recipes;
  final Set<String> favoriteNames;
  final List<LegacyCategory> categories;
  final List<StringIntTuple> tags;
  final List<String> ingredientCatalog;
  final List<String> nutritionCatalog;
  final List<LegacyCalendarValue> calendar;
  final List<LegacyShoppingSource> shoppingSources;
  final Map<String, String> deletions;
  final List<LegacyBackupValue> backupFiles;
  final Map<String, String> issues;
  final int repairedEntries;
  final Recipe? newDraft;
  final Recipe? editingDraft;
}
