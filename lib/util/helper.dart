import 'package:flutter/widgets.dart';
import 'package:fraction/fraction.dart';
import '../generated/i18n.dart';

import '../models/ingredient.dart';

/// valid formats:
/// 1.9/2,7
/// 1.0
/// 0,5
double? getDoubleFromString(String number) {
  String validNumber = number.replaceAll(",", ".");
  double parsedDouble;
  try {
    parsedDouble = double.parse(validNumber);
    return parsedDouble;
  } catch (e) {
    print(e);
  }

  try {
    var f = MixedFraction.fromString(validNumber);
    parsedDouble = f.toDouble();
    return parsedDouble;
  } catch (e) {
    print(e);
  }

  try {
    var f = Fraction.fromString(validNumber);
    parsedDouble = f.toDouble();
    return parsedDouble;
  } catch (e) {
    print(e);
  }

  return null;
}

/// TODO: update to show number in nice string format
String getFractionDouble(double number) {
  var f = Fraction.fromDouble(number, precision: 0.01);
  String mf = MixedFraction.fromFraction(f).toString();

  return mf.endsWith("0/1") ? number.toStringAsFixed(0) : mf;
}

String cutDouble(double number) {
  if (number == number.floor().toDouble()) {
    return number.toStringAsFixed(0);
  }
  return number.toStringAsFixed(2);
}

String? getImageDatatype(String filename) {
  String? dataType;
  String partWithDataType = filename.substring(filename.length - 5);
  if (partWithDataType.contains('.')) {
    dataType = partWithDataType.substring(partWithDataType.lastIndexOf('.'));
  } else {
    if (partWithDataType.endsWith('jpg')) dataType = '.jpg';
    if (partWithDataType.endsWith('png')) dataType = '.png';
    if (partWithDataType.endsWith('jpeg')) dataType = '.jpeg';
    if (partWithDataType.endsWith('jpg')) dataType = '.jpg';
  }
  return dataType;
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
  String returnString;
  if (min ~/ 60 > 0) {
    returnString = '${min ~/ 60}h ';
    if (min - (min ~/ 60 * 60) != 0) {
      String remainingMinutesString = (min - (min ~/ 60 * 60)).toString();
      if (remainingMinutesString[remainingMinutesString.lastIndexOf(".") + 1] ==
          "0") {
        return returnString +=
            '${remainingMinutesString.substring(0, remainingMinutesString.lastIndexOf("."))} min';
      } else {
        return returnString +=
            '${remainingMinutesString.substring(0, remainingMinutesString.lastIndexOf(".") + 2)} min';
      }
    } else {
      return returnString;
    }
  }
  String minString = min.toString();
  if (minString[minString.lastIndexOf(".") + 1] == "0") {
    return "${minString.substring(0, minString.lastIndexOf("."))} min";
  } else {
    return "${minString.substring(0, minString.lastIndexOf(".") + 2)} min";
  }
}

int getIngredientCount(List<List<Ingredient>> ingredients) {
  int ingredientCount = 0;
  for (final List<Ingredient> i in ingredients) {
    ingredientCount += i.length;
  }
  return ingredientCount;
}

String stringReplaceSpaceUnderscore(String name) {
  return name.replaceAll(' ', '_');
}

bool stringIsValidDouble(String text) {
  if (text.isEmpty) {
    return false;
  }
  String pattern = r"^(?!0*[.,]?0+$)\d*[.,]?\d+$";

  RegExp regex = RegExp(pattern);
  if (regex.hasMatch(text) || text == "0") {
    return true;
  } else {
    return false;
  }
}

List<String> trimRemoveTrailingEmptyStrings(List<String> list) {
  List<String> output = List<String>.from(list);

  for (int i = list.length - 1; i >= 0; i--) {
    if (list[i] == "") {
      output.removeLast();
    } else {
      output[i] = list[i].trim();
      break;
    }
  }
  return output;
}

/// trys to get the number value out of the string and otherwise
/// returns null
double? getNumberOfString(String numberInfo) {
  bool failed = false;

  try {
    if (numberInfo.contains("/")) {
      double firstNumber =
          double.parse(numberInfo.substring(0, numberInfo.indexOf("/")));
      double secondNumber =
          double.parse(numberInfo.substring(numberInfo.indexOf("/") + 1));
      return firstNumber / secondNumber;
    }
  } catch (e) {
    failed = true;
  }
  if (failed) {
    if (numberInfo == "½") {
      return 0.5;
    } else if (numberInfo == "⅓") {
      return 0.33;
    } else if (numberInfo == "¼") {
      return 0.25;
    }
  }
  return double.tryParse(numberInfo);
}

String getMonthString(int month, BuildContext context) {
  switch (month) {
    case 1:
      return I18n.of(context)!.january;
    case 2:
      return I18n.of(context)!.february;
    case 3:
      return I18n.of(context)!.march;
    case 4:
      return I18n.of(context)!.april;
    case 5:
      return I18n.of(context)!.may_full;
    case 6:
      return I18n.of(context)!.june;
    case 7:
      return I18n.of(context)!.july;
    case 8:
      return I18n.of(context)!.august;
    case 9:
      return I18n.of(context)!.september;
    case 10:
      return I18n.of(context)!.october;
    case 11:
      return I18n.of(context)!.november;
    case 12:
      return I18n.of(context)!.december;
    default:
      return "";
  }
}

String getWeekdayString(int weekday, BuildContext context) {
  switch (weekday) {
    case 1:
      return I18n.of(context)!.monday;
    case 2:
      return I18n.of(context)!.tuesday;
    case 3:
      return I18n.of(context)!.wednesday;
    case 4:
      return I18n.of(context)!.thursday;
    case 5:
      return I18n.of(context)!.friday;
    case 6:
      return I18n.of(context)!.saturday;
    case 7:
      return I18n.of(context)!.sunday;
    default:
      return "";
  }
}

String getMonthAbbrevString(int month, BuildContext context) {
  switch (month) {
    case 1:
      return I18n.of(context)!.jan;
    case 2:
      return I18n.of(context)!.feb;
    case 3:
      return I18n.of(context)!.mar;
    case 4:
      return I18n.of(context)!.apr;
    case 5:
      return I18n.of(context)!.may;
    case 6:
      return I18n.of(context)!.jun;
    case 7:
      return I18n.of(context)!.jul;
    case 8:
      return I18n.of(context)!.aug;
    case 9:
      return I18n.of(context)!.sep;
    case 10:
      return I18n.of(context)!.oct;
    case 11:
      return I18n.of(context)!.nov;
    case 12:
      return I18n.of(context)!.dec;
    default:
      return "";
  }
}
