part of 'recipe_manager_bloc.dart';

abstract class RecipeManagerState extends Equatable {
  const RecipeManagerState();
}

class InitialRecipeManagerState extends RecipeManagerState {
  @override
  List<Object> get props => [];
}

class AddRecipesState extends RecipeManagerState {
  final List<Recipe> recipes;

  const AddRecipesState(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class AddFavoriteState extends RecipeManagerState {
  final Recipe recipe;

  const AddFavoriteState(this.recipe);
  @override
  List<Object> get props => [recipe];
}

class RemoveFavoriteState extends RecipeManagerState {
  final Recipe recipe;

  const RemoveFavoriteState(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class DeleteRecipeState extends RecipeManagerState {
  final Recipe recipe;

  const DeleteRecipeState(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class UpdateRecipeState extends RecipeManagerState {
  final Recipe oldRecipe;
  final Recipe updatedRecipe;

  const UpdateRecipeState(this.oldRecipe, this.updatedRecipe);

  @override
  List<Object> get props => [oldRecipe, updatedRecipe];
}

class AddCategoriesState extends RecipeManagerState {
  final List<String> categories;

  const AddCategoriesState(this.categories);

  @override
  List<Object> get props => [categories];
}

class DeleteCategoryState extends RecipeManagerState {
  final String category;

  const DeleteCategoryState(this.category);

  @override
  List<Object> get props => [category];
}

class UpdateCategoryState extends RecipeManagerState {
  final String oldCategory;
  final String updatedCategory;

  const UpdateCategoryState(this.oldCategory, this.updatedCategory);

  @override
  List<Object> get props => [oldCategory, updatedCategory];
}

class MoveCategoryState extends RecipeManagerState {
  final int oldIndex;
  final int newIndex;
  final DateTime time;

  const MoveCategoryState(
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
