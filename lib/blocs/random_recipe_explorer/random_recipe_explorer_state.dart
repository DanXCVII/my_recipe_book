part of 'random_recipe_explorer_bloc.dart';

enum ExploreFilterKind { all, category, tag }

class ExploreFilter extends Equatable {
  const ExploreFilter._(this.kind, this.value);

  const ExploreFilter.all() : this._(ExploreFilterKind.all, null);

  const ExploreFilter.category(String category)
    : this._(ExploreFilterKind.category, category);

  const ExploreFilter.tag(String tag) : this._(ExploreFilterKind.tag, tag);

  final ExploreFilterKind kind;
  final String? value;

  @override
  List<Object?> get props => [kind, value];
}

abstract class RandomRecipeExplorerState extends Equatable {
  const RandomRecipeExplorerState({
    this.categories = const [],
    this.tags = const [],
    this.filter = const ExploreFilter.all(),
  });

  final List<String> categories;
  final List<StringIntTuple> tags;
  final ExploreFilter filter;
}

class LoadingRandomRecipeExplorer extends RandomRecipeExplorerState {
  const LoadingRandomRecipeExplorer({
    super.categories,
    super.tags,
    super.filter,
  });

  @override
  List<Object?> get props => [categories, tags, filter];
}

class LoadedRandomRecipeExplorer extends RandomRecipeExplorerState {
  const LoadedRandomRecipeExplorer({
    required this.randomRecipes,
    required super.categories,
    required super.tags,
    required super.filter,
    required this.revision,
  });

  final List<Recipe> randomRecipes;
  final int revision;

  @override
  List<Object?> get props => [
    randomRecipes,
    categories,
    tags,
    filter,
    revision,
  ];
}

class FailedRandomRecipeExplorer extends RandomRecipeExplorerState {
  const FailedRandomRecipeExplorer({
    required this.error,
    super.categories,
    super.tags,
    super.filter,
  });

  final Object error;

  @override
  List<Object?> get props => [error, categories, tags, filter];
}
