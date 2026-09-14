import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../local_storage/local_repository.dart';

class MigrationMonitor {
  MigrationMonitor._(this._enabled);

  final bool _enabled;

  static Future<MigrationMonitor> initialize() async {
    try {
      await Firebase.initializeApp();
      final packageInfo = await PackageInfo.fromPlatform();
      await FirebaseCrashlytics.instance.setCustomKey(
        'migration_version',
        DriftRepository.currentMigrationVersion,
      );
      await FirebaseCrashlytics.instance.setCustomKey(
        'storage_schema_version',
        DriftRepository.currentSchemaVersion,
      );
      await FirebaseCrashlytics.instance.setCustomKey(
        'app_version',
        packageInfo.version,
      );
      await FirebaseCrashlytics.instance.setCustomKey(
        'app_build',
        packageInfo.buildNumber,
      );
      await FirebaseCrashlytics.instance.setCustomKey(
        'platform',
        defaultTargetPlatform.name,
      );
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      return MigrationMonitor._(true);
    } catch (error) {
      debugPrint(
        'Crash reporting is disabled until Firebase is configured: $error',
      );
      return MigrationMonitor._(false);
    }
  }

  Future<void> started() => _event('storage_migration_started');

  Future<void> retried(int recovered, int remaining) async {
    if (!_enabled) return;
    await FirebaseCrashlytics.instance.setCustomKey(
      'migration_retry_recovered',
      recovered,
    );
    await FirebaseCrashlytics.instance.setCustomKey(
      'migration_retry_remaining',
      remaining,
    );
    await _event('storage_migration_retried');
  }

  Future<void> completed({
    required Duration duration,
    required int importedRecipes,
    required int repairedEntries,
    required int skippedEntries,
  }) async {
    if (!_enabled) return;
    await FirebaseCrashlytics.instance.setCustomKey(
      'migration_duration_ms',
      duration.inMilliseconds,
    );
    await FirebaseCrashlytics.instance.setCustomKey(
      'migration_imported_recipes',
      importedRecipes,
    );
    await FirebaseCrashlytics.instance.setCustomKey(
      'migration_repaired_entries',
      repairedEntries,
    );
    await FirebaseCrashlytics.instance.setCustomKey(
      'migration_skipped_entries',
      skippedEntries,
    );
    await _event(
      skippedEntries == 0
          ? 'storage_migration_completed'
          : 'storage_migration_completed_with_warning',
    );
  }

  Future<void> failed(String code, StackTrace stackTrace) async {
    if (!_enabled) return;
    await FirebaseCrashlytics.instance.setCustomKey(
      'migration_outcome',
      'storage_migration_failed',
    );
    await FirebaseCrashlytics.instance.setCustomKey(
      'migration_error_code',
      code,
    );
    await FirebaseCrashlytics.instance.recordError(
      StateError('Storage migration failed: $code'),
      stackTrace,
      reason: 'storage_migration_failed',
      fatal: false,
    );
  }

  Future<void> _event(String code) async {
    if (!_enabled) return;
    await FirebaseCrashlytics.instance.setCustomKey('migration_outcome', code);
    await FirebaseCrashlytics.instance.log(code);
    await FirebaseCrashlytics.instance.recordError(
      StateError(code),
      StackTrace.current,
      reason: code,
      fatal: false,
    );
  }
}
