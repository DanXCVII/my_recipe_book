class GlobalSettings {
  bool _enableAnimations;
  bool _disableStandby;
  bool _showStepsIntro;
  bool _firstStart;

  static final GlobalSettings _singleton = GlobalSettings._internal(
    true,
    true,
    true,
    false,
  );

  factory GlobalSettings() {
    return _singleton;
  }

  GlobalSettings._internal(
    this._enableAnimations,
    this._disableStandby,
    this._showStepsIntro,
    this._firstStart,
  );

  bool standbyDisabled() => _disableStandby;

  bool animationsEnabled() => _enableAnimations;

  bool showStepsIntro() => _showStepsIntro;

  bool isFirstStart() => _firstStart;

  void enableAnimations(bool value) {
    _enableAnimations = value;
  }

  void disableStandby(bool value) {
    _disableStandby = value;
  }

  void hasSeenStepIntro(bool value) {
    _showStepsIntro = !value;
  }

  void thisIsFirstStart(bool value) {
    _firstStart = value;
  }
}
