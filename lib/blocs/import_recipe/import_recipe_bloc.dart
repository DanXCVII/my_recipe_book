import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_recipe_book/local_storage/local_paths.dart';

import '../../local_storage/hive.dart';
import '../../local_storage/io_operations.dart' as IO;
import '../../models/recipe.dart';
import '../recipe_manager/recipe_manager_bloc.dart';

part 'import_recipe_event.dart';
part 'import_recipe_state.dart';

class ImportRecipeBloc extends Bloc<ImportRecipeEvent, ImportRecipeState> {
  RecipeManagerBloc recipeManagerBloc;
  String fileEndingLastImport;

  ImportRecipeBloc(this.recipeManagerBloc);

  @override
  ImportRecipeState get initialState => InitialImportRecipeState();

  @override
  Stream<ImportRecipeState> mapEventToState(
    ImportRecipeEvent event,
  ) async* {
    if (event is StartImportRecipes) {
      yield* _mapImportRecipesToState(event);
    } else if (event is FinishImportRecipes) {
      yield* _mapFinishImportRecipes(event);
    }
  }

  Stream<ImportRecipeState> _mapImportRecipesToState(
      StartImportRecipes event) async* {
    yield ImportingRecipes(0);

    if (event.importZipFile.path.endsWith("zip")) {
      fileEndingLastImport = "zip";
      if (event.delay != null) await Future.delayed(event.delay);

      List<Recipe> importRecipes = [];
      List<String> failedZips = [];
      List<Recipe> alreadyExisting = [];

      Map<String, Recipe> recipes =
          await IO.importRecipesToTmp(event.importZipFile);
      yield ImportingRecipes(0.1);

      List<String> recipeKeys = recipes.keys.toList();
      for (int i = 0; i < recipeKeys.length; i++) {
        // await Future.delayed(Duration(seconds: 1));
        if (recipes[recipeKeys[i]] == null) {
          failedZips.add(recipeKeys[i].toString());
        } else {
          // if a recipe with the same name isn't already saved to hive
          if (await HiveProvider()
                  .getRecipeByName(recipes[recipeKeys[i]].name) !=
              null) {
            // if the recipe is already saved in hive, add it to the alreadyExisting list
            alreadyExisting.add(await HiveProvider()
                .getRecipeByName(recipes[recipeKeys[i]].name));
          } else {
            importRecipes.add(recipes[recipeKeys[i]]);
          }
          if (recipeKeys.length != 1) {
            yield ImportingRecipes(double.parse(
                (0.1 + ((i / recipeKeys.length) * 0.9)).toStringAsFixed(1)));
          } else {
            if (importRecipes.isNotEmpty) {
              yield* _mapFinishImportRecipes(
                  FinishImportRecipes([recipes[recipeKeys[i]]]));
              return;
            }
          }
        }
      }

      yield MultipleRecipes(importRecipes, failedZips, alreadyExisting);
    } else if (event.importZipFile.path.endsWith("mrb")) {
      fileEndingLastImport = "mrb";
      if (event.delay != null) await Future.delayed(event.delay);

      yield ImportingRecipes(0.5);

      List<String> recipeNames =
          await IO.extractMRBzipGetNames(event.importZipFile);

      List<Recipe> importRecipes = [];
      List<Recipe> alreadyExisting = [];

      for (String recipeName in recipeNames) {
        Recipe hiveRecipe = await HiveProvider().getRecipeByName(recipeName);
        if (hiveRecipe != null) {
          alreadyExisting.add(hiveRecipe);
        } else {
          importRecipes.add(Recipe(name: recipeName));
        }
      }

      yield MultipleRecipes(importRecipes, [], alreadyExisting);
    }
  }

  Stream<ImportRecipeState> _mapFinishImportRecipes(
      FinishImportRecipes event) async* {
    yield ImportingRecipes(0);

    List<Recipe> importRecipes = [];
    List<Recipe> alreadyExisting = [];
    List<Recipe> failedRecipes = [];

    List<String> importCategories = [];

    if (fileEndingLastImport == "zip") {
      yield ImportingRecipes(0.1);

      for (int i = 0; i < event.recipes.length; i++) {
        // await Future.delayed(Duration(seconds: 1));
        // if a recipe with the same name isn't already saved to hive -> double check
        if (await HiveProvider().getRecipeByName(event.recipes[i].name) ==
            null) {
          // import recipe data to app ..
          bool importedRecipeData =
              await IO.importRecipeFromTmp(event.recipes[i]);
          // .. and if it succeeded ..
          if (importedRecipeData == true) {
            List<String> categories = HiveProvider().getCategoryNames();
            List<String> newCategories = [];
            for (String category in event.recipes[i].categories) {
              if (!categories.contains(category) &&
                  !importCategories.contains(category)) {
                newCategories.add(category);
              }
            }
            // add recipe to recipeManager
            importCategories.addAll(newCategories);
            importRecipes.add(event.recipes[i]);
          } else {
            failedRecipes.add(event.recipes[i]);
          }
        } else {
          // if the recipe is already saved in hive, add it to the alreadyExisting list
          alreadyExisting
              .add(await HiveProvider().getRecipeByName(event.recipes[i].name));
        }
        yield ImportingRecipes(double.parse(
            (0.1 + ((i / event.recipes.length) * 0.9)).toStringAsFixed(1)));
      }
      recipeManagerBloc.add(RMAddCategories(importCategories));
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => recipeManagerBloc.add(RMAddRecipes(importRecipes)));

      imageCache.clear();
    } else if (fileEndingLastImport == "mrb") {
      yield ImportingRecipes(0.1);

      for (int i = 0; i < event.recipes.length; i++) {
        // await Future.delayed(Duration(seconds: 1));
        // if a recipe with the same name isn't already saved to hive -> double check
        if (await HiveProvider().getRecipeByName(event.recipes[i].name) ==
            null) {
          // import recipe data to app ..
          Recipe importedRecipeData =
              await IO.importMRBrecipeFromTmp(event.recipes[i].name);
          // .. and if it succeeded ..
          if (importedRecipeData != null) {
            List<String> categories = HiveProvider().getCategoryNames();
            List<String> newCategories = [];
            for (String category in importedRecipeData.categories) {
              if (!categories.contains(category) &&
                  !importCategories.contains(category)) {
                newCategories.add(category);
              }
            }
            // add recipe to recipeManager
            importCategories.addAll(newCategories);
            importRecipes.add(importedRecipeData);
          } else {
            failedRecipes.add(importedRecipeData);
          }
        } else {
          // if the recipe is already saved in hive, add it to the alreadyExisting list
          alreadyExisting
              .add(await HiveProvider().getRecipeByName(event.recipes[i].name));
        }
        yield ImportingRecipes(double.parse(
            (0.1 + ((i / event.recipes.length) * 0.9)).toStringAsFixed(1)));
      }
      recipeManagerBloc.add(RMAddCategories(importCategories));
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => recipeManagerBloc.add(RMAddRecipes(importRecipes)));

      imageCache.clear();
    }

    yield ImportedRecipes(importRecipes, failedRecipes, alreadyExisting);
  }
}
