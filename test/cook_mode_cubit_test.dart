import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/cook_mode/cook_mode_cubit.dart';

void main() {
  test('tracks steps and ephemeral ingredient preparation', () async {
    final cubit = CookModeCubit(stepCount: 3);
    addTearDown(cubit.close);

    cubit.nextStep();
    expect(cubit.state.currentStep, 1);
    cubit.selectStep(99);
    expect(cubit.state.currentStep, 2);
    cubit.previousStep();
    expect(cubit.state.currentStep, 1);

    cubit.toggleIngredient('garlic');
    expect(cubit.state.preparedIngredientIds, contains('garlic'));
    cubit.toggleIngredient('garlic');
    expect(cubit.state.preparedIngredientIds, isNot(contains('garlic')));
  });

  test('deadline timer pauses, resumes, extends, and completes once', () async {
    var now = DateTime(2026, 1, 1, 12);
    final cubit = CookModeCubit(
      stepCount: 2,
      clock: () => now,
      timerFactory: (_, __) => Timer(const Duration(days: 1), () {}),
    );
    addTearDown(cubit.close);

    cubit.setTimer(const Duration(minutes: 2));
    expect(cubit.state.timerStatus, CookTimerStatus.idle);
    expect(cubit.state.remaining, const Duration(minutes: 2));

    cubit.startTimer();
    now = now.add(const Duration(seconds: 45));
    cubit.syncTimer();
    expect(cubit.state.remaining, const Duration(seconds: 75));

    cubit.pauseTimer();
    expect(cubit.state.timerStatus, CookTimerStatus.paused);
    now = now.add(const Duration(minutes: 5));
    cubit.syncTimer();
    expect(cubit.state.remaining, const Duration(seconds: 75));

    cubit.addMinute();
    expect(cubit.state.remaining, const Duration(seconds: 135));
    cubit.resumeTimer();
    now = now.add(const Duration(seconds: 135));
    cubit.syncTimer();
    expect(cubit.state.timerStatus, CookTimerStatus.completed);
    expect(cubit.state.remaining, Duration.zero);

    cubit.syncTimer();
    expect(cubit.state.timerStatus, CookTimerStatus.completed);
  });

  test('reset and cancel clear timer state predictably', () async {
    final cubit = CookModeCubit(
      stepCount: 1,
      timerFactory: (_, __) => Timer(const Duration(days: 1), () {}),
    );
    addTearDown(cubit.close);

    cubit.setTimer(const Duration(minutes: 3));
    cubit.startTimer();
    cubit.resetTimer();
    expect(cubit.state.timerStatus, CookTimerStatus.idle);
    expect(cubit.state.remaining, const Duration(minutes: 3));

    cubit.cancelTimer();
    expect(cubit.state.hasConfiguredTimer, isFalse);
    expect(cubit.state.remaining, Duration.zero);
  });

  test(
    'pausing at the deadline completes instead of freezing at zero',
    () async {
      var now = DateTime(2026, 1, 1, 12);
      final cubit = CookModeCubit(
        stepCount: 1,
        clock: () => now,
        timerFactory: (_, __) => Timer(const Duration(days: 1), () {}),
      );
      addTearDown(cubit.close);

      cubit.setTimer(const Duration(seconds: 10));
      cubit.startTimer();
      now = now.add(const Duration(seconds: 10));
      cubit.pauseTimer();

      expect(cubit.state.timerStatus, CookTimerStatus.completed);
      expect(cubit.state.remaining, Duration.zero);
    },
  );
}
