import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/tuple.dart';
import '../recipe_manager/recipe_manager_state.dart' as RMState;
import './category_overview.dart';
import '../../hive.dart';

class CategoryOverviewBloc
    extends Bloc<CategoryOverviewEvent, CategoryOverviewState> {
  final RecipeManagerBloc recipeManagerBloc;
  StreamSubscription subscription;

  CategoryOverviewBloc({@required this.recipeManagerBloc}) {
    subscription = recipeManagerBloc.listen((rmState) {
      if (state is LoadedCategoryOverview) {
        if (rmState is RMState.AddRecipeState) {
          add(COAddRecipe(rmState.recipe));
        } else if (rmState is RMState.DeleteRecipeState) {
          add(CODeleteRecipe(rmState.recipe));
        } else if (rmState is RMState.UpdateRecipeState) {
          add(COUpdateRecipe(rmState.oldRecipe, rmState.updatedRecipe));
        } else if (rmState is RMState.DeleteCategoryState) {
          add(CODeleteCategory(rmState.category));
        } else if (rmState is RMState.UpdateCategoryState) {
          add(COUpdateCategory(rmState.oldCategory, rmState.updatedCategory));
        } else if (rmState is RMState.MoveCategoryState) {
          add(COMoveCategory(rmState.oldIndex, rmState.newIndex));
        }
      }
    });
  }

  @override
  CategoryOverviewState get initialState => LoadingCategoryOverview();

  @override
  Stream<CategoryOverviewState> mapEventToState(
    CategoryOverviewEvent event,
  ) async* {
    if (event is COLoadCategoryOverview) {
      yield* _mapLoadCategoryOverviewToState();
    } else if (event is COAddRecipe) {
      yield* _mapAddRecipeToState(event);
    } else if (event is COUpdateRecipe) {
      yield* _mapUpdateRecipeToState(event);
    } else if (event is CODeleteRecipe) {
      yield* _mapDeleteRecipeToState(event);
    } else if (event is CODeleteCategory) {
      yield* _mapDeleteCategoryToState(event);
    } else if (event is COUpdateCategory) {
      yield* _mapUpdateCategoryToState(event);
    } else if (event is COMoveCategory) {
      yield* _mapMoveCategoryToState(event);
    }
  }

  Stream<CategoryOverviewState> _mapLoadCategoryOverviewToState() async* {
    final List<Tuple2<String, String>> categoryRandomImageList =
        await _getCategoriesRandomImage();

    yield LoadedCategoryOverview(categoryRandomImageList);
  }

  Stream<CategoryOverviewState> _mapAddRecipeToState(COAddRecipe event) async* {
    if (state is LoadedCategoryOverview) {
      final List<Tuple2<String, String>> categoryRandomImageList =
          await _addCategoryRandomImage(
              (state as LoadedCategoryOverview).categories, event.recipe);

      yield LoadedCategoryOverview(categoryRandomImageList);
    }
  }

  Stream<CategoryOverviewState> _mapUpdateRecipeToState(
      COUpdateRecipe event) async* {
    if (state is LoadedCategoryOverview) {
      final List<Tuple2<String, String>> removedRecipeCategoryOverview =
          await _removeRecipeFromOverview(
              (state as LoadedCategoryOverview).categories, event.oldRecipe);
      final List<Tuple2<String, String>> updatedRecipeCategoryOverview =
          await _addCategoryRandomImage(
              removedRecipeCategoryOverview, event.updatedRecipe);

      yield LoadedCategoryOverview(updatedRecipeCategoryOverview);
    }
  }

  Stream<CategoryOverviewState> _mapDeleteRecipeToState(
      CODeleteRecipe event) async* {
    if (state is LoadedCategoryOverview) {
      final List<Tuple2<String, String>> categoryRandomImageList =
          await _removeRecipeFromOverview(
              (state as LoadedCategoryOverview).categories, event.recipe);
      yield LoadedCategoryOverview(categoryRandomImageList);
    }
  }

  Stream<CategoryOverviewState> _mapDeleteCategoryToState(
      CODeleteCategory event) async* {
    if (state is LoadedCategoryOverview) {
      final List<Tuple2<String, String>> categoryRandomImageList =
          (state as LoadedCategoryOverview).categories
            ..removeWhere((t) => t.item1 == event.category);

      yield LoadedCategoryOverview(categoryRandomImageList);
    }
  }

  Stream<CategoryOverviewState> _mapUpdateCategoryToState(
      COUpdateCategory event) async* {
    if (state is LoadedCategoryOverview) {
      final List<Tuple2<String, String>> categoryRandomImageList =
          (state as LoadedCategoryOverview).categories.map((t) {
        if (t.item1 == event.oldCategory) {
          return Tuple2(t.item1, event.updatedCategory);
        } else {
          return t;
        }
      }).toList();

      yield LoadedCategoryOverview(categoryRandomImageList);
    }
  }

  Stream<CategoryOverviewState> _mapMoveCategoryToState(
      COMoveCategory event) async* {
    if (state is LoadedCategoryOverview) {
      List<Tuple2<String, String>> oldCategoryRandomImageList =
          (state as LoadedCategoryOverview).categories;
      // verify if working
      List<Tuple2<String, String>> newCategoryRandomImageList =
          oldCategoryRandomImageList
            ..insert(event.newIndex, oldCategoryRandomImageList[event.oldIndex])
            ..removeAt(event.oldIndex > event.newIndex
                ? event.oldIndex + 1
                : event.oldIndex);

      yield LoadedCategoryOverview(newCategoryRandomImageList);
    }
  }

  Future<List<Tuple2<String, String>>> _removeRecipeFromOverview(
      List<Tuple2<String, String>> categoryRandomImageList,
      Recipe recipe) async {
    List<Tuple2<String, String>> newCategoryRandomImageList = [];

    for (Tuple2<String, String> t in categoryRandomImageList) {
      // if the current category shows the image of the to be deleted recipe
      if (t.item2 == recipe.imagePath) {
        // get a new randomImage
        Recipe randomRecipe = await HiveProvider().getRandomRecipeOfCategory(
            category: t.item1, excludedRecipe: recipe);

        String newRandomImage =
            randomRecipe == null ? null : randomRecipe.imagePath;
        // if there is a new randomImage
        if (newRandomImage != null) {
          // add the new randomImage to the category
          newCategoryRandomImageList.add(Tuple2(t.item1, newRandomImage));
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
      Recipe randomRecipe =
          await HiveProvider().getRandomRecipeOfCategory(category: category);
      String randomImage = randomRecipe == null ? null : randomRecipe.imagePath;
      categoryRandomImageList.add(Tuple2(category,
          randomImage == null ? "images/randomFood.jpg" : randomImage));
    }
    return categoryRandomImageList;
  }

  /// if the new recipe is under a category the only one, add the category to the
  /// overview with the new recipeImage
  Future<List<Tuple2<String, String>>> _addCategoryRandomImage(
      List<Tuple2<String, String>> oldCategoryRandomImageList,
      Recipe recipe) async {
    List<Tuple2<String, String>> categoryRandomImageList = [];

    for (String category in recipe.categories) {
      bool alreadyAdded = false;
      for (Tuple2<String, String> t in oldCategoryRandomImageList) {
        // if the current recipeCategory is already in the overview
        if (t.item1.compareTo(category) == 0) {
          // add the old category to the new overviewList
          categoryRandomImageList.add(t);
          alreadyAdded = true;
          break;
        }
      }
      // if the current recipeCategory is not yet in the overview
      if (!alreadyAdded) {
        // add the category with the image of the recipe
        categoryRandomImageList.add(Tuple2<String, String>(
            category,
            (await HiveProvider().getRandomRecipeOfCategory(category: category))
                .imagePath));
      }
    }
    return categoryRandomImageList;
  }

  @override
  void close() {
    subscription.cancel();
    super.close();
  }
}
