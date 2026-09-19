import 'package:app_review/app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AppReviewRequester {
  Future<bool> isAvailable();

  Future<void> requestReview();
}

class NativeAppReviewRequester implements AppReviewRequester {
  @override
  Future<bool> isAvailable() => AppReview.isRequestReviewAvailable();

  @override
  Future<void> requestReview() => AppReview.requestReview();
}

/// Requests the platform review sheet only after the user has had enough time
/// to experience the app.
///
/// The legacy `rate_my_app` preference keys are deliberately retained. This
/// preserves existing launch counts, reminder dates, and "No thanks" choices
/// when upgrading.
class ReviewPromptService {
  ReviewPromptService({
    AppReviewRequester? requester,
    Future<SharedPreferences> Function()? preferences,
    Future<String> Function()? appVersion,
    DateTime Function()? now,
  }) : _requester = requester ?? NativeAppReviewRequester(),
       _preferences = preferences ?? SharedPreferences.getInstance,
       _appVersion = appVersion ?? _readAppVersion,
       _now = now ?? DateTime.now;

  static const _minimumDateKey = 'rateMyApp_minimumDate';
  static const _launchesKey = 'rateMyApp_launches';
  static const _doNotOpenAgainKey = 'rateMyApp_doNotOpenAgain';
  static const _lastRequestedVersionKey = 'nativeReview_lastRequestedVersion';

  static const minimumDays = 7;
  static const minimumLaunches = 10;
  static const reviewCooldown = Duration(days: 90);

  final AppReviewRequester _requester;
  final Future<SharedPreferences> Function() _preferences;
  final Future<String> Function() _appVersion;
  final DateTime Function() _now;

  Future<void> recordLaunchAndRequestIfEligible() async {
    final preferences = await _preferences();
    final now = _now();
    final launches = (preferences.getInt(_launchesKey) ?? 0) + 1;
    await preferences.setInt(_launchesKey, launches);

    final minimumDateMilliseconds = preferences.getInt(_minimumDateKey);
    if (minimumDateMilliseconds == null) {
      await preferences.setInt(
        _minimumDateKey,
        now.add(const Duration(days: minimumDays)).millisecondsSinceEpoch,
      );
      return;
    }

    if (preferences.getBool(_doNotOpenAgainKey) ?? false) return;
    if (launches < minimumLaunches) return;

    final minimumDate = DateTime.fromMillisecondsSinceEpoch(
      minimumDateMilliseconds,
    );
    if (now.isBefore(minimumDate)) return;

    final appVersion = await _appVersion();
    if (preferences.getString(_lastRequestedVersionKey) == appVersion) {
      return;
    }
    if (!await _requester.isAvailable()) return;

    await _requester.requestReview();
    await preferences.setString(_lastRequestedVersionKey, appVersion);
    await preferences.setInt(
      _minimumDateKey,
      now.add(reviewCooldown).millisecondsSinceEpoch,
    );
  }

  static Future<String> _readAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version}+${packageInfo.buildNumber}';
  }
}
