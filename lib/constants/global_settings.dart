class GlobalSettings {
  bool _enableAnimations;

  static final GlobalSettings _singleton = GlobalSettings._internal(true);

  factory GlobalSettings() {
    return _singleton;
  }

  GlobalSettings._internal(
    this._enableAnimations,
  );

  bool animationsEnabled() => _enableAnimations;

  void enableAnimations(bool value) {
    _enableAnimations = value;
  }
}
