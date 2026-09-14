# Hive-to-Drift release checklist

The app now uses Drift for normal storage and keeps Hive CE only as a legacy
reader. Do not remove the legacy adapters or change their type IDs while a
pre-Drift build can still upgrade directly to the current release.

## Firebase prerequisites

- Keep the Firebase project on the Spark plan; Crashlytics does not require a
  paid plan.
- Android is connected through `android/app/google-services.json` for
  `com.release.my_recipe_book`.
- Before an iOS beta, register the final App Store bundle identifier in the
  same Firebase project and run `flutterfire configure` (or add the generated
  `GoogleService-Info.plist` and Xcode configuration manually).
- Make a release build for each platform and verify a forced non-fatal test
  event arrives in Crashlytics before starting migration testing.

Migration telemetry must remain aggregate-only. The implementation records
migration/schema/build versions, platform, duration, counts, and sanitized
error codes. It must not record recipe names, ingredients, paths, timestamps,
or serialized records.

## Fixture and interruption matrix

Run the migration suite with Hive 2.2.3 fixtures covering all deployed adapter
fields, Unicode and case-sensitive names, nulls, empty and uneven nested lists,
custom category/nutrition order, favorite-box disagreement, tag colors,
calendar duplicate indices above nine, cart summary/manual groups, both drafts,
and deletion tombstones.

For each fixture, compare repository-level snapshots before and after migration.
Also terminate the app during backup, legacy reads, and the Drift transaction.
Every restart must either retry from Hive or find the committed completion
marker; it must never expose partial Drift state.

Required device runs:

- Android internal build, small and large datasets.
- iOS TestFlight internal build, small and large datasets.
- Direct upgrade from every still-supported pre-Drift store build.
- One legacy device and one Drift device syncing updates, renames, deletions,
  and timestamp conflicts through Google Drive.
- A corrupted canonical recipe: readable data enters the app, the recovery
  notice remains visible, retry does not overwrite a same-name Drift recipe,
  and legacy files remain present.
- A clock advanced beyond 90 days: cleanup only occurs after a valid completion
  marker, a successful SQLite integrity check, and zero unresolved issues.

## Staged rollout gates

Start with internal users, then beta, then a small production percentage.
Advance only after reviewing migration completion/warning/failure rates,
crash-free users, migration/startup duration, recovery reports, and Google Drive
sync outcomes. Pause the rollout on any data-loss signal or unexplained increase
in migration failures; retained Hive snapshots are recovery inputs and must not
be treated as a dual-write or downgrade store.
