import 'package:flutter/material.dart';
import 'package:my_recipe_book/models/recipe.dart';

import '../../database.dart';

enum Validator {
  INGREDIENTS_NOT_VALID,
  REQUIRED_FIELDS,
  NAME_TAKEN,
  GLOSSARY_NOT_VALID,
  VALID
}

class RecipeValidator {
  static final RecipeValidator _rValidator = new RecipeValidator._internal();

  factory RecipeValidator() {
    return _rValidator;
  }

  RecipeValidator._internal();

  Future<Validator> validateForm(
    GlobalKey<FormState> formKey,
    List<List<TextEditingController>> ingredientNameController,
    List<List<TextEditingController>> ingredientAmountController,
    List<List<TextEditingController>> ingredientUnitController,
    List<TextEditingController> ingredientGlossaryController,
    String recipeName,
    bool editingRecipe,
  ) async {
    if (!formKey.currentState.validate())
      return Validator.REQUIRED_FIELDS;
    else if (!_isIngredientListValid(
      ingredientNameController,
      ingredientAmountController,
      ingredientUnitController,
    ))
      return Validator.INGREDIENTS_NOT_VALID;
    else if (!_isGlossaryValid(
      ingredientNameController,
      ingredientAmountController,
      ingredientUnitController,
      ingredientGlossaryController,
    ))
      return Validator.GLOSSARY_NOT_VALID;
    else if (!editingRecipe && await DBProvider.db.doesRecipeExist(recipeName))
      return Validator.NAME_TAKEN;
    else
      return Validator.VALID;
  }

  bool _isIngredientListValid(
    List<List<TextEditingController>> ingredients,
    List<List<TextEditingController>> amount,
    List<List<TextEditingController>> unit,
  ) {
    int validator = 0;
    for (int i = 0; i < ingredients.length; i++) {
      for (int j = 0; j < ingredients[i].length; j++) {
        validator = 0;
        if (ingredients[i][j].text == "") validator++;
        if (amount[i][j].text == "") validator++;
        if (unit[i][j].text == "") validator++;
        if (validator == 1 || validator == 2) return false;
      }
    }
    return true;
  }

  bool _isGlossaryValid(
      List<List<TextEditingController>> ingredients,
      List<List<TextEditingController>> amount,
      List<List<TextEditingController>> unit,
      List<TextEditingController> ingredientsGlossary) {
    List<List<Ingredient>> ingredientList =
        getCleanIngredientData(ingredients, amount, unit);
    List<String> ingredientGlossary =
        getCleanGlossary(ingredientsGlossary, ingredientList);
    if (ingredientList.length > 1 &&
        ingredientGlossary.length < ingredientList.length) return false;

    return true;
  }
}

/// sets the length of the glossary for the ingredients section equal to
/// the length list<list<ingredients>> (removes unnessesary sections)
/// After that, it removes the empty strings in the glossary
List<String> getCleanGlossary(List<TextEditingController> glossary,
    List<List<Ingredient>> cleanIngredientsData) {
  List<String> output = new List<String>();
  for (int i = 0; i < glossary.length; i++) {
    output.add(glossary[i].text);
  }

  for (int i = cleanIngredientsData.length; i < glossary.length; i++) {
    output.removeLast();
  }
  for (int i = 0; i < output.length; i++) {
    if (output[i] == '') output.removeAt(i);
  }

  return output;
}

/// removes all leading and trailing whitespaces and empty ingredients from the lists
/// of ingredients and
List<List<Ingredient>> getCleanIngredientData(
    List<List<TextEditingController>> ingredients,
    List<List<TextEditingController>> amount,
    List<List<TextEditingController>> unit) {
  /// creating the three lists with the data of the ingredients
  /// by getting the data of the controllers.
  List<List<String>> ingredientsNames = [[]];
  for (int i = 0; i < ingredients.length; i++) {
    ingredientsNames.add([]);
    for (int j = 0; j < ingredients[i].length; j++) {
      ingredientsNames[i].add(ingredients[i][j].text);
    }
  }

  List<List<double>> ingredientsAmount = new List<List<double>>();
  for (int i = 0; i < amount.length; i++) {
    ingredientsAmount.add(new List<double>());
    for (int j = 0; j < amount[i].length; j++) {
      String addValue = "-1";
      if (amount[i][j].text != "") addValue = amount[i][j].text;
      ingredientsAmount[i]
          .add(double.parse(addValue.replaceAll(new RegExp(r','), 'e')));
    }
  }

  List<List<String>> ingredientsUnit = new List<List<String>>();
  for (int i = 0; i < unit.length; i++) {
    ingredientsUnit.add(new List<String>());
    for (int j = 0; j < unit[i].length; j++) {
      ingredientsUnit[i].add(unit[i][j].text);
    }
  }

  /// List which will be the clean list with the list of the ingredients
  /// data.
  List<List<Ingredient>> cleanIngredientsData = [[]];

  for (int i = 0; i < ingredientsNames.length; i++) {
    cleanIngredientsData.add([]);
    for (int j = 0; j < ingredientsNames[i].length; j++)
      cleanIngredientsData[i].add(Ingredient(
        name: ingredientsNames[i][j],
        amount: ingredientsAmount[i][j],
        unit: ingredientsUnit[i][j],
      ));
  }

  for (int i = 0; i < cleanIngredientsData.length; i++) {
    for (int j = 0; j < cleanIngredientsData[i].length; j++) {
      // remove leading and trailing white spaces
      cleanIngredientsData[i][j].name = cleanIngredientsData[i][j].name.trim();
      cleanIngredientsData[i][j].unit = cleanIngredientsData[i][j].unit.trim();
      // remove all ingredients from the list, when all three fields are empty
      if (cleanIngredientsData[i][j].name == "" &&
          cleanIngredientsData[i][j].amount == -1 &&
          cleanIngredientsData[i][j].unit == "") {
        cleanIngredientsData[i].removeAt(j);
      }
    }
  }
  // create the output list with the clean ingredient lists
  cleanIngredientsData.removeWhere((item) => item.isEmpty);

  return cleanIngredientsData;
}
