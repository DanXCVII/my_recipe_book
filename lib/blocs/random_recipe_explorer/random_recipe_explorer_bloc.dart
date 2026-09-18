import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../local_storage/local_repository.dart';
import '../../models/recipe.dart';
import '../../models/string_int_tuple.dart';
import '../recipe_manager/recipe_manager_bloc.dart' as rm;

part 'random_recipe_explorer_event.dart';
part 'random_recipe_explorer_state.dart';

class RandomRecipeExplorerBloc
    extends Bloc<RandomRecipeExplorerEvent, RandomRecipeExplorerState> {
  RandomRecipeExplorerBloc({
    required this.recipeManagerBloc,
    required this.repository,
    Random? random,
  }) : _random = random ?? Random(),
       super(const LoadingRandomRecipeExplorer()) {
    _subscription = recipeManagerBloc.stream.listen(_onRecipeManagerState);
    on<InitializeRandomRecipeExplorer>(_onInitialize);
    on<ReloadRandomRecipeExplorer>(_onReload);
    on<ChangeExploreFilter>(_onChangeFilter);
    on<UpdateExploreRecipe>(_onUpdateRecipe);
  }

  final rm.RecipeManagerBloc recipeManagerBloc;
  final LocalRepository repository;
  final Random _random;
  int _deckRevision = 0;
  late final StreamSubscription<rm.RecipeManagerState> _subscription;

  void _onRecipeManagerState(rm.RecipeManagerState managerState) {
    if (managerState is rm.AddFavoriteState) {
      add(UpdateExploreRecipe(managerState.recipe.copyWith(isFavorite: true)));
      return;
    }
    if (managerState is rm.RemoveFavoriteState) {
      add(UpdateExploreRecipe(managerState.recipe.copyWith(isFavorite: false)));
      return;
    }
    if (managerState is rm.UpdateRecipeState) {
      add(const ReloadRandomRecipeExplorer());
      return;
    }
    if (managerState is rm.AddRecipesState ||
        managerState is rm.DeleteRecipeState ||
        managerState is rm.AddCategoriesState ||
        managerState is rm.DeleteCategoryState ||
        managerState is rm.UpdateCategoryState ||
        managerState is rm.MoveCategoryState ||
        managerState is rm.AddRecipeTagsState ||
        managerState is rm.DeleteRecipeTagState ||
        managerState is rm.UpdateRecipeTagState) {
      add(const ReloadRandomRecipeExplorer());
    }
  }

  Future<void> _onInitialize(
    InitializeRandomRecipeExplorer event,
    Emitter<RandomRecipeExplorerState> emit,
  ) async {
    await _load(event.filter ?? state.filter, emit);
  }

  Future<void> _onReload(
    ReloadRandomRecipeExplorer event,
    Emitter<RandomRecipeExplorerState> emit,
  ) async {
    await _load(state.filter, emit);
  }

  Future<void> _onChangeFilter(
    ChangeExploreFilter event,
    Emitter<RandomRecipeExplorerState> emit,
  ) async {
    await _load(event.filter, emit);
  }

  void _onUpdateRecipe(
    UpdateExploreRecipe event,
    Emitter<RandomRecipeExplorerState> emit,
  ) {
    final current = state;
    if (current is! LoadedRandomRecipeExplorer) return;
    final containsRecipe = current.randomRecipes.any(
      (recipe) => recipe.name == event.recipe.name,
    );
    if (!containsRecipe) return;
    emit(
      LoadedRandomRecipeExplorer(
        randomRecipes: current.randomRecipes
            .map(
              (recipe) =>
                  recipe.name == event.recipe.name ? event.recipe : recipe,
            )
            .toList(growable: false),
        categories: current.categories,
        tags: current.tags,
        filter: current.filter,
        revision: current.revision,
      ),
    );
  }

  Future<void> _load(
    ExploreFilter requestedFilter,
    Emitter<RandomRecipeExplorerState> emit,
  ) async {
    final previous = state;
    emit(
      LoadingRandomRecipeExplorer(
        categories: previous.categories,
        tags: previous.tags,
        filter: requestedFilter,
      ),
    );
    try {
      final categories = List<String>.unmodifiable(
        repository.getCategoryNames(),
      );
      final tags = List<StringIntTuple>.unmodifiable(
        repository.getRecipeTags(),
      );
      final filter = _validatedFilter(requestedFilter, categories, tags);
      final source = switch (filter.kind) {
        ExploreFilterKind.all => await repository.getAllRecipes(),
        ExploreFilterKind.category => await repository.getCategoryRecipes(
          filter.value!,
        ),
        ExploreFilterKind.tag => await repository.getRecipeTagRecipes(
          filter.value!,
        ),
      };
      final recipesByName = <String, Recipe>{
        for (final recipe in source) recipe.name: recipe,
      };
      final deck = recipesByName.values.toList()..shuffle(_random);
      emit(
        LoadedRandomRecipeExplorer(
          randomRecipes: List<Recipe>.unmodifiable(deck),
          categories: categories,
          tags: tags,
          filter: filter,
          revision: ++_deckRevision,
        ),
      );
    } catch (error) {
      emit(
        FailedRandomRecipeExplorer(
          error: error,
          categories: previous.categories,
          tags: previous.tags,
          filter: requestedFilter,
        ),
      );
    }
  }

  ExploreFilter _validatedFilter(
    ExploreFilter requested,
    List<String> categories,
    List<StringIntTuple> tags,
  ) {
    return switch (requested.kind) {
      ExploreFilterKind.all => requested,
      ExploreFilterKind.category when categories.contains(requested.value) =>
        requested,
      ExploreFilterKind.tag
          when tags.any((tag) => tag.text == requested.value) =>
        requested,
      _ => const ExploreFilter.all(),
    };
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
