import '../models/enums.dart';

class MyDoubleWrapper {
  double? myDouble;

  MyDoubleWrapper({this.myDouble});
}

class MyVegetableWrapper {
  Vegetable vegetableStatus = Vegetable.NON_VEGETARIAN;

  Vegetable getVegetableStatus() {
    return vegetableStatus;
  }

  void setVegetableStatus(Vegetable vegetableStatus) {
    this.vegetableStatus = vegetableStatus;
  }
}
