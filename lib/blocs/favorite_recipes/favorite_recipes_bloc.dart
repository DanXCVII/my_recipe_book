import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../constants/global_constants.dart' as constants;
import '../../local_storage/local_repository.dart';
import '../../models/enums.dart';
import '../../models/recipe.dart';
import '../../models/recipe_sort.dart';
import '../../util/helper.dart';
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
    on<FilterFavoritesCategory>((event, emit) {
      _selectedCategory = event.category;
      _emitLoaded(emit);
    });
    on<FilterFavoritesVegetable>((event, emit) {
      _selectedVegetable = event.vegetable;
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
      _selectedCategory = null;
      _selectedVegetable = null;
      _emitLoaded(emit);
    });
  }

  final RM.RecipeManagerBloc recipeManagerBloc;
  final LocalRepository repository;
  late final StreamSubscription<RM.RecipeManagerState> subscription;

  List<Recipe> _allRecipes = [];
  RSort _recipeSort = RSort(RecipeSort.BY_LAST_MODIFIED, false);
  String _query = '';
  String? _selectedCategory;
  Vegetable? _selectedVegetable;

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
      _normalizeSelectedCategory();
      _emitLoaded(emit);
    } catch (_) {
      emit(FailedFavorites());
    }
  }

  void _normalizeSelectedCategory() {
    if (_selectedCategory == null) return;
    if (!_categoryCounts().containsKey(_selectedCategory)) {
      _selectedCategory = null;
    }
  }

  void _emitLoaded(Emitter<FavoriteRecipesState> emit) {
    final normalizedQuery = _query.trim().toLowerCase();
    final visibleRecipes = _allRecipes.where((recipe) {
      if (_selectedCategory == constants.noCategory) {
        if (recipe.categories.isNotEmpty) return false;
      } else if (_selectedCategory != null &&
          !recipe.categories.contains(_selectedCategory)) {
        return false;
      }

      if (_selectedVegetable != null &&
          recipe.vegetable != _selectedVegetable) {
        return false;
      }

      if (normalizedQuery.isEmpty) return true;
      if (recipe.name.toLowerCase().contains(normalizedQuery)) return true;
      if (recipe.tags.any(
        (tag) => tag.text.toLowerCase().contains(normalizedQuery),
      )) {
        return true;
      }
      return recipe.ingredients
          .expand((section) => section)
          .any(
            (ingredient) =>
                ingredient.name.toLowerCase().contains(normalizedQuery),
          );
    }).toList();

    _sortRecipes(visibleRecipes);
    emit(
      LoadedFavorites(
        allRecipes: List<Recipe>.unmodifiable(_allRecipes),
        visibleRecipes: List<Recipe>.unmodifiable(visibleRecipes),
        categoryCounts: Map<String, int>.unmodifiable(_categoryCounts()),
        recipeSort: _recipeSort,
        query: _query,
        selectedCategory: _selectedCategory,
        selectedVegetable: _selectedVegetable,
      ),
    );
  }

  Map<String, int> _categoryCounts() {
    final counts = <String, int>{};
    for (final recipe in _allRecipes) {
      if (recipe.categories.isEmpty) {
        counts.update(
          constants.noCategory,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      } else {
        for (final category in recipe.categories) {
          counts.update(category, (count) => count + 1, ifAbsent: () => 1);
        }
      }
    }
    return counts;
  }

  void _sortRecipes(List<Recipe> recipes) {
    final ascending = _recipeSort.ascending ?? true;
    recipes.sort((first, second) {
      final int result;
      switch (_recipeSort.sort) {
        case RecipeSort.BY_NAME:
          result = first.name.toLowerCase().compareTo(
            second.name.toLowerCase(),
          );
        case RecipeSort.BY_EFFORT:
          return _compareNullable(
            first.effort,
            second.effort,
            ascending: ascending,
          );
        case RecipeSort.BY_INGREDIENT_COUNT:
          result = getIngredientCount(first.ingredients)
              .compareTo(getIngredientCount(second.ingredients));
        case RecipeSort.BY_LAST_MODIFIED:
          return _compareNullable(
            DateTime.tryParse(first.lastModified),
            DateTime.tryParse(second.lastModified),
            ascending: ascending,
          );
        case RecipeSort.BY_TOTAL_TIME:
          result = first.totalTime.compareTo(second.totalTime);
      }
      return ascending ? result : -result;
    });
  }

  int _compareNullable<T extends Comparable<Object?>>(
    T? first,
    T? second, {
    required bool ascending,
  }) {
    if (first == null && second == null) return 0;
    if (first == null) return 1;
    if (second == null) return -1;
    final result = first.compareTo(second);
    return ascending ? result : -result;
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
