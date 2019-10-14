import 'package:scoped_model/scoped_model.dart';

class MainPageNavigator extends Model {
  int _index = 0;
  bool _showRecipesCatOverview;
  bool _showOverlay = false;
  bool _showFancyShoppingList = true;

  int get index => _index;

  bool get showFancyShoppingList => _showFancyShoppingList;

  bool get showOverlay => _showOverlay;


  bool get recipeCatOverview => _showRecipesCatOverview;

  void changeOverlayStatus(bool status) {
    _showOverlay = status;
    notifyListeners();
  }

  void changeIndex(int index) {
    this._index = index;
    switch (index) {
      case 0:
        _showOverlay = false;

        break;
      case 1:
        _showOverlay = false;

        break;
      case 2:
        _showOverlay = false;
        break;
      case 3:
        _showOverlay = true;
        break;
      case 4:
        _showOverlay = false;
        break;
      default:
        throw ArgumentError('$index is not a valid index for the bottomNavBar');
    }
    notifyListeners();
  }

  void changeCurrentMainView(bool mainView) {
    this._showRecipesCatOverview = mainView;
    notifyListeners();
  }

  void initCurrentMainView(bool mainView) {
    if (this._showRecipesCatOverview == null)
      _showRecipesCatOverview = mainView;
    return;
  }

  void changeFancyShoppingList(bool value) {
    _showFancyShoppingList = value;
    notifyListeners();
  }
}
