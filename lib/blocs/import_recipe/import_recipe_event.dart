import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../models/recipe.dart';

abstract class ImportRecipeEvent extends Equatable {
  const ImportRecipeEvent();
}

class StartImportRecipes extends ImportRecipeEvent {
  final File importZipFile;
  final Duration delay;

  StartImportRecipes(this.importZipFile, {this.delay});

  @override
  List<Object> get props => [importZipFile, delay];

  @override
  String toString() => 'Import recipe { importZipFile: $importZipFile }';
}

class FinishImportRecipes extends ImportRecipeEvent {
  final List<Recipe> recipes;

  FinishImportRecipes(this.recipes);

  @override
  List<Object> get props => [recipes];
}
