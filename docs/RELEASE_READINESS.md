# Deferred validation and release checklist

Last updated: 2026-09-13

The project has been migrated far enough to build and start on Android with
current tooling. Automated tests pass, and a debug APK has been built and
launched successfully.

The checks below are intentionally deferred while secondary maintenance work
continues. They are still required before the app is treated as release-ready
or an update is published to users.

## 1. Verify a fresh checkout

Test the repository without relying on generated files or configuration left
over in the current working copy.

- Clone the repository into a new directory.
- Run `flutter pub get`.
- Run `flutter test`.
- Build a debug Android APK.
- Confirm that the build needs only documented local configuration and no
  missing tracked files.

Success means a new contributor or build machine can reproduce the build from
the committed repository.

## 2. Complete an Android functional smoke test

Test the important application flows on an Android device or emulator:

- Start with a clean installation.
- Create, edit, view, and delete a recipe.
- Add recipe images, ingredients, categories, tags, and preparation steps.
- Exercise the shopping list and recipe calendar.
- Import, export, and share recipes.
- Import a recipe from a website.
- Restart the app and confirm that data and settings persist.

Record device model, Android version, and failures so regressions can be
reproduced.

## 3. Verify compatibility with existing user data

Do not test first with the only copy of valuable recipe data.

- Back up data produced by the previously released app.
- Install or upgrade to the migrated version using a representative copy.
- Confirm recipes, images, categories, tags, shopping-list entries, calendar
  entries, and settings still load correctly.
- Confirm that modified data remains readable after another app restart.
- Verify export and restore before relying on the migrated app with real data.

Any required data migration should be implemented and tested before release.

## 4. Test external integrations

Compilation does not prove that integrations configured outside this
repository still work.

- Test Google Drive sign-in, upload, download, conflict handling, sign-out, and
  reauthentication.
- Verify the OAuth Android package name and SHA certificate fingerprints for
  both debug and release signing keys.
- Test advertisements using the provider's test mode or test ad units. Do not
  click live advertisements during testing.
- Confirm behavior when the network is unavailable or authentication expires.
- Check any Play Console or cloud-service configuration required by the app.

Keep signing keys, OAuth client secrets, and local service credentials outside
the repository. Public mobile identifiers such as AdMob app and unit IDs may
remain tracked.

## 5. Produce and distribute an internal release

- Restore or create the release-signing setup without committing credentials.
- Choose the next application version and build number.
- Build the release Android App Bundle.
- Install or distribute it through Google Play internal testing.
- Repeat the critical smoke tests against the signed release build.
- Review startup crashes and integration failures before widening distribution.

The internal release should be treated as the final validation gate before a
production rollout.

## Scope note

iOS has not been validated and is outside this checklist. It needs its own
build, signing, permissions, integration, and device-testing pass if iOS support
is resumed.
