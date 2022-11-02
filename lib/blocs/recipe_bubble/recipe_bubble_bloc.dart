import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:my_recipe_book/local_storage/hive.dart';

import '../../models/recipe.dart';
import '../recipe_manager/recipe_manager_bloc.dart' as RM;

part 'recipe_bubble_event.dart';
part 'recipe_bubble_state.dart';

class RecipeBubbleBloc extends Bloc<RecipeBubbleEvent, RecipeBubbleState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  late StreamSubscription subscription;

  RecipeBubbleBloc({required this.recipeManagerBloc})
      : super(LoadedRecipeBubbles([])) {
    subscription = recipeManagerBloc.stream.listen((rmState) {
      if (state is LoadedRecipeBubbles) {
        if (rmState is RM.DeleteRecipeState) {
          if ((state as LoadedRecipeBubbles).recipes.contains(rmState.recipe)) {
            add(RemoveRecipeBubble([rmState.recipe]));
          }
        } else if (rmState is RM.UpdateRecipeState) {
          if ((state as LoadedRecipeBubbles)
              .recipes
              .contains(rmState.oldRecipe)) {
            add(RemoveRecipeBubble([rmState.oldRecipe]));
          }
        } else if (rmState is RM.UpdateCategoryState ||
            rmState is RM.DeleteCategoryState ||
            rmState is RM.UpdateRecipeTagState ||
            rmState is RM.DeleteRecipeTagState) {
          add(ReloadRecipeBubbles());
        }
      }
    });

    on<AddRecipeBubble>((event, emit) async {
      if ((state as LoadedRecipeBubbles).recipes.length < 3) {
        List<Recipe> recipes =
            List<Recipe>.from((state as LoadedRecipeBubbles).recipes)
              ..addAll(event.recipes);

        emit(LoadedRecipeBubbles(recipes));
      }
    });

    on<RemoveRecipeBubble>((event, emit) async {
      if (state is LoadedRecipeBubbles) {
        List<Recipe> newRecipeList =
            List<Recipe>.from((state as LoadedRecipeBubbles).recipes);

        for (Recipe r in event.recipes) {
          newRecipeList.remove(r);
        }

        emit(LoadedRecipeBubbles(newRecipeList));
      }
    });

    on<ReloadRecipeBubbles>((event, emit) async {
      if (state is LoadedRecipeBubbles) {
        List<Recipe> newRecipeList = [];

        for (int i = 0;
            i < (state as LoadedRecipeBubbles).recipes.length;
            i++) {
          Recipe? recipe = await HiveProvider()
              .getRecipeByName((state as LoadedRecipeBubbles).recipes[i].name);
          if (recipe != null) {
            newRecipeList.add(recipe);
          }
        }

        emit(LoadedRecipeBubbles(newRecipeList));
      }
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
