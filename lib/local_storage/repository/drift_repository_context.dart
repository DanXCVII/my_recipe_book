import '../database.dart';

class DriftRepositoryContext {
  DriftRepositoryContext([AppDatabase? database]) : _database = database;

  AppDatabase? _database;

  AppDatabase get db => _database!;

  Future<void> initialize() async {
    _database ??= await AppDatabase.open();
  }
}
