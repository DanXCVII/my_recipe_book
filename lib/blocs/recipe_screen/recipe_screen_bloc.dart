import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../local_storage/hive.dart';
import '../../models/recipe.dart';
import '../recipe_manager/recipe_manager_bloc.dart';

part 'recipe_screen_event.dart';
part 'recipe_screen_state.dart';

class RecipeScreenBloc extends Bloc<RecipeScreenEvent, RecipeScreenState> {
  final Recipe recipe;
  StreamSubscription rmListener;
  RecipeManagerBloc recipeManagerBloc;

  RecipeScreenBloc(this.recipe, this.recipeManagerBloc)
      : super(RecipeScreenInfo(recipe, [])) {
    rmListener = recipeManagerBloc.listen((state) {
      if (state is DeleteRecipeState) {
        if (state.recipe == recipe) {
          Future.delayed(Duration(milliseconds: 100))
              .then((_) => add(HideRecipe()));
        }
      }
    });
  }

  @override
  Future<void> close() {
    rmListener.cancel();
    return super.close();
  }

  @override
  Stream<RecipeScreenState> mapEventToState(
    RecipeScreenEvent event,
  ) async* {
    if (event is InitRecipeScreen) {
      yield* _mapInitRecipeScreenToState(event);
    } else if (event is HideRecipe) {
      yield* _mapHideRecipeToState(event);
    }
  }

  Stream<RecipeScreenState> _mapInitRecipeScreenToState(
      InitRecipeScreen event) async* {
    List<String> categoryImages = [];
    for (String category in recipe.categories) {
      categoryImages.add(
          (await HiveProvider().getRandomRecipeOfCategory(category: category))
              .imagePreviewPath);
    }
    yield RecipeScreenInfo(recipe, categoryImages);
  }

  Stream<RecipeScreenState> _mapHideRecipeToState(HideRecipe event) async* {
    yield RecipeEditedDeleted();
  }
}
