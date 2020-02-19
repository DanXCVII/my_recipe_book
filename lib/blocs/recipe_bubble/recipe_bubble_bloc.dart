import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../models/recipe.dart';
import '../recipe_manager/recipe_manager_bloc.dart' as RM;

part 'recipe_bubble_event.dart';
part 'recipe_bubble_state.dart';

class RecipeBubbleBloc extends Bloc<RecipeBubbleEvent, RecipeBubbleState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  StreamSubscription subscription;

  RecipeBubbleBloc({@required this.recipeManagerBloc}) {
    subscription = recipeManagerBloc.listen((rmState) {
      if (state is LoadedRecipeBubbles) {
        if (rmState is RM.DeleteRecipeState) {
          if ((state as LoadedRecipeBubbles).recipes.contains(rmState.recipe)) {
            add(RemoveRecipeBubble(rmState.recipe));
          }
        }
      }
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }

  @override
  RecipeBubbleState get initialState => LoadedRecipeBubbles([]);

  @override
  Stream<RecipeBubbleState> mapEventToState(
    RecipeBubbleEvent event,
  ) async* {
    if (event is AddRecipeBubble) {
      yield* _mapAddRecipeBubbleToState(event);
    } else if (event is RemoveRecipeBubble) {
      yield* _mapRemoveRecipeBubbleToState(event);
    }
  }

  Stream<RecipeBubbleState> _mapAddRecipeBubbleToState(
      AddRecipeBubble event) async* {
    if ((state as LoadedRecipeBubbles).recipes.length < 3) {
      List<Recipe> recipes =
          List<Recipe>.from((state as LoadedRecipeBubbles).recipes)
            ..add(event.recipe);

      yield LoadedRecipeBubbles(recipes);
    }
  }

  Stream<RecipeBubbleState> _mapRemoveRecipeBubbleToState(
      RemoveRecipeBubble event) async* {
    List<Recipe> recipes =
        List<Recipe>.from((state as LoadedRecipeBubbles).recipes)
          ..remove(event.recipe);

    yield LoadedRecipeBubbles(recipes);
  }
}
