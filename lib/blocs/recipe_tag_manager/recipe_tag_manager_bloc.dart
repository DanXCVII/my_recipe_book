import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart'
    as RM;
import 'package:my_recipe_book/local_storage/hive.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';

part 'recipe_tag_manager_event.dart';
part 'recipe_tag_manager_state.dart';

class RecipeTagManagerBloc
    extends Bloc<RecipeTagManagerEvent, RecipeTagManagerState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  StreamSubscription subscription;

  List<StringIntTuple> selectedTags = [];

  RecipeTagManagerBloc(
      {@required this.recipeManagerBloc, List<StringIntTuple> selectedTags})
      : super(LoadingRecipeTagManager()) {
    if (selectedTags != null)
      this.selectedTags = List<StringIntTuple>.from(selectedTags);
    subscription = recipeManagerBloc.listen((rmState) {
      if (state is LoadedRecipeTagManager) {
        if (rmState is RM.AddRecipeTagsState) {
          add(AddRecipeTags(rmState.recipeTags));
        } else if (rmState is RM.DeleteRecipeTagState) {
          add(DeleteRecipeTag(rmState.recipeTag));
        } else if (rmState is RM.UpdateRecipeTagState) {
          add(UpdateRecipeTag(rmState.oldRecipeTag, rmState.updatedRecipeTag));
        }
      }
    });
  }

  @override
  Stream<RecipeTagManagerState> mapEventToState(
    RecipeTagManagerEvent event,
  ) async* {
    if (event is InitializeRecipeTagManager) {
      yield* _mapInitializeRecipeTagManagerToState(event);
    } else if (event is AddRecipeTags) {
      yield* _mapAddRecipeTagsToState(event);
    } else if (event is DeleteRecipeTag) {
      yield* _mapDeleteRecipeTagToState(event);
    } else if (event is UpdateRecipeTag) {
      yield* _mapUpdateRecipeTagToState(event);
    } else if (event is SelectRecipeTag) {
      selectRecipeTag(event);
    } else if (event is UnselectRecipeTag) {
      unselectRecipeTag(event);
    }
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }

  Stream<RecipeTagManagerState> _mapInitializeRecipeTagManagerToState(
      InitializeRecipeTagManager event) async* {
    final List<StringIntTuple> recipeTags = HiveProvider().getRecipeTags();

    yield LoadedRecipeTagManager(recipeTags);
  }

  Stream<RecipeTagManagerState> _mapAddRecipeTagsToState(
      AddRecipeTags event) async* {
    if (state is LoadedRecipeTagManager) {
      selectedTags.addAll(event.recipeTags);

      yield LoadedRecipeTagManager(List<StringIntTuple>.from(
          (state as LoadedRecipeTagManager).recipeTags)
        ..addAll(event.recipeTags));
    }
  }

  Stream<RecipeTagManagerState> _mapDeleteRecipeTagToState(
      DeleteRecipeTag event) async* {
    if (state is LoadedRecipeTagManager) {
      yield LoadedRecipeTagManager(List<StringIntTuple>.from(
          (state as LoadedRecipeTagManager).recipeTags)
        ..remove(event.recipeTag));

      if (selectedTags.contains(event.recipeTag)) {
        selectedTags.remove(event.recipeTag);
      }
    }
  }

  Stream<RecipeTagManagerState> _mapUpdateRecipeTagToState(
      UpdateRecipeTag event) async* {
    if (state is LoadedRecipeTagManager) {
      final List<StringIntTuple> recipeTags =
          (state as LoadedRecipeTagManager).recipeTags.map((recipeTag) {
        if (recipeTag == event.oldRecipeTag) {
          return event.updatedRecipeTag;
        } else {
          return recipeTag;
        }
      }).toList();

      if (selectedTags.contains(event.oldRecipeTag)) {
        selectedTags[selectedTags.indexOf(event.oldRecipeTag)] =
            event.updatedRecipeTag;
      }

      yield LoadedRecipeTagManager(recipeTags);
    }
  }

  void selectRecipeTag(SelectRecipeTag event) {
    selectedTags.add(event.recipeTag);
  }

  void unselectRecipeTag(UnselectRecipeTag event) {
    selectedTags.remove(event.recipeTag);
  }
}
