part of 'random_recipe_explorer_bloc.dart';

abstract class RandomRecipeExplorerEvent {
  const RandomRecipeExplorerEvent();
}

class InitializeRandomRecipeExplorer extends RandomRecipeExplorerEvent {
  const InitializeRandomRecipeExplorer({this.filter});

  final ExploreFilter? filter;
}

class ReloadRandomRecipeExplorer extends RandomRecipeExplorerEvent {
  const ReloadRandomRecipeExplorer();
}

class ChangeExploreFilter extends RandomRecipeExplorerEvent {
  const ChangeExploreFilter(this.filter);

  final ExploreFilter filter;
}

class UpdateExploreRecipe extends RandomRecipeExplorerEvent {
  const UpdateExploreRecipe(this.recipe);

  final Recipe recipe;
}
