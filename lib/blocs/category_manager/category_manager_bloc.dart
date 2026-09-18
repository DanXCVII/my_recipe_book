import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../local_storage/local_repository.dart';
import '../recipe_manager/recipe_manager_bloc.dart' as RM;

part 'category_manager_event.dart';
part 'category_manager_state.dart';

class CategoryManagerBloc
    extends Bloc<CategoryManagerEvent, CategoryManagerState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  final LocalRepository repository;
  late StreamSubscription subscription;

  List<String> selectedCategories;

  CategoryManagerBloc({
    required this.recipeManagerBloc,
    required this.repository,
    required List<String> selectedCategories,
  }) : selectedCategories = List<String>.from(selectedCategories),
       super(LoadingCategoryManager()) {
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
      final List<String> categories = repository.getCategoryNames();

      emit(LoadedCategoryManager(categories));
    });

    on<AddCategories>((event, emit) async {
      if (state is LoadedCategoryManager) {
        selectedCategories = [...selectedCategories, ...event.categories];

        final categories = List<String>.from(
          (state as LoadedCategoryManager).categories,
        );
        final systemIndex = categories.indexOf(noCategoryName);
        categories.insertAll(
          systemIndex < 0 ? categories.length : systemIndex,
          event.categories,
        );

        emit(LoadedCategoryManager(categories));
      }
    });

    on<DeleteCategory>((event, emit) async {
      if (state is LoadedCategoryManager) {
        final List<String> categories = List<String>.from(
          (state as LoadedCategoryManager).categories,
        )..remove(event.category);
        selectedCategories = selectedCategories
            .where((category) => category != event.category)
            .toList();

        emit(LoadedCategoryManager(categories));
      }
    });

    on<UpdateCategory>((event, emit) async {
      if (state is LoadedCategoryManager) {
        final List<String> categories = (state as LoadedCategoryManager)
            .categories
            .map((category) {
              if (category == event.oldCategory) {
                return event.updatedCategory;
              } else {
                return category;
              }
            })
            .toList();

        selectedCategories = selectedCategories
            .map(
              (category) => category == event.oldCategory
                  ? event.updatedCategory
                  : category,
            )
            .toList();

        emit(LoadedCategoryManager(categories));
      }
    });

    on<MoveCategory>((event, emit) async {
      if (state is LoadedCategoryManager) {
        final categories = List<String>.from(
          (state as LoadedCategoryManager).categories,
        );
        if (event.oldIndex < 0 ||
            event.oldIndex >= categories.length ||
            event.newIndex < 0 ||
            event.newIndex >= categories.length ||
            event.oldIndex == event.newIndex) {
          return;
        }
        final moved = categories.removeAt(event.oldIndex);
        categories.insert(event.newIndex, moved);
        emit(LoadedCategoryManager(categories));
      }
    });

    on<SelectCategory>((event, emit) async {
      if (!selectedCategories.contains(event.categoryName)) {
        selectedCategories = [...selectedCategories, event.categoryName];
      }
    });

    on<UnselectCategory>((event, emit) async {
      selectedCategories = selectedCategories
          .where((category) => category != event.categoryName)
          .toList();
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
