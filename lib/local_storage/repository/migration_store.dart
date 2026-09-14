import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../models/enums.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../models/recipe_sort.dart';
import '../database.dart';
import 'draft_deletion_store.dart';
import 'drift_repository_context.dart';
import 'legacy_snapshot.dart';
import 'local_repository_contract.dart';
import 'recipe_store.dart';
import 'shopping_cart_store.dart';

class MigrationStore {
  MigrationStore(
    this._context,
    this._recipes,
    this._drafts,
    this._cart,
    this._reloadAll,
  );

  final DriftRepositoryContext _context;
  final RecipeStore _recipes;
  final DraftDeletionStore _drafts;
  final ShoppingCartStore _cart;
  final Future<void> Function() _reloadAll;

  Future<void> _initialize() async {
    await _context.initialize();
    await _reloadAll();
  }

  Future<bool> hasCompletedLegacyMigration() async {
    await _initialize();
    final row =
        await (_context.db.select(_context.db.storageMetadata)
              ..where((table) => table.key.equals('legacy_migration_complete')))
            .getSingleOrNull();
    return row?.value == '1';
  }

  Future<bool> hasAnyStoredData() async {
    await _initialize();
    final checks = <Future<Object?>>[
      (_context.db.select(
        _context.db.storedRecipes,
      )..limit(1)).getSingleOrNull(),
      (_context.db.select(
        _context.db.storedCategories,
      )..limit(1)).getSingleOrNull(),
      (_context.db.select(_context.db.storedTags)..limit(1)).getSingleOrNull(),
      (_context.db.select(
        _context.db.ingredientCatalogEntries,
      )..limit(1)).getSingleOrNull(),
      (_context.db.select(
        _context.db.nutritionCatalogEntries,
      )..limit(1)).getSingleOrNull(),
      (_context.db.select(
        _context.db.calendarEntries,
      )..limit(1)).getSingleOrNull(),
      (_context.db.select(
        _context.db.shoppingSources,
      )..limit(1)).getSingleOrNull(),
      (_context.db.select(
        _context.db.recipeDrafts,
      )..limit(1)).getSingleOrNull(),
      (_context.db.select(
        _context.db.deletionTombstones,
      )..limit(1)).getSingleOrNull(),
      (_context.db.select(
        _context.db.storageMetadata,
      )..limit(1)).getSingleOrNull(),
    ];
    return (await Future.wait(checks)).any((row) => row != null);
  }

  Future<bool> isFreshSeedPending() async {
    final storageKind = await (_context.db.select(
      _context.db.storageMetadata,
    )..where((row) => row.key.equals('storage_kind'))).getSingleOrNull();
    if (storageKind?.value != 'fresh_drift') return false;
    final seeded =
        await (_context.db.select(_context.db.storageMetadata)
              ..where((row) => row.key.equals('starter_seed_complete')))
            .getSingleOrNull();
    return seeded?.value != '1';
  }

  Future<void> markFreshSeedComplete() async {
    await _context.db
        .into(_context.db.storageMetadata)
        .insertOnConflictUpdate(
          const StorageMetadataCompanion(
            key: Value('starter_seed_complete'),
            value: Value('1'),
          ),
        );
  }

  Future<void> initializeFresh() async {
    await _initialize();
    await _context.db.transaction(() async {
      if (await (_context.db.select(
            _context.db.storedCategories,
          )..limit(1)).getSingleOrNull() ==
          null) {
        await _context.db
            .into(_context.db.storedCategories)
            .insert(
              StoredCategoriesCompanion.insert(
                name: noCategoryName,
                position: 0,
                sortKind: _sortName(RecipeSort.BY_NAME),
                isSystem: const Value(true),
              ),
            );
      }
      if (await (_context.db.select(
            _context.db.shoppingSources,
          )..limit(1)).getSingleOrNull() ==
          null) {
        await _context.db
            .into(_context.db.shoppingSources)
            .insert(
              ShoppingSourcesCompanion.insert(
                sourceKey: shoppingSummaryName,
                displayName: shoppingSummaryName,
                isSummary: const Value(true),
                position: 0,
              ),
            );
      }
      await _context.db
          .into(_context.db.storageMetadata)
          .insertOnConflictUpdate(
            const StorageMetadataCompanion(
              key: Value('legacy_migration_complete'),
              value: Value('1'),
            ),
          );
      await _drafts.writeDraft(
        newRecipeDraftSlot,
        Recipe(name: '', servings: null, vegetable: Vegetable.VEGETARIAN),
      );
      await _context.db
          .into(_context.db.storageMetadata)
          .insertOnConflictUpdate(
            const StorageMetadataCompanion(
              key: Value('storage_kind'),
              value: Value('fresh_drift'),
            ),
          );
    });
    await _reloadAll();
  }

  Future<void> importLegacySnapshot(LegacySnapshot snapshot) async {
    await _initialize();
    await _context.db.transaction(() async {
      await _clearApplicationTables();

      final categories = List<LegacyCategory>.from(snapshot.categories);
      if (!categories.any((entry) => entry.name == noCategoryName)) {
        categories.add(
          LegacyCategory(noCategoryName, RSort(RecipeSort.BY_NAME, true)),
        );
      }
      for (var index = 0; index < categories.length; index++) {
        final category = categories[index];
        await _context.db
            .into(_context.db.storedCategories)
            .insert(
              StoredCategoriesCompanion.insert(
                name: category.name,
                position: index,
                sortKind: _sortName(category.sort.sort),
                ascending: Value(category.sort.ascending ?? true),
                isSystem: Value(category.name == noCategoryName),
              ),
            );
      }

      for (var index = 0; index < snapshot.tags.length; index++) {
        final tag = snapshot.tags[index];
        await _context.db
            .into(_context.db.storedTags)
            .insert(
              StoredTagsCompanion.insert(
                name: tag.text,
                color: tag.number,
                position: index,
              ),
            );
      }
      for (var index = 0; index < snapshot.ingredientCatalog.length; index++) {
        await _context.db
            .into(_context.db.ingredientCatalogEntries)
            .insertOnConflictUpdate(
              IngredientCatalogEntriesCompanion.insert(
                name: snapshot.ingredientCatalog[index],
                position: index,
              ),
            );
      }
      for (var index = 0; index < snapshot.nutritionCatalog.length; index++) {
        await _context.db
            .into(_context.db.nutritionCatalogEntries)
            .insertOnConflictUpdate(
              NutritionCatalogEntriesCompanion.insert(
                name: snapshot.nutritionCatalog[index],
                position: index,
              ),
            );
      }

      for (final recipe in snapshot.recipes) {
        await _recipes.insertRecipeGraph(
          recipe.copyWith(
            isFavorite: snapshot.favoriteNames.contains(recipe.name),
          ),
        );
      }
      if (snapshot.newDraft != null) {
        await _drafts.writeDraft(newRecipeDraftSlot, snapshot.newDraft!);
      }
      if (snapshot.editingDraft != null) {
        await _drafts.writeDraft(
          editingRecipeDraftSlot,
          snapshot.editingDraft!,
        );
      }
      for (final entry in snapshot.calendar) {
        await _context.db
            .into(_context.db.calendarEntries)
            .insert(
              CalendarEntriesCompanion.insert(
                scheduledAt: entry.scheduledAt,
                recipeName: entry.recipeName,
                position: entry.position,
              ),
            );
      }
      await _cart.writeCart(
        snapshot.shoppingSources
            .map(
              (source) => ShoppingCartSource(
                source.key,
                source.displayName,
                List<CheckableIngredient>.from(source.items),
                isSummary: source.isSummary,
              ),
            )
            .toList(),
      );
      for (final entry in snapshot.deletions.entries) {
        await _context.db
            .into(_context.db.deletionTombstones)
            .insertOnConflictUpdate(
              DeletionTombstonesCompanion.insert(
                recipeName: entry.key,
                deletedAt: entry.value,
              ),
            );
      }
      for (final entry in snapshot.issues.entries) {
        await _context.db
            .into(_context.db.legacyMigrationIssues)
            .insertOnConflictUpdate(
              LegacyMigrationIssuesCompanion.insert(
                legacyKey: entry.key,
                errorCode: entry.value,
              ),
            );
      }
      for (final file in snapshot.backupFiles) {
        await _context.db
            .into(_context.db.legacyBackupFiles)
            .insertOnConflictUpdate(
              LegacyBackupFilesCompanion.insert(
                path: file.path,
                byteLength: file.byteLength,
                sha256Digest: file.sha256Digest,
              ),
            );
      }
      final now = DateTime.now().toUtc().toIso8601String();
      await _context.db
          .into(_context.db.storageMetadata)
          .insertOnConflictUpdate(
            StorageMetadataCompanion.insert(
              key: 'legacy_migrated_at',
              value: now,
            ),
          );
      await _context.db
          .into(_context.db.storageMetadata)
          .insertOnConflictUpdate(
            const StorageMetadataCompanion(
              key: Value('storage_kind'),
              value: Value('migrated_hive_2'),
            ),
          );

      final importedRows = await _context.db
          .select(_context.db.storedRecipes)
          .get();
      final importedNames = importedRows.map((row) => row.name).toSet();
      final expectedNames = snapshot.recipes
          .map((recipe) => recipe.name)
          .toSet();
      if (importedRows.length != snapshot.recipes.length ||
          importedNames.length != expectedNames.length ||
          !importedNames.containsAll(expectedNames)) {
        throw StateError('legacy_recipe_validation_failed');
      }
      final foreignKeyErrors = await _context.db
          .customSelect('PRAGMA foreign_key_check')
          .get();
      if (foreignKeyErrors.isNotEmpty) {
        throw StateError('legacy_foreign_key_validation_failed');
      }

      // Keep this as the transaction's final write. Termination at any earlier
      // point rolls back, leaving startup free to retry the Hive import.
      await _context.db
          .into(_context.db.storageMetadata)
          .insertOnConflictUpdate(
            const StorageMetadataCompanion(
              key: Value('legacy_migration_complete'),
              value: Value('1'),
            ),
          );
    });
    await _reloadAll();
  }

  Future<List<LegacyMigrationIssue>> unresolvedMigrationIssues() async {
    await _initialize();
    return (_context.db.select(
      _context.db.legacyMigrationIssues,
    )..where((table) => table.resolved.equals(false))).get();
  }

  Future<int> unresolvedMigrationIssueCount() async =>
      (await unresolvedMigrationIssues()).length;

  Future<List<MigrationIssueSummary>> migrationIssues() async =>
      (await unresolvedMigrationIssues())
          .map(
            (issue) => MigrationIssueSummary(issue.legacyKey, issue.errorCode),
          )
          .toList();

  Future<bool> recoverLegacyRecipe(String legacyKey, Recipe recipe) async {
    if (await _recipes.doesRecipeExist(recipe.name)) return false;
    await _context.db.transaction(() async {
      await _recipes.insertRecipeGraph(recipe);
      await (_context.db.update(_context.db.legacyMigrationIssues)
            ..where((row) => row.legacyKey.equals(legacyKey)))
          .write(const LegacyMigrationIssuesCompanion(resolved: Value(true)));
    });
    await _reloadAll();
    return true;
  }

  Future<void> cleanupLegacyFilesIfDue() async {
    if (!await hasCompletedLegacyMigration()) return;
    final migrated = await (_context.db.select(
      _context.db.storageMetadata,
    )..where((row) => row.key.equals('legacy_migrated_at'))).getSingleOrNull();
    final migratedAt = DateTime.tryParse(migrated?.value ?? '');
    if (migratedAt == null ||
        DateTime.now().toUtc().isBefore(
          migratedAt.add(const Duration(days: 90)),
        )) {
      return;
    }
    if ((await unresolvedMigrationIssues()).isNotEmpty) return;
    final quickCheck = await _context.db
        .customSelect('PRAGMA quick_check')
        .getSingle();
    if (quickCheck.data.values.first != 'ok') return;

    final documents = await getApplicationDocumentsDirectory();
    final root = p.normalize(p.absolute(documents.path));
    final files = await _context.db.select(_context.db.legacyBackupFiles).get();
    for (final entry in files) {
      final target = p.normalize(p.absolute(entry.path));
      if (!p.isWithin(root, target)) continue;
      final file = File(target);
      if (file.existsSync()) await file.delete();
    }
    final backupDirectory = Directory(p.join(root, 'legacy_hive_backup_v1'));
    if (backupDirectory.existsSync() && backupDirectory.listSync().isEmpty) {
      await backupDirectory.delete();
    }
    await _context.db
        .into(_context.db.storageMetadata)
        .insertOnConflictUpdate(
          StorageMetadataCompanion.insert(
            key: 'legacy_cleanup_completed_at',
            value: DateTime.now().toUtc().toIso8601String(),
          ),
        );
  }

  Future<void> _clearApplicationTables() async {
    await _context.db.delete(_context.db.shoppingItems).go();
    await _context.db.delete(_context.db.shoppingSources).go();
    await _context.db.delete(_context.db.calendarEntries).go();
    await _context.db.delete(_context.db.recipeDrafts).go();
    await _context.db.delete(_context.db.deletionTombstones).go();
    await _context.db.delete(_context.db.storedRecipes).go();
    await _context.db.delete(_context.db.storedCategories).go();
    await _context.db.delete(_context.db.storedTags).go();
    await _context.db.delete(_context.db.ingredientCatalogEntries).go();
    await _context.db.delete(_context.db.nutritionCatalogEntries).go();
    await _context.db.delete(_context.db.legacyMigrationIssues).go();
    await _context.db.delete(_context.db.legacyBackupFiles).go();
    await _context.db.delete(_context.db.storageMetadata).go();
  }

  String _sortName(RecipeSort value) => value.name;
}
