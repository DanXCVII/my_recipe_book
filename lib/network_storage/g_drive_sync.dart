import 'package:my_recipe_book/local_storage/hive.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/tuple.dart';

// first DateTime, second Recipe
List<Tuple2<String, String>> deletionHistory;

void synchornizeGDrive() async {
  List<Recipe> driveRecipes = await getGDriveRecipes();

  await synchronizeDeletionsGDrive(driveRecipes);
}

/// adds all local recipes, which are not online to GDrive AND
/// adds all online recipes, which are not local to local storage
/// WARNING: should be executed after
Future<void> synchronizeRecipesGDrive(List<Recipe> driveRecipes) async {
  await synchronizeDeletionsGDrive(driveRecipes);

  for (Recipe driveRecipe in driveRecipes) {
    Recipe localRecipe = await HiveProvider().getRecipeByName(driveRecipe.name);
    // if there is a recipe with the same name already added locally
    if (localRecipe != null) {
      // if the local recipe is older than the drive recipe
      if (DateTime.parse(localRecipe.lastModified)
          .isBefore(DateTime.parse(driveRecipe.lastModified))) {
        await HiveProvider().deleteRecipe(driveRecipe.name);
        await HiveProvider().saveRecipe(driveRecipe);
      } // if the drive recipe is older than the local recipe
      else if (DateTime.parse(localRecipe.lastModified)
          .isAfter(DateTime.parse(driveRecipe.lastModified))) {
        await deleteGDriveRecipe(driveRecipe.name);
        await addGDriveRecipe(localRecipe);
      }
    } else {
      await HiveProvider().saveRecipe(driveRecipe);
    }
  }
}

/// deletes all local recipes, which are older than the deletion entry online
/// also: deletes all online recipes, which are older than the deletion entry local
/// if the deletion entry is older than a created recipe with the same name,
/// the respective recipe will be saved online/local
Future<void> synchronizeDeletionsGDrive(List<Recipe> driveRecipes) async {
  for (Tuple2<String, String> localHistoryEntry in deletionHistory) {
    Recipe searchRecipe =
        driveRecipes.firstWhere((r) => r.name == localHistoryEntry.item2);
    if (searchRecipe == null) {
      break;
    } else {
      // if the deletion occured after the last modification of the recipe
      if (DateTime.parse(searchRecipe.lastModified)
          .isBefore(DateTime.parse(localHistoryEntry.item1))) {
        await deleteGDriveRecipe(searchRecipe.name);
      } // if the deletion is older than the last modification
      else {
        await addGDriveRecipe(searchRecipe);
      }
    }
  }

  // TODO: implement clearLocalHistory()
  // await clearLocalHistory();

  for (Tuple2<String, String> onlineHistoryEntry
      in (await getGDriveDeletionHistory())) {
    Recipe searchRecipe =
        driveRecipes.firstWhere((r) => r.name == onlineHistoryEntry.item2);
    if (searchRecipe == null) {
      break;
    } else {
      // if the deletion occured after the last modification of the recipe
      if (DateTime.parse(searchRecipe.lastModified)
          .isBefore(DateTime.parse(onlineHistoryEntry.item1))) {
        await HiveProvider().deleteRecipe(onlineHistoryEntry.item2);
      } // if the deletion is older than the last modification
      else {
        await HiveProvider().saveRecipe(searchRecipe);
        await removeGDriveDeletionEntry(searchRecipe.name);
      }
    }
  }
}

// TODO: implement method removeGDriveDeletionEntry
Future<void> removeGDriveDeletionEntry(String recipeName) async {}

// TODO: implement method addGDriveRecipe
Future<void> addGDriveRecipe(Recipe recipe) async {}

// TODO: implement method getGDriveRecipes
Future<List<Recipe>> getGDriveRecipes() async {
  return [];
}

// TODO: implement method getGDriveDeletionHistory
Future<List<Tuple2<String, String>>> getGDriveDeletionHistory() async {}

// TODO: implement method deleteGDriveRecipe
Future<void> deleteGDriveRecipe(String recipeName) async {
  // also add the deletion history entry in GDrive
}
