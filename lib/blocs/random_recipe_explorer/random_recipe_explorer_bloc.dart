import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_state.dart'
    as RMState;
import 'package:my_recipe_book/models/recipe.dart';
import '../../hive.dart';
import 'random_recipe_explorer.dart';

class RandomRecipeExplorerBloc
    extends Bloc<RandomRecipeExplorerEvent, RandomRecipeExplorerState> {
  final RecipeManagerBloc recipeManagerBloc;
  StreamSubscription subscription;

  RandomRecipeExplorerBloc({@required this.recipeManagerBloc}) {
    subscription = recipeManagerBloc.listen((rmState) {
      if (state is LoadedRandomRecipeExplorer) {
        final List<String> categories =
            (this.state as LoadedRandomRecipeExplorer).categories;
        final int selectedIndex =
            (this.state as LoadedRandomRecipeExplorer).selectedCategory;
        final String selectedCategory = categories[selectedIndex];

        if (rmState is RMState.AddRecipeState) {
          if (rmState.recipe.categories.isEmpty) {
            add(InitializeRandomRecipeExplorer());
          }
          if (rmState.recipe.categories.contains(selectedCategory)) {
            add(RotateRecipe());
          }
        } else if (rmState is RMState.DeleteRecipeState) {
          add(DeleteRecipe(rmState.recipe));
        } else if (rmState is RMState.UpdateRecipeState) {
          add(UpdateRecipe(rmState.oldRecipe, rmState.updatedRecipe));
        } else if (rmState is RMState.AddCategoryState) {
          add(AddCategory(rmState.category));
        } else if (rmState is RMState.DeleteCategoryState) {
          add(DeleteCategory(rmState.category));
        } else if (rmState is RMState.UpdateCategoryState) {
          add(UpdateCategory(rmState.oldCategory, rmState.updatedCategory));
        }
      }
    });
  }

  @override
  RandomRecipeExplorerState get initialState => LoadingRandomRecipeExplorer();

  @override
  Stream<RandomRecipeExplorerState> mapEventToState(
    RandomRecipeExplorerEvent event,
  ) async* {
    if (event is InitializeRandomRecipeExplorer) {
      yield* _mapLoadCategoryOverviewToState(event);
    } else if (event is ReloadRandomRecipeExplorer) {
      yield* _mapReloadRandomRecipeExplorerToState(event);
    } else if (event is RotateRecipe) {
      yield* _mapRotateRecipeToState(event);
    } else if (event is AddCategory) {
      yield* _mapAddCategoryToState(event);
    } else if (event is DeleteCategory) {
      yield* _mapDeleteCategoryToState(event);
    } else if (event is UpdateCategory) {
      yield* _mapUpdateCategoryToState(event);
    } else if (event is DeleteRecipe) {
      yield* _mapDeleteRecipeToState(event);
    } else if (event is UpdateRecipe) {
      yield* _mapUpdateRecipeToState(event);
    } else if (event is ChangeCategory) {
      yield* _mapChangeCategoryToState(event);
    }
  }

  Stream<RandomRecipeExplorerState> _mapLoadCategoryOverviewToState(
      InitializeRandomRecipeExplorer event) async* {
    final List<String> categories = HiveProvider().getCategoryNames()
      ..insert(0, 'all categories');

    List<Recipe> randomRecipes = [];
    for (int i = 0; i < 50; i++) {
      randomRecipes.add(await HiveProvider().getRandomRecipeOfCategory(
          category: event.selectedCategory == "all categories"
              ? null
              : event.selectedCategory));
    }
    yield LoadedRandomRecipeExplorer(
        randomRecipes[0] == null ? [] : randomRecipes,
        categories,
        categories.indexOf(event.selectedCategory));
  }

  Stream<RandomRecipeExplorerState> _mapAddCategoryToState(
      AddCategory event) async* {
    if (state is LoadedRandomRecipeExplorer) {
      final List<String> categories = (state as LoadedRandomRecipeExplorer)
          .categories
        ..insert((state as LoadedRandomRecipeExplorer).categories.length - 1,
            event.category);

      yield LoadedRandomRecipeExplorer(
        (state as LoadedRandomRecipeExplorer).randomRecipes,
        categories,
        (state as LoadedRandomRecipeExplorer).selectedCategory,
      );
    }
  }

  Stream<RandomRecipeExplorerState> _mapDeleteCategoryToState(
      DeleteCategory event) async* {
    if (state is LoadedRandomRecipeExplorer) {
      List<String> categories =
          (state as LoadedRandomRecipeExplorer).categories;
      int selectedIndex =
          (state as LoadedRandomRecipeExplorer).selectedCategory;
      if (categories.indexOf(event.category) == selectedIndex) {
        List<Recipe> randomRecipes = [];
        for (int i = 0; i < 10; i++) {
          randomRecipes.add(await HiveProvider().getRandomRecipeOfCategory());
        }

        yield LoadedRandomRecipeExplorer(
            randomRecipes[0] == null ? [] : randomRecipes,
            categories,
            selectedIndex);
      } else if (categories.indexOf(event.category) < selectedIndex) {
        yield LoadedRandomRecipeExplorer(
          (state as LoadedRandomRecipeExplorer).randomRecipes,
          categories,
          selectedIndex - 1,
        );
      }
    }
  }

  Stream<RandomRecipeExplorerState> _mapChangeCategoryToState(
      ChangeCategory event) async* {
    add(InitializeRandomRecipeExplorer(selectedCategory: event.category));
  }

  Stream<RandomRecipeExplorerState> _mapUpdateRecipeToState(
      UpdateRecipe event) async* {
    if (state is LoadedRandomRecipeExplorer) {
      List<Recipe> randomRecipes =
          (state as LoadedRandomRecipeExplorer).randomRecipes;

      if (randomRecipes.contains(event.oldRecipe)) {
        randomRecipes[randomRecipes.indexOf(event.oldRecipe)] =
            event.updatedRecipe;

        yield LoadedRandomRecipeExplorer(
          randomRecipes,
          (state as LoadedRandomRecipeExplorer).categories,
          (state as LoadedRandomRecipeExplorer).selectedCategory,
        );
      }
    }
  }

  Stream<RandomRecipeExplorerState> _mapDeleteRecipeToState(
      DeleteRecipe event) async* {
    if (state is LoadedRandomRecipeExplorer) {
      List<Recipe> randomRecipes =
          (state as LoadedRandomRecipeExplorer).randomRecipes;
      List<String> categories =
          (state as LoadedRandomRecipeExplorer).categories;
      int selectedIndex =
          (state as LoadedRandomRecipeExplorer).selectedCategory;

      if (randomRecipes.contains(event.recipe)) {
        randomRecipes[randomRecipes.indexOf(event.recipe)] =
            await HiveProvider().getRandomRecipeOfCategory(
                category:
                    selectedIndex == 0 ? null : categories[selectedIndex]);

        yield LoadedRandomRecipeExplorer(
            randomRecipes, categories, selectedIndex);
      }
    }
  }

  Stream<RandomRecipeExplorerState> _mapUpdateCategoryToState(
      UpdateCategory event) async* {
    final List<String> categories =
        (state as LoadedRandomRecipeExplorer).categories;
    int renamedCategoryIndex = categories.indexOf(event.oldCategory);
    categories[renamedCategoryIndex] = event.newCategory;

    yield LoadedRandomRecipeExplorer(
      (state as LoadedRandomRecipeExplorer).randomRecipes,
      categories,
      (state as LoadedRandomRecipeExplorer).selectedCategory,
    );
  }

  Stream<RandomRecipeExplorerState> _mapReloadRandomRecipeExplorerToState(
      ReloadRandomRecipeExplorer event) async* {
    if (state is LoadedRandomRecipeExplorer) {
      final List<String> categories =
          (state as LoadedRandomRecipeExplorer).categories;
      final int selectedCategory =
          (state as LoadedRandomRecipeExplorer).selectedCategory;
      final List<Recipe> randomRecipes = [];
      for (int i = 0; i < 50; i++) {
        randomRecipes.add(await HiveProvider().getRandomRecipeOfCategory(
            category:
                selectedCategory == 0 ? null : categories[selectedCategory]));
      }

      yield LoadedRandomRecipeExplorer(
        randomRecipes[0] == null ? null : randomRecipes,
        categories,
        selectedCategory,
      );
    }
  }

  Stream<RandomRecipeExplorerState> _mapRotateRecipeToState(
      RotateRecipe event) async* {
    if (state is LoadedRandomRecipeExplorer) {
      final List<String> categories =
          (state as LoadedRandomRecipeExplorer).categories;
      final int selectedCategory =
          (state as LoadedRandomRecipeExplorer).selectedCategory;

      final Recipe randomRecipe = await HiveProvider()
          .getRandomRecipeOfCategory(
              category:
                  selectedCategory == 0 ? null : categories[selectedCategory]);

      final List<Recipe> randomRecipes = List<Recipe>.from(
          ((state as LoadedRandomRecipeExplorer).randomRecipes))
        ..removeAt(0)
        ..add(randomRecipe);

      yield LoadedRandomRecipeExplorer(
          randomRecipes,
          (state as LoadedRandomRecipeExplorer).categories,
          (state as LoadedRandomRecipeExplorer).selectedCategory);
    }
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
