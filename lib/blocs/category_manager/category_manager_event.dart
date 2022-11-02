part of 'category_manager_bloc.dart';

abstract class CategoryManagerEvent extends Equatable {
  const CategoryManagerEvent();
}

class InitializeCategoryManager extends CategoryManagerEvent {
  @override
  List<Object> get props => [];
}

class AddCategories extends CategoryManagerEvent {
  final List<String> categories;

  const AddCategories(this.categories);

  @override
  List<Object> get props => [categories];
}

class DeleteCategory extends CategoryManagerEvent {
  final String category;

  const DeleteCategory(this.category);

  @override
  List<Object> get props => [category];
}

class MoveCategory extends CategoryManagerEvent {
  final int oldIndex;
  final int newIndex;
  final DateTime time;

  const MoveCategory(
    this.oldIndex,
    this.newIndex,
    this.time,
  );

  @override
  List<Object> get props => [
        oldIndex,
        newIndex,
        time,
      ];
}

class UpdateCategory extends CategoryManagerEvent {
  final String oldCategory;
  final String updatedCategory;

  const UpdateCategory(this.oldCategory, this.updatedCategory);

  @override
  List<Object> get props => [oldCategory, updatedCategory];
}

class SelectCategory extends CategoryManagerEvent {
  final String/*!*/ categoryName;

  const SelectCategory(this.categoryName);

  @override
  List<Object> get props => [categoryName];
}

class UnselectCategory extends CategoryManagerEvent {
  final String categoryName;

  const UnselectCategory(this.categoryName);

  @override
  List<Object> get props => [categoryName];
}
