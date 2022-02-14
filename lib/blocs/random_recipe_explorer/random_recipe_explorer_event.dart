part of 'random_recipe_explorer_bloc.dart';

abstract class RandomRecipeExplorerEvent {
  const RandomRecipeExplorerEvent();
}

class InitializeRandomRecipeExplorer extends RandomRecipeExplorerEvent {
  final String/*!*/ selectedCategory;

  const InitializeRandomRecipeExplorer(
      {this.selectedCategory = 'all categories'});
}

class ReloadRandomRecipeExplorer extends RandomRecipeExplorerEvent {}

class AddCategories extends RandomRecipeExplorerEvent {
  final List<String/*!*/> categories;

  const AddCategories(this.categories);
}

class DeleteCategory extends RandomRecipeExplorerEvent {
  final String/*!*/ category;

  const DeleteCategory(this.category);
}

class DeleteRecipe extends RandomRecipeExplorerEvent {
  final Recipe recipe;

  const DeleteRecipe(this.recipe);
}

class UpdateRecipe extends RandomRecipeExplorerEvent {
  final Recipe oldRecipe;
  final Recipe updatedRecipe;

  const UpdateRecipe(this.oldRecipe, this.updatedRecipe);
}

class UpdateCategory extends RandomRecipeExplorerEvent {
  final String/*!*/ oldCategory;
  final String updatedCategory;

  const UpdateCategory(this.oldCategory, this.updatedCategory);
}

class ChangeCategory extends RandomRecipeExplorerEvent {
  final String/*!*/ category;

  const ChangeCategory(this.category);
}

class MoveCategory extends RandomRecipeExplorerEvent {
  final int oldIndex;
  final int newIndex;

  MoveCategory(this.oldIndex, this.newIndex);
}
