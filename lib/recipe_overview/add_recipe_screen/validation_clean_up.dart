import 'package:flutter/material.dart';
import 'package:my_recipe_book/helper.dart';

import '../../database.dart';
import '../../models/ingredient.dart';

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

  Validator validateIngredientsData(
    GlobalKey<FormState> formKey,
    List<List<TextEditingController>> ingredientNameController,
    List<List<TextEditingController>> ingredientAmountController,
    List<List<TextEditingController>> ingredientUnitController,
    List<TextEditingController> ingredientGlossaryController,
  ) {
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
    else {
      return Validator.VALID;
    }
  }

  Future<Validator> validateGeneralInfo(GlobalKey<FormState> formKey,
      bool editingRecipe, String recipeName) async {
    if (!formKey.currentState.validate())
      return Validator.REQUIRED_FIELDS;
    else if (!editingRecipe && await DBProvider.db.doesRecipeExist(recipeName))
      return Validator.NAME_TAKEN;
    else
      return Validator.VALID;
  }

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
    for (int i = 0; i < ingredients.length; i++) {
      for (int j = 0; j < ingredients[i].length; j++) {
        if (ingredients[i][j].text == "") {
          if (amount[i][j].text != "" || unit[i][j].text != "") return false;
        } else {
          if (amount[i][j].text == "" && unit[i][j].text != "") return false;
        }
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

/// creating list of list of ingredients with the data of the
/// textEditingControllers. All lists must be the same size.
/// The amount will be converted to a double, because the recipe
/// saves the amount as a double
List<List<Ingredient>> getIngredientsList(
    List<List<TextEditingController>> ingredientNamesContr,
    List<List<TextEditingController>> amountContr,
    List<List<TextEditingController>> unitContr) {
  List<List<Ingredient>> ingredients = [];

  for (int i = 0; i < ingredientNamesContr.length; i++) {
    ingredients.add([]);
    for (int j = 0; j < ingredientNamesContr[i].length; j++) {
      String ingredientName = ingredientNamesContr[i][j].text;
      double amount = validateNumber(amountContr[i][j].text)
          ? double.parse(
              amountContr[i][j].text.replaceAll(new RegExp(r','), 'e'))
          : null;
      String unit = unitContr[i][j].text;
      ingredients[i]
          .add(Ingredient(name: ingredientName, amount: amount, unit: unit));
    }
  }

  return ingredients;
}

/// removes all leading and trailing whitespaces and empty ingredients from the lists
/// of ingredients and
List<List<Ingredient>> getCleanIngredientData(
    List<List<TextEditingController>> ingredients,
    List<List<TextEditingController>> amount,
    List<List<TextEditingController>> unit) {
  /// creating the three lists with the data of the ingredients
  /// by getting the data of the controllers.
  List<List<String>> ingredientsNames = ingredients
      .map((list) => list.map((ingredient) => ingredient.text).toList())
      .toList();

  List<List<double>> ingredientsAmount = amount
      .map((list) => list.map((amount) {
            if (amount.text != "") {
              String addValue = amount.text;
              return double.parse(addValue.replaceAll(new RegExp(r','), 'e'));
            } else {
              return null;
            }
          }).toList())
      .toList();

  List<List<String>> ingredientsUnit = unit
      .map((list) =>
          list.map((unit) => unit.text == '' ? null : unit.text).toList())
      .toList();

  /// List which will be the clean list with the list of the ingredients
  /// data.
  List<List<Ingredient>> cleanIngredientsData = [[]];

  for (int i = 0; i < ingredientsNames.length; i++) {
    cleanIngredientsData.add([]);
    for (int j = 0; j < ingredientsNames[i].length; j++) {
      // remove leading and trailing spaces
      String name = ingredientsNames[i][j].trim();
      // only add ingredient if the name is not empty
      if (name != "") {
        String unit;
        // trim unit if not empty
        if (ingredientsUnit[i][j] != null) unit = ingredientsUnit[i][j].trim();
        // add the ingredient with modified data
        cleanIngredientsData[i].add(Ingredient(
          name: name,
          amount: ingredientsAmount[i][j],
          unit: unit,
        ));
      }
    }
  }

  // create the output list with the clean ingredient lists
  cleanIngredientsData.removeWhere((item) => item.isEmpty);

  return cleanIngredientsData;
}
