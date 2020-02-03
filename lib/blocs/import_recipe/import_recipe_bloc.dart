import 'dart:async';

import 'package:bloc/bloc.dart';

import './import_recipe.dart';
import '../../hive.dart';
import '../../local_storage/io_operations.dart' as IO;
import '../../models/recipe.dart';
import '../recipe_manager/recipe_manager.dart';

class ImportRecipeBloc extends Bloc<ImportRecipeEvent, ImportRecipeState> {
  RecipeManagerBloc recipeManagerBloc;

  ImportRecipeBloc(this.recipeManagerBloc);

  @override
  ImportRecipeState get initialState => InitialImportRecipeState();

  @override
  Stream<ImportRecipeState> mapEventToState(
    ImportRecipeEvent event,
  ) async* {
    if (event is ImportRecipes) {
      yield* _mapImportRecipesToState(event);
    }
  }

  Stream<ImportRecipeState> _mapImportRecipesToState(
      ImportRecipes event) async* {
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
      if (recipes[recipeKeys[i]] == null) {
        failedZips.add(recipeKeys[i].toString());
      } else {
        // if a recipe with the same name isn't already save to hive
        if (await HiveProvider().getRecipeByName(recipes[recipeKeys[i]].name) ==
            null) {
          // import recipe data to app ..
          bool importedRecipeData =
              await IO.importRecipeFromTmp(recipes[recipeKeys[i]]);
          // .. and if it doesn't fail ..
          if (importedRecipeData == true) {
            // .. save recipe data to hive
            await HiveProvider().saveRecipe(recipes[recipeKeys[i]]);
            // add recipe to recipeManager
            recipeManagerBloc.add(RMAddRecipe(recipes[recipeKeys[i]]));
          }
        } else {
          // if the recipe is already saved in hive, add it to the alreadyExisting list
          alreadyExisting.add(await HiveProvider()
              .getRecipeByName(recipes[recipeKeys[i]].name));
        }
        yield ImportingRecipes(0.1 + (i / recipeKeys.length * 0.9));
      }
    }

    yield ImportedRecipes(importRecipes, failedZips, alreadyExisting);
  }
}
