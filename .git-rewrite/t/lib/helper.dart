import 'package:flutter/material.dart';

import 'models/recipe.dart';

String cutDouble(double number) {
  if (number == number.floor().toDouble()) {
    return number.toStringAsFixed(0);
  }
  return number.toStringAsFixed(2);
}

/// Takes a List<List<Ingredient>> and flattens it to a List<Ingredient>
/// with still all the ingredients inside
List<Ingredient> flattenIngredients(List<List<Ingredient>> listList) {
  List<Ingredient> singleList = [];

  for (int i = 0; i < listList.length; i++) {
    singleList.addAll(listList[i]);
  }
  return singleList;
}

/// returns the given time in minutes in hours and minutes without trailing 0's
/// eg: 80.0 => 1 h 20 min
/// 60.0 => 1 h
/// 30.0 => 30 min
String getTimeHoursMinutes(double min) {
  if (min ~/ 60 > 0) {
    String returnString =
        '${(min ~/ 60).toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), '')}h ';
    if (min - (min ~/ 60 * 60) != 0) {
      return returnString +=
          '${(min - (min ~/ 60 * 60)).toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), '')} min';
    } else {
      return returnString;
    }
  }
  return "${min.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), '')} min";
}

int getIngredientCount(List<List<Ingredient>> ingredients) {
  int ingredientCount = 0;
  for (final List<Ingredient> i in ingredients) {
    if (i != null) ingredientCount += i.length;
  }
  return ingredientCount;
}

String getUnderscoreName(String name) {
  return name.replaceAll(' ', '_');
}

bool validateNumber(String text) {
  if (text.isEmpty) {
    return true;
  }
  String pattern = r"^(?!0*[.,]?0+$)\d*[.,]?\d+$";

  RegExp regex = RegExp(pattern);
  if (regex.hasMatch(text)) {
    return true;
  } else {
    return false;
  }
}

List<String> removeEmptyStrings(List<TextEditingController> list) {
  List<String> output = [];

  for (int i = 0; i < list.length; i++) {
    if (list[i].text != "") {
      output.add(list[i].text);
    }
  }
  return output;
}
