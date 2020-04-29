import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/nutrition.dart';
import 'package:my_recipe_book/util/helper.dart';

/// ingredient info can have form of:
/// 1 1/2 g Butter
/// 2  Eier
/// 4 Eier
/// ½ Schachtel Tomaten
///  Gew\u00fcrzmischung
/// Wasser
Ingredient getIngredientFromString(String ingredientInfo) {
  double amount;
  String unit;
  String name;

  try {
    if (ingredientInfo.startsWith(" ")) {
      return Ingredient(name: ingredientInfo.substring(1));
    } else if (!ingredientInfo.contains(" ")) {
      return Ingredient(name: ingredientInfo);
    } else if (getNumberOfString(
            ingredientInfo.substring(0, ingredientInfo.indexOf(" "))) !=
        null) {
      amount = getNumberOfString(
          ingredientInfo.substring(0, ingredientInfo.indexOf(" ")));

      if (ingredientInfo.contains(" ", ingredientInfo.indexOf(" ") + 1)) {
        String remainingIngredInfo =
            ingredientInfo.substring(ingredientInfo.indexOf(" ") + 1);
        if (remainingIngredInfo.startsWith(" ")) {
          return Ingredient(
              name:
                  remainingIngredInfo.substring(1, remainingIngredInfo.length),
              amount: amount);
        }

        String secondSubString =
            remainingIngredInfo.substring(0, remainingIngredInfo.indexOf(" "));
        if (getNumberOfString(secondSubString) != null) {
          amount += getNumberOfString(secondSubString);
          if (remainingIngredInfo[remainingIngredInfo.indexOf(" ") + 1] ==
              " ") {
            return Ingredient(
              name: remainingIngredInfo
                  .substring(remainingIngredInfo.indexOf(" ") + 2),
              amount: amount,
            );
          }
        } else {
          unit = secondSubString;
        }
        name =
            remainingIngredInfo.substring(remainingIngredInfo.indexOf(" ") + 1);
      } else {
        name = ingredientInfo.substring(ingredientInfo.indexOf(" ") + 1);
      }
    }
  } catch (e) {}
  return Ingredient(name: name, amount: amount, unit: unit);
}

List<Ingredient> getIngredientsFromMRB(String xmlData) {
  List<Ingredient> ingredients = [];
  if (xmlData.contains("<ingredient>")) {
    String iteratedIngredientSection = xmlData.substring(
        xmlData.indexOf("<ingredient>"), xmlData.indexOf("</ingredient>"));
    while (iteratedIngredientSection.contains("<li>")) {
      String ingredientStringData = iteratedIngredientSection.substring(
          iteratedIngredientSection.indexOf("<li>") + 4,
          iteratedIngredientSection.indexOf("</li>"));

      ingredients.add(getIngredientFromString(ingredientStringData));

      iteratedIngredientSection = iteratedIngredientSection
          .substring(iteratedIngredientSection.indexOf("</li>") + 5);
    }
  }

  return ingredients;
}

List<String> getStepsFromMRB(String xmlData) {
  List<String> steps = [];
  if (xmlData.contains("<recipeText>")) {
    String iteratedStepsData = xmlData.substring(
        xmlData.indexOf("<recipeText>"), xmlData.indexOf("</recipeText>"));
    while (iteratedStepsData.contains("<li>")) {
      String recipeStep = iteratedStepsData.substring(
          iteratedStepsData.indexOf("<li>") + 4,
          iteratedStepsData.indexOf("</li>"));

      steps.add(recipeStep);

      iteratedStepsData =
          iteratedStepsData.substring(iteratedStepsData.indexOf("</li>") + 5);
    }
  }

  return steps;
}

List<Nutrition> getNutritionsFromMRB(String xmlData) {
  List<Nutrition> nutritions = [];
  if (xmlData.contains("<nutrition>")) {
    String iteratedStepsData = xmlData.substring(
        xmlData.indexOf("<recipeText>"), xmlData.indexOf("</recipeText>"));
    while (iteratedStepsData.contains("<li>")) {
      String nutritionString = iteratedStepsData.substring(
          iteratedStepsData.indexOf("<li>") + 4,
          iteratedStepsData.indexOf("</li>"));

      nutritions.add(
        Nutrition(
          name: nutritionString.substring(0, nutritionString.indexOf(" :")),
          amountUnit:
              nutritionString.substring(nutritionString.indexOf(": ") + 2),
        ),
      );

      iteratedStepsData =
          iteratedStepsData.substring(iteratedStepsData.indexOf("</li>") + 5);
    }
  }

  return nutritions;
}

String getURLfromMRB(String xmlData) {
  if (xmlData.contains("<url>")) {
    return xmlData
        .substring(
          xmlData.indexOf("<url>") + 5,
          xmlData.indexOf("</url>"),
        )
        .trim();
  }
  return null;
}

double getServingsFromMRB(String xmlData) {
  if (xmlData.contains("<quantity>")) {
    return getFirstFullNumber(xmlData.substring(
      xmlData.indexOf("<quantity>"),
      xmlData.indexOf("</quantity>"),
    ));
  }
  return null;
}

/// test.77.60kk => 77.60
/// 7 k => 7.0
/// 7.99.99 => 7.99
double getFirstFullNumber(String text) {
  bool foundDot = false;
  bool foundNumber = false;
  int startIndex;
  int endIndex;

  for (int i = 0; i < text.length; i++) {
    if (startIndex == null && double.tryParse(text[i]) != null) {
      startIndex = i;
      foundNumber = true;
    } else if (foundNumber == true && foundDot == false && text[i] == ".") {
      foundDot = true;
    } else if (startIndex != null && double.tryParse(text[i]) != null) {
    } else if (startIndex != null) {
      return double.tryParse(text.substring(startIndex, i - 1));
    } else if (startIndex != null && i == text.length - 1) {
      return double.tryParse(text.substring(startIndex, i));
    }
  }
  return null;
}
