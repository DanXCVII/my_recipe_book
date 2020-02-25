import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../hive.dart';
import '../../local_storage/io_operations.dart' as IO;
import '../../models/recipe.dart';
import '../recipe_manager/recipe_manager_bloc.dart';

part 'import_recipe_event.dart';
part 'import_recipe_state.dart';

class ImportRecipeBloc extends Bloc<ImportRecipeEvent, ImportRecipeState> {
  RecipeManagerBloc recipeManagerBloc;

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
        if (await HiveProvider().getRecipeByName(recipes[recipeKeys[i]].name) !=
            null) {
          // if the recipe is already saved in hive, add it to the alreadyExisting list
          alreadyExisting.add(await HiveProvider()
              .getRecipeByName(recipes[recipeKeys[i]].name));
        } else {
          importRecipes.add(recipes[recipeKeys[i]]);
        }
        if (recipeKeys.length != 1) {
          yield ImportingRecipes(0.1 + (i / recipeKeys.length * 0.9));
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
  }

  Stream<ImportRecipeState> _mapFinishImportRecipes(
      FinishImportRecipes event) async* {
    yield ImportingRecipes(0);

    List<Recipe> importRecipes = [];
    List<Recipe> alreadyExisting = [];
    List<Recipe> failedRecipes = [];

    yield ImportingRecipes(0.1);

    for (int i = 0; i < event.recipes.length; i++) {
      // await Future.delayed(Duration(seconds: 1));
      // if a recipe with the same name isn't already save to hive -> double check
      if (await HiveProvider().getRecipeByName(event.recipes[i].name) == null) {
        // import recipe data to app ..
        bool importedRecipeData =
            await IO.importRecipeFromTmp(event.recipes[i]);
        // .. and if it succeeded ..
        if (importedRecipeData == true) {
          List<String> categories = HiveProvider().getCategoryNames();
          for (String category in event.recipes[i].categories) {
            if (!categories.contains(category)) {
              recipeManagerBloc.add(RMAddCategory(category));
              await Future.delayed(Duration(milliseconds: 50));
            }
          }
          // add recipe to recipeManager
          recipeManagerBloc.add(RMAddRecipe(event.recipes[i]));
          importRecipes.add(event.recipes[i]);
        } else {
          failedRecipes.add(event.recipes[i]);
        }
      } else {
        // if the recipe is already saved in hive, add it to the alreadyExisting list
        alreadyExisting
            .add(await HiveProvider().getRecipeByName(event.recipes[i].name));
      }
      yield ImportingRecipes(0.1 + (i / event.recipes.length * 0.9));
    }
    imageCache.clear();
    yield ImportedRecipes(importRecipes, failedRecipes, alreadyExisting);
  }
}
