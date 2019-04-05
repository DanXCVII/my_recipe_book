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

class MyVegetableWrapper {
  Vegetable vegetableStatus;

  Vegetable getVegetableStatus() {
    return vegetableStatus;
  }

  Vegetable setVegetableStatus(Vegetable vegetableStatus) {
    vegetableStatus = vegetableStatus;
  }
}