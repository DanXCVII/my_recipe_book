import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_state.dart'
    as RMState;
import 'package:my_recipe_book/hive.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/tuple.dart';
import './recipe_category_overview.dart';

class RecipeCategoryOverviewBloc
    extends Bloc<RecipeCategoryOverviewEvent, RecipeCategoryOverviewState> {
  final RecipeManagerBloc recipeManagerBloc;
  StreamSubscription subscription;

  RecipeCategoryOverviewBloc({@required this.recipeManagerBloc}) {
    subscription = recipeManagerBloc.listen((rmState) {
      if (state is LoadedRecipeCategoryOverview) {
        if (rmState is RMState.AddRecipeState) {
          add(RCOAddRecipe(rmState.recipe));
        } else if (rmState is RMState.DeleteRecipeState) {
          add(RCODeleteRecipe(rmState.recipe));
        } else if (rmState is RMState.UpdateRecipeState) {
          add(RCOUpdateRecipe(rmState.oldRecipe, rmState.updatedRecipe));
        } else if (rmState is RMState.AddCategoryState) {
          add(RCOAddCategory(rmState.category));
        } else if (rmState is RMState.DeleteCategoryState) {
          add(RCODeleteCategory(rmState.category));
        } else if (rmState is RMState.UpdateCategoryState) {
          add(RCOUpdateCategory(rmState.oldCategory, rmState.updatedCategory));
        } else if (rmState is RMState.MoveCategoryState) {
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
      yield* _mapLoadCategoryOverviewToState();
    } else if (event is RCOAddRecipe) {
      yield* _mapAddRecipeToState(event);
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

  Stream<RecipeCategoryOverviewState> _mapLoadCategoryOverviewToState() async* {
    List<Tuple2<String, List<Recipe>>> categoryRecipes = [];
    final List<String> categories = HiveProvider().getCategoryNames();

    for (String category in categories) {
      List<Recipe> categoryRecipeList =
          await HiveProvider().getCategoryRecipes(category);
      categoryRecipes.add(Tuple2(category, categoryRecipeList));
    }

    yield LoadedRecipeCategoryOverview(categoryRecipes);
  }

  Stream<RecipeCategoryOverviewState> _mapAddRecipeToState(
      RCOAddRecipe event) async* {
    if (state is LoadedRecipeCategoryOverview) {
      final List<Tuple2<String, List<Recipe>>> recipeCategoryOverview =
          _addRecipeToOverview(event.recipe,
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
          _addRecipeToOverview(event.updatedRecipe, recipeCategoryOverviewVone);

      yield LoadedRecipeCategoryOverview(recipeCategoryOverviewVtwo);
    }
  }

  Stream<RecipeCategoryOverviewState> _mapAddCategoryToState(
      RCOAddCategory event) async* {
    if (state is LoadedRecipeCategoryOverview) {
      final List<Tuple2<String, List<Recipe>>> recipeCategoryOverview = (state
              as LoadedRecipeCategoryOverview)
          .rCategoryOverview
        ..insert(
            (state as LoadedRecipeCategoryOverview).rCategoryOverview.length -
                1,
            Tuple2(event.category, []));

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

  List<Tuple2<String, List<Recipe>>> _addRecipeToOverview(Recipe recipe,
      List<Tuple2<String, List<Recipe>>> recipeCategoryOverview) {
    List<Tuple2<String, List<Recipe>>> recipeOverview =
        (state as LoadedRecipeCategoryOverview).rCategoryOverview.map((tuple) {
      // for every category in the newRecipe
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
    }).toList();

    // check every recipe category, if it is already in the overview
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
          recipeOverview.last.item1 == "no category" &&
          recipeOverview.last.item2.length < 8) {
        // add it to the existing no category section
        recipeOverview.last.item2.add(recipe);
      } else {
        // add "no category" with the new recipe to the overview
        recipeOverview
            .add(Tuple2<String, List<Recipe>>("no category", [recipe]));
      }
    }
    return recipeOverview;
  }

  @override
  void close() {
    subscription.cancel();
    super.close();
  }
}