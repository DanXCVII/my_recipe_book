import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/src/widgets/framework.dart' as fw;
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

  RecipeCategoryOverviewBloc({@required this.recipeManagerBloc})
      : super(LoadingRecipeCategoryOverviewState()) {
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
        } else if (rmState is RM.DeleteRecipeTagState ||
            rmState is RM.UpdateRecipeTagState) {
          add(RCOLoadRecipeCategoryOverview());
        }
      }
    });
  }

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
    } else if (event is RCOUpdateCategory) {
      yield* _mapUpdateCategoryToState(event);
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
          _addRecipesToOverview(
              event.recipes,
              List<Tuple2<String, List<Recipe>>>.from(
                  (state as LoadedRecipeCategoryOverview).rCategoryOverview));

      yield LoadedRecipeCategoryOverview(recipeCategoryOverview);
    }
  }

  Stream<RecipeCategoryOverviewState> _mapDeleteRecipeToState(
      RCODeleteRecipe event) async* {
    if (state is LoadedRecipeCategoryOverview) {
      final List<Tuple2<String, List<Recipe>>> recipeCategoryOverview =
          _removeRecipeFromOverview(
              event.recipe,
              List<Tuple2<String, List<Recipe>>>.from(
                  (state as LoadedRecipeCategoryOverview).rCategoryOverview));

      yield LoadedRecipeCategoryOverview(recipeCategoryOverview);
    }
  }

  Stream<RecipeCategoryOverviewState> _mapUpdateRecipeToState(
      RCOUpdateRecipe event) async* {
    if (state is LoadedRecipeCategoryOverview) {
      final List<Tuple2<String, List<Recipe>>> recipeCategoryOverviewVone =
          _removeRecipeFromOverview(
              event.oldRecipe,
              List<Tuple2<String, List<Recipe>>>.from(
                  (state as LoadedRecipeCategoryOverview).rCategoryOverview));
      final List<Tuple2<String, List<Recipe>>> recipeCategoryOverviewVtwo =
          _addRecipesToOverview([
        event.updatedRecipe
      ], List<Tuple2<String, List<Recipe>>>.from(recipeCategoryOverviewVone));

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
      yield* _mapLoadCategoryOverviewToState(RCOLoadRecipeCategoryOverview());
    }
  }

  Stream<RecipeCategoryOverviewState> _mapUpdateCategoryToState(
      RCOUpdateCategory event) async* {
    if (state is LoadedRecipeCategoryOverview) {
      final List<Tuple2<String, List<Recipe>>> recipeCategoryOverview = ((state
              as LoadedRecipeCategoryOverview)
          .rCategoryOverview
          .map((tuple) {
        String overviewItemName = tuple.item1;
        if (tuple.item1 == event.oldCategory) {
          overviewItemName = event.updatedCategory;
        }
        return Tuple2<String, List<Recipe>>(
          overviewItemName,
          tuple.item2
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
        );
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
    return recipeCategoryOverview.map((tuple) {
      var updatedOverviewItem = Tuple2<String, List<Recipe>>(tuple.item1,
          tuple.item2..removeWhere((item2) => item2.name == recipe.name));
      return updatedOverviewItem.item1 == "no category" &&
              updatedOverviewItem.item2.isEmpty
          ? null
          : updatedOverviewItem;
    }).toList()
      ..removeWhere((item) => item == null);
  }

  List<Tuple2<String, List<Recipe>>> _addRecipesToOverview(List<Recipe> recipes,
      List<Tuple2<String, List<Recipe>>> recipeCategoryOverview) {
    // check every recipe category, if it is already in the overview
    for (Recipe recipe in recipes) {
      for (String c in recipe.categories) {
        bool alreadyAdded = false;
        for (Tuple2<String, List<Recipe>> t in recipeCategoryOverview) {
          if (t.item1 == c) {
            t.item2.add(recipe);
            alreadyAdded = true;
          }
        }
        // if it's not yet added
        if (!alreadyAdded) {
          // if the overview is empty
          if (recipeCategoryOverview.length == 0) {
            // add it to the end
            recipeCategoryOverview
                .add(Tuple2<String, List<Recipe>>(c, [recipe]));
          }
          // if the last category of the overview is "no category"
          else if (recipeCategoryOverview.last.item1 == "no category") {
            // add it to the second last position
            recipeCategoryOverview.insert(recipeCategoryOverview.length - 1,
                Tuple2<String, List<Recipe>>(c, [recipe]));
          }
          // if the overview is not empty and the last category is unlike "no category"
          else {
            // add it to the end
            recipeCategoryOverview
                .add(Tuple2<String, List<Recipe>>(c, [recipe]));
          }
        }
      }
      // if the recipe is in no category
      if (recipe.categories.isEmpty) {
        // if the no category is already in the overview and has less then 8 recipes
        if (recipeCategoryOverview.isNotEmpty &&
            recipeCategoryOverview.last.item1 == "no category") {
          if (recipeCategoryOverview.last.item2.length < 8) {
            // add it to the existing no category section
            recipeCategoryOverview.last.item2.add(recipe);
          }
        } else {
          // add "no category" with the new recipe to the overview
          recipeCategoryOverview
              .add(Tuple2<String, List<Recipe>>("no category", [recipe]));
        }
      }
    }

    return recipeCategoryOverview;
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
