import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../local_storage/hive.dart';
import '../../models/recipe.dart';
import '../recipe_manager/recipe_manager_bloc.dart' as RM;

part 'random_recipe_explorer_event.dart';
part 'random_recipe_explorer_state.dart';

class RandomRecipeExplorerBloc
    extends Bloc<RandomRecipeExplorerEvent, RandomRecipeExplorerState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  StreamSubscription subscription;

  RandomRecipeExplorerBloc({@required this.recipeManagerBloc})
      : super(LoadingRandomRecipeExplorer()) {
    subscription = recipeManagerBloc.stream.listen((rmState) {
      if (state is LoadedRandomRecipeExplorer) {
        final List<String> categories =
            (this.state as LoadedRandomRecipeExplorer).categories;
        final int selectedIndex =
            (this.state as LoadedRandomRecipeExplorer).selectedCategory;
        final String selectedCategory = categories[selectedIndex];

        if (rmState is RM.AddRecipesState) {
          for (Recipe recipe in rmState.recipes) {
            if (recipe.categories.contains(selectedCategory) ||
                selectedCategory == "all categories" ||
                (recipe.categories.isEmpty &&
                    selectedCategory == "no category")) {
              add(ReloadRandomRecipeExplorer());
            }
          }
        } else if (rmState is RM.DeleteRecipeState) {
          add(ReloadRandomRecipeExplorer());
        } else if (rmState is RM.UpdateRecipeState) {
          add(UpdateRecipe(rmState.oldRecipe, rmState.updatedRecipe));
        } else if (rmState is RM.AddFavoriteState) {
          add(UpdateRecipe(
              rmState.recipe.copyWith(isFavorite: false), rmState.recipe));
        } else if (rmState is RM.RemoveFavoriteState) {
          add(UpdateRecipe(
              rmState.recipe.copyWith(isFavorite: true), rmState.recipe));
        } else if (rmState is RM.AddCategoriesState) {
          add(AddCategories(rmState.categories));
        } else if (rmState is RM.DeleteCategoryState) {
          add(DeleteCategory(rmState.category));
        } else if (rmState is RM.UpdateCategoryState) {
          add(UpdateCategory(rmState.oldCategory, rmState.updatedCategory));
        } else if (rmState is RM.DeleteRecipeTagState ||
            rmState is RM.UpdateRecipeTagState) {
          add(InitializeRandomRecipeExplorer(
              selectedCategory:
                  (state as LoadedRandomRecipeExplorer).categories[
                      (state as LoadedRandomRecipeExplorer).selectedCategory]));
        } else if (rmState is RM.MoveCategoryState) {
          add(MoveCategory(rmState.oldIndex, rmState.newIndex));
        }
      }
    });

    on<InitializeRandomRecipeExplorer>((event, emit) async {
      final List<String> categories = HiveProvider().getCategoryNames()
        ..insert(0, 'all categories');

      List<Recipe/*!*/> randomRecipes = [];
      for (int i = 0; i < 50; i++) {
        randomRecipes.add(await HiveProvider().getRandomRecipeOfCategory(
          category: event.selectedCategory == "all categories"
              ? null
              : event.selectedCategory,
          excludedRecipe: randomRecipes.isNotEmpty ? randomRecipes.last : null,
        ));
      }
      emit(LoadedRandomRecipeExplorer(
          randomRecipes[0] == null ? [] : randomRecipes,
          categories,
          categories.indexOf(event.selectedCategory)));
    });

    on<AddCategories>((event, emit) async {
      if (state is LoadedRandomRecipeExplorer) {
        final List<String> categories =
            List<String>.from((state as LoadedRandomRecipeExplorer).categories)
              ..insertAll(
                  (state as LoadedRandomRecipeExplorer).categories.length - 1,
                  event.categories);

        emit(LoadedRandomRecipeExplorer(
          (state as LoadedRandomRecipeExplorer).randomRecipes,
          categories,
          (state as LoadedRandomRecipeExplorer).selectedCategory,
        ));
      }
    });

    on<DeleteCategory>((event, emit) async {
      if (state is LoadedRandomRecipeExplorer) {
        List<String> categories =
            List<String>.from((state as LoadedRandomRecipeExplorer).categories);
        int selectedIndex =
            (state as LoadedRandomRecipeExplorer).selectedCategory;
        if (categories.indexOf(event.category) == selectedIndex) {
          List<Recipe> randomRecipes = [];
          for (int i = 0; i < 10; i++) {
            randomRecipes.add(await HiveProvider().getRandomRecipeOfCategory());
          }

          emit(LoadedRandomRecipeExplorer(
            randomRecipes[0] == null ? [] : randomRecipes,
            List<String>.from(categories)..remove(event.category),
            selectedIndex,
          ));
        } else if (categories.indexOf(event.category) < selectedIndex) {
          emit(LoadedRandomRecipeExplorer(
            (state as LoadedRandomRecipeExplorer).randomRecipes,
            List<String>.from(categories)..remove(event.category),
            selectedIndex - 1,
          ));
        } else {
          emit(LoadedRandomRecipeExplorer(
            (state as LoadedRandomRecipeExplorer).randomRecipes,
            List<String>.from(categories)..remove(event.category),
            (state as LoadedRandomRecipeExplorer).selectedCategory,
          ));
        }
      }
    });

    on<UpdateRecipe>((event, emit) async {
      if (state is LoadedRandomRecipeExplorer) {
        List<Recipe> randomRecipes =
            (state as LoadedRandomRecipeExplorer).randomRecipes;

        bool updated = false;
        // while randomRecipes contains the old recipe
        while (randomRecipes.contains(event.oldRecipe)) {
          // update them
          randomRecipes[randomRecipes.indexOf(event.oldRecipe)] =
              event.updatedRecipe;
          updated = true;
        }

        if (updated == true) {
          emit(LoadedRandomRecipeExplorer(
            randomRecipes,
            (state as LoadedRandomRecipeExplorer).categories,
            (state as LoadedRandomRecipeExplorer).selectedCategory,
          ));
        }
      }
    });

    on<DeleteRecipe>((event, emit) async {
      if (state is LoadedRandomRecipeExplorer) {
        List<Recipe> randomRecipes =
            (state as LoadedRandomRecipeExplorer).randomRecipes;
        List<String> categories =
            (state as LoadedRandomRecipeExplorer).categories;
        int selectedIndex =
            (state as LoadedRandomRecipeExplorer).selectedCategory;

        if (await HiveProvider().getRandomRecipeOfCategory(
                category:
                    selectedIndex == 0 ? null : categories[selectedIndex]) ==
            null) {
          emit(LoadedRandomRecipeExplorer([], categories, selectedIndex));
          return;
        }

        bool updated = false;
        while (randomRecipes.contains(event.recipe)) {
          randomRecipes[randomRecipes.indexOf(event.recipe)] =
              await HiveProvider().getRandomRecipeOfCategory(
                  category:
                      selectedIndex == 0 ? null : categories[selectedIndex]);
          updated = true;
        }
        if (updated) {
          emit(LoadedRandomRecipeExplorer(
              randomRecipes, categories, selectedIndex));
        }
      }
    });

    on<UpdateCategory>((event, emit) async {
      if (state is LoadedRandomRecipeExplorer) {
        final List<String> categories =
            List<String>.from((state as LoadedRandomRecipeExplorer).categories);
        int renamedCategoryIndex = categories.indexOf(event.oldCategory);
        categories[renamedCategoryIndex] = event.updatedCategory;

        emit(LoadedRandomRecipeExplorer(
          (state as LoadedRandomRecipeExplorer)
              .randomRecipes
              .map(
                (recipe) => recipe.copyWith(
                  categories: recipe.categories
                      .map(
                        (category) => category == event.oldCategory
                            ? event.updatedCategory
                            : category,
                      )
                      .toList(),
                ),
              )
              .toList(),
          categories,
          (state as LoadedRandomRecipeExplorer).selectedCategory,
        ));
      }
    });

    on<ReloadRandomRecipeExplorer>((event, emit) async {
      if (state is LoadedRandomRecipeExplorer) {
        final List<String> categories =
            (state as LoadedRandomRecipeExplorer).categories;
        final int selectedCategory =
            (state as LoadedRandomRecipeExplorer).selectedCategory;
        final List<Recipe> randomRecipes = [];

        emit(LoadingRecipes(categories, selectedCategory));

        for (int i = 0; i < 50; i++) {
          randomRecipes.add(await HiveProvider().getRandomRecipeOfCategory(
              category:
                  selectedCategory == 0 ? null : categories[selectedCategory]));
        }

        emit(LoadedRandomRecipeExplorer(
          randomRecipes[0] == null ? null : randomRecipes,
          categories,
          selectedCategory,
        ));
      }
    });

    on<MoveCategory>((event, emit) async {
      if (state is LoadedRandomRecipeExplorer) {
        if (state is LoadedRandomRecipeExplorer) {
          List<String> oldCategoryRandomImageList =
              (state as LoadedRandomRecipeExplorer).categories;
          // verify if working
          List<String> newCategoryRandomImageList = oldCategoryRandomImageList
            ..insert(event.newIndex + 1,
                oldCategoryRandomImageList[event.oldIndex + 1])
            ..removeAt(event.oldIndex > event.newIndex
                ? event.oldIndex + 2
                : event.oldIndex + 1);

          emit(LoadedRandomRecipeExplorer(
            (state as LoadedRandomRecipeExplorer).randomRecipes,
            newCategoryRandomImageList,
            (state as LoadedRandomRecipeExplorer).selectedCategory,
          ));
        }
      }
    });

    on<ChangeCategory>((event, emit) async {
      add(InitializeRandomRecipeExplorer(selectedCategory: event.category));
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
