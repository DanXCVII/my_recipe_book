import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_book/blocs/category_overview/category_overview_bloc.dart';
import 'package:my_recipe_book/blocs/random_recipe_explorer/random_recipe_explorer_bloc.dart';

import '../../local_storage/hive.dart';
import '../../models/recipe.dart';
import '../../models/tuple.dart';
import '../recipe_manager/recipe_manager_bloc.dart' as RM;

part 'recipe_category_overview_event.dart';
part 'recipe_category_overview_state.dart';

class RecipeCategoryOverviewBloc
    extends Bloc<RecipeCategoryOverviewEvent, RecipeCategoryOverviewState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  StreamSubscription subscription;

  RecipeCategoryOverviewBloc({@required this.recipeManagerBloc}) {
    subscription = recipeManagerBloc.listen((rmState) {
      if (state is LoadedRecipeCategoryOverview) {
        if (rmState is RM.AddRecipesState) {
          add(RCOAddRecipes(rmState.recipes));
        } else if (rmState is RM.DeleteRecipeState) {
          add(RCODeleteRecipe(rmState.recipe));
        } else if (rmState is RM.UpdateRecipeState) {
          add(RCOUpdateRecipe(rmState.oldRecipe, rmState.updatedRecipe));
        } else if (rmState is RM.AddCategoriesState) {
          add(RCOAddCategory(rmState.categories));
        } else if (rmState is RM.DeleteCategoryState) {
          add(RCODeleteCategory(rmState.category));
        } else if (rmState is RM.UpdateCategoryState) {
          add(RCOUpdateCategory(rmState.oldCategory, rmState.updatedCategory));
        } else if (rmState is RM.MoveCategoryState) {
          add(RCOMoveCategory(rmState.oldIndex, rmState.newIndex));
        }
      }
    });
  }

  @override
  RecipeCategoryOverviewState get initialState =>
      LoadingRecipeCategoryOverviewState();

  @override
  Stream<RecipeCategoryOverviewState> mapEventToState(
    RecipeCategoryOverviewEvent event,
  ) async* {
    if (event is RCOLoadRecipeCategoryOverview) {
      yield* _mapLoadCategoryOverviewToState(event);
    } else if (event is RCOAddRecipes) {
      yield* _mapAddRecipesToState(event);
    } else if (event is RCOUpdateRecipe) {
      yield* _mapUpdateRecipeToState(event);
    } else if (event is RCOAddCategory) {
      yield* _mapAddCategoryToState(event);
    } else if (event is RCODeleteRecipe) {
      yield* _mapDeleteRecipeToState(event);
    } else if (event is RCODeleteCategory) {
      yield* _mapDeleteCategoryToState(event);
    } else if (event is RCOMoveCategory) {
      yield* _mapMoveCategoryToState(event);
    }
  }

  Stream<RecipeCategoryOverviewState> _mapLoadCategoryOverviewToState(
      RCOLoadRecipeCategoryOverview event) async* {
    if (event.reopenBoxes) await HiveProvider().reopenBoxes();

    List<Tuple2<String, List<Recipe>>> categoryRecipes = [];
    final List<String> categories = HiveProvider().getCategoryNames();

    for (String category in categories) {
      List<Recipe> categoryRecipeList =
          await HiveProvider().getCategoryRecipes(category);
      if (category == "no category" && categoryRecipeList.isEmpty) {
      } else {
        categoryRecipes.add(Tuple2(category, categoryRecipeList));
      }
    }

    yield LoadedRecipeCategoryOverview(categoryRecipes);

    if (event.categoryOverviewContext != null) {
      BlocProvider.of<RandomRecipeExplorerBloc>(event.categoryOverviewContext)
          .add(InitializeRandomRecipeExplorer());
      BlocProvider.of<CategoryOverviewBloc>(event.categoryOverviewContext)
          .add(COLoadCategoryOverview());
    }
  }

  Stream<RecipeCategoryOverviewState> _mapAddRecipesToState(
      RCOAddRecipes event) async* {
    if (state is LoadedRecipeCategoryOverview) {
      final List<Tuple2<String, List<Recipe>>> recipeCategoryOverview =
          _addRecipesToOverview(event.recipes,
              (state as LoadedRecipeCategoryOverview).rCategoryOverview);

      yield LoadedRecipeCategoryOverview(recipeCategoryOverview);
    }
  }

  Stream<RecipeCategoryOverviewState> _mapDeleteRecipeToState(
      RCODeleteRecipe event) async* {
    if (state is LoadedRecipeCategoryOverview) {
      final List<Tuple2<String, List<Recipe>>> recipeCategoryOverview =
          _removeRecipeFromOverview(event.recipe,
              (state as LoadedRecipeCategoryOverview).rCategoryOverview);

      yield LoadedRecipeCategoryOverview(recipeCategoryOverview);
    }
  }

  Stream<RecipeCategoryOverviewState> _mapUpdateRecipeToState(
      RCOUpdateRecipe event) async* {
    if (state is LoadedRecipeCategoryOverview) {
      final List<Tuple2<String, List<Recipe>>> recipeCategoryOverviewVone =
          _removeRecipeFromOverview(event.oldRecipe,
              (state as LoadedRecipeCategoryOverview).rCategoryOverview);
      final List<Tuple2<String, List<Recipe>>> recipeCategoryOverviewVtwo =
          _addRecipesToOverview(
              [event.updatedRecipe], recipeCategoryOverviewVone);

      yield LoadedRecipeCategoryOverview(recipeCategoryOverviewVtwo);
    }
  }

  Stream<RecipeCategoryOverviewState> _mapAddCategoryToState(
      RCOAddCategory event) async* {
    if (state is LoadedRecipeCategoryOverview) {
      int categoryCount =
          (state as LoadedRecipeCategoryOverview).rCategoryOverview.length;
      final List<Tuple2<String, List<Recipe>>> recipeCategoryOverview = (state
              as LoadedRecipeCategoryOverview)
          .rCategoryOverview
        ..insertAll(
            categoryCount == 0 ? 0 : categoryCount - 1,
            event.categories
                .map((category) => Tuple2<String, List<Recipe>>(category, []))
                .toList());

      yield LoadedRecipeCategoryOverview(recipeCategoryOverview);
    }
  }

  Stream<RecipeCategoryOverviewState> _mapDeleteCategoryToState(
      RCODeleteCategory event) async* {
    if (state is LoadedRecipeCategoryOverview) {
      final List<Tuple2<String, List<Recipe>>> recipeCategoryOverview = ((state
              as LoadedRecipeCategoryOverview)
          .rCategoryOverview
          .map((tuple) {
        if (tuple.item1 == event.category) {
          return null;
        } else {
          return tuple;
        }
      }).toList())
        ..removeWhere((item) => item == null);

      yield LoadedRecipeCategoryOverview(recipeCategoryOverview);
    }
  }

  Stream<RecipeCategoryOverviewState> _mapMoveCategoryToState(
      RCOMoveCategory event) async* {
    if (state is LoadedRecipeCategoryOverview) {
      List<Tuple2<String, List<Recipe>>> oldrCategoryOverview =
          (state as LoadedRecipeCategoryOverview).rCategoryOverview;
      // verify if working
      List<Tuple2<String, List<Recipe>>> newrCategoryOverview =
          oldrCategoryOverview
            ..insert(event.newIndex, oldrCategoryOverview[event.oldIndex])
            ..removeAt(event.oldIndex > event.newIndex
                ? event.oldIndex + 1
                : event.oldIndex);

      yield LoadedRecipeCategoryOverview(newrCategoryOverview);
    }
  }

  List<Tuple2<String, List<Recipe>>> _removeRecipeFromOverview(Recipe recipe,
      List<Tuple2<String, List<Recipe>>> recipeCategoryOverview) {
    return (state as LoadedRecipeCategoryOverview)
        .rCategoryOverview
        .map((tuple) {
      // iterate through the recipes in the current category
      for (Recipe r in tuple.item2) {
        // if the recipename of the current recipe equals the delete recipe name
        if ((r.name).compareTo(recipe.name) == 0) {
          // remove that recipe and return the tuple without the recipe
          return Tuple2(tuple.item1, tuple.item2..remove(r));
        }
      }
      // recipe doesn't exist in that category
      return tuple;
    }).toList();
  }

  List<Tuple2<String, List<Recipe>>> _addRecipesToOverview(List<Recipe> recipes,
      List<Tuple2<String, List<Recipe>>> recipeCategoryOverview) {
    List<Tuple2<String, List<Recipe>>> recipeOverview =
        (state as LoadedRecipeCategoryOverview).rCategoryOverview.map((tuple) {
      // for every category in the newRecipe
      for (Recipe recipe in recipes) {
        for (String category in recipe.categories) {
          // if the category equals the one in the existing recipes
          if (tuple.item1.compareTo(category) == 0) {
            // and if the recipes under this category are less than 8
            if (tuple.item2.length < 8) {
              // add the recipe to that category and return the category with the recipes
              return Tuple2(category, tuple.item2..add(recipe));
            }
          }
        }
        // if the newRecipe is not in that category
        return tuple;
      }
    }).toList();

    // check every recipe category, if it is already in the overview
    for (Recipe recipe in recipes) {
      for (String c in recipe.categories) {
        bool alreadyAdded = false;
        for (Tuple2<String, List<Recipe>> t in recipeOverview) {
          if (t.item1 == c) {
            alreadyAdded = true;
          }
        }
        // if it's not yet added
        if (!alreadyAdded) {
          // if the overview is empty
          if (recipeOverview.length == 0) {
            // add it to the end
            recipeOverview.add(Tuple2<String, List<Recipe>>(c, [recipe]));
          }
          // if the last category of the overview is "no category"
          else if (recipeOverview.last.item1 == "no category") {
            // add it to the second last position
            recipeOverview.insert(recipeOverview.length - 1,
                Tuple2<String, List<Recipe>>(c, [recipe]));
          }
          // if the overview is not empty and the last category is unlike "no category"
          else {
            // add it to the end
            recipeOverview.add(Tuple2<String, List<Recipe>>(c, [recipe]));
          }
        }
      }
      // if the recipe is in no category
      if (recipe.categories.isEmpty) {
        // if the no category is already in the overview and has less then 8 recipes
        if (recipeOverview.isNotEmpty &&
            recipeOverview.last.item1 == "no category") {
          if (recipeOverview.last.item2.length < 8) {
            // add it to the existing no category section
            recipeOverview.last.item2.add(recipe);
          }
        } else {
          // add "no category" with the new recipe to the overview
          recipeOverview
              .add(Tuple2<String, List<Recipe>>("no category", [recipe]));
        }
      }
    }
    return recipeOverview;
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
