import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_book/blocs/random_recipe_explorer/random_recipe_explorer_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_category_overview/recipe_category_overview_bloc.dart';

import '../../local_storage/hive.dart';
import '../../models/recipe.dart';
import '../../models/tuple.dart';
import '../recipe_manager/recipe_manager_bloc.dart' as RM;

part 'category_overview_event.dart';
part 'category_overview_state.dart';

class CategoryOverviewBloc
    extends Bloc<CategoryOverviewEvent, CategoryOverviewState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  late StreamSubscription subscription;

  CategoryOverviewBloc({required this.recipeManagerBloc})
      : super(LoadingCategoryOverview()) {
    subscription = recipeManagerBloc.stream.listen((rmState) {
      if (state is LoadedCategoryOverview) {
        if (rmState is RM.AddRecipesState) {
          add(COAddRecipes(rmState.recipes));
        } else if (rmState is RM.DeleteRecipeState) {
          add(CODeleteRecipe(rmState.recipe));
        } else if (rmState is RM.AddCategoriesState) {
          add(COAddCategory(rmState.categories));
        } else if (rmState is RM.DeleteCategoryState) {
          add(CODeleteCategory(rmState.category));
        } else if (rmState is RM.UpdateCategoryState) {
          add(COUpdateCategory(rmState.oldCategory, rmState.updatedCategory));
        } else if (rmState is RM.MoveCategoryState) {
          add(COMoveCategory(rmState.oldIndex, rmState.newIndex));
        } else if (rmState is RM.DeleteRecipeTagState ||
            rmState is RM.UpdateRecipeTagState) {
          add(COLoadCategoryOverview());
        }
      }
    });

    on<COLoadCategoryOverview>((event, emit) async {
      if (event.reopenBoxes) await HiveProvider().reopenBoxes();

      final List<Tuple2<String, String>> categoryRandomImageList =
          await _getCategoriesRandomImage();

      emit(LoadedCategoryOverview(categoryRandomImageList));

      if (event.categoryOverviewContext != null) {
        BlocProvider.of<RandomRecipeExplorerBloc>(event.categoryOverviewContext!)
            .add(InitializeRandomRecipeExplorer());
        BlocProvider.of<RecipeCategoryOverviewBloc>(
                event.categoryOverviewContext!)
            .add(RCOLoadRecipeCategoryOverview());
      }
    });

    on<COAddRecipes>((event, emit) async {
      if (state is LoadedCategoryOverview) {
        final List<Tuple2<String, String >>
            categoryRandomImageList = await _addCategoryRandomImage(
                (state as LoadedCategoryOverview).categories, event.recipes);

        emit(LoadedCategoryOverview(categoryRandomImageList));
      }
    });

    on<CODeleteRecipe>((event, emit) async {
      if (state is LoadedCategoryOverview) {
        final List<Tuple2<String, String /*!*/ >>
            categoryRandomImageList = await _removeRecipeFromOverview(
                (state as LoadedCategoryOverview).categories, event.recipe);
        emit(LoadedCategoryOverview(categoryRandomImageList));
      }
    });

    on<COAddCategory>((event, emit) async {
      if (state is LoadedCategoryOverview) {
        final List<Tuple2<String, String>> categoryRandomImageList =
            await _getCategoriesRandomImage();

        emit(LoadedCategoryOverview(categoryRandomImageList));
      }
    });

    on<CODeleteCategory>((event, emit) async {
      if (state is LoadedCategoryOverview) {
        final List<Tuple2<String, String >>
            categoryRandomImageList = (state as LoadedCategoryOverview)
                .categories
              ..removeWhere((t) => t.item1 == event.category);

        emit(LoadedCategoryOverview(categoryRandomImageList));
      }
    });

    on<COUpdateCategory>((event, emit) async {
      if (state is LoadedCategoryOverview) {
        final List<Tuple2<String, String >>
            categoryRandomImageList =
            (state as LoadedCategoryOverview).categories.map((t) {
          if (t.item1 == event.oldCategory) {
            return Tuple2<String, String >(
                event.updatedCategory, t.item2);
          } else {
            return t;
          }
        }).toList();

        emit(LoadedCategoryOverview(categoryRandomImageList));
      }
    });

    on<COMoveCategory>((event, emit) async {
      if (state is LoadedCategoryOverview) {
        List<Tuple2<String, String >> oldCategoryRandomImageList =
            (state as LoadedCategoryOverview).categories;
        // verify if working
        List<Tuple2<String, String>> newCategoryRandomImageList =
            oldCategoryRandomImageList
              ..insert(
                  event.newIndex, oldCategoryRandomImageList[event.oldIndex])
              ..removeAt(event.oldIndex > event.newIndex
                  ? event.oldIndex + 1
                  : event.oldIndex);

        emit(LoadedCategoryOverview(newCategoryRandomImageList));
      }
    });
  }

  Future<List<Tuple2<String, String>>> _removeRecipeFromOverview(
      List<Tuple2<String, String>> categoryRandomImageList,
      Recipe recipe) async {
    List<Tuple2<String, String>> newCategoryRandomImageList = [];

    for (Tuple2<String, String> t in categoryRandomImageList) {
      // if the current category shows the image of the to be deleted recipe
      if (t.item2 == recipe.imagePath) {
        // get a new randomImage
        Recipe? randomRecipe = await HiveProvider().getRandomRecipeOfCategory(
            category: t.item1, excludedRecipe: recipe);

        String? newRandomImage =
            randomRecipe == null ? null : randomRecipe.imagePath;
        // if there is a new randomImage
        if (newRandomImage != null) {
          // add the new randomImage to the category
          newCategoryRandomImageList
              .add(Tuple2<String, String>(t.item1, newRandomImage));
        }
      } // if the catogry randomImage is not of the to be deleted recipe
      else {
        // add the old category randomImage tuple to the categoryOverview
        newCategoryRandomImageList.add(t);
      }
    }

    return newCategoryRandomImageList;
  }

  Future<List<Tuple2<String, String>>> _getCategoriesRandomImage() async {
    final List<String> categories = HiveProvider().getCategoryNames();
    final List<Tuple2<String, String>> categoryRandomImageList = [];

    for (String category in categories) {
      Recipe? randomRecipe =
          await HiveProvider().getRandomRecipeOfCategory(category: category);
      String? randomImage = randomRecipe == null ? null : randomRecipe.imagePath;
      if (randomImage != null) {
        categoryRandomImageList
            .add(Tuple2<String, String>(category, randomImage));
      }
    }
    return categoryRandomImageList;
  }

  /// if the new recipe is under a category the only one, add the category to the
  /// overview with the new recipeImage
  Future<List<Tuple2<String, String >>> _addCategoryRandomImage(
      List<Tuple2<String, String>> oldCategoryRandomImageList,
      List<Recipe> recipes) async {
    List<Tuple2<String /*!*/, String >> categoryRandomImageList =
        List<Tuple2<String, String>>.from(oldCategoryRandomImageList);

    for (Recipe recipe in recipes) {
      for (String category in recipe.categories) {
        bool alreadyAdded = false;
        for (Tuple2<String, String > t in categoryRandomImageList) {
          // if the current recipeCategory is already in the overview
          if (t.item1 == category) {
            // add the old category to the new overviewList
            alreadyAdded = true;
            break;
          }
        }
        // if the current recipeCategory is not yet in the overview
        if (!alreadyAdded) {
          // add the category with the image of the recipe
          categoryRandomImageList.add(Tuple2<String, String >(
              category,
              (await HiveProvider()
                      .getRandomRecipeOfCategory(category: category))!
                  .imagePath));
        }
      }
    }
    return categoryRandomImageList;
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
