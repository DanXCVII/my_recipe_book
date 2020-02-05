import 'models/enums.dart';

class MyImageWrapper {
  String selectedImage;

  MyImageWrapper({this.selectedImage});
}

class MyBooleanWrapper {
  bool myBool;

  MyBooleanWrapper(this.myBool);
}

class MyDoubleWrapper {
  double myDouble;

  MyDoubleWrapper({this.myDouble});
}

class MyIntWrapper {
  int myInt;

  MyIntWrapper(this.myInt);
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
