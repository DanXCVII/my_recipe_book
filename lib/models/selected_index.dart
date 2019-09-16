import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class MainPageNavigator extends Model {
  int _index = 0;
  bool _currentMainView;
  String _title = 'recipes';
  bool showOverlay = false;

  int get index => _index;

  String get title => _title;

  bool get currentMainView => _currentMainView;

  void changeOverlayStatus(bool status) {
    showOverlay = status;
    notifyListeners();
  }

  void changeIndex(int index) {
    this._index = index;
    switch (index) {
      case 0:
        _title = "recipes";
        showOverlay = false;

        break;
      case 1:
        _title = "favorites";
        showOverlay = false;

        break;
      case 2:
        _title = "basket";
        showOverlay = false;
        break;
      case 3:
        _title = "roll the dice";
        showOverlay = true;
        break;
      case 4:
        _title = "settings";
        showOverlay = false;
        break;
      default:
        throw ArgumentError('$index is not a valid index for the bottomNavBar');
    }
    notifyListeners();
  }

  void changeCurrentMainView(bool mainView) {
    this._currentMainView = mainView;
    notifyListeners();
  }

  void initCurrentMainView(bool mainView) {
    if (this._currentMainView == null) _currentMainView = mainView;
    return;
  }
}
