part of 'random_recipe_explorer_bloc.dart';

abstract class RandomRecipeExplorerEvent extends Equatable {
  const RandomRecipeExplorerEvent();

  @override
  List<Object> get props => [];
}

class InitializeRandomRecipeExplorer extends RandomRecipeExplorerEvent {
  final String selectedCategory;

  const InitializeRandomRecipeExplorer(
      {this.selectedCategory = 'all categories'});

  @override
  List<Object> get props => [selectedCategory];
}

class ReloadRandomRecipeExplorer extends RandomRecipeExplorerEvent {}

class AddCategories extends RandomRecipeExplorerEvent {
  final List<String> categories;

  const AddCategories(this.categories);

  @override
  List<Object> get props => [categories];
}

class DeleteCategory extends RandomRecipeExplorerEvent {
  final String category;

  const DeleteCategory(this.category);

  @override
  List<Object> get props => [category];
}

class DeleteRecipe extends RandomRecipeExplorerEvent {
  final Recipe recipe;

  const DeleteRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class UpdateRecipe extends RandomRecipeExplorerEvent {
  final Recipe oldRecipe;
  final Recipe updatedRecipe;

  const UpdateRecipe(this.oldRecipe, this.updatedRecipe);

  @override
  List<Object> get props => [oldRecipe, updatedRecipe];
}

class UpdateCategory extends RandomRecipeExplorerEvent {
  final String oldCategory;
  final String updatedCategory;

  const UpdateCategory(this.oldCategory, this.updatedCategory);

  @override
  List<Object> get props => [oldCategory, updatedCategory];
}

class ChangeCategory extends RandomRecipeExplorerEvent {
  final String category;

  const ChangeCategory(this.category);

  @override
  List<Object> get props => [category];
}
