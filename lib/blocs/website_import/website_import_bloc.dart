import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../constants/global_constants.dart';
import '../../local_storage/hive.dart';
import '../../local_storage/io_operations.dart' as IO;
import '../../local_storage/local_paths.dart';
import '../../models/enums.dart';
import '../../models/ingredient.dart';
import '../../models/nutrition.dart';
import '../../models/recipe.dart';
import '../../models/tuple.dart';
import '../../util/recipe_extractor.dart';
import '../recipe_manager/recipe_manager_bloc.dart';

part 'website_import_event.dart';
part 'website_import_state.dart';

enum ImportState { SUCCESS, DUPLICATE, FAIL }

class WebsiteImportBloc extends Bloc<WebsiteImportEvent, WebsiteImportState> {
  final RecipeManagerBloc recipeManagerBloc;

  WebsiteImportBloc(this.recipeManagerBloc) : super(ReadyToImport());

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

    bool hasInternetConnection;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasInternetConnection = true;
      }
    } on SocketException catch (_) {
      hasInternetConnection = false;
    }
    if (!hasInternetConnection) {
      yield FailedToConnect();
      return;
    }

    var response;

    try {
      response = await http.get(event.url);
    } catch (e) {
      yield InvalidUrl();
      return;
    }

    // just a safety check
    if (response == null) {
      return;
    }

    if (response.statusCode == 200) {
      String httpWebsite = response.body;

      Tuple2<ImportState, Recipe> importRecipe;

      Map<String, dynamic> recipeMap =
          await _tryGetRecipeRecipeMap(httpWebsite);

      if (recipeMap != null) {
        importRecipe = await _getRecipeFromSchemaRecipe(recipeMap, event.url);
      } else if (event.url.contains("allrecipes.com")) {
        importRecipe =
            await getRecipeFromAllRecipesData(httpWebsite, event.url);
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
        await HiveProvider().saveTmpRecipe(importRecipe.item2);

        yield ImportedRecipe(importRecipe.item2);
        return;
      }
    } else {
      yield FailedToConnect();
    }
  }

  Future<Tuple2<ImportState, Recipe>> getRecipeFromAllRecipesData(
      String websiteData, String url) async {
    try {
      Recipe finalRecipe;
      String httpRecipeContent = websiteData.substring(
          websiteData.indexOf("<h1 id=\"recipe-main-content\""),
          websiteData.indexOf("see-full-nutrition"));

      String recipeName = httpRecipeContent.substring(
          httpRecipeContent.indexOf(">") + 1,
          httpRecipeContent.indexOf("<", 3));
      if (HiveProvider().getRecipeNames().contains(recipeName)) {
        return Tuple2<ImportState, Recipe>(ImportState.DUPLICATE,
            await HiveProvider().getRecipeByName(recipeName));
      }

      List<String> steps = _getStepsFromAllRecipes(httpRecipeContent);
      List<Nutrition> recipeNutritions = [];
      if (httpRecipeContent.contains("nutrition-summary-facts")) {
        recipeNutritions = _getNutritionsFromAllRecipes(httpRecipeContent
            .substring(httpRecipeContent.indexOf("nutrition-summary-facts")));
      }
      List<List<Ingredient>> ingredients = [
        _getIngredientStringFromAllRecipes(httpRecipeContent)
            .map((item) => getIngredientFromString(item))
            .toList()
              ..removeWhere((item) => item == null)
      ];
      List<double> times = _getTimesFromHttpData(
        httpRecipeContent.substring(
          httpRecipeContent.indexOf("<time itemprop=\"prepTime\""),
          httpRecipeContent.indexOf(
            "recipeInstructions",
            httpRecipeContent.indexOf("<time itemprop=\"prepTime\""),
          ),
        ),
      );

      Recipe importRecipe = Recipe(
        name: recipeName,
        lastModified: DateTime.now().toIso8601String(),
        servings: null,
        preperationTime: times[0],
        cookingTime: times[1],
        totalTime: times[2],
        steps: steps,
        stepImages: List<List<String>>.generate(steps.length, (i) => []),
        nutritions: recipeNutritions,
        vegetable: Vegetable.NON_VEGETARIAN,
        ingredients: ingredients,
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
        _getRecipeImageStringFromAllRecipes(httpRecipeContent),
        importRecipeImagePath,
      );
      await IO.saveRecipeImage(
          File(importRecipeImagePath), newRecipeLocalPathString);

      finalRecipe = importRecipe.copyWith(
        imagePath: await PathProvider.pP
            .getRecipeImagePathFull(newRecipeLocalPathString, ".jpg"),
        imagePreviewPath: await PathProvider.pP
            .getRecipeImagePreviewPathFull(newRecipeLocalPathString, ".jpg"),
      );

      if (finalRecipe == null) {
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
  }

  /// accepts the format
  /// returns first index: full res image,
  /// second index: low res image
  /// "image": {"url": "url..."}
  /// "image": [url...]
  /// "image": url...
  Future<List<String>> _getImageFromSchemaRecipe(
      Map<String, dynamic> recipeMap) async {
    String importRecipeImagePath =
        await PathProvider.pP.getImportDir() + "/importRecipeImage.jpg";

    String recipeImageUrl;

    bool gotImage = false;

    try {
      recipeImageUrl = recipeMap["image"].first;
      gotImage = true;
    } catch (e) {}
    if (!gotImage) {
      try {
        recipeImageUrl = recipeMap["image"]["url"];
        gotImage = true;
      } catch (e) {}
    }
    if (!gotImage) {
      try {
        recipeImageUrl = recipeMap["image"];
        gotImage = true;
      } catch (e) {}
    }
    if (!gotImage) {
      try {
        recipeImageUrl = recipeMap["image"].first["url"];
        gotImage = true;
      } catch (e) {}
    }

    if (gotImage) {
      await Dio().download(
        recipeImageUrl,
        importRecipeImagePath,
      );
      await IO.saveRecipeImage(
          File(importRecipeImagePath), newRecipeLocalPathString);

      return [
        await PathProvider.pP
            .getRecipeImagePathFull(newRecipeLocalPathString, ".jpg"),
        await PathProvider.pP
            .getRecipeImagePreviewPathFull(newRecipeLocalPathString, ".jpg")
      ];
    } else {
      return null;
    }
  }

  Future<Tuple2<ImportState, Recipe>> _getRecipeFromSchemaRecipe(
      Map<String, dynamic> recipeMap, String url) async {
    if (HiveProvider().getRecipeNames().contains(recipeMap["name"])) {
      return Tuple2<ImportState, Recipe>(ImportState.DUPLICATE,
          await HiveProvider().getRecipeByName(recipeMap["name"]));
    }

    try {
      Map<String, double> recipeTimes = _getTimesFromSchemaRecipe(recipeMap);
      List<String> recipeImagePaths =
          await _getImageFromSchemaRecipe(recipeMap);
      List<Nutrition> recipeNutritions =
          _getNutritionsFromSchemaRecipe(recipeMap);

      List<String> savedNutritions = HiveProvider().getNutritions();
      for (Nutrition n in recipeNutritions) {
        if (!savedNutritions.contains(n.name)) {
          await HiveProvider().addNutrition(n.name);
        }
      }
      List<String> recipeSteps = _getStepsFromSchemaRecipe(recipeMap);

      Recipe finalRecipe = Recipe(
        name: recipeMap["name"],
        imagePath: recipeImagePaths[0],
        imagePreviewPath: recipeImagePaths[1],
        servings: _getServingsFromSchemaRecipe(recipeMap),
        preperationTime: recipeTimes["prepTime"],
        cookingTime: recipeTimes["cookTime"],
        totalTime: recipeTimes["totalTime"],
        vegetable: _getVegetableFromSchemaRecipe(recipeMap),
        ingredients: [
          _getIngredientsFromSchemaRecipe(recipeMap),
        ],
        ingredientsGlossary: [],
        steps: recipeSteps,
        stepImages: List<List<String>>.generate(recipeSteps.length, (i) => []),
        nutritions: recipeNutritions,
        lastModified: DateTime.now().toIso8601String(),
        source: url,
      );

      return Tuple2(ImportState.SUCCESS, finalRecipe);
    } catch (e) {
      print("failed importing map");
    }

    return Tuple2(ImportState.FAIL, null);
  }

  /// checks if the key recipeYield is existingin the map and then
  /// returns the first number of the value of the key. Otherwise returns null
  double _getServingsFromSchemaRecipe(Map<String, dynamic> recipeMap) {
    double servings = 1;
    try {
      if (recipeMap.containsKey("recipeYield")) {
        if (recipeMap["recipeYield"] is double) {
          return recipeMap["recipeYield"];
        }
        if (recipeMap["recipeYield"].contains(" ")) {
          return double.tryParse(recipeMap["recipeYield"]
              .substring(0, recipeMap["recipeYield"].toString().indexOf(" ")));
        } else {
          if (recipeMap["recipeYield"] is List) {
            servings = double.tryParse(recipeMap["recipeYield"].first);
          } else {
            servings = double.tryParse(recipeMap["recipeYield"]);
          }
        }
      }
    } catch (e) {
      print("failed to get servings from recipe");
    }
    return servings;
  }

  List<String> _getStepsFromSchemaRecipe(Map<String, dynamic> recipeMap) {
    List<String> recipeSteps = [];

    bool gotSteps = false;
    try {
      String stepsInfo = recipeMap["recipeInstructions"];
      recipeSteps = _getStepsFromSingleStringFormat(stepsInfo);
      gotSteps = true;
    } catch (e) {}
    if (!gotSteps) {
      try {
        if (recipeMap["recipeInstructions"].first is String &&
            recipeMap["recipeInstructions"].last is String)
          recipeMap["recipeInstructions"]
              .forEach((item) => recipeSteps.add(item.toString()));
        gotSteps = true;
      } catch (e) {}
    }
    if (!gotSteps) {
      try {
        List<dynamic> dynamicStepInfo = recipeMap["recipeInstructions"];
        List<Map<String, dynamic>> stepsInfo = [];
        for (var i in dynamicStepInfo) {
          stepsInfo.add(i);
        }

        recipeSteps = _getStepsFromHowToFormat(stepsInfo);
        gotSteps = true;
      } catch (e) {}
    }

    if (!gotSteps) {
      try {
        recipeSteps = List<String>.from(recipeMap["recipeInstructions"]);

        gotSteps = true;
      } catch (e) {
        print('list<String> could not be converted');
      }
    }

    recipeSteps = recipeSteps
      ..forEach((step) => step.replaceAll(RegExp("\<(.*?)\>"), "").trim())
      ..removeWhere((i) => i == "");

    return recipeSteps;
  }

  Vegetable _getVegetableFromSchemaRecipe(Map<String, dynamic> recipeMap) {
    if (recipeMap.containsKey("keywords")) {
      try {
        String plainKeywordsInfo = recipeMap["keywords"].toString();

        if (plainKeywordsInfo.contains("vegan") ||
            plainKeywordsInfo.contains("vegano") ||
            plainKeywordsInfo.contains("végétalien")) {
          return Vegetable.VEGAN;
        } else if (plainKeywordsInfo.contains("vegetarisch") ||
            plainKeywordsInfo.contains("vegetariano") ||
            plainKeywordsInfo.contains("vegetarian") ||
            plainKeywordsInfo.contains("végétarien")) {
          return Vegetable.VEGETARIAN;
        } else {
          return Vegetable.NON_VEGETARIAN;
        }
      } catch (e) {}
    }
    return Vegetable.NON_VEGETARIAN;
  }

  List<String> _getStepsFromSingleStringFormat(String stepsInfo) {
    List<String> steps = [];

    String cutStepInfo = stepsInfo;
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
    } else if (cutStepInfo.contains("\n")) {
      cutStepInfo += "\n";
      while (cutStepInfo.contains("\n")) {
        steps.add(cutStepInfo.substring(0, cutStepInfo.indexOf("\n")));
        cutStepInfo = cutStepInfo.substring(cutStepInfo.indexOf("\n") + 1);
      }
    } else {
      steps.add(stepsInfo);
    }

    return steps..removeWhere((item) => item.length <= 1);
  }

  List<String> _getStepsFromHowToFormat(
      List<Map<String, dynamic>> recipeSteps) {
    List<String> steps = [];

    try {
      for (Map<String, dynamic> recipeStepInfo in recipeSteps) {
        if (recipeStepInfo["@type"] == "HowToSection") {
          for (Map<String, dynamic> subStep
              in recipeStepInfo["itemListElement"]) {
            steps.add(subStep["text"]);
          }
        } else if (recipeStepInfo["@type"] == "HowToStep") {
          steps.add(recipeStepInfo["text"]);
        }
      }
    } catch (e) {
      print("failed importing steps");
      return steps;
    }

    return steps;
  }

  /// checks all the ld+json string in the httpData and if one contains the recipe
  /// data, returns the Map
  Future<Map<String, dynamic>> _tryGetRecipeRecipeMap(String httpData) async {
    String iteratedHttpData = httpData;
    while (iteratedHttpData.contains("application/ld+json")) {
      int jsonStartIndex = iteratedHttpData.indexOf(
              ">", iteratedHttpData.indexOf("application/ld+json")) +
          1;
      if (jsonStartIndex != -1) {
        Map<String, dynamic> recipeMap = await _getRecipeMap(
            iteratedHttpData.substring(jsonStartIndex,
                iteratedHttpData.indexOf("</script>", jsonStartIndex)));
        if (recipeMap != null) {
          return recipeMap;
        } else {
          iteratedHttpData = iteratedHttpData
              .substring(iteratedHttpData.indexOf("application/ld+json") + 5);
        }
      }
    }
    return null;
  }

  /// checks if the decoded json string is decoded the recipeMap or if
  /// it is a list of Maps of which the last element is the recipeMap.
  /// Returns null if it's none of the options.
  Future<Map<String, dynamic>> _getRecipeMap(String cutJsonData) async {
    bool foundRecipeMap = true;
    try {
      Map<String, dynamic> recipeMap = await json.decode(cutJsonData);
      if (recipeMap["@type"] == "Recipe" &&
          recipeMap.containsKey("recipeIngredient")) {
        return recipeMap;
      }
    } catch (e) {
      foundRecipeMap = false;
    }
    try {
      List<dynamic> recipeJsonList = await json.decode(cutJsonData);
      for (Map<String, dynamic> map in recipeJsonList) {
        if (map["@type"] == "Recipe" && map.containsKey("recipeIngredient")) {
          return map;
        }
      }
    } catch (e) {
      foundRecipeMap = false;
    }
    try {
      Map<String, dynamic> recipeMap = await json.decode(cutJsonData);

      for (Map<String, dynamic> map in recipeMap["@graph"]) {
        if (map["@type"] == "Recipe" && map.containsKey("recipeIngredient")) {
          return map;
        }
      }
    } catch (e) {
      foundRecipeMap = false;
    }
    print("foundRecipeMap: $foundRecipeMap");
    return null;
  }

  /// looks for the keys "prepTime", "cookTime" and "totalTime"
  /// and it's values are threatened as XQueryDuration Strings.
  /// Result Map has all the keys:
  /// "prepTime", "cookTime" and "totalTime" with it's values null,
  /// if no information could be extracted out of the recipe map
  Map<String, double> _getTimesFromSchemaRecipe(
      Map<String, dynamic> recipeMapData) {
    Map<String, double> times = {
      "prepTime": null,
      "cookTime": null,
      "totalTime": null,
    };

    if (recipeMapData.containsKey("prepTime")) {
      try {
        times["prepTime"] =
            _getTimeInMinutesFromXQueryString(recipeMapData["prepTime"]);
      } catch (e) {
        times["prepTime"] = 0;
      }
    }
    if (recipeMapData.containsKey("cookTime")) {
      try {
        times["cookTime"] =
            _getTimeInMinutesFromXQueryString(recipeMapData["cookTime"]);
      } catch (e) {
        times["cookTime"] = 0;
      }
    }
    if (recipeMapData.containsKey("totalTime")) {
      try {
        times["totalTime"] =
            _getTimeInMinutesFromXQueryString(recipeMapData["totalTime"]);
      } catch (e) {
        times["totalTime"] = 0;
      }
    }

    return times;
  }

  /// P5Y4M5DT3H5M15.5S
  /// P5Y
  /// PT3H
  /// P5Y4M
  /// P15M
  /// P5DT3H5M15.5S
  double _getTimeInMinutesFromXQueryString(String timeString) {
    String iteratedTimeString = timeString;
    double timeInMinutes = 0;

    iteratedTimeString = timeString.replaceAll("P", "").replaceAll("T", "");

    if (iteratedTimeString.indexOf("Y") != -1) {
      timeInMinutes += double.tryParse(iteratedTimeString.substring(
              0, iteratedTimeString.indexOf("Y"))) *
          525600;
      iteratedTimeString =
          iteratedTimeString.substring(iteratedTimeString.indexOf("Y") + 1);
    }
    if (iteratedTimeString.indexOf("D") != -1) {
      timeInMinutes += double.tryParse(iteratedTimeString.substring(
              0, iteratedTimeString.indexOf("D"))) *
          1440;
      iteratedTimeString =
          iteratedTimeString.substring(iteratedTimeString.indexOf("D") + 1);
    }
    if (iteratedTimeString.indexOf("H") != -1) {
      timeInMinutes += double.tryParse(iteratedTimeString.substring(
              0, iteratedTimeString.indexOf("H"))) *
          60;
      iteratedTimeString =
          iteratedTimeString.substring(iteratedTimeString.indexOf("H") + 1);
    }
    if (iteratedTimeString.indexOf("M") != -1) {
      timeInMinutes += double.tryParse(
          iteratedTimeString.substring(0, iteratedTimeString.indexOf("M")));
      iteratedTimeString =
          iteratedTimeString.substring(iteratedTimeString.indexOf("M") + 1);
    }
    return timeInMinutes;
  }

  /// removes the keys with @type, removes the substring Content and
  /// everything with value == null
  /// example:
  /// "nutrition": {
  ///   "@type": "NutritionInformation",
  ///   "calories": "226 kcal",
  ///   "fatContent": "12,3979 g",
  ///   "proteinContent": "13,4402 g",
  ///   "carbohydrateContent": "15,0834 g",
  ///   "servingSize": "100 g"
  /// }
  List<Nutrition> _getNutritionsFromSchemaRecipe(
      Map<String, dynamic> recipeMap) {
    if (recipeMap.containsKey("nutrition")) {
      try {
        List<String> keys = recipeMap["nutrition"].keys.toList();
        return keys
            .map((key) => key == "@type" || recipeMap["nutrition"][key] == null
                ? null
                : Nutrition(
                    name: key.replaceAll("Content", "").replaceAll("Size", ""),
                    amountUnit: recipeMap["nutrition"][key].toString(),
                  ))
            .toList()
              ..removeWhere((item) => item == null);
      } catch (e) {}
    }
    return [];
  }

  List<Ingredient> _getIngredientsFromSchemaRecipe(
      Map<String, dynamic> recipeMap) {
    List<Ingredient> ingredients = [];
    try {
      for (String ingredientString in recipeMap["recipeIngredient"]) {
        ingredients.add(getIngredientFromString(ingredientString));
      }
    } catch (e) {
      print("failed importing ingredients");
    }
    return ingredients;
  }

  List<String> _getStepsFromAllRecipes(String httpData) {
    List<String> steps = [];
    String iteratedHttpData =
        httpData.substring(httpData.indexOf("directions__list--item\">"));
    while (iteratedHttpData.contains("directions__list--item\">")) {
      steps.add(iteratedHttpData.substring(
        iteratedHttpData.indexOf("directions__list--item\">") + 25,
        iteratedHttpData.indexOf(
          "</span>",
          iteratedHttpData.indexOf("directions__list--item\">"),
        ),
      ));
      iteratedHttpData = iteratedHttpData.substring(
          iteratedHttpData.indexOf("directions__list--item\">") + 10);
    }
    return steps;
  }

  List<Nutrition> _getNutritionsFromAllRecipes(String httpData) {
    List<Nutrition> nutritions = [];
    try {
      String iteratedHttpData = httpData;
      while (iteratedHttpData.contains("span itemprop=\"")) {
        nutritions.add(Nutrition(
          name: iteratedHttpData.substring(
            iteratedHttpData.indexOf("span itemprop=\"") + 15,
            iteratedHttpData.indexOf(
                "\"", iteratedHttpData.indexOf("span itemprop=\"") + 17),
          ),
          amountUnit: iteratedHttpData.substring(
            iteratedHttpData.indexOf(
                    "\">", iteratedHttpData.indexOf("span itemprop=\"")) +
                2,
            iteratedHttpData.indexOf(
                "<span", iteratedHttpData.indexOf("span itemprop=\"") + 17),
          ),
        ));
        iteratedHttpData = iteratedHttpData
            .substring(iteratedHttpData.indexOf("span itemprop=\"") + 17);
      }
    } catch (e) {}
    return nutritions
        .map((item) => Nutrition(
              name: item.name.replaceAll("Content", ""),
              amountUnit: item.amountUnit,
            ))
        .toList();
  }

  List<String> _getIngredientStringFromAllRecipes(String httpData) {
    List<String> ingredients = [];

    String cutRecipeData =
        httpData.substring(httpData.indexOf("recipeIngredient\">"));
    while (cutRecipeData.contains("recipeIngredient\">")) {
      ingredients.add(cutRecipeData.substring(
        cutRecipeData.indexOf("recipeIngredient\">") + 18,
        cutRecipeData.indexOf("</span>"),
      ));
      if (cutRecipeData.contains("recipeIngredient\">", 5)) {
        cutRecipeData = cutRecipeData
            .substring(cutRecipeData.indexOf("recipeIngredient\">", 5));
      } else {
        break;
      }
    }

    return ingredients;
  }

  ///<ul class="prepTime">
  ///     <li class="prepTime__item"><span class="svg-icon--recipe-page--time_stats_gr svg-icon--recipe-page--time_stats_gr-dims"></span></li>
  ///     <li class="prepTime__item" aria-label="Prep time: 15 Minutes">
  ///         <p class="prepTime__item--type" aria-hidden="true">Prep</p><time itemprop="prepTime" datetime="PT15M"><span aria-hidden="true"><span class="prepTime__item--time">15</span> m</span></time>
  ///     </li>
  ///                 <li class="prepTime__item" aria-label="Cook time: 45 Minutes">
  ///             <p class="prepTime__item--type" aria-hidden="true">Cook</p><time itemprop="cookTime" datetime="PT45M"><span aria-hidden="true"><span class="prepTime__item--time">45</span> m</span></time>
  ///         </li>
  ///                 <li class="prepTime__item" aria-label="Ready in 1 Hour ">
  ///             <p class="prepTime__item--type" aria-hidden="true">Ready In</p><time itemprop="totalTime" datetime="PT1H"><span aria-hidden="true"><span class="prepTime__item--time">1</span> h</span></time>
  ///         </li>
  /// </ul>
  List<double> _getTimesFromHttpData(String httpData) {
    double preperationTime;
    double cookingTime;
    double totalTime;
    try {
      preperationTime = _getTimeInMinutesFromXQueryString(httpData.substring(
        httpData.indexOf("prepTime\" datetime=\"") + 21,
        httpData.indexOf("><span aria") - 1,
      ));
    } catch (e) {}
    try {
      cookingTime = _getTimeInMinutesFromXQueryString(httpData.substring(
          httpData.indexOf("cookTime\" datetime=\"") + 21,
          httpData.indexOf(
                "><span aria",
                httpData.indexOf("cookTime\" datetime=\"") + 21,
              ) -
              1));
    } catch (e) {}
    try {
      _getTimeInMinutesFromXQueryString(httpData.substring(
        httpData.indexOf("totalTime\" datetime=\"") + 22,
        httpData.indexOf(
                "><span aria", httpData.indexOf("totalTime\" datetime=\"")) -
            1,
      ));
    } catch (e) {}
    return [
      preperationTime,
      cookingTime,
      totalTime,
    ];
  }

  String _getRecipeImageStringFromAllRecipes(String httpData) {
    String halfCut =
        httpData.substring(0, httpData.indexOf("jpg, null', Recipe") + 3);
    return halfCut.substring(halfCut.lastIndexOf("'") + 1);
  }
}
