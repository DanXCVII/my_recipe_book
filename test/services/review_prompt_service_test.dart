import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/services/review_prompt_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DateTime now;
  late FakeAppReviewRequester requester;

  setUp(() {
    now = DateTime(2026, 9, 18, 12);
    requester = FakeAppReviewRequester();
    SharedPreferences.setMockInitialValues({});
  });

  ReviewPromptService createService() => ReviewPromptService(
    requester: requester,
    appVersion: () async => '1.5.0+145',
    now: () => now,
  );

  test('starts the seven-day eligibility period on the first launch', () async {
    await createService().recordLaunchAndRequestIfEligible();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getInt('rateMyApp_launches'), 1);
    expect(
      preferences.getInt('rateMyApp_minimumDate'),
      now.add(const Duration(days: 7)).millisecondsSinceEpoch,
    );
    expect(requester.requestCount, 0);
  });

  test('requests a review after ten launches and seven days', () async {
    SharedPreferences.setMockInitialValues({
      'rateMyApp_launches': 9,
      'rateMyApp_minimumDate': now
          .subtract(const Duration(days: 1))
          .millisecondsSinceEpoch,
    });

    await createService().recordLaunchAndRequestIfEligible();

    expect(requester.requestCount, 1);
    expect(
      (await SharedPreferences.getInstance()).getString(
        'nativeReview_lastRequestedVersion',
      ),
      '1.5.0+145',
    );
    expect(
      (await SharedPreferences.getInstance()).getInt('rateMyApp_minimumDate'),
      now.add(const Duration(days: 90)).millisecondsSinceEpoch,
    );
  });

  test('does not request twice for the same app version', () async {
    SharedPreferences.setMockInitialValues({
      'rateMyApp_launches': 20,
      'rateMyApp_minimumDate': now
          .subtract(const Duration(days: 1))
          .millisecondsSinceEpoch,
      'nativeReview_lastRequestedVersion': '1.5.0+145',
    });

    await createService().recordLaunchAndRequestIfEligible();

    expect(requester.requestCount, 0);
  });

  test('honors the previous No thanks preference', () async {
    SharedPreferences.setMockInitialValues({
      'rateMyApp_launches': 20,
      'rateMyApp_minimumDate': now
          .subtract(const Duration(days: 1))
          .millisecondsSinceEpoch,
      'rateMyApp_doNotOpenAgain': true,
    });

    await createService().recordLaunchAndRequestIfEligible();

    expect(requester.requestCount, 0);
  });

  test('retries later when the platform review sheet is unavailable', () async {
    requester.available = false;
    SharedPreferences.setMockInitialValues({
      'rateMyApp_launches': 9,
      'rateMyApp_minimumDate': now
          .subtract(const Duration(days: 1))
          .millisecondsSinceEpoch,
    });

    await createService().recordLaunchAndRequestIfEligible();

    expect(requester.requestCount, 0);
    expect(
      (await SharedPreferences.getInstance()).getString(
        'nativeReview_lastRequestedVersion',
      ),
      isNull,
    );
  });
}

class FakeAppReviewRequester implements AppReviewRequester {
  bool available = true;
  int requestCount = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<void> requestReview() async {
    requestCount++;
  }
}
