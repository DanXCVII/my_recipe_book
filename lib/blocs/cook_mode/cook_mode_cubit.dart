import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CookTimerStatus { idle, running, paused, completed }

typedef CookModeClock = DateTime Function();
typedef CookModeTimerFactory = Timer Function(
  Duration duration,
  void Function(Timer timer) callback,
);

class CookModeState extends Equatable {
  const CookModeState({
    this.currentStep = 0,
    this.preparedIngredientIds = const <String>{},
    this.timerStatus = CookTimerStatus.idle,
    this.timerDuration = Duration.zero,
    this.remaining = Duration.zero,
    this.deadline,
    this.keepAwake = true,
  });

  final int currentStep;
  final Set<String> preparedIngredientIds;
  final CookTimerStatus timerStatus;
  final Duration timerDuration;
  final Duration remaining;
  final DateTime? deadline;
  final bool keepAwake;

  bool get hasConfiguredTimer => timerDuration > Duration.zero;

  bool get hasActiveTimer =>
      remaining > Duration.zero &&
      (timerStatus == CookTimerStatus.running ||
          timerStatus == CookTimerStatus.paused);

  double get timerProgress {
    if (timerDuration.inMilliseconds <= 0) return 0;
    return (remaining.inMilliseconds / timerDuration.inMilliseconds).clamp(
      0,
      1,
    );
  }

  CookModeState copyWith({
    int? currentStep,
    Set<String>? preparedIngredientIds,
    CookTimerStatus? timerStatus,
    Duration? timerDuration,
    Duration? remaining,
    DateTime? deadline,
    bool clearDeadline = false,
    bool? keepAwake,
  }) {
    return CookModeState(
      currentStep: currentStep ?? this.currentStep,
      preparedIngredientIds: Set<String>.unmodifiable(
        preparedIngredientIds ?? this.preparedIngredientIds,
      ),
      timerStatus: timerStatus ?? this.timerStatus,
      timerDuration: timerDuration ?? this.timerDuration,
      remaining: remaining ?? this.remaining,
      deadline: clearDeadline ? null : deadline ?? this.deadline,
      keepAwake: keepAwake ?? this.keepAwake,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    preparedIngredientIds,
    timerStatus,
    timerDuration,
    remaining,
    deadline,
    keepAwake,
  ];
}

class CookModeCubit extends Cubit<CookModeState> {
  CookModeCubit({
    required this.stepCount,
    bool keepAwake = true,
    CookModeClock? clock,
    CookModeTimerFactory? timerFactory,
  }) : _clock = clock ?? DateTime.now,
       _timerFactory = timerFactory ?? Timer.periodic,
       super(CookModeState(keepAwake: keepAwake));

  final int stepCount;
  final CookModeClock _clock;
  final CookModeTimerFactory _timerFactory;
  Timer? _ticker;

  void selectStep(int index) {
    if (stepCount <= 0) return;
    emit(state.copyWith(currentStep: index.clamp(0, stepCount - 1)));
  }

  void nextStep() => selectStep(state.currentStep + 1);

  void previousStep() => selectStep(state.currentStep - 1);

  void toggleIngredient(String id) {
    final prepared = Set<String>.of(state.preparedIngredientIds);
    prepared.contains(id) ? prepared.remove(id) : prepared.add(id);
    emit(state.copyWith(preparedIngredientIds: prepared));
  }

  void setKeepAwake(bool value) {
    if (value == state.keepAwake) return;
    emit(state.copyWith(keepAwake: value));
  }

  void setTimer(Duration duration) {
    if (duration <= Duration.zero) return;
    _ticker?.cancel();
    emit(
      state.copyWith(
        timerStatus: CookTimerStatus.idle,
        timerDuration: duration,
        remaining: duration,
        clearDeadline: true,
      ),
    );
  }

  void startTimer() {
    if (state.remaining <= Duration.zero) return;
    _ticker?.cancel();
    final deadline = _clock().add(state.remaining);
    emit(
      state.copyWith(timerStatus: CookTimerStatus.running, deadline: deadline),
    );
    _ticker = _timerFactory(const Duration(seconds: 1), (_) => syncTimer());
  }

  void pauseTimer() {
    if (state.timerStatus != CookTimerStatus.running) return;
    _syncRemaining(complete: true);
    _ticker?.cancel();
    if (state.timerStatus != CookTimerStatus.running) return;
    emit(
      state.copyWith(timerStatus: CookTimerStatus.paused, clearDeadline: true),
    );
  }

  void resumeTimer() {
    if (state.timerStatus != CookTimerStatus.paused) return;
    startTimer();
  }

  void addMinute() {
    if (!state.hasConfiguredTimer) return;
    if (state.timerStatus == CookTimerStatus.running) {
      _syncRemaining(complete: false);
    }
    final remaining = state.remaining + const Duration(minutes: 1);
    final duration = remaining > state.timerDuration
        ? remaining
        : state.timerDuration;
    final running = state.timerStatus == CookTimerStatus.running;
    emit(
      state.copyWith(
        timerDuration: duration,
        remaining: remaining,
        deadline: running ? _clock().add(remaining) : null,
        clearDeadline: !running,
      ),
    );
  }

  void resetTimer() {
    if (!state.hasConfiguredTimer) return;
    _ticker?.cancel();
    emit(
      state.copyWith(
        timerStatus: CookTimerStatus.idle,
        remaining: state.timerDuration,
        clearDeadline: true,
      ),
    );
  }

  void cancelTimer() {
    _ticker?.cancel();
    emit(
      state.copyWith(
        timerStatus: CookTimerStatus.idle,
        timerDuration: Duration.zero,
        remaining: Duration.zero,
        clearDeadline: true,
      ),
    );
  }

  void restartTimer() {
    if (!state.hasConfiguredTimer) return;
    _ticker?.cancel();
    emit(
      state.copyWith(
        timerStatus: CookTimerStatus.idle,
        remaining: state.timerDuration,
        clearDeadline: true,
      ),
    );
    startTimer();
  }

  void syncTimer() {
    if (state.timerStatus != CookTimerStatus.running) return;
    _syncRemaining(complete: true);
  }

  void _syncRemaining({required bool complete}) {
    final deadline = state.deadline;
    if (deadline == null) return;
    final milliseconds = deadline.difference(_clock()).inMilliseconds;
    if (milliseconds <= 0) {
      _ticker?.cancel();
      emit(
        state.copyWith(
          timerStatus: complete
              ? CookTimerStatus.completed
              : CookTimerStatus.paused,
          remaining: Duration.zero,
          clearDeadline: true,
        ),
      );
      return;
    }
    emit(state.copyWith(remaining: Duration(milliseconds: milliseconds)));
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
