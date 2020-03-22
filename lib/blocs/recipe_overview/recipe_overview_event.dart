part of 'recipe_overview_bloc.dart';

abstract class RecipeOverviewEvent extends Equatable {
  const RecipeOverviewEvent();

  @override
  List<Object> get props => [];
}

class LoadVegetableRecipeOverview extends RecipeOverviewEvent {
  final Vegetable vegetable;

  const LoadVegetableRecipeOverview(this.vegetable);

  @override
  List<Object> get props => [vegetable];
}

class LoadRecipeTagRecipeOverview extends RecipeOverviewEvent {
  final StringIntTuple recipeTag;

  const LoadRecipeTagRecipeOverview(this.recipeTag);

  @override
  List<Object> get props => [recipeTag];
}

class LoadCategoryRecipeOverview extends RecipeOverviewEvent {
  final String category;

  const LoadCategoryRecipeOverview(this.category);

  @override
  List<Object> get props => [category];
}

class ChangeRecipeSort extends RecipeOverviewEvent {
  final RecipeSort recipeSort;

  const ChangeRecipeSort(this.recipeSort);

  @override
  List<Object> get props => [recipeSort];
}

class ChangeAscending extends RecipeOverviewEvent {
  final bool ascending;

  const ChangeAscending(this.ascending);

  @override
  List<Object> get props => [ascending];
}

class FilterRecipesVegetable extends RecipeOverviewEvent {
  final Vegetable vegetable;

  const FilterRecipesVegetable(this.vegetable);

  @override
  List<Object> get props => [vegetable];
}

class FilterRecipesTag extends RecipeOverviewEvent {
  final List<String> recipeTags;

  const FilterRecipesTag(
    this.recipeTags,
  );

  @override
  List<Object> get props => [recipeTags];
}

class AddRecipes extends RecipeOverviewEvent {
  final List<Recipe> recipes;

  const AddRecipes(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class UpdateRecipe extends RecipeOverviewEvent {
  final Recipe oldRecipe;
  final Recipe updatedRecipe;

  const UpdateRecipe(this.oldRecipe, this.updatedRecipe);

  @override
  List<Object> get props => [oldRecipe, updatedRecipe];
}

class DeleteRecipe extends RecipeOverviewEvent {
  final Recipe recipe;

  const DeleteRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class UpdateFavoriteStatus extends RecipeOverviewEvent {
  final Recipe recipe;

  const UpdateFavoriteStatus(this.recipe);

  @override
  List<Object> get props => [recipe];
}
