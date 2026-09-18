part of 'import_recipe_bloc.dart';

abstract class ImportRecipeEvent extends Equatable {
  const ImportRecipeEvent();
}

class StartImportRecipes extends ImportRecipeEvent {
  final ImportCandidate candidate;
  final Duration delay;

  StartImportRecipes(this.candidate, {required this.delay});

  @override
  List<Object> get props => [
    candidate.file.path,
    candidate.originalFileName,
    delay,
  ];
}

class FinishImportRecipes extends ImportRecipeEvent {
  final List<Recipe> recipes;

  FinishImportRecipes(this.recipes);

  @override
  List<Object> get props => [recipes];
}
