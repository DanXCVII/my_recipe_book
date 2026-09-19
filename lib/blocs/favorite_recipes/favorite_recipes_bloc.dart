import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../local_storage/local_repository.dart';
import '../../models/enums.dart';
import '../../models/recipe.dart';
import '../../models/recipe_collection_filters.dart';
import '../../models/recipe_sort.dart';
import '../recipe_manager/recipe_manager_bloc.dart' as RM;

part 'favorite_recipes_event.dart';
part 'favorite_recipes_state.dart';

class FavoriteRecipesBloc
    extends Bloc<FavoriteRecipesEvent, FavoriteRecipesState> {
  FavoriteRecipesBloc({
    required this.recipeManagerBloc,
    required this.repository,
  }) : super(LoadingFavorites()) {
    subscription = recipeManagerBloc.stream.listen(_onRecipeManagerState);

    on<LoadFavorites>(_loadFavorites);
    on<FilterFavoritesQuery>((event, emit) {
      _query = event.query;
      _emitLoaded(emit);
    });
    on<UpdateFavoriteFilters>((event, emit) {
      _filters = event.filters.normalizedFor(_allRecipes);
      _emitLoaded(emit);
    });
    on<ChangeFavoritesSort>((event, emit) {
      _recipeSort = RSort(event.recipeSort, _recipeSort.ascending ?? true);
      _emitLoaded(emit);
    });
    on<ChangeFavoritesAscending>((event, emit) {
      _recipeSort = RSort(_recipeSort.sort, event.ascending);
      _emitLoaded(emit);
    });
    on<ClearFavoriteFilters>((event, emit) {
      _query = '';
      _filters = const RecipeCollectionFilters();
      _emitLoaded(emit);
    });
  }

  final RM.RecipeManagerBloc recipeManagerBloc;
  final LocalRepository repository;
  late final StreamSubscription<RM.RecipeManagerState> subscription;

  List<Recipe> _allRecipes = [];
  RSort _recipeSort = RSort(RecipeSort.BY_LAST_MODIFIED, false);
  String _query = '';
  RecipeCollectionFilters _filters = const RecipeCollectionFilters();

  void _onRecipeManagerState(RM.RecipeManagerState managerState) {
    if (managerState is RM.AddFavoriteState ||
        managerState is RM.RemoveFavoriteState ||
        managerState is RM.DeleteRecipeState ||
        managerState is RM.UpdateRecipeState ||
        managerState is RM.AddCategoriesState ||
        managerState is RM.DeleteCategoryState ||
        managerState is RM.UpdateCategoryState) {
      add(const LoadFavorites(showLoading: false));
    }
  }

  Future<void> _loadFavorites(
    LoadFavorites event,
    Emitter<FavoriteRecipesState> emit,
  ) async {
    if (event.showLoading && _allRecipes.isEmpty) emit(LoadingFavorites());
    try {
      _allRecipes = await repository.getFavoriteRecipes();
      _filters = _filters.normalizedFor(_allRecipes);
      _emitLoaded(emit);
    } catch (_) {
      emit(FailedFavorites());
    }
  }

  void _emitLoaded(Emitter<FavoriteRecipesState> emit) {
    _filters = _filters.normalizedFor(_allRecipes);
    final visibleRecipes = sortRecipeCollection(
      filterRecipeCollection(
        recipes: _allRecipes,
        query: _query,
        filters: _filters,
      ),
      _recipeSort,
    );
    emit(
      LoadedFavorites(
        allRecipes: List<Recipe>.unmodifiable(_allRecipes),
        visibleRecipes: List<Recipe>.unmodifiable(visibleRecipes),
        recipeSort: _recipeSort,
        query: _query,
        filters: _filters,
      ),
    );
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
