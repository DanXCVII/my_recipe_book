import 'models/ingredient.dart';

String cutDouble(double number) {
  if (number == number.floor().toDouble()) {
    return number.toStringAsFixed(0);
  }
  return number.toStringAsFixed(2);
}

String getImageDatatype(String filename) {
  String dataType;
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
    if (i != null) ingredientCount += i.length;
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

List<String> removeTrailingEmptyStrings(List<String> list) {
  List<String> output = List<String>.from(list);

  for (int i = list.length - 1; i >= 0; i--) {
    if (list[i] == "") {
      output.removeLast();
    } else {
      break;
    }
  }
  return output;
}
