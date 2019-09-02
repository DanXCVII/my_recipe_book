import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class MainPageNavigator extends Model {
  int _index = 0;
  Widget _currentMainView;
  String _title = 'recipes';

  int get index => _index;

  String get title => _title;

  Widget get currentMainView => _currentMainView;

  void changeIndex(int index) {
    this._index = index;
    switch (index) {
      case 0:
        _title = "recipes";
        break;
      case 1:
        _title = "favorites";
        break;
      case 2:
        _title = "shopping cart";
        break;
      case 3:
        _title = "roll the dice";
        break;
      case 4:
        _title = "settings";
        break;
      default:
        throw ArgumentError('$index is not a valid index for the bottomNavBar');
    }
    notifyListeners();
  }

  void changeCurrentMainView(Widget mainView) {
    this._currentMainView = mainView;
    notifyListeners();
  }

  void initCurrentMainView(Widget mainView) {
    if(this._currentMainView == null)  _currentMainView = mainView; return;
  }
}
