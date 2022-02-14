class GlobalSettings {
  bool _enableAnimations;
  bool _disableStandby;
  bool _showStepsIntro;
  bool _firstStart;
  bool _showDecimal;

  static final GlobalSettings _singleton = GlobalSettings._internal(
    true,
    true,
    true,
    false,
    true,
  );

  factory GlobalSettings() {
    return _singleton;
  }

  GlobalSettings._internal(
    this._enableAnimations,
    this._disableStandby,
    this._showStepsIntro,
    this._firstStart,
    this._showDecimal,
  );

  bool standbyDisabled() => _disableStandby;

  bool animationsEnabled() => _enableAnimations;

  bool showStepsIntro() => _showStepsIntro;

  bool isFirstStart() => _firstStart;

  bool showDecimal() => _showDecimal;

  void enableAnimations(bool/*!*/ value) {
    _enableAnimations = value;
  }

  void disableStandby(bool/*!*/ value) {
    _disableStandby = value;
  }

  void hasSeenStepIntro(bool value) {
    _showStepsIntro = !value;
  }

  void thisIsFirstStart(bool value) {
    _firstStart = value;
  }

  void shouldShowDecimal(bool/*!*/ value) {
    _showDecimal = value;
  }
}
