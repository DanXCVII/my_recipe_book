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
    subscription = recipeManagerBloc.stream.listen((rmState) {
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

    on<InitializeRecipeTagManager>((event, emit) async {
      final List<StringIntTuple> recipeTags = HiveProvider().getRecipeTags();

      emit(LoadedRecipeTagManager(recipeTags));
    });

    on<AddRecipeTags>((event, emit) async {
      if (state is LoadedRecipeTagManager) {
        selectedTags.addAll(event.recipeTags);

        emit(LoadedRecipeTagManager(List<StringIntTuple>.from(
            (state as LoadedRecipeTagManager).recipeTags)
          ..addAll(event.recipeTags)));
      }
    });

    on<DeleteRecipeTag>((event, emit) async {
      if (state is LoadedRecipeTagManager) {
        emit(LoadedRecipeTagManager(List<StringIntTuple>.from(
            (state as LoadedRecipeTagManager).recipeTags)
          ..remove(event.recipeTag)));

        if (selectedTags.contains(event.recipeTag)) {
          selectedTags.remove(event.recipeTag);
        }
      }
    });

    on<UpdateRecipeTag>((event, emit) async {
      if (state is LoadedRecipeTagManager) {
        final List<StringIntTuple/*!*/> recipeTags =
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

        emit(LoadedRecipeTagManager(recipeTags));
      }
    });

    on<SelectRecipeTag>((event, emit) async {
      selectedTags.add(event.recipeTag);
    });

    on<UnselectRecipeTag>((event, emit) async {
      selectedTags.remove(event.recipeTag);
    });
  }
}
