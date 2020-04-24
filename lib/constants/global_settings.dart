class GlobalSettings {
  bool _enableAnimations;
  bool _disableStandby;
  bool _showStepsIntro;

  static final GlobalSettings _singleton =
      GlobalSettings._internal(true, true, true);

  factory GlobalSettings() {
    return _singleton;
  }

  GlobalSettings._internal(
    this._enableAnimations,
    this._disableStandby,
    this._showStepsIntro,
  );

  bool standbyDisabled() => _disableStandby;

  bool animationsEnabled() => _enableAnimations;

  bool showStepsIntro() => _showStepsIntro;

  void enableAnimations(bool value) {
    _enableAnimations = value;
  }

  void disableStandby(bool value) {
    _disableStandby = value;
  }

  void hasSeenStepIntro(bool value) {
    _showStepsIntro = !value;
  }
}
