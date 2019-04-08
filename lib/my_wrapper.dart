import 'dart:io';

import './recipe.dart';

class MyImageWrapper {
  File _selectedImage;

  File getSelectedImage() {
    return _selectedImage;
  }

  void setSelectedImage(File image) {
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

  Vegetable setVegetableStatus(Vegetable vegetableStatus) {
    vegetableStatus = vegetableStatus;
  }
}
