import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_state.dart'
    as RMState;
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_sort.dart';
import '../../helper.dart';
import '../../hive.dart';
import './recipe_overview.dart';

class RecipeOverviewBloc
    extends Bloc<RecipeOverviewEvent, RecipeOverviewState> {
  final RecipeManagerBloc recipeManagerBloc;
  StreamSubscription subscription;

  RecipeOverviewBloc({@required this.recipeManagerBloc}) {
    subscription = recipeManagerBloc.listen((rmState) {
      if (state is LoadedRecipeOverview) {
        if (rmState is RMState.AddRecipeState) {
          add(AddRecipe(rmState.recipe));
        } else if (rmState is RMState.DeleteRecipeState) {
          add(DeleteRecipe(rmState.recipe));
        } else if (rmState is RMState.UpdateRecipeState) {
          add(UpdateRecipe(rmState.oldRecipe, rmState.updatedRecipe));
        } else if (rmState is RMState.AddFavoriteState) {
          if (state is LoadedRecipeOverview) {
            if (_belongsToRecipeList(rmState.recipe)) {
              add(UpdateFavoriteStatus(rmState.recipe));
            }
          }
        }
      }
    });
  }

  @override
  RecipeOverviewState get initialState => LoadingRecipeOverview();

  @override
  Stream<RecipeOverviewState> mapEventToState(
    RecipeOverviewEvent event,
  ) async* {
    if (event is LoadCategoryRecipeOverview) {
      yield* _mapLoadCategoryRecipeOverviewToState(event);
    } else if (event is LoadVegetableRecipeOverview) {
      yield* _mapLoadVegetableRecipeOverviewToState(event);
    } else if (event is ChangeRecipeSort) {
      yield* _mapChangeRecipeSortToState(event);
    } else if (event is AddRecipe) {
      yield* _mapAddRecipeToState(event);
    } else if (event is DeleteRecipe) {
      yield* _mapDeleteRecipeToState(event);
    } else if (event is UpdateRecipe) {
      yield* _mapUpdateRecipeToState(event);
    } else if (event is UpdateFavoriteStatus) {
      yield* _mapUpdateFavoriteStatus(event);
    }
  }

  Stream<RecipeOverviewState> _mapLoadCategoryRecipeOverviewToState(
      LoadCategoryRecipeOverview event) async* {
    final List<Recipe> recipes =
        await HiveProvider().getCategoryRecipes(event.category);
    final String randomRecipeImage = _getRandomRecipeImage(recipes);

    yield LoadedRecipeOverview(
      recipes: recipes,
      randomImage: randomRecipeImage,
      category: event.category,
    );
  }

  Stream<RecipeOverviewState> _mapLoadVegetableRecipeOverviewToState(
      LoadVegetableRecipeOverview event) async* {
    final List<Recipe> recipes =
        await HiveProvider().getVegetableRecipes(event.vegetable);
    final String randomRecipeImage = _getRandomRecipeImage(recipes);

    yield LoadedRecipeOverview(
      recipes: recipes,
      randomImage: randomRecipeImage,
      vegetable: event.vegetable,
      recipeSort: RSort(RecipeSort.BY_NAME, true),
    );
  }

  Stream<RecipeOverviewState> _mapChangeRecipeSortToState(
      ChangeRecipeSort event) async* {
    if (state is LoadedRecipeOverview) {
      final List<Recipe> recipes = (state as LoadedRecipeOverview).recipes;
      final List<Recipe> sortedRecipes = sortRecipes(event.recipeSort, recipes);

      yield LoadedRecipeOverview(
        recipes: sortedRecipes,
        randomImage: (state as LoadedRecipeOverview).randomImage,
        vegetable: (state as LoadedRecipeOverview).vegetable,
        category: (state as LoadedRecipeOverview).category,
        recipeSort: event.recipeSort,
      );
    }
  }

  Stream<RecipeOverviewState> _mapDeleteRecipeToState(
      DeleteRecipe event) async* {
    if (state is LoadedRecipeOverview) {
      if (_belongsToRecipeList(event.recipe)) {
        final List<Recipe> recipes = (state as LoadedRecipeOverview).recipes
          ..removeWhere((recipe) => event.recipe == recipe);

        yield LoadedRecipeOverview(
          recipes: recipes,
          randomImage: (state as LoadedRecipeOverview).randomImage,
          vegetable: (state as LoadedRecipeOverview).vegetable,
          category: (state as LoadedRecipeOverview).category,
          recipeSort: (state as LoadedRecipeOverview).recipeSort,
        );
      }
    }
  }

  Stream<RecipeOverviewState> _mapAddRecipeToState(AddRecipe event) async* {
    if (state is LoadedRecipeOverview) {
      if (_belongsToRecipeList(event.recipe)) {
        final List<Recipe> recipes = (state as LoadedRecipeOverview).recipes;
        final List<Recipe> sortedRecipes = sortRecipes(
            (state as LoadedRecipeOverview).recipeSort,
            recipes..add(event.recipe));

        yield LoadedRecipeOverview(
          recipes: sortedRecipes,
          randomImage: _getRandomRecipeImage(sortedRecipes),
          vegetable: (state as LoadedRecipeOverview).vegetable,
          category: (state as LoadedRecipeOverview).category,
          recipeSort: (state as LoadedRecipeOverview).recipeSort,
        );
      }
    }
  }

  Stream<RecipeOverviewState> _mapUpdateRecipeToState(
      UpdateRecipe event) async* {
    if (state is LoadedRecipeOverview) {
      if (_belongsToRecipeList(event.oldRecipe) &&
          _belongsToRecipeList(event.updatedRecipe)) {
        final List<Recipe> recipes = (state as LoadedRecipeOverview).recipes;
        int indexOldRecipe = recipes.indexOf(event.oldRecipe);
        final List<Recipe> updatedRecipes = recipes
          ..replaceRange(
              indexOldRecipe, indexOldRecipe + 1, [event.updatedRecipe]);
        final List<Recipe> sortedRecipes = sortRecipes(
            (state as LoadedRecipeOverview).recipeSort, updatedRecipes);

        yield LoadedRecipeOverview(
          recipes: sortedRecipes,
          randomImage: _getRandomRecipeImage(sortedRecipes),
          vegetable: (state as LoadedRecipeOverview).vegetable,
          category: (state as LoadedRecipeOverview).category,
          recipeSort: (state as LoadedRecipeOverview).recipeSort,
        );
      } else if (_belongsToRecipeList(event.oldRecipe) &&
          !_belongsToRecipeList(event.updatedRecipe)) {
        yield* _mapDeleteRecipeToState(DeleteRecipe(event.oldRecipe));
      }
    }
  }

  bool _belongsToRecipeList(Recipe recipe) {
    if (state is LoadedRecipeOverview) {
      // if the bloc shows recipes of a category
      if ((state as LoadedRecipeOverview).category != null) {
        final String overviewCategory =
            (state as LoadedRecipeOverview).category;

        // if the bloc shows recipes of "no cateogry"
        if (recipe.categories.isEmpty && overviewCategory == "no category") {
          return true;
        } // the bloc shows recipes of a userCategory
        else {
          for (String category in recipe.categories) {
            if (category == overviewCategory) {
              return true;
            }
          }
        }
      } // the bloc shows recipes of a vegetable
      else {
        final Vegetable overviewVegetable =
            (state as LoadedRecipeOverview).vegetable;

        if (overviewVegetable == recipe.vegetable) {
          return true;
        }
      }
      return false;
    }
    return false;
  }

  String _getRandomRecipeImage(List<Recipe> recipes) {
    Random r = Random();

    return recipes.isEmpty
        ? null
        : recipes[recipes.length == 1 ? 0 : r.nextInt(recipes.length - 1)]
            .imagePreviewPath;
  }

  List<Recipe> sortRecipes(RSort recipeSort, List<Recipe> recipes) {
    if (recipes.isEmpty) return [];

    switch (recipeSort.sort) {
      case RecipeSort.BY_NAME:
        return recipes
          ..sort((a, b) => recipeSort.ascending
              ? a.name.compareTo(b.name)
              : b.name.compareTo((a.name)));
        break;
      case RecipeSort.BY_EFFORT:
        return recipes
          ..sort((a, b) => recipeSort.ascending
              ? a.effort.compareTo(b.effort)
              : b.effort.compareTo(a.effort));
        break;
      case RecipeSort.BY_INGREDIENT_COUNT:
        return recipes
          ..sort((a, b) => recipeSort.ascending
              ? getIngredientCount(a.ingredients)
                  .compareTo(getIngredientCount(b.ingredients))
              : getIngredientCount(b.ingredients)
                  .compareTo(getIngredientCount(a.ingredients)));
        break;
    }
    return recipes;
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }

  Stream<RecipeOverviewState> _mapUpdateFavoriteStatus(
      UpdateFavoriteStatus event) async* {
    if (state is LoadedRecipeOverview) {
      if (_belongsToRecipeList(event.recipe)) {
        final List<Recipe> recipes =
            List<Recipe>.from((state as LoadedRecipeOverview).recipes);
        int favoriteIndex =
            recipes.indexWhere((recipe) => recipe.name == event.recipe.name);
        final List<Recipe> updatedRecipes = recipes
          ..replaceRange(favoriteIndex, favoriteIndex + 1, [event.recipe]);
        final List<Recipe> sortedRecipes =
            (state as LoadedRecipeOverview).recipeSort == null
                ? updatedRecipes
                : sortRecipes(
                    (state as LoadedRecipeOverview).recipeSort, updatedRecipes);

        yield LoadedRecipeOverview(
          recipes: sortedRecipes,
          randomImage: _getRandomRecipeImage(sortedRecipes),
          vegetable: (state as LoadedRecipeOverview).vegetable,
          category: (state as LoadedRecipeOverview).category,
          recipeSort: (state as LoadedRecipeOverview).recipeSort,
        );
      }
    }
  }
}
