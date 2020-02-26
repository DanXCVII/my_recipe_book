import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../hive.dart';
import '../recipe_manager/recipe_manager_bloc.dart' as RM;

part 'category_manager_event.dart';
part 'category_manager_state.dart';

class CategoryManagerBloc
    extends Bloc<CategoryManagerEvent, CategoryManagerState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  StreamSubscription subscription;

  CategoryManagerBloc({@required this.recipeManagerBloc}) {
    subscription = recipeManagerBloc.listen((rmState) {
      if (state is LoadedCategoryManager) {
        if (rmState is RM.AddCategoriesState) {
          add(AddCategories(rmState.categories));
        } else if (rmState is RM.DeleteCategoryState) {
          add(DeleteCategory(rmState.category));
        } else if (rmState is RM.UpdateCategoryState) {
          add(UpdateCategory(rmState.oldCategory, rmState.updatedCategory));
        } else if (rmState is RM.MoveCategoryState) {
          add(MoveCategory(rmState.oldIndex, rmState.newIndex, DateTime.now()));
        }
      }
    });
  }

  @override
  CategoryManagerState get initialState => LoadingCategoryManager();

  @override
  Stream<CategoryManagerState> mapEventToState(
      CategoryManagerEvent event) async* {
    if (event is InitializeCategoryManager) {
      yield* _mapLoadingCategoryManagerToState();
    } else if (event is AddCategories) {
      yield* _mapAddCategoriesToState(event);
    } else if (event is DeleteCategory) {
      yield* _mapDeleteCategoryToState(event);
    } else if (event is UpdateCategory) {
      yield* _mapUpdateCategoryToState(event);
    } else if (event is MoveCategory) {
      yield* _mapMoveCategoryToState(event);
    }
  }

  Stream<CategoryManagerState> _mapLoadingCategoryManagerToState() async* {
    final List<String> categories = HiveProvider().getCategoryNames();

    yield LoadedCategoryManager(categories);
  }

  Stream<CategoryManagerState> _mapAddCategoriesToState(
      AddCategories event) async* {
    if (state is LoadedCategoryManager) {
      final List<String> categories =
          List.from((state as LoadedCategoryManager).categories)
            ..insertAll((state as LoadedCategoryManager).categories.length - 1,
                event.categories);

      yield LoadedCategoryManager(categories);
    }
  }

  Stream<CategoryManagerState> _mapDeleteCategoryToState(
      DeleteCategory event) async* {
    if (state is LoadedCategoryManager) {
      final List<String> categories =
          List<String>.from((state as LoadedCategoryManager).categories)
            ..remove(event.category);

      yield LoadedCategoryManager(categories);
    }
  }

  Stream<CategoryManagerState> _mapUpdateCategoryToState(
      UpdateCategory event) async* {
    if (state is LoadedCategoryManager) {
      final List<String> categories =
          (state as LoadedCategoryManager).categories.map((category) {
        if (category == event.oldCategory) {
          return event.updatedCategory;
        } else {
          return category;
        }
      }).toList();

      yield LoadedCategoryManager(categories);
    }
  }

  Stream<CategoryManagerState> _mapMoveCategoryToState(
      MoveCategory event) async* {
    if (state is LoadedCategoryManager) {
      // List in HiveProvider()Provider() is already updated of the recipeManager

      final List<String> it1 = List<String>.from(
          (state as LoadedCategoryManager).categories
            ..insert(event.newIndex,
                (state as LoadedCategoryManager).categories[event.oldIndex]));

      final List<String> it2 = List<String>.from(it1
        ..removeAt(event.oldIndex > event.newIndex
            ? event.oldIndex + 1
            : event.oldIndex));

      yield LoadedCategoryManager(it2);
    }
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
