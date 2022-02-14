part of 'import_recipe_bloc.dart';

abstract class ImportRecipeState extends Equatable {
  const ImportRecipeState();

  @override
  List<Object> get props => [];
}

class InitialImportRecipeState extends ImportRecipeState {}

class ImportingRecipes extends ImportRecipeState {
  final double percentageDone;

  ImportingRecipes(this.percentageDone);

  @override
  List<Object> get props => [percentageDone];
}

class InvalidFile extends ImportRecipeState {
  final String fileName;

  InvalidFile(this.fileName);

  @override
  List<Object> get props => [fileName];
}

class InvalidDataType extends ImportRecipeState {
  final String fileExtension;

  InvalidDataType(this.fileExtension);

  @override
  List<Object> get props => [fileExtension];
}

class MultipleRecipes extends ImportRecipeState {
  // successfully imported recipes
  final List<Recipe/*!*/>/*!*/ readyToImportRecipes;
  // the name of the recipe is already saved in hive
  final List<Recipe/*!*/>/*!*/ alreadyExistingRecipes;
  // names of the .zip files with invalid recipe data
  final List<String>/*!*/ failedZips;

  MultipleRecipes([
    this.readyToImportRecipes,
    this.failedZips,
    this.alreadyExistingRecipes,
  ]);

  @override
  List<Object> get props => [
        readyToImportRecipes,
        alreadyExistingRecipes,
      ];
}

class ImportedRecipes extends ImportRecipeState {
  // successfully imported recipes
  final List<Recipe/*!*/>/*!*/ importedRecipes;
  // names of the .zip files with invalid recipe data
  final List<Recipe/*!*/>/*!*/ failedRecipes;
  // the name of the recipe is already saved in hive
  final List<Recipe/*!*/>/*!*//*!*/ alreadyExistingRecipes;

  ImportedRecipes([
    this.importedRecipes,
    this.failedRecipes,
    this.alreadyExistingRecipes,
  ]);

  @override
  List<Object> get props => [
        importedRecipes,
        failedRecipes,
        alreadyExistingRecipes,
      ];
}
