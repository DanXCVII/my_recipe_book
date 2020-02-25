part of 'category_manager_bloc.dart';

abstract class CategoryManagerEvent extends Equatable {
  const CategoryManagerEvent();
}

class InitializeCategoryManager extends CategoryManagerEvent {
  @override
  List<Object> get props => [];
}

class AddCategory extends CategoryManagerEvent {
  final String category;

  const AddCategory(this.category);

  @override
  List<Object> get props => [category];
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
