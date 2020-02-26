part of 'recipe_manager_bloc.dart';

abstract class RecipeManagerEvent extends Equatable {
  const RecipeManagerEvent();
}

class RMAddRecipe extends RecipeManagerEvent {
  final Recipe recipe;

  const RMAddRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class RMDeleteRecipe extends RecipeManagerEvent {
  final String recipeName;
  final bool deleteFiles;

  const RMDeleteRecipe(this.recipeName, {@required this.deleteFiles});

  @override
  List<Object> get props => [recipeName];
}

class RMAddFavorite extends RecipeManagerEvent {
  final Recipe recipe;

  const RMAddFavorite(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class RMRemoveFavorite extends RecipeManagerEvent {
  final Recipe recipe;

  const RMRemoveFavorite(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class RMDeleteCategory extends RecipeManagerEvent {
  final String category;

  const RMDeleteCategory(this.category);

  @override
  List<Object> get props => [category];
}

class RMAddCategories extends RecipeManagerEvent {
  final List<String> categories;

  const RMAddCategories(this.categories);

  @override
  List<Object> get props => [categories];
}

class RMUpdateCategory extends RecipeManagerEvent {
  final String oldCategory;
  final String updatedCategory;

  const RMUpdateCategory(this.oldCategory, this.updatedCategory);

  @override
  List<Object> get props => [oldCategory, updatedCategory];
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
