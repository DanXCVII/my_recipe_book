import './recipe.dart';

class MyImageWrapper {
  String _selectedImage;

  String getSelectedImage() {
    return _selectedImage;
  }

  void setSelectedImage(String image) {
    _selectedImage = image;
  }
}

class MyDoubleWrapper {
  double number;

  MyDoubleWrapper({this.number});

  double getDouble() {
    return number;
  }

  void setDouble(double i) {
    number = i;
  }
}

class MyVegetableWrapper {
  Vegetable vegetableStatus;

  Vegetable getVegetableStatus() {
    return vegetableStatus;
  }

  void setVegetableStatus(Vegetable vegetableStatus) {
    this.vegetableStatus = vegetableStatus;
  }
}
