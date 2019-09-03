import 'recipe.dart';

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

String getTimeHoursMinutes(double min) {
  if (min ~/ 60 > 0) {
    return "${min ~/ 60}h ${min - (min ~/ 60 * 60)}min";
  }
  return "$min min";
}
