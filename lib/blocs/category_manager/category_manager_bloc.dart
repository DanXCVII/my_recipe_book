import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_event.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_state.dart'
    as RMState;
import 'package:my_recipe_book/hive.dart';
import './category_manager.dart';

class CategoryManagerBloc
    extends Bloc<CategoryManagerEvent, CategoryManagerState> {
  final RecipeManagerBloc recipeManagerBloc;
  StreamSubscription subscription;

  CategoryManagerBloc({@required this.recipeManagerBloc}) {
    subscription = recipeManagerBloc.listen((state) {
      print(this.hashCode);
      if (state is RMState.AddCategoryState) {
        add(AddCategory(state.category));
      } else if (state is RMState.DeleteCategoryState) {
        add(DeleteCategory(state.category));
      } else if (state is RMState.UpdateCategoryState) {
        add(UpdateCategory(state.oldCategory, state.updatedCategory));
      } else if (state is RMState.MoveCategoryState) {
        add(MoveCategory(state.oldIndex, state.newIndex));
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
    } else if (event is AddCategory) {
      yield* _mapAddCategoryToState(event);
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

  Stream<CategoryManagerState> _mapAddCategoryToState(
      AddCategory event) async* {
    if (state is LoadedCategoryManager) {
      final List<String> categories =
          List.from((state as LoadedCategoryManager).categories)
            ..insert((state as LoadedCategoryManager).categories.length,
                event.category);

      yield LoadedCategoryManager(categories);
    }
  }

  Stream<CategoryManagerState> _mapDeleteCategoryToState(
      DeleteCategory event) async* {
    if (state is LoadedCategoryManager) {
      final List<String> categories =
          (state as LoadedCategoryManager).categories..remove(event.category);

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
      });

      yield LoadedCategoryManager(categories);
    }
  }

  Stream<CategoryManagerState> _mapMoveCategoryToState(
      MoveCategory event) async* {
    if (state is LoadedCategoryManager) {
      // List in HiveProvider()Provider() is already updated of the recipeManager
      final List<String> categories = HiveProvider().getCategoryNames();

      yield LoadedCategoryManager(categories);
    }
  }

  @override
  void close() {
    subscription.cancel();
    super.close();
  }
}
