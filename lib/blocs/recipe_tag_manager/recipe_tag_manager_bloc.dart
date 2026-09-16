import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart'
    as RM;
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/string_int_tuple.dart';

part 'recipe_tag_manager_event.dart';
part 'recipe_tag_manager_state.dart';

class RecipeTagManagerBloc
    extends Bloc<RecipeTagManagerEvent, RecipeTagManagerState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  final LocalRepository repository;
  StreamSubscription? subscription;

  final List<StringIntTuple> _initialSelectedTags;

  RecipeTagManagerBloc({
    required this.recipeManagerBloc,
    required this.repository,
    List<StringIntTuple> selectedTags = const [],
  }) : _initialSelectedTags = List<StringIntTuple>.from(selectedTags),
       super(LoadingRecipeTagManager()) {
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
      final List<StringIntTuple> recipeTags = repository.getRecipeTags();

      emit(
        LoadedRecipeTagManager(
          recipeTags: recipeTags,
          selectedTags: _normalizeSelectedTags(
            _initialSelectedTags,
            recipeTags,
          ),
        ),
      );
    });

    on<AddRecipeTags>((event, emit) async {
      if (state is LoadedRecipeTagManager) {
        final current = state as LoadedRecipeTagManager;
        final recipeTags = _upsertTags(current.recipeTags, event.recipeTags);
        final selectedTags = _upsertTags(
          current.selectedTags,
          event.recipeTags,
        );

        emit(
          LoadedRecipeTagManager(
            recipeTags: recipeTags,
            selectedTags: selectedTags,
          ),
        );
      }
    });

    on<DeleteRecipeTag>((event, emit) async {
      if (state is LoadedRecipeTagManager) {
        final current = state as LoadedRecipeTagManager;
        emit(
          LoadedRecipeTagManager(
            recipeTags: current.recipeTags
                .where((tag) => tag.text != event.recipeTag.text)
                .toList(),
            selectedTags: current.selectedTags
                .where((tag) => tag.text != event.recipeTag.text)
                .toList(),
          ),
        );
      }
    });

    on<UpdateRecipeTag>((event, emit) async {
      if (state is LoadedRecipeTagManager) {
        final current = state as LoadedRecipeTagManager;
        final recipeTags = _replaceTag(
          current.recipeTags,
          event.oldRecipeTag.text,
          event.updatedRecipeTag,
        );
        final selectedTags =
            current.selectedTags.any(
              (tag) => tag.text == event.oldRecipeTag.text,
            )
            ? _replaceTag(
                current.selectedTags,
                event.oldRecipeTag.text,
                event.updatedRecipeTag,
              )
            : current.selectedTags;

        emit(
          LoadedRecipeTagManager(
            recipeTags: recipeTags,
            selectedTags: selectedTags,
          ),
        );
      }
    });

    on<SelectRecipeTag>((event, emit) async {
      if (state is LoadedRecipeTagManager) {
        final current = state as LoadedRecipeTagManager;
        emit(
          LoadedRecipeTagManager(
            recipeTags: current.recipeTags,
            selectedTags: _upsertTags(current.selectedTags, [event.recipeTag]),
          ),
        );
      }
    });

    on<UnselectRecipeTag>((event, emit) async {
      if (state is LoadedRecipeTagManager) {
        final current = state as LoadedRecipeTagManager;
        emit(
          LoadedRecipeTagManager(
            recipeTags: current.recipeTags,
            selectedTags: current.selectedTags
                .where((tag) => tag.text != event.recipeTag.text)
                .toList(),
          ),
        );
      }
    });
  }

  static List<StringIntTuple> _normalizeSelectedTags(
    List<StringIntTuple> selectedTags,
    List<StringIntTuple> recipeTags,
  ) {
    final currentByName = {
      for (final recipeTag in recipeTags) recipeTag.text: recipeTag,
    };
    final normalized = <StringIntTuple>[];
    final seenNames = <String>{};
    for (final selectedTag in selectedTags) {
      if (seenNames.add(selectedTag.text)) {
        normalized.add(currentByName[selectedTag.text] ?? selectedTag);
      }
    }
    return normalized;
  }

  static List<StringIntTuple> _upsertTags(
    List<StringIntTuple> existing,
    List<StringIntTuple> additions,
  ) {
    var result = List<StringIntTuple>.from(existing);
    for (final addition in additions) {
      final index = result.indexWhere((tag) => tag.text == addition.text);
      if (index == -1) {
        result.add(addition);
      } else {
        result[index] = addition;
      }
    }
    return result;
  }

  static List<StringIntTuple> _replaceTag(
    List<StringIntTuple> tags,
    String oldName,
    StringIntTuple replacement,
  ) {
    return _upsertTags(
      const [],
      tags.map((tag) => tag.text == oldName ? replacement : tag).toList(),
    );
  }

  @override
  Future<void> close() async {
    await subscription?.cancel();
    return super.close();
  }
}
