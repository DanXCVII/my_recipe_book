import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@TableIndex(name: 'stored_recipes_favorite', columns: {#isFavorite})
@TableIndex(name: 'stored_recipes_rating', columns: {#rating})
@TableIndex(name: 'stored_recipes_vegetable', columns: {#vegetable})
class StoredRecipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get imagePath => text()();
  TextColumn get imagePreviewPath => text()();
  RealColumn get preparationTime => real()();
  RealColumn get cookingTime => real()();
  RealColumn get totalTime => real()();
  RealColumn get servings => real().nullable()();
  TextColumn get servingName => text().nullable()();
  TextColumn get vegetable => text()();
  TextColumn get notes => text()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  IntColumn get effort => integer().nullable()();
  TextColumn get lastModified => text()();
  IntColumn get rating => integer().nullable()();
  TextColumn get source => text().nullable()();
  BoolColumn get hasStepTitles => boolean()();
}

class StoredCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  IntColumn get position => integer()();
  TextColumn get sortKind => text()();
  BoolColumn get ascending => boolean().withDefault(const Constant(true))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
}

@TableIndex(name: 'stored_recipe_categories_category', columns: {#categoryId})
@TableIndex(name: 'stored_recipe_categories_recipe', columns: {#recipeId})
class StoredRecipeCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId =>
      integer().references(StoredRecipes, #id, onDelete: KeyAction.cascade)();
  IntColumn get categoryId => integer().references(
    StoredCategories,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get position => integer()();
}

class StoredTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  IntColumn get color => integer()();
  IntColumn get position => integer()();
}

@TableIndex(name: 'stored_recipe_tags_tag', columns: {#tagId})
@TableIndex(name: 'stored_recipe_tags_recipe', columns: {#recipeId})
class StoredRecipeTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId =>
      integer().references(StoredRecipes, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId =>
      integer().references(StoredTags, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
}

class StoredIngredientGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId =>
      integer().references(StoredRecipes, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  BoolColumn get hasIngredientGroup => boolean()();
  BoolColumn get hasGlossary => boolean()();
  TextColumn get glossary => text().nullable()();
}

class StoredIngredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer().references(
    StoredIngredientGroups,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get position => integer()();
  TextColumn get name => text()();
  RealColumn get amount => real().nullable()();
  TextColumn get unit => text().nullable()();
}

class StoredNutritions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId =>
      integer().references(StoredRecipes, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get name => text()();
  TextColumn get amountUnit => text()();
}

class StoredStepGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId =>
      integer().references(StoredRecipes, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  BoolColumn get hasInstruction => boolean()();
  TextColumn get instruction => text().nullable()();
  BoolColumn get hasTitle => boolean()();
  TextColumn get title => text().nullable()();
  BoolColumn get hasImageGroup => boolean()();
}

class StoredStepImages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer().references(
    StoredStepGroups,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get position => integer()();
  TextColumn get path => text()();
}

class IngredientCatalogEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  IntColumn get position => integer()();
}

class NutritionCatalogEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  IntColumn get position => integer()();
}

@TableIndex(name: 'calendar_entries_scheduled_at', columns: {#scheduledAt})
class CalendarEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get scheduledAt => text()();
  TextColumn get recipeName => text()();
  IntColumn get position => integer()();
}

class ShoppingSources extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sourceKey => text().unique()();
  TextColumn get displayName => text()();
  BoolColumn get isSummary => boolean().withDefault(const Constant(false))();
  IntColumn get position => integer()();
}

class ShoppingItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sourceId =>
      integer().references(ShoppingSources, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get name => text()();
  RealColumn get amount => real().nullable()();
  TextColumn get unit => text().nullable()();
  BoolColumn get checked => boolean()();
}

class RecipeDrafts extends Table {
  TextColumn get slot => text()();
  IntColumn get codecVersion => integer()();
  TextColumn get payload => text()();

  @override
  Set<Column<Object>> get primaryKey => {slot};
}

class DeletionTombstones extends Table {
  TextColumn get recipeName => text()();
  TextColumn get deletedAt => text()();

  @override
  Set<Column<Object>> get primaryKey => {recipeName};
}

class StorageMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class LegacyMigrationIssues extends Table {
  TextColumn get legacyKey => text()();
  TextColumn get errorCode => text()();
  BoolColumn get resolved => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {legacyKey};
}

class LegacyBackupFiles extends Table {
  TextColumn get path => text()();
  IntColumn get byteLength => integer()();
  TextColumn get sha256Digest => text()();

  @override
  Set<Column<Object>> get primaryKey => {path};
}

@DriftDatabase(
  tables: [
    StoredRecipes,
    StoredCategories,
    StoredRecipeCategories,
    StoredTags,
    StoredRecipeTags,
    StoredIngredientGroups,
    StoredIngredients,
    StoredNutritions,
    StoredStepGroups,
    StoredStepImages,
    IngredientCatalogEntries,
    NutritionCatalogEntries,
    CalendarEntries,
    ShoppingSources,
    ShoppingItems,
    RecipeDrafts,
    DeletionTombstones,
    StorageMetadata,
    LegacyMigrationIssues,
    LegacyBackupFiles,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  static Future<AppDatabase> open() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'my_recipe_book.sqlite'));
    return AppDatabase(NativeDatabase.createInBackground(file));
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
