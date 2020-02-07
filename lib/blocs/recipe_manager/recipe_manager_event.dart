part of 'recipe_manager_bloc.dart';

abstract class RecipeManagerEvent extends Equatable {
  const RecipeManagerEvent();
}

class RMAddRecipe extends RecipeManagerEvent {
  final Recipe recipe;

  const RMAddRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'AddRecipe { recipe: $recipe }';
}

class RMUpdateRecipe extends RecipeManagerEvent {
  final Recipe oldRecipe;
  final Recipe updatedRecipe;

  const RMUpdateRecipe(this.oldRecipe, this.updatedRecipe);

  @override
  List<Object> get props => [oldRecipe, updatedRecipe];

  @override
  String toString() => 'UpdateRecipe { updatedRecipe: $updatedRecipe }';
}

class RMDeleteRecipe extends RecipeManagerEvent {
  final String recipeName;
  final bool deleteFiles;

  const RMDeleteRecipe(this.recipeName, {@required this.deleteFiles});

  @override
  List<Object> get props => [recipeName];

  @override
  String toString() => 'DeleteRecipe { recipeName: $recipeName }';
}

class RMAddFavorite extends RecipeManagerEvent {
  final Recipe recipe;

  const RMAddFavorite(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'Add Favorite { recipe: $recipe }';
}

class RMRemoveFavorite extends RecipeManagerEvent {
  final Recipe recipe;

  const RMRemoveFavorite(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'Add Favorite { recipe: $recipe }';
}

class RMDeleteCategory extends RecipeManagerEvent {
  final String category;

  const RMDeleteCategory(this.category);

  @override
  List<Object> get props => [category];

  @override
  String toString() => 'DeleteCategory { category: $category }';
}

class RMAddCategory extends RecipeManagerEvent {
  final String category;

  const RMAddCategory(this.category);

  @override
  List<Object> get props => [category];

  @override
  String toString() => 'AddCategory { category: $category }';
}

class RMUpdateCategory extends RecipeManagerEvent {
  final String oldCategory;
  final String updatedCategory;

  const RMUpdateCategory(this.oldCategory, this.updatedCategory);

  @override
  List<Object> get props => [oldCategory, updatedCategory];

  @override
  String toString() =>
      'UpdateCategory { oldCategory: $oldCategory, updatedCategory: $updatedCategory }';
}

class RMMoveCategory extends RecipeManagerEvent {
  final int oldIndex;
  final int newIndex;
  final DateTime time;

  const RMMoveCategory(
    this.oldIndex,
    this.newIndex,
    this.time,
  );

  @override
  List<Object> get props => [
        oldIndex,
        newIndex,
        time,
      ];
}
