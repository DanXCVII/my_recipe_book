import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/models/recipe.dart';

abstract class ImportRecipeState extends Equatable {
  const ImportRecipeState();

  @override
  List<Object> get props => [];
}

class InitialImportRecipeState extends ImportRecipeState {}

class ImportingRecipes extends ImportRecipeState {}

class ImportedRecipes extends ImportRecipeState {
  // successfully imported recipes
  final List<Recipe> importedRecipes;
  // names of the .zip files with invalid recipe data
  final List<String> failedZips;
  // the name of the recipe is already saved in hive
  final List<Recipe> alreadyExistingRecipes;

  ImportedRecipes([
    this.importedRecipes,
    this.failedZips,
    this.alreadyExistingRecipes,
  ]);

  @override
  List<Object> get props => [
        importedRecipes,
        failedZips,
        alreadyExistingRecipes,
      ];

  @override
  String toString() =>
      'Imported recipes { importedRecipes: $importedRecipes , failedZips: $failedZips, alreadyExistingRecipes: $alreadyExistingRecipes }';
}
