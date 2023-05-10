import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../local_storage/hive.dart';
import '../recipe_manager/recipe_manager_bloc.dart' as RM;

part 'category_manager_event.dart';
part 'category_manager_state.dart';

class CategoryManagerBloc
    extends Bloc<CategoryManagerEvent, CategoryManagerState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  late StreamSubscription subscription;

  List<String> selectedCategories = [];

  CategoryManagerBloc(
      {required this.recipeManagerBloc,
      required List<String> selectedCategories})
      : super(LoadingCategoryManager()) {
    if (selectedCategories.isNotEmpty)
      this.selectedCategories = List<String>.from(selectedCategories);
    subscription = recipeManagerBloc.stream.listen((rmState) {
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

    on<InitializeCategoryManager>((event, emit) async {
      final List<String> categories = HiveProvider().getCategoryNames();

      emit(LoadedCategoryManager(categories));
    });

    on<AddCategories>((event, emit) async {
      if (state is LoadedCategoryManager) {
        selectedCategories.addAll(event.categories);

        final List<String> categories =
            List.from((state as LoadedCategoryManager).categories)
              ..insertAll(
                  (state as LoadedCategoryManager).categories.length - 1,
                  event.categories);

        emit(LoadedCategoryManager(categories));
      }
    });

    on<DeleteCategory>((event, emit) async {
      if (state is LoadedCategoryManager) {
        final List<String> categories =
            List<String>.from((state as LoadedCategoryManager).categories)
              ..remove(event.category);
        if (selectedCategories.contains(event.category)) {
          selectedCategories.remove(event.category);
        }

        emit(LoadedCategoryManager(categories));
      }
    });

    on<UpdateCategory>((event, emit) async {
      if (state is LoadedCategoryManager) {
        final List<String> categories =
            (state as LoadedCategoryManager).categories.map((category) {
          if (category == event.oldCategory) {
            return event.updatedCategory;
          } else {
            return category;
          }
        }).toList();

        if (selectedCategories.contains(event.oldCategory)) {
          selectedCategories[selectedCategories.indexOf(event.oldCategory)] =
              event.updatedCategory;
        }

        emit(LoadedCategoryManager(categories));
      }
    });

    on<MoveCategory>((event, emit) async {
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

        emit(LoadedCategoryManager(it2));
      }
    });

    on<SelectCategory>((event, emit) async {
      selectedCategories.add(event.categoryName);
    });

    on<UnselectCategory>((event, emit) async {
      selectedCategories.remove(event.categoryName);
    });

    @override
    Future<void> close() {
      subscription.cancel();
      return super.close();
    }
  }
}
