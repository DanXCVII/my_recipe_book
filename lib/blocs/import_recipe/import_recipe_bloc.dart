import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager.dart';
import 'package:my_recipe_book/hive.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/settings/import_recipe.dart';
import './import_recipe.dart';

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
    yield ImportingRecipes();

    List<Recipe> importRecipes = [];
    List<String> failedZips = [];
    List<Recipe> alreadyExisting = [];

    Map<String, Recipe> recipes = await importRecipesToTmp(event.importZipFile);

    for (var key in recipes.keys) {
      if (recipes[key] == null) {
        failedZips.add(key.toString());
      } else {
        // if a recipe with the same name isn't already save to hive
        if (await HiveProvider().getRecipeByName(recipes[key].name) == null) {
          // import recipe data to app ..
          bool importedRecipeData = await importRecipeFromTmp(recipes[key]);
          // .. and if it doesn't fail ..
          if (importedRecipeData == true) {
            // .. save recipe data to hive
            await HiveProvider().saveRecipe(recipes[key]);
            // add recipe to recipeManager
            recipeManagerBloc.add(RMAddRecipe(recipes[key]));
          }
        } else {
          // if the recipe is already saved in hive, add it to the alreadyExisting list
          alreadyExisting
              .add(await HiveProvider().getRecipeByName(recipes[key].name));
        }
      }
    }

    yield ImportedRecipes(importRecipes, failedZips, alreadyExisting);
  }
}
