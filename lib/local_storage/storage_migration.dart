import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/ingredient.dart';
import '../models/enums.dart';
import '../models/recipe.dart';
import '../models/recipe_sort.dart';
import '../models/string_int_tuple.dart';
import 'hive.dart' as legacy;
import 'local_repository.dart';
import '../services/migration_monitor.dart';

enum StorageMigrationStage {
  opening,
  backingUp,
  readingLegacyData,
  writingDriftData,
  validating,
  ready,
}

class StorageMigrationProgress {
  const StorageMigrationProgress(
    this.stage, {
    this.current = 0,
    this.total = 0,
  });
  final StorageMigrationStage stage;
  final int current;
  final int total;
}

class StorageMigrationResult {
  const StorageMigrationResult({
    required this.wasMigrated,
    required this.isFreshInstall,
    required this.importedRecipes,
    required this.repairedEntries,
    required this.skippedEntries,
    this.migrationVersion = DriftRepository.currentMigrationVersion,
    this.schemaVersion = DriftRepository.currentSchemaVersion,
    this.issueCodeCounts = const {},
  });

  final bool wasMigrated;
  final bool isFreshInstall;
  final int importedRecipes;
  final int repairedEntries;
  final int skippedEntries;
  final int migrationVersion;
  final int schemaVersion;
  final Map<String, int> issueCodeCounts;

  bool get hasWarnings => skippedEntries > 0;
}

class StorageMigrationException implements Exception {
  const StorageMigrationException(this.code, [this.cause]);
  final String code;
  final Object? cause;

  @override
  String toString() => 'StorageMigrationException($code)';
}

class StorageMigrationCoordinator {
  StorageMigrationCoordinator(this.repository, this.monitor);

  final DriftRepository repository;
  final MigrationMonitor monitor;

  Future<int> retrySkippedRecipes() async {
    final issues = await repository.unresolvedMigrationIssues();
    if (issues.isEmpty) return 0;
    var recovered = 0;
    try {
      final provider = await legacy.openLegacyHive();
      for (final issue in issues.where(
        (entry) => entry.errorCode == 'unreadable_recipe',
      )) {
        try {
          final recipe = await provider.lazyBoxRecipes.get(issue.legacyKey);
          if (recipe != null &&
              await repository.recoverLegacyRecipe(
                issue.legacyKey,
                recipe.copyWith(
                  isFavorite: provider.boxFavorites.values.contains(
                    recipe.name,
                  ),
                ),
              )) {
            recovered++;
          }
        } catch (_) {}
      }
    } finally {
      await Hive.close();
    }
    final remaining = await repository.unresolvedMigrationIssueCount();
    await monitor.retried(recovered, remaining);
    return recovered;
  }

  Future<StorageMigrationResult> initialize({
    void Function(StorageMigrationProgress progress)? onProgress,
  }) async {
    final stopwatch = Stopwatch()..start();
    onProgress?.call(
      const StorageMigrationProgress(StorageMigrationStage.opening),
    );
    try {
      await repository.initialize();
      if (await repository.hasCompletedLegacyMigration()) {
        await repository.cleanupLegacyFilesIfDue();
        final issues = await repository.unresolvedMigrationIssues();
        return StorageMigrationResult(
          wasMigrated: false,
          isFreshInstall: await repository.isFreshSeedPending(),
          importedRecipes: repository.getRecipeNames().length,
          repairedEntries: 0,
          skippedEntries: issues.length,
          issueCodeCounts: _issueCounts(issues.map((issue) => issue.errorCode)),
        );
      }

      final legacyDirectory = await getApplicationDocumentsDirectory();
      final legacyFiles = await _findLegacyFiles(legacyDirectory);
      if (legacyFiles.isEmpty) {
        if (await repository.hasAnyStoredData()) {
          throw const StorageMigrationException('unmarked_drift_data');
        }
        await repository.initializeFresh();
        return const StorageMigrationResult(
          wasMigrated: false,
          isFreshInstall: true,
          importedRecipes: 0,
          repairedEntries: 0,
          skippedEntries: 0,
        );
      }

      await monitor.started();
      onProgress?.call(
        StorageMigrationProgress(
          StorageMigrationStage.backingUp,
          total: legacyFiles.length,
        ),
      );
      final backups = await _backupLegacyFiles(
        legacyDirectory,
        legacyFiles,
        onProgress,
      );

      onProgress?.call(
        const StorageMigrationProgress(StorageMigrationStage.readingLegacyData),
      );
      final provider = await legacy.openLegacyHive();
      final snapshot = await _readLegacySnapshot(provider, backups, onProgress);

      onProgress?.call(
        StorageMigrationProgress(
          StorageMigrationStage.writingDriftData,
          total: snapshot.recipes.length,
        ),
      );
      await repository.importLegacySnapshot(snapshot);
      await Hive.close();

      onProgress?.call(
        const StorageMigrationProgress(StorageMigrationStage.validating),
      );
      final imported = repository.getRecipeNames().length;
      if (imported != snapshot.recipes.length) {
        throw StorageMigrationException(
          'recipe_count_mismatch',
          '$imported/${snapshot.recipes.length}',
        );
      }
      final result = StorageMigrationResult(
        wasMigrated: true,
        isFreshInstall: false,
        importedRecipes: imported,
        repairedEntries: snapshot.repairedEntries,
        skippedEntries: snapshot.issues.length,
        issueCodeCounts: _issueCounts(snapshot.issues.values),
      );
      await monitor.completed(
        duration: stopwatch.elapsed,
        importedRecipes: result.importedRecipes,
        repairedEntries: result.repairedEntries,
        skippedEntries: result.skippedEntries,
      );
      onProgress?.call(
        const StorageMigrationProgress(StorageMigrationStage.ready),
      );
      return result;
    } catch (error, stackTrace) {
      try {
        await Hive.close();
      } catch (_) {}
      final code = error is StorageMigrationException
          ? error.code
          : 'unexpected_migration_failure';
      await monitor.failed(code, stackTrace);
      if (error is StorageMigrationException) rethrow;
      throw StorageMigrationException(code, error);
    }
  }

  Map<String, int> _issueCounts(Iterable<String> codes) {
    final result = <String, int>{};
    for (final code in codes) {
      result[code] = (result[code] ?? 0) + 1;
    }
    return Map.unmodifiable(result);
  }

  Future<List<File>> _findLegacyFiles(Directory directory) async {
    if (!directory.existsSync()) return [];
    final knownBoxNames = <String>{
      legacy.BoxNames.recipes,
      legacy.BoxNames.keyString,
      legacy.BoxNames.recipeNames,
      legacy.BoxNames.tmpRecipe,
      legacy.BoxNames.ratings,
      legacy.BoxNames.favorites,
      legacy.BoxNames.ingredientNames,
      legacy.BoxNames.order,
      legacy.BoxNames.recipeSort,
      legacy.BoxNames.shoppingCart,
      legacy.BoxNames.recipeCategories,
      legacy.BoxNames.recipeTags,
      legacy.BoxNames.recipeTagsList,
      legacy.BoxNames.recipeCalendar,
      legacy.BoxNames.syncDeletionRecipes,
      legacy.BoxNames.vegetarian,
      legacy.BoxNames.vegan,
      legacy.BoxNames.nonVegetarain,
    }.map((name) => name.toLowerCase()).toSet();
    final files = <File>[];
    await for (final entity in directory.list(followLinks: false)) {
      if (entity is! File) continue;
      final basename = p.basename(entity.path).toLowerCase();
      final isHive = basename.endsWith('.hive');
      final isLock = basename.endsWith('.lock');
      if (!isHive && !isLock) continue;
      const extensionLength = 5;
      final boxName = basename.substring(0, basename.length - extensionLength);
      if (knownBoxNames.contains(boxName)) files.add(entity);
    }
    return files.any((file) => file.path.endsWith('.hive')) ? files : [];
  }

  Future<List<LegacyBackupValue>> _backupLegacyFiles(
    Directory documents,
    List<File> files,
    void Function(StorageMigrationProgress progress)? onProgress,
  ) async {
    final backupDirectory = Directory(
      p.join(documents.path, 'legacy_hive_backup_v1'),
    );
    await backupDirectory.create(recursive: true);
    final result = <LegacyBackupValue>[];
    for (var index = 0; index < files.length; index++) {
      final source = files[index];
      final destination = File(
        p.join(backupDirectory.path, p.basename(source.path)),
      );
      if (!destination.existsSync()) await source.copy(destination.path);
      final bytes = await destination.readAsBytes();
      final digest = sha256.convert(bytes).toString();
      result
        ..add(LegacyBackupValue(source.path, source.lengthSync(), digest))
        ..add(LegacyBackupValue(destination.path, bytes.length, digest));
      onProgress?.call(
        StorageMigrationProgress(
          StorageMigrationStage.backingUp,
          current: index + 1,
          total: files.length,
        ),
      );
    }
    return result;
  }

  Future<LegacySnapshot> _readLegacySnapshot(
    legacy.LegacyHiveReader provider,
    List<LegacyBackupValue> backups,
    void Function(StorageMigrationProgress progress)? onProgress,
  ) async {
    final issues = <String, String>{};
    final recipes = <Recipe>[];
    final recipeNames = <String>{};
    var repairedEntries = 0;
    final recipeKeys = provider.lazyBoxRecipes.keys.toList();
    for (var index = 0; index < recipeKeys.length; index++) {
      final key = recipeKeys[index];
      try {
        final recipe = await provider.lazyBoxRecipes.get(key);
        if (recipe != null) {
          if (recipeNames.add(recipe.name)) {
            recipes.add(recipe);
          } else {
            issues[key.toString()] = 'duplicate_recipe_name';
          }
        }
      } catch (_) {
        issues[key.toString()] = 'unreadable_recipe';
      }
      onProgress?.call(
        StorageMigrationProgress(
          StorageMigrationStage.readingLegacyData,
          current: index + 1,
          total: recipeKeys.length,
        ),
      );
    }

    final favoriteNames = provider.boxFavorites.values.toSet();
    final categories = <LegacyCategory>[];
    final categoryNames = <String>{};
    final categoryKeys = List<String>.from(
      provider.boxOrder.get('categories') ?? const <String>[],
    );
    for (final key in categoryKeys) {
      final name = provider.boxKeyString.get(key);
      if (name == null) {
        issues['category:$key'] = 'missing_category_name';
        continue;
      }
      if (!categoryNames.add(name)) {
        repairedEntries++;
        continue;
      }
      final sort =
          provider.boxRecipeSort.get(key) ?? RSort(RecipeSort.BY_NAME, true);
      categories.add(LegacyCategory(name, sort));
    }

    final tagsByName = LinkedHashMap<String, StringIntTuple>();
    for (final tag in provider.boxRecipeTags.values) {
      if (tagsByName.containsKey(tag.text)) repairedEntries++;
      tagsByName[tag.text] = tag;
    }
    for (final recipe in recipes) {
      for (final category in recipe.categories) {
        if (categoryNames.add(category)) {
          final systemIndex = categories.indexWhere(
            (entry) => entry.name == noCategoryName,
          );
          final repaired = LegacyCategory(
            category,
            RSort(RecipeSort.BY_NAME, true),
          );
          if (systemIndex < 0) {
            categories.add(repaired);
          } else {
            categories.insert(systemIndex, repaired);
          }
          repairedEntries++;
        }
      }
      for (final tag in recipe.tags) {
        final indexedTag = tagsByName[tag.text];
        if (indexedTag == null || indexedTag.number != tag.number) {
          tagsByName[tag.text] = tag;
          repairedEntries++;
        }
      }
    }
    final tags = tagsByName.values.toList();
    final ingredientValues = provider.boxIngredientNames.values.toList();
    final ingredientCatalog = LinkedHashSet<String>.from(ingredientValues);
    repairedEntries += ingredientValues.length - ingredientCatalog.length;
    final nutritionValues = List<String>.from(
      provider.boxOrder.get('nutritions') ?? const <String>[],
    );
    final nutritionCatalog = LinkedHashSet<String>.from(nutritionValues);
    repairedEntries += nutritionValues.length - nutritionCatalog.length;
    for (final recipe in recipes) {
      for (final ingredient in recipe.ingredients.expand((group) => group)) {
        if (ingredientCatalog.add(ingredient.name)) repairedEntries++;
      }
      for (final nutrition in recipe.nutritions) {
        if (nutritionCatalog.add(nutrition.name)) repairedEntries++;
      }
    }

    final indexedRecipeNames = provider.boxRecipeNames.values.toSet();
    final canonicalRecipeNames = recipes.map((recipe) => recipe.name).toSet();
    repairedEntries += canonicalRecipeNames
        .difference(indexedRecipeNames)
        .length;
    repairedEntries += indexedRecipeNames
        .difference(canonicalRecipeNames)
        .length;

    final calendar = <LegacyCalendarValue>[];
    for (final keyValue in provider.boxRecipeCalendar.keys) {
      final key = keyValue.toString();
      final separator = key.lastIndexOf('#');
      final recipeName = provider.boxRecipeCalendar.get(keyValue);
      if (separator <= 0 ||
          recipeName == null ||
          DateTime.tryParse(key.substring(0, separator)) == null) {
        issues['calendar:$key'] = 'invalid_calendar_entry';
        continue;
      }
      calendar.add(
        LegacyCalendarValue(
          key.substring(0, separator),
          recipeName,
          int.tryParse(key.substring(separator + 1)) ?? calendar.length,
        ),
      );
    }

    final shoppingByKey = <String, LegacyShoppingSource>{};
    for (final keyValue in provider.boxShoppingCart.keys) {
      final key = keyValue.toString();
      final isSummary = key == shoppingSummaryName;
      String displayName = isSummary
          ? shoppingSummaryName
          : provider.boxRecipeNames.get(key) ??
                provider.boxKeyString.get(key) ??
                key;
      final items =
          provider.boxShoppingCart
              .get(keyValue)
              ?.cast<CheckableIngredient>()
              .toList() ??
          <CheckableIngredient>[];
      final source = LegacyShoppingSource(
        displayName,
        displayName,
        items,
        isSummary: isSummary,
      );
      final existing = shoppingByKey[displayName];
      if (existing == null) {
        shoppingByKey[displayName] = source;
      } else {
        repairedEntries++;
        shoppingByKey[displayName] = LegacyShoppingSource(
          displayName,
          displayName,
          [...existing.items, ...items],
          isSummary: existing.isSummary || isSummary,
        );
      }
    }

    final deletions = <String, String>{};
    for (final value in provider.boxSyncDeletionRecipes.values) {
      deletions[value.name] = value.value;
    }

    return LegacySnapshot(
      recipes: recipes,
      favoriteNames: favoriteNames,
      categories: categories,
      tags: tags,
      ingredientCatalog: ingredientCatalog.toList(),
      nutritionCatalog: nutritionCatalog.toList(),
      calendar: calendar,
      shoppingSources: shoppingByKey.values.toList(),
      deletions: deletions,
      backupFiles: backups,
      issues: issues,
      repairedEntries: repairedEntries,
      newDraft: provider.boxTmpRecipe.get(legacy.tmpRecipeKey),
      editingDraft: provider.boxTmpRecipe.get(legacy.tmpEditingRecipeKey),
    );
  }
}
