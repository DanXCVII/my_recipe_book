import './recipe.dart';

class MyImageWrapper {
  String selectedImage;

  MyImageWrapper({this.selectedImage});
}

class MyBooleanWrapper {
  bool myBool;

  MyBooleanWrapper({this.myBool});
}

class MyDoubleWrapper {
  double myDouble;

  MyDoubleWrapper({this.myDouble});
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
