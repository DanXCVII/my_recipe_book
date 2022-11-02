import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';

import '../../util/helper.dart';
import '../../local_storage/hive.dart';
import '../../models/enums.dart';
import '../../models/recipe.dart';
import '../../models/recipe_sort.dart';
import '../recipe_manager/recipe_manager_bloc.dart' as RM;

part 'recipe_overview_event.dart';
part 'recipe_overview_state.dart';

class RecipeOverviewBloc
    extends Bloc<RecipeOverviewEvent, RecipeOverviewState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  late StreamSubscription subscription;

  Vegetable? currentVegetableFilter;
  List<String> currentRecipeTagFilter = [];

  List<Recipe> unfilteredRecipes = [];

  RecipeOverviewBloc({required this.recipeManagerBloc})
      : super(LoadingRecipeOverview()) {
    subscription = recipeManagerBloc.stream.listen((rmState) {
      if (state is LoadedRecipeOverview) {
        if (rmState is RM.AddRecipesState) {
          add(AddRecipes(rmState.recipes));
        } else if (rmState is RM.DeleteRecipeState) {
          add(DeleteRecipe(rmState.recipe));
        } else if (rmState is RM.UpdateRecipeState) {
          add(UpdateRecipe(rmState.oldRecipe, rmState.updatedRecipe));
        } else if (rmState is RM.AddFavoriteState) {
          if (state is LoadedRecipeOverview) {
            if (_belongsToRecipeList(rmState.recipe)) {
              add(UpdateFavoriteStatus(rmState.recipe));
            }
          }
        } else if (rmState is RM.RemoveFavoriteState) {
          if (state is LoadedRecipeOverview) {
            if (_belongsToRecipeList(rmState.recipe)) {
              add(UpdateFavoriteStatus(rmState.recipe));
            }
          }
        }
      }
    });

    on<LoadCategoryRecipeOverview>((event, emit) async {
      final Recipe? randomRecipe = (await HiveProvider()
          .getRandomRecipeOfCategory(category: event.category));
      final String? randomRecipeImage =
          randomRecipe != null ? randomRecipe.imagePreviewPath : null;

      emit(LoadingRecipes(
        randomImage: randomRecipeImage,
        category: event.category,
      ));

      final RSort categorySort =
          await HiveProvider().getSortOrder(event.category);
      final List<Recipe> recipes =
          await HiveProvider().getCategoryRecipes(event.category);
      final List<Recipe> sortedRecipes = sortRecipes(categorySort, recipes);

      unfilteredRecipes = List<Recipe>.from(sortedRecipes);

      emit(LoadedRecipeOverview(
        recipes: sortedRecipes,
        randomImage: randomRecipeImage,
        recipeSort: categorySort,
        category: event.category,
      ));
    });

    on<LoadVegetableRecipeOverview>((event, emit) async {
      final Recipe? randomRecipe =
          await HiveProvider().getRandomRecipeOfVegetable(event.vegetable);
      final String? randomRecipeImage =
          randomRecipe != null ? randomRecipe.imagePreviewPath : null;

      emit(LoadingRecipes(
        randomImage: randomRecipeImage,
        vegetable: event.vegetable,
      ));

      final List<Recipe> recipes =
          await HiveProvider().getVegetableRecipes(event.vegetable);

      unfilteredRecipes = List<Recipe>.from(recipes);

      emit(LoadedRecipeOverview(
        recipes: recipes,
        randomImage: randomRecipeImage,
        vegetable: event.vegetable,
        recipeSort: RSort(RecipeSort.BY_NAME, true),
      ));
    });

    on<ChangeRecipeSort>((event, emit) async {
      if (state is LoadedRecipeOverview) {
        final RSort newRecipeSort = RSort(event.recipeSort,
            (state as LoadedRecipeOverview).recipeSort!.ascending);

        final List<Recipe> recipes = (state as LoadedRecipeOverview).recipes!;
        final List<Recipe> sortedRecipes = sortRecipes(newRecipeSort, recipes);
        unfilteredRecipes = sortedRecipes;

        if ((state as LoadedRecipeOverview).category != null) {
          await HiveProvider().changeSortOrder(
              newRecipeSort, (state as LoadedRecipeOverview).category!);
        }

        emit(LoadedRecipeOverview(
          recipes: sortedRecipes,
          randomImage: (state as LoadedRecipeOverview).randomImage,
          vegetable: (state as LoadedRecipeOverview).vegetable,
          category: (state as LoadedRecipeOverview).category,
          recipeTag: (state as LoadedRecipeOverview).recipeTag,
          recipeSort: newRecipeSort,
        ));
      }
    });

    on<AddRecipes>((event, emit) async {
      if (state is LoadedRecipeOverview) {
        final List<Recipe> recipes = (state as LoadedRecipeOverview).recipes!;

        for (Recipe r in event.recipes) {
          if (_belongsToRecipeList(r)) {
            recipes..add(r);
          }
        }
        final List<Recipe> sortedRecipes =
            sortRecipes((state as LoadedRecipeOverview).recipeSort, recipes);

        emit(LoadedRecipeOverview(
          recipes: sortedRecipes,
          randomImage: _getRandomRecipeImage(sortedRecipes),
          vegetable: (state as LoadedRecipeOverview).vegetable,
          category: (state as LoadedRecipeOverview).category,
          recipeTag: (state as LoadedRecipeOverview).recipeTag,
          recipeSort: (state as LoadedRecipeOverview).recipeSort,
        ));
      }
    });

    on<DeleteRecipe>((event, emit) async {
      if (state is LoadedRecipeOverview) {
        if (_belongsToRecipeList(event.recipe)) {
          final List<Recipe> recipes =
              List<Recipe>.from((state as LoadedRecipeOverview).recipes!)
                ..removeWhere((recipe) => event.recipe == recipe);

          emit(LoadedRecipeOverview(
            recipes: recipes,
            randomImage: (state as LoadedRecipeOverview).randomImage,
            vegetable: (state as LoadedRecipeOverview).vegetable,
            category: (state as LoadedRecipeOverview).category,
            recipeTag: (state as LoadedRecipeOverview).recipeTag,
            recipeSort: (state as LoadedRecipeOverview).recipeSort,
          ));
        }
      }
    });

    on<UpdateRecipe>((event, emit) async {
      if (state is LoadedRecipeOverview) {
        if (_belongsToRecipeList(event.oldRecipe) &&
            _belongsToRecipeList(event.updatedRecipe)) {
          final List<Recipe> recipes = (state as LoadedRecipeOverview).recipes!;
          int indexOldRecipe = recipes.indexOf(event.oldRecipe);
          final List<Recipe> updatedRecipes = recipes
            ..replaceRange(
                indexOldRecipe, indexOldRecipe + 1, [event.updatedRecipe]);
          final List<Recipe> sortedRecipes = sortRecipes(
              (state as LoadedRecipeOverview).recipeSort, updatedRecipes);

          emit(LoadedRecipeOverview(
            recipes: sortedRecipes,
            randomImage: _getRandomRecipeImage(sortedRecipes),
            vegetable: (state as LoadedRecipeOverview).vegetable,
            category: (state as LoadedRecipeOverview).category,
            recipeTag: (state as LoadedRecipeOverview).recipeTag,
            recipeSort: (state as LoadedRecipeOverview).recipeSort,
          ));
        } else if (_belongsToRecipeList(event.oldRecipe) &&
            !_belongsToRecipeList(event.updatedRecipe)) {
          this.add(DeleteRecipe(event.oldRecipe));
        }
      }
    });

    on<UpdateFavoriteStatus>((event, emit) async {
      if (state is LoadedRecipeOverview) {
        if (_belongsToRecipeList(event.recipe)) {
          final List<Recipe> recipes =
              List<Recipe>.from((state as LoadedRecipeOverview).recipes!);
          int favoriteIndex =
              recipes.indexWhere((recipe) => recipe.name == event.recipe.name);
          final List<Recipe> updatedRecipes = recipes
            ..replaceRange(favoriteIndex, favoriteIndex + 1, [event.recipe]);
          final List<Recipe> sortedRecipes =
              (state as LoadedRecipeOverview).recipeSort == null
                  ? updatedRecipes
                  : sortRecipes((state as LoadedRecipeOverview).recipeSort,
                      updatedRecipes);

          emit(LoadedRecipeOverview(
            recipes: sortedRecipes,
            randomImage: _getRandomRecipeImage(sortedRecipes),
            vegetable: (state as LoadedRecipeOverview).vegetable,
            category: (state as LoadedRecipeOverview).category,
            recipeSort: (state as LoadedRecipeOverview).recipeSort,
          ));
        }
      }
    });

    on<FilterRecipesVegetable>((event, emit) async {
      if (state is LoadedRecipeOverview) {
        currentVegetableFilter = event.vegetable;

        emit(LoadedRecipeOverview(
          recipes: List<Recipe>.from(unfilteredRecipes)
            ..removeWhere((recipe) {
              for (String recipeTagName in currentRecipeTagFilter) {
                if (recipe.tags.firstWhereOrNull((tag) => tag.text == recipeTagName) ==
                    null) {
                  return true;
                }
              }
              if (currentVegetableFilter != null) {
                if (recipe.vegetable != currentVegetableFilter) {
                  return true;
                }
              }
              return false;
            }),
          randomImage: (state as LoadedRecipeOverview).randomImage,
          vegetable: (state as LoadedRecipeOverview).vegetable,
          category: (state as LoadedRecipeOverview).category,
          recipeTag: (state as LoadedRecipeOverview).recipeTag,
          recipeSort: (state as LoadedRecipeOverview).recipeSort,
        ));
      }
    });

    on<ChangeAscending>((event, emit) async {
      if (state is LoadedRecipeOverview) {
        final RSort newRecipeSort = RSort(
            (state as LoadedRecipeOverview).recipeSort!.sort, event.ascending);

        final List<Recipe> recipes =
            List<Recipe>.from((state as LoadedRecipeOverview).recipes!);
        final List<Recipe> sortedRecipes = sortRecipes(newRecipeSort, recipes);
        unfilteredRecipes = sortedRecipes;

        if ((state as LoadedRecipeOverview).category != null) {
          await HiveProvider().changeSortOrder(
              newRecipeSort, (state as LoadedRecipeOverview).category!);
        }

        emit(LoadedRecipeOverview(
          recipes: sortedRecipes,
          randomImage: (state as LoadedRecipeOverview).randomImage,
          vegetable: (state as LoadedRecipeOverview).vegetable,
          category: (state as LoadedRecipeOverview).category,
          recipeTag: (state as LoadedRecipeOverview).recipeTag,
          recipeSort: (state as LoadedRecipeOverview).recipeSort,
        ));
      }
    });

    on<LoadRecipeTagRecipeOverview>((event, emit) async {
      final Recipe? randomRecipe =
          await HiveProvider().getRandomRecipeOfRecipeTag(event.recipeTag.text);
      final String? randomRecipeImage =
          randomRecipe != null ? randomRecipe.imagePreviewPath : null;

      emit(LoadingRecipes(
        randomImage: randomRecipeImage,
        recipeTag: event.recipeTag,
      ));

      final List<Recipe> recipes =
          await HiveProvider().getRecipeTagRecipes(event.recipeTag.text);
      unfilteredRecipes = List<Recipe>.from(recipes);

      emit(LoadedRecipeOverview(
        recipes: recipes,
        randomImage: randomRecipeImage,
        recipeTag: event.recipeTag,
        recipeSort: RSort(RecipeSort.BY_NAME, true),
      ));
    });

    on<FilterRecipesTag>((event, emit) async {
      if (state is LoadedRecipeOverview) {
        currentRecipeTagFilter = event.recipeTags;

        emit(LoadedRecipeOverview(
          recipes: List<Recipe>.from(unfilteredRecipes)
            ..removeWhere((recipe) {
              for (String recipeTagName in event.recipeTags) {
                if (recipe.tags.firstWhereOrNull((tag) => tag.text == recipeTagName) ==
                    null) {
                  return true;
                }
              }
              if (currentVegetableFilter != null) {
                if (recipe.vegetable != currentVegetableFilter) {
                  return true;
                }
              }
              return false;
            }),
          randomImage: (state as LoadedRecipeOverview).randomImage,
          vegetable: (state as LoadedRecipeOverview).vegetable,
          category: (state as LoadedRecipeOverview).category,
          recipeTag: (state as LoadedRecipeOverview).recipeTag,
          recipeSort: (state as LoadedRecipeOverview).recipeSort,
        ));
      }
    });
  }

  bool _belongsToRecipeList(Recipe recipe) {
    if (state is LoadedRecipeOverview) {
      // if the bloc shows recipes of a category
      if ((state as LoadedRecipeOverview).category != null) {
        final String? overviewCategory =
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
        final Vegetable? overviewVegetable =
            (state as LoadedRecipeOverview).vegetable;

        if (overviewVegetable == recipe.vegetable) {
          return true;
        }
      }
      return false;
    }
    return false;
  }

  String? _getRandomRecipeImage(List<Recipe> recipes) {
    Random r = Random();

    return recipes.isEmpty
        ? null
        : recipes[recipes.length == 1 ? 0 : r.nextInt(recipes.length - 1)]
            .imagePreviewPath;
  }

  List<Recipe> sortRecipes(RSort? recipeSort, List<Recipe> recipes) {
    if (recipes.isEmpty) return [];

    switch (recipeSort!.sort) {
      case RecipeSort.BY_NAME:
        return recipes
          ..sort((a, b) => recipeSort.ascending!
              ? a.name.compareTo(b.name)
              : b.name.compareTo((a.name)));
        break;
      case RecipeSort.BY_EFFORT:
        return recipes
          ..sort((a, b) => recipeSort.ascending!
              ? a.effort!.compareTo(b.effort!)
              : b.effort!.compareTo(a.effort!));
        break;
      case RecipeSort.BY_INGREDIENT_COUNT:
        return recipes
          ..sort((a, b) => recipeSort.ascending!
              ? getIngredientCount(a.ingredients)
                  .compareTo(getIngredientCount(b.ingredients))
              : getIngredientCount(b.ingredients)
                  .compareTo(getIngredientCount(a.ingredients)));
        break;
      case RecipeSort.BY_LAST_MODIFIED:
        return recipes
          ..sort((a, b) => recipeSort.ascending!
              ? DateTime.parse(a.lastModified == null
                      ? DateTime.now().toString()
                      : a.lastModified!)
                  .compareTo(DateTime.parse(b.lastModified == null
                      ? DateTime.now().toString()
                      : b.lastModified!))
              : DateTime.parse(b.lastModified == null
                      ? DateTime.now().toString()
                      : b.lastModified!)
                  .compareTo(DateTime.parse(a.lastModified == null
                      ? DateTime.now().toString()
                      : a.lastModified!)));
        break;
    }
    return recipes;
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
