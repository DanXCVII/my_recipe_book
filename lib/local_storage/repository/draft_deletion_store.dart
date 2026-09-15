import 'dart:convert';

import '../../models/recipe.dart';
import '../database.dart';
import 'drift_repository_context.dart';
import 'local_repository_contract.dart';

class DraftDeletionStore {
  DraftDeletionStore(this._context, this._reloadAll);

  final DriftRepositoryContext _context;
  final Future<void> Function() _reloadAll;
  Map<String, DateTime> _deletions = {};
  Map<String, Recipe> _drafts = {};

  bool wasDeletedBefore(String recipeName) =>
      _deletions.containsKey(recipeName);

  DateTime? getDeletionDate(String recipeName) => _deletions[recipeName];

  Map<String, DateTime> getDeletions() => Map.unmodifiable(_deletions);

  Future<void> clearDeletions() async {
    await _context.db.delete(_context.db.deletionTombstones).go();
    await _reloadAll();
  }

  Future<void> saveTmpRecipe(Recipe recipe) async {
    await writeDraft(newRecipeDraftSlot, recipe);
    await _reloadAll();
  }

  Future<void> saveTmpEditingRecipe(Recipe recipe) async {
    await writeDraft(editingRecipeDraftSlot, recipe);
    await _reloadAll();
  }

  Future<void> writeDraft(String slot, Recipe recipe) async {
    final map = Map<String, dynamic>.from(recipe.toMap())
      ..['_isFavorite'] = recipe.isFavorite
      ..['_stepTitlesWasNull'] = recipe.stepTitles == null;
    await _context.db
        .into(_context.db.recipeDrafts)
        .insertOnConflictUpdate(
          RecipeDraftsCompanion.insert(
            slot: slot,
            codecVersion: 2,
            payload: jsonEncode(map),
          ),
        );
  }

  Recipe _decodeDraft(String payload) {
    final map = Map<String, dynamic>.from(jsonDecode(payload) as Map);
    final recipe = Recipe.fromMap(map, keepDateTime: true);
    return recipe.copyWith(isFavorite: map['_isFavorite'] == true);
  }

  Recipe? getTmpRecipe() => _drafts[newRecipeDraftSlot];

  Recipe? getTmpEditingRecipe() => _drafts[editingRecipeDraftSlot];

  Future<void> deleteTmpEditingRecipe() async {
    await (_context.db.delete(
      _context.db.recipeDrafts,
    )..where((row) => row.slot.equals(editingRecipeDraftSlot))).go();
    await _reloadAll();
  }

  Future<void> resetTmpRecipe() =>
      saveTmpRecipe(Recipe(name: '', servings: null));

  Future<void> reload() async {
    _deletions = {};
    for (final row
        in await _context.db.select(_context.db.deletionTombstones).get()) {
      final parsed = DateTime.tryParse(row.deletedAt);
      if (parsed != null) _deletions[row.recipeName] = parsed;
    }
    _drafts = {};
    for (final row
        in await _context.db.select(_context.db.recipeDrafts).get()) {
      try {
        _drafts[row.slot] = _decodeDraft(row.payload);
      } catch (_) {}
    }
  }
}
