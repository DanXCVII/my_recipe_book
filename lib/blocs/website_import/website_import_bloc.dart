import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/constants/global_constants.dart';
import 'package:my_recipe_book/local_storage/hive.dart';
import 'package:my_recipe_book/local_storage/io_operations.dart' as IO;
import 'package:my_recipe_book/local_storage/local_paths.dart';
import 'package:my_recipe_book/models/tuple.dart';

import '../../models/enums.dart';
import '../../models/ingredient.dart';
import '../../models/nutrition.dart';
import '../../models/recipe.dart';
import '../../models/string_int_tuple.dart';

part 'website_import_event.dart';
part 'website_import_state.dart';

enum ImportState { SUCCESS, DUPLICATE, FAIL }

class WebsiteImportBloc extends Bloc<WebsiteImportEvent, WebsiteImportState> {
  final RecipeManagerBloc recipeManagerBloc;

  WebsiteImportBloc(this.recipeManagerBloc);

  @override
  WebsiteImportState get initialState => ReadyToImport();

  @override
  Stream<WebsiteImportState> mapEventToState(
    WebsiteImportEvent event,
  ) async* {
    if (event is ImportRecipe) {
      yield* _mapImportRecipeToState(event);
    }
  }

  Stream<WebsiteImportState> _mapImportRecipeToState(
      ImportRecipe event) async* {
    yield ImportingRecipe();

    var response;
    try {
      response = await http.get(event.url);
    } catch (e) {
      yield InvalidUrl();
    }
    if (response == null) {
      return;
    }
    if (response.statusCode == 200) {
      String httpWebsite = response.body;

      Tuple2<ImportState, Recipe> importRecipe;

      if (event.url.contains("chefkoch.de")) {
        importRecipe = await getRecipeFromChefKData(httpWebsite, event.url);
      } else if (event.url.contains("elavegan.com")) {
        importRecipe = await getRecipeFromElaVeganData(httpWebsite, event.url);
      } else if (event.url.contains("kochbar.de")) {
        importRecipe = await getRecipeFromKochBData(httpWebsite, event.url);
      } else {
        yield InvalidUrl();
        return;
      }
      if (importRecipe.item1.toString() == ImportState.FAIL.toString()) {
        yield FailedImportingRecipe(event.url);
        return;
      } else if (importRecipe.item1 == ImportState.DUPLICATE) {
        yield AlreadyExists(importRecipe.item2.name);
      } else {
        yield ImportedRecipe(importRecipe.item2);
        return;
      }
    } else {
      yield FailedToConnect();
    }
  }

  Future<Tuple2<ImportState, Recipe>> getRecipeFromElaVeganData(
      String websiteData, String url) async {
    try {
      String halfCut = websiteData.substring(websiteData.indexOf(
              "<script type='application/ld+json' class='yoast-schema-graph yoast-schema-graph--main'>") +
          87);
      String recipeJsonString =
          halfCut.substring(0, halfCut.indexOf("</script>"));
      List<dynamic> jsonList = await json.decode(recipeJsonString)["@graph"];
      Map<String, dynamic> jsonMap = jsonList.last;

      if (HiveProvider().getRecipeNames().contains(jsonMap["name"])) {
        return Tuple2<ImportState, Recipe>(ImportState.DUPLICATE,
            await HiveProvider().getRecipeByName(jsonMap["name"]));
      }

      List<dynamic> stepsList = jsonMap["recipeInstructions"];
      List<String> steps = stepsList.map((map) {
        return map["text"].toString();
      }).toList();
      List<Nutrition> recipeNutritions =
          _getElaVNutritions(jsonMap["nutrition"]);

      Recipe importRecipe = Recipe(
        name: jsonMap["name"],
        lastModified: DateTime.now().toIso8601String(),
        servings: double.parse(jsonMap["recipeYield"]),
        preperationTime: getMinFromElaVFormat(jsonMap["prepTime"]),
        cookingTime: getMinFromElaVFormat(jsonMap["cookTime"]),
        totalTime: getMinFromElaVFormat(jsonMap["totalTime"]),
        steps: steps,
        stepImages: List<List<String>>.generate(steps.length, (i) => []),
        nutritions: recipeNutritions,
        vegetable: Vegetable.VEGAN,
        ingredients: [
          jsonMap["recipeIngredient"]
              .map<Ingredient>((item) => _getIngredientFromElaVFormat(item))
              .toList()
        ],
        source: url,
      );

      List<String> savedNutritions = HiveProvider().getNutritions();
      for (Nutrition n in recipeNutritions) {
        if (!savedNutritions.contains(n.name)) {
          await HiveProvider().addNutrition(n.name);
        }
      }

      String importRecipeImagePath =
          await PathProvider.pP.getImportDir() + "/importRecipeImage.jpg";

      await Dio().download(
        jsonMap["image"].first,
        importRecipeImagePath,
      );
      await IO.saveRecipeImage(
          File(importRecipeImagePath), newRecipeLocalPathString);

      Recipe finalRecipe = importRecipe.copyWith(
        imagePath: await PathProvider.pP
            .getRecipeImagePathFull(newRecipeLocalPathString, ".jpg"),
        imagePreviewPath: await PathProvider.pP
            .getRecipeImagePreviewPathFull(newRecipeLocalPathString, ".jpg"),
      );

      if (finalRecipe != null) {
        HiveProvider().saveTmpRecipe(finalRecipe);
      } else {
        return Tuple2<ImportState, Recipe>(
          ImportState.FAIL,
          null,
        );
      }
      return Tuple2<ImportState, Recipe>(
        ImportState.SUCCESS,
        finalRecipe,
      );
    } catch (e) {
      return Tuple2<ImportState, Recipe>(ImportState.FAIL, null);
    }
    return Tuple2<ImportState, Recipe>(ImportState.FAIL, null);
  }

  Future<Tuple2<ImportState, Recipe>> getRecipeFromChefKData(
      String websiteData, String url) async {
    try {
      String halfCut = websiteData.substring(
          websiteData.lastIndexOf("<script type=\"application/ld+json\">") +
              38);
      String recipeJsonString =
          halfCut.substring(0, halfCut.indexOf("</script>"));
      Map<String, dynamic> jsonMap = await json.decode(recipeJsonString);

      List<String> steps =
          _getStepsFromChefKFormat(jsonMap["recipeInstructions"]);

      if (HiveProvider().getRecipeNames().contains(jsonMap["name"])) {
        return Tuple2<ImportState, Recipe>(ImportState.DUPLICATE,
            await HiveProvider().getRecipeByName(jsonMap["name"]));
      }

      List<Nutrition> recipeNutritions = jsonMap.containsKey("nutrition")
          ? List<Nutrition>.generate(
              jsonMap["nutrition"].keys.length - 1,
              (index) => Nutrition(
                  name: jsonMap["nutrition"].keys.toList()[index + 1],
                  amountUnit: jsonMap["nutrition"]
                      [jsonMap["nutrition"].keys.toList()[index + 1]]))
          : [];

      Recipe importRecipe = Recipe(
        name: jsonMap["name"],
        preperationTime: getMinFromChefKFormat(jsonMap["prepTime"]),
        totalTime: getMinFromChefKFormat(jsonMap["totalTime"]),
        lastModified: DateTime.now().toIso8601String(),
        servings: double.parse(jsonMap["recipeYield"]
            .substring(0, jsonMap["recipeYield"].toString().indexOf(" "))),
        effort: 5,
        ingredients: [
          List<String>.from(jsonMap["recipeIngredient"])
              .map((item) => _getIngredientFromChefKFormat(item))
              .toList()
        ],
        vegetable: _getVegetableFromChefKFormat(
            List<String>.from(jsonMap["keywords"])),
        steps: steps,
        stepImages: List<List<String>>.generate(steps.length, (i) => []),
        nutritions: recipeNutritions,
        source: url,
      );

      List<String> savedNutritions = HiveProvider().getNutritions();
      for (Nutrition n in recipeNutritions) {
        if (!savedNutritions.contains(n.name)) {
          await HiveProvider().addNutrition(n.name);
        }
      }

      String importRecipeImagePath =
          await PathProvider.pP.getImportDir() + "/importRecipeImage.jpg";

      await Dio().download(
        jsonMap["image"],
        importRecipeImagePath,
      );
      await IO.saveRecipeImage(
          File(importRecipeImagePath), newRecipeLocalPathString);

      Recipe finalRecipe = importRecipe.copyWith(
        imagePath: await PathProvider.pP
            .getRecipeImagePathFull(newRecipeLocalPathString, ".jpg"),
        imagePreviewPath: await PathProvider.pP
            .getRecipeImagePreviewPathFull(newRecipeLocalPathString, ".jpg"),
      );

      if (finalRecipe != null) {
        HiveProvider().saveTmpRecipe(finalRecipe);
      } else {
        return Tuple2<ImportState, Recipe>(
          ImportState.FAIL,
          null,
        );
      }
      return Tuple2<ImportState, Recipe>(
        ImportState.SUCCESS,
        finalRecipe,
      );
    } catch (e) {
      return Tuple2<ImportState, Recipe>(ImportState.FAIL, null);
    }
    return Tuple2<ImportState, Recipe>(ImportState.FAIL, null);
  }

  Future<Tuple2<ImportState, Recipe>> getRecipeFromKochBData(
      String websiteData, String url) async {
    try {
      String halfCut = websiteData.substring(
          websiteData.lastIndexOf("<script type=\"application/ld+json\">") +
              35);
      String recipeJsonString =
          halfCut.substring(0, halfCut.indexOf("</script>"));
      Map<String, dynamic> jsonMap = await json.decode(recipeJsonString);

      if (HiveProvider().getRecipeNames().contains(jsonMap["name"])) {
        return Tuple2<ImportState, Recipe>(ImportState.DUPLICATE,
            await HiveProvider().getRecipeByName(jsonMap["name"]));
      }

      List<String> steps =
          List<dynamic>.from(jsonMap["recipeInstructions"]).map((map) {
        return map["text"].toString();
      }).toList();
      List<Nutrition> recipeNutritions =
          _getElaVNutritions(jsonMap["nutrition"]);

      Recipe importRecipe = Recipe(
        name: jsonMap["name"],
        lastModified: DateTime.now().toIso8601String(),
        servings: double.tryParse(jsonMap["recipeYield"]
            .substring(0, jsonMap["recipeYield"].indexOf(" "))),
        preperationTime: getMinFromElaVFormat(jsonMap["prepTime"]),
        cookingTime: getMinFromElaVFormat(jsonMap["cookTime"]),
        totalTime: getMinFromElaVFormat(jsonMap["totalTime"]),
        steps: steps,
        stepImages: List<List<String>>.generate(steps.length, (i) => []),
        nutritions: recipeNutritions,
        vegetable: _getVegetableFromChefKFormat(
            List<String>.from(jsonMap["recipeCategory"])),
        ingredients: [
          jsonMap["recipeIngredient"]
              .map<Ingredient>((item) => _getIngredientFromChefKFormat(
                  double.tryParse(item[0]) == null ? " $item" : item))
              .toList()
        ],
        source: url,
      );

      List<String> savedNutritions = HiveProvider().getNutritions();
      for (Nutrition n in recipeNutritions) {
        if (!savedNutritions.contains(n.name)) {
          await HiveProvider().addNutrition(n.name);
        }
      }

      String importRecipeImagePath =
          await PathProvider.pP.getImportDir() + "/importRecipeImage.jpg";

      await Dio().download(
        jsonMap["image"],
        importRecipeImagePath,
      );
      await IO.saveRecipeImage(
          File(importRecipeImagePath), newRecipeLocalPathString);

      Recipe finalRecipe = importRecipe.copyWith(
        imagePath: await PathProvider.pP
            .getRecipeImagePathFull(newRecipeLocalPathString, ".jpg"),
        imagePreviewPath: await PathProvider.pP
            .getRecipeImagePreviewPathFull(newRecipeLocalPathString, ".jpg"),
      );

      if (finalRecipe != null) {
        HiveProvider().saveTmpRecipe(finalRecipe);
      } else {
        return Tuple2<ImportState, Recipe>(
          ImportState.FAIL,
          null,
        );
      }
      return Tuple2<ImportState, Recipe>(
        ImportState.SUCCESS,
        finalRecipe,
      );
    } catch (e) {
      return Tuple2<ImportState, Recipe>(ImportState.FAIL, null);
    }
    return Tuple2<ImportState, Recipe>(ImportState.FAIL, null);
  }

  /// the format must be like "P0DT0H30M" where
  /// number before D declarates the amount of days,
  /// number before H declarates the amount of hours and
  /// number before M declarates the amount of minutes
  double getMinFromChefKFormat(String numberString) {
    double totalMinutes = 0;
    totalMinutes +=
        int.parse(numberString.substring(1, numberString.indexOf("D"))) * 1440;
    totalMinutes += int.parse(numberString.substring(
            numberString.indexOf("T") + 1, numberString.indexOf("H"))) *
        60;
    totalMinutes += int.parse(numberString.substring(
        numberString.indexOf("H") + 1, numberString.indexOf("M")));

    return totalMinutes;
  }

  /// the format must be like:
  /// with all info: "1 TL Gew\u00fcrzmischung (Garam Masala)"
  /// with no unit: "1  Gew\u00fcrzmischung (Garam Masala)"
  /// with no amount: "evtl. Gew\u00fcrzmischung (Garam Masala)"
  /// with not unit and amount: " Gew\u00fcrzmischung (Garam Masala)"
  Ingredient _getIngredientFromChefKFormat(String ingredientInfo) {
    String name;
    double amount;
    String unit;

    try {
      // with no amount: "evtl. Gew\u00fcrzmischung (Garam Masala)"
      if (!(int.tryParse(ingredientInfo[0]) != null ||
              ingredientInfo[0] == "½" ||
              ingredientInfo[0] == "¼") &&
          ingredientInfo[0] != " ") {
        name = ingredientInfo.substring(
            ingredientInfo.indexOf(" ") + 1, ingredientInfo.length);
      } else {
        bool hasUnitAmount = true;
        // with not unit and amount: " Gew\u00fcrzmischung (Garam Masala)"
        if (ingredientInfo.startsWith(" ")) {
          name = ingredientInfo.substring(1);
        } else {
          if (!ingredientInfo.contains("n. B.")) {
            String amountInfo =
                ingredientInfo.substring(0, ingredientInfo.indexOf(" "));
            ingredientInfo.substring(0, ingredientInfo.indexOf(" "));
            if (amountInfo == "½") {
              amount = 0.5;
            } else if (amountInfo == "¼")
              amount = 0.25;
            else {
              try {
                amount = double.parse(amountInfo);
              } catch (e) {
                print(e.toString());
                amount = 0;
              }
            }
          } else {
            hasUnitAmount = false;
          }

          if (ingredientInfo.contains("  ")) {
            name = ingredientInfo.substring(ingredientInfo.indexOf("  ") + 2);
          } else {
            String ingredientInfoNoAmnt =
                ingredientInfo.substring(ingredientInfo.indexOf(" ") + 1);

            if (ingredientInfoNoAmnt.contains("EL, ") ||
                ingredientInfoNoAmnt.contains("gr. ") ||
                ingredientInfoNoAmnt.contains("kl. ") ||
                ingredientInfoNoAmnt.contains("TL. ")) {
              unit = hasUnitAmount
                  ? ingredientInfoNoAmnt.substring(
                      0, ingredientInfoNoAmnt.indexOf(" ", 5))
                  : null;
              name = ingredientInfoNoAmnt
                  .substring(ingredientInfoNoAmnt.indexOf(" ", 5));
            } else {
              unit = hasUnitAmount
                  ? ingredientInfoNoAmnt.substring(
                      0, ingredientInfoNoAmnt.indexOf(" "))
                  : null;
              name = ingredientInfoNoAmnt
                  .substring(ingredientInfoNoAmnt.indexOf(" ") + 1);
            }
          }
        }
      }
    } catch (e) {
      // if whatever goes wrong when parsing, catch the exception
    }
    return Ingredient(name: name, unit: unit, amount: amount);
  }

  List<String> _getStepsFromChefKFormat(String stepsInfo) {
    List<String> steps = [];

    String cutStepInfo = stepsInfo;
    print(stepsInfo);
    if (cutStepInfo.contains("\n\r\n")) {
      cutStepInfo += "\n\r\n";
      while (cutStepInfo.contains("\n\r\n")) {
        steps.add(cutStepInfo.substring(0, cutStepInfo.indexOf("\n\r\n")));
        cutStepInfo = cutStepInfo.substring(cutStepInfo.indexOf("\n\r\n") + 3);
      }
    } else if (cutStepInfo.contains("\n\n")) {
      cutStepInfo += "\n\n";
      while (cutStepInfo.contains("\n\n")) {
        steps.add(cutStepInfo.substring(0, cutStepInfo.indexOf("\n\n")));
        cutStepInfo = cutStepInfo.substring(cutStepInfo.indexOf("\n\n") + 2);
      }
    } else {
      steps.add(stepsInfo);
    }

    return steps..removeWhere((item) => item.length <= 1);
  }

  /// checks if the list contains vegan (1 prio) or vegetarisch
  Vegetable _getVegetableFromChefKFormat(List<String> keywords) {
    for (String keyword in keywords) {
      if (keyword.toLowerCase().contains("vegan")) {
        return Vegetable.VEGAN;
      } else if (keyword.toLowerCase().contains("vegetarisch")) {
        return Vegetable.VEGETARIAN;
      }
    }

    return Vegetable.NON_VEGETARIAN;
  }

  /// the format must be like "PT15M" where
  /// the total minutes are between PT and M (if null, returns null)
  double getMinFromElaVFormat(String numberString) {
    return numberString == null
        ? null
        : double.tryParse(numberString.substring(2, numberString.indexOf("M")));
  }

  /// the format must be like:
  /// with all info: "1/2 TL Gew\u00fcrzmischung (Garam Masala)"
  /// with no unit: "1  Gew\u00fcrzmischung (Garam Masala)"
  /// with no amount: "evtl. Gew\u00fcrzmischung (Garam Masala)"
  /// with not unit and amount: "Gew\u00fcrzmischung (Garam Masala)"
  Ingredient _getIngredientFromElaVFormat(String ingredientInfo) {
    String name;
    double amount;
    String unit;

    String ingredientInfoAmount =
        ingredientInfo.substring(0, ingredientInfo.indexOf(" "));
    String nameUnitInfo;

    bool hasAmount = false;
    try {
      if (double.tryParse(ingredientInfoAmount[0]) != null) {
        if (ingredientInfoAmount.contains("/")) {
          double firstNumber = double.parse(ingredientInfoAmount.substring(
              0, ingredientInfoAmount.indexOf("/")));
          double secondNumber = double.parse(ingredientInfoAmount
              .substring(ingredientInfoAmount.indexOf("/") + 1));
          amount = firstNumber / secondNumber;
        }
        if (amount == null) {
          amount = double.tryParse(ingredientInfoAmount);
        }
        if (amount == null) {
          nameUnitInfo = ingredientInfo;
        } else {
          nameUnitInfo =
              ingredientInfo.substring(ingredientInfo.indexOf(" ") + 1);
        }
        if (nameUnitInfo.startsWith(" ")) {
          name = nameUnitInfo.substring(1);
        } else {
          unit = nameUnitInfo.substring(0, nameUnitInfo.indexOf(" "));
          name = nameUnitInfo.substring(nameUnitInfo.indexOf(" ") + 1);
        }
      } else {
        name = ingredientInfo;
      }
    } catch (e) {
      // if whatever goes wrong when parsing, catch the exception
    }

    return Ingredient(name: name, unit: unit, amount: amount);
  }

  /// example:
  /// "nutrition": {
  ///   "@type": "NutritionInformation",
  ///   "calories": "226 kcal",
  ///   "fatContent": "12,3979 g",
  ///   "proteinContent": "13,4402 g",
  ///   "carbohydrateContent": "15,0834 g",
  ///   "servingSize": "100 g"
  /// }
  List<Nutrition> _getElaVNutritions(Map<String, dynamic> nutritionData) {
    return nutritionData.keys
        .map((key) => key == "@type"
            ? null
            : Nutrition(
                name: key.replaceAll("Content", ""),
                amountUnit: nutritionData[key],
              ))
        .toList()
          ..removeWhere((item) => item == null);
  }
}
