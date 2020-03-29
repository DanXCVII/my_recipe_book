import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
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
      } else {
        yield InvalidUrl();
        return;
      }
      if (importRecipe == null) {
        yield FailedImportingRecipe(event.url);
        return;
      } else if (importRecipe.item1 == ImportState.DUPLICATE) {
        yield AlreadyExists(importRecipe.item2.name);
      } else {
        recipeManagerBloc.add(RMAddRecipes([importRecipe.item2]));
        yield ImportedRecipe(importRecipe.item2);
        return;
      }
    } else {
      yield FailedToConnect();
    }
  }

  Future<Tuple2<ImportState, Recipe>> getRecipeFromChefKData(
      String websiteData, String url) async {
    String halfCut = websiteData.substring(
        websiteData.lastIndexOf("<script type=\"application/ld+json\">") + 38);
    String recipeJsonString =
        halfCut.substring(0, halfCut.indexOf("</script>"));
    Map<String, dynamic> jsonMap = await json.decode(recipeJsonString);

    try {
      List<String> steps =
          _getStepsFromChefKFormat(jsonMap["recipeInstructions"]);

      if (HiveProvider().getRecipeNames().contains(jsonMap["name"])) {
        return Tuple2<ImportState, Recipe>(ImportState.DUPLICATE,
            await HiveProvider().getRecipeByName(jsonMap["name"]));
      }

      Recipe importRecipe = Recipe(
        name: jsonMap["name"],
        preperationTime: getMinFromChefKFormat(jsonMap["prepTime"]),
        totalTime: getMinFromChefKFormat(jsonMap["totalTime"]),
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
        nutritions: jsonMap.containsKey("nutrition")
            ? List<Nutrition>.generate(
                jsonMap["nutrition"].keys.length - 1,
                (index) => Nutrition(
                    name: jsonMap["nutrition"].keys.toList()[index + 1],
                    amountUnit: jsonMap["nutrition"]
                        [jsonMap["nutrition"].keys.toList()[index + 1]]))
            : [],
        tags: List<String>.from(jsonMap["keywords"])
            .map(
              (item) => StringIntTuple(
                text: item.toString(),
                number: HiveProvider().getRecipeTags().firstWhere(
                            (tag) => tag.text == item.toString(),
                            orElse: () => null) ==
                        null
                    ? 4278238420
                    : HiveProvider()
                        .getRecipeTags()
                        .firstWhere(
                          (tag) => tag.text == item.toString(),
                        )
                        .number,
              ),
            )
            .toList(),
        source: url,
      );

      String importRecipeImagePath =
          await PathProvider.pP.getImportDir() + "importRecipeImage.jpg";

      await Dio().download(
        jsonMap["image"],
        importRecipeImagePath,
      );
      await IO.saveRecipeImage(File(importRecipeImagePath), jsonMap["name"]);

      return Tuple2<ImportState, Recipe>(
        ImportState.SUCCESS,
        importRecipe.copyWith(
          imagePath: await PathProvider.pP
              .getRecipeImagePathFull(jsonMap["name"], ".jpg"),
          imagePreviewPath: await PathProvider.pP
              .getRecipeImagePreviewPathFull(jsonMap["name"], ".jpg"),
        ),
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
  /// with not unit and amount: " Gew\u00fcrzmischung (Garam Masala)"
  Ingredient _getIngredientFromChefKFormat(String ingredientInfo) {
    String name;
    double amount;
    String unit;

    if (ingredientInfo.startsWith(" ")) {
      name = ingredientInfo.substring(1);
    } else {
      String amountInfo =
          ingredientInfo.substring(0, ingredientInfo.indexOf(" "));
      if (amountInfo == "½") {
        amount = 0.5;
      } else if (amountInfo == "¼")
        amount = 0.25;
      else {
        try {
          double.parse(amountInfo);
        } catch (e) {
          print(e.toString());
          amount = 0;
        }
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
          unit = ingredientInfoNoAmnt.substring(
              0, ingredientInfoNoAmnt.indexOf(" ", 5));
          name = ingredientInfoNoAmnt
              .substring(ingredientInfoNoAmnt.indexOf(" ", 5));
        } else {
          unit = ingredientInfoNoAmnt.substring(
              0, ingredientInfoNoAmnt.indexOf(" "));
          name = ingredientInfoNoAmnt
              .substring(ingredientInfoNoAmnt.indexOf(" ") + 1);
        }
      }
    }
    return Ingredient(name: name, unit: unit, amount: amount);
  }

  List<String> _getStepsFromChefKFormat(String stepsInfo) {
    List<String> steps = [];

    String cutStepInfo = stepsInfo + "\n";
    while (cutStepInfo.contains("\n")) {
      steps.add(cutStepInfo.substring(0, cutStepInfo.indexOf("\n")));
      cutStepInfo = cutStepInfo.substring(cutStepInfo.indexOf("\n") + 1);
    }

    return steps..removeWhere((item) => item.length <= 1);
  }

  Vegetable _getVegetableFromChefKFormat(List<String> keywords) {
    for (String keyword in keywords) {
      if (keyword.toLowerCase().contains("vegetarisch")) {
        return Vegetable.VEGETARIAN;
      } else if (keyword.toLowerCase().contains("vegan")) {
        return Vegetable.VEGAN;
      }
    }

    return Vegetable.NON_VEGETARIAN;
  }
}
