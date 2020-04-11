class GlobalSettings {
  bool _enableAnimations;
  bool _disableStandby;

  static final GlobalSettings _singleton = GlobalSettings._internal(true, true);

  factory GlobalSettings() {
    return _singleton;
  }

  GlobalSettings._internal(
    this._enableAnimations,
    this._disableStandby,
  );

  bool standbyDisabled() => _disableStandby;

  bool animationsEnabled() => _enableAnimations;

  void enableAnimations(bool value) {
    _enableAnimations = value;
  }

  void disableStandby(bool value) {
    _disableStandby = value;
  }
}
