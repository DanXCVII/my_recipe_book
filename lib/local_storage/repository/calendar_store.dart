import 'package:drift/drift.dart';

import '../database.dart';
import 'drift_repository_context.dart';

class CalendarStore {
  CalendarStore(this._context);

  final DriftRepositoryContext _context;

  Future<void> addRecipeToCalendar(DateTime date, String recipeName) async {
    final sameDate = await (_context.db.select(
      _context.db.calendarEntries,
    )..where((row) => row.scheduledAt.equals(date.toIso8601String()))).get();
    await _context.db
        .into(_context.db.calendarEntries)
        .insert(
          CalendarEntriesCompanion.insert(
            scheduledAt: date.toIso8601String(),
            recipeName: recipeName,
            position: sameDate.length,
          ),
        );
  }

  Future<void> removeRecipeFromCalendar(String recipeName) async {
    await (_context.db.delete(
      _context.db.calendarEntries,
    )..where((row) => row.recipeName.equals(recipeName))).go();
  }

  Future<void> removeRecipeFromDateCalendar(
    DateTime date,
    String recipeName,
  ) async {
    final row =
        await (_context.db.select(_context.db.calendarEntries)
              ..where(
                (entry) =>
                    entry.scheduledAt.equals(date.toIso8601String()) &
                    entry.recipeName.equals(recipeName),
              )
              ..orderBy([(entry) => OrderingTerm.asc(entry.position)])
              ..limit(1))
            .getSingleOrNull();
    if (row != null) {
      await (_context.db.delete(
        _context.db.calendarEntries,
      )..where((entry) => entry.id.equals(row.id))).go();
    }
  }

  Future<Map<DateTime, List<String>>> getRecipeCalendar() async {
    final rows =
        await (_context.db.select(_context.db.calendarEntries)..orderBy([
              (row) => OrderingTerm.asc(row.scheduledAt),
              (row) => OrderingTerm.asc(row.position),
            ]))
            .get();
    final result = <DateTime, List<String>>{};
    for (final row in rows) {
      final date = DateTime.parse(row.scheduledAt);
      result.putIfAbsent(date, () => []).add(row.recipeName);
    }
    return result;
  }
}
