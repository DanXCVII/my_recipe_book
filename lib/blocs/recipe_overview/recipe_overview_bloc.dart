import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../constants/global_constants.dart' as constants;
import '../../local_storage/local_repository.dart';
import '../../models/enums.dart';
import '../../models/recipe.dart';
import '../../models/recipe_sort.dart';
import '../../models/string_int_tuple.dart';
import '../../util/helper.dart';
import '../recipe_manager/recipe_manager_bloc.dart' as RM;

part 'recipe_overview_event.dart';
part 'recipe_overview_state.dart';

class RecipeOverviewBloc
    extends Bloc<RecipeOverviewEvent, RecipeOverviewState> {
  RecipeOverviewBloc({
    required this.recipeManagerBloc,
    required this.repository,
  }) : super(LoadingRecipeOverview()) {
    subscription = recipeManagerBloc.stream.listen(_onRecipeManagerState);

    on<LoadCategoryRecipeOverview>(_loadCategory);
    on<LoadVegetableRecipeOverview>(_loadVegetable);
    on<LoadRecipeTagRecipeOverview>(_loadRecipeTag);
    on<ChangeRecipeSort>(_changeSort);
    on<ChangeAscending>(_changeAscending);
    on<FilterRecipesVegetable>(_filterVegetable);
    on<FilterRecipesTag>(_filterTags);
    on<FilterRecipesQuery>(_filterQuery);
    on<ClearRecipeFilters>(_clearFilters);
    on<RetryRecipeOverview>(_retry);
    on<AddRecipes>(_addRecipes);
    on<DeleteRecipe>(_deleteRecipe);
    on<UpdateRecipe>(_updateRecipe);
    on<UpdateFavoriteStatus>(_updateFavoriteStatus);
  }

  final RM.RecipeManagerBloc recipeManagerBloc;
  final LocalRepository repository;
  late final StreamSubscription<RM.RecipeManagerState> subscription;

  List<Recipe> _allRecipes = [];
  String? _category;
  Vegetable? _routeVegetable;
  StringIntTuple? _routeRecipeTag;
  RSort _recipeSort = RSort(RecipeSort.BY_NAME, true);
  String _query = '';
  Vegetable? _selectedVegetable;
  List<String> _selectedRecipeTags = [];

  void _onRecipeManagerState(RM.RecipeManagerState managerState) {
    if (state is! LoadedRecipeOverview) return;

    if (managerState is RM.AddRecipesState) {
      add(AddRecipes(managerState.recipes));
    } else if (managerState is RM.DeleteRecipeState) {
      add(DeleteRecipe(managerState.recipe));
    } else if (managerState is RM.UpdateRecipeState) {
      add(UpdateRecipe(managerState.oldRecipe, managerState.updatedRecipe));
    } else if (managerState is RM.AddFavoriteState) {
      add(UpdateFavoriteStatus(managerState.recipe));
    } else if (managerState is RM.RemoveFavoriteState) {
      add(UpdateFavoriteStatus(managerState.recipe));
    }
  }

  Future<void> _loadCategory(
    LoadCategoryRecipeOverview event,
    Emitter<RecipeOverviewState> emit,
  ) async {
    _resetContext(category: event.category);
    emit(LoadingRecipes(category: event.category));
    try {
      _recipeSort = await repository.getSortOrder(event.category);
      _allRecipes = await repository.getCategoryRecipes(event.category);
      _emitLoaded(emit);
    } catch (_) {
      emit(FailedRecipeOverview(category: event.category));
    }
  }

  Future<void> _loadVegetable(
    LoadVegetableRecipeOverview event,
    Emitter<RecipeOverviewState> emit,
  ) async {
    _resetContext(vegetable: event.vegetable);
    emit(LoadingRecipes(vegetable: event.vegetable));
    try {
      _allRecipes = await repository.getVegetableRecipes(event.vegetable);
      _emitLoaded(emit);
    } catch (_) {
      emit(FailedRecipeOverview(vegetable: event.vegetable));
    }
  }

  Future<void> _loadRecipeTag(
    LoadRecipeTagRecipeOverview event,
    Emitter<RecipeOverviewState> emit,
  ) async {
    _resetContext(recipeTag: event.recipeTag);
    emit(LoadingRecipes(recipeTag: event.recipeTag));
    try {
      _allRecipes = await repository.getRecipeTagRecipes(event.recipeTag.text);
      _emitLoaded(emit);
    } catch (_) {
      emit(FailedRecipeOverview(recipeTag: event.recipeTag));
    }
  }

  void _resetContext({
    String? category,
    Vegetable? vegetable,
    StringIntTuple? recipeTag,
  }) {
    _category = category;
    _routeVegetable = vegetable;
    _routeRecipeTag = recipeTag;
    _recipeSort = RSort(RecipeSort.BY_NAME, true);
    _query = '';
    _selectedVegetable = null;
    _selectedRecipeTags = [];
  }

  Future<void> _changeSort(
    ChangeRecipeSort event,
    Emitter<RecipeOverviewState> emit,
  ) async {
    if (state is! LoadedRecipeOverview) return;
    _recipeSort = RSort(event.recipeSort, _recipeSort.ascending ?? true);
    await _persistCategorySort();
    _emitLoaded(emit);
  }

  Future<void> _changeAscending(
    ChangeAscending event,
    Emitter<RecipeOverviewState> emit,
  ) async {
    if (state is! LoadedRecipeOverview) return;
    _recipeSort = RSort(_recipeSort.sort, event.ascending);
    await _persistCategorySort();
    _emitLoaded(emit);
  }

  Future<void> _persistCategorySort() async {
    if (_category != null) {
      await repository.changeSortOrder(_recipeSort, _category!);
    }
  }

  void _filterVegetable(
    FilterRecipesVegetable event,
    Emitter<RecipeOverviewState> emit,
  ) {
    if (state is! LoadedRecipeOverview) return;
    _selectedVegetable = event.vegetable;
    _emitLoaded(emit);
  }

  void _filterTags(FilterRecipesTag event, Emitter<RecipeOverviewState> emit) {
    if (state is! LoadedRecipeOverview) return;
    _selectedRecipeTags = List<String>.from(event.recipeTags);
    _emitLoaded(emit);
  }

  void _filterQuery(
    FilterRecipesQuery event,
    Emitter<RecipeOverviewState> emit,
  ) {
    if (state is! LoadedRecipeOverview) return;
    _query = event.query;
    _emitLoaded(emit);
  }

  void _clearFilters(
    ClearRecipeFilters event,
    Emitter<RecipeOverviewState> emit,
  ) {
    if (state is! LoadedRecipeOverview) return;
    _query = '';
    _selectedVegetable = null;
    _selectedRecipeTags = [];
    _emitLoaded(emit);
  }

  void _retry(RetryRecipeOverview event, Emitter<RecipeOverviewState> emit) {
    if (_category != null) {
      add(LoadCategoryRecipeOverview(_category!));
    } else if (_routeVegetable != null) {
      add(LoadVegetableRecipeOverview(_routeVegetable!));
    } else if (_routeRecipeTag != null) {
      add(LoadRecipeTagRecipeOverview(_routeRecipeTag!));
    }
  }

  void _addRecipes(AddRecipes event, Emitter<RecipeOverviewState> emit) {
    if (state is! LoadedRecipeOverview) return;
    final names = _allRecipes.map((recipe) => recipe.name).toSet();
    for (final recipe in event.recipes) {
      if (_belongsToOverview(recipe) && names.add(recipe.name)) {
        _allRecipes.add(recipe);
      }
    }
    _emitLoaded(emit);
  }

  void _deleteRecipe(DeleteRecipe event, Emitter<RecipeOverviewState> emit) {
    if (state is! LoadedRecipeOverview) return;
    _allRecipes = _allRecipes
        .where((recipe) => recipe.name != event.recipe.name)
        .toList();
    _emitLoaded(emit);
  }

  void _updateRecipe(UpdateRecipe event, Emitter<RecipeOverviewState> emit) {
    if (state is! LoadedRecipeOverview) return;
    final oldIndex = _allRecipes.indexWhere(
      (recipe) => recipe.name == event.oldRecipe.name,
    );
    final updatedBelongs = _belongsToOverview(event.updatedRecipe);

    if (oldIndex >= 0 && updatedBelongs) {
      _allRecipes = List<Recipe>.from(_allRecipes)
        ..[oldIndex] = event.updatedRecipe;
    } else if (oldIndex >= 0) {
      _allRecipes = List<Recipe>.from(_allRecipes)..removeAt(oldIndex);
    } else if (updatedBelongs) {
      _allRecipes = List<Recipe>.from(_allRecipes)..add(event.updatedRecipe);
    }
    _emitLoaded(emit);
  }

  void _updateFavoriteStatus(
    UpdateFavoriteStatus event,
    Emitter<RecipeOverviewState> emit,
  ) {
    if (state is! LoadedRecipeOverview) return;
    final index = _allRecipes.indexWhere(
      (recipe) => recipe.name == event.recipe.name,
    );
    if (index < 0) return;
    _allRecipes = List<Recipe>.from(_allRecipes)..[index] = event.recipe;
    _emitLoaded(emit);
  }

  void _emitLoaded(Emitter<RecipeOverviewState> emit) {
    final normalizedQuery = _query.trim().toLowerCase();
    final visibleRecipes = _allRecipes.where((recipe) {
      if (_selectedVegetable != null &&
          recipe.vegetable != _selectedVegetable) {
        return false;
      }

      final tagNames = recipe.tags.map((tag) => tag.text).toList();
      if (!_selectedRecipeTags.every(tagNames.contains)) return false;

      if (normalizedQuery.isEmpty) return true;
      if (recipe.name.toLowerCase().contains(normalizedQuery)) return true;
      return tagNames.any(
        (tagName) => tagName.toLowerCase().contains(normalizedQuery),
      );
    }).toList();

    _sortRecipes(visibleRecipes);

    emit(
      LoadedRecipeOverview(
        allRecipes: List<Recipe>.unmodifiable(_allRecipes),
        visibleRecipes: List<Recipe>.unmodifiable(visibleRecipes),
        category: _category,
        vegetable: _routeVegetable,
        recipeTag: _routeRecipeTag,
        recipeSort: _recipeSort,
        query: _query,
        selectedVegetable: _selectedVegetable,
        selectedRecipeTags: List<String>.unmodifiable(_selectedRecipeTags),
      ),
    );
  }

  bool _belongsToOverview(Recipe recipe) {
    if (_category != null) {
      if (_category == constants.allCategories) return true;
      if (_category == constants.noCategory) return recipe.categories.isEmpty;
      return recipe.categories.contains(_category);
    }
    if (_routeVegetable != null) {
      return recipe.vegetable == _routeVegetable;
    }
    if (_routeRecipeTag != null) {
      return recipe.tags.any((tag) => tag.text == _routeRecipeTag!.text);
    }
    return false;
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
