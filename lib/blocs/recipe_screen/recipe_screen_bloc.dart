import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/models/recipe.dart';

part 'recipe_screen_event.dart';
part 'recipe_screen_state.dart';

class RecipeScreenBloc extends Bloc<RecipeScreenEvent, RecipeScreenState> {
  final Recipe recipe;
  StreamSubscription rmListener;
  RecipeManagerBloc recipeManagerBloc;

  RecipeScreenBloc(this.recipe, this.recipeManagerBloc) {
    rmListener = recipeManagerBloc.listen((state) {
      if (state is DeleteRecipeState) {
        if (state.recipe == recipe) {
          add(HideRecipe());
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
  RecipeScreenState get initialState => RecipeScreenInfo(recipe);

  @override
  Stream<RecipeScreenState> mapEventToState(
    RecipeScreenEvent event,
  ) async* {
    if (event is HideRecipe) {
      yield* _mapHideRecipeToState(event);
    }
  }

  Stream<RecipeScreenState> _mapHideRecipeToState(HideRecipe event) async* {
    yield RecipeScreenInfo(Recipe(name: 'deleted recipe'));
  }
}
