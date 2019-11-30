import 'package:equatable/equatable.dart';

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

  @override
  String toString() => 'add category { category: $category }';
}

class DeleteCategory extends CategoryManagerEvent {
  final String category;

  const DeleteCategory(this.category);

  @override
  List<Object> get props => [category];

  @override
  String toString() => 'delete category { category: $category }';
}

class MoveCategory extends CategoryManagerEvent {
  final int oldIndex;
  final int newIndex;

  const MoveCategory(this.oldIndex, this.newIndex);

  @override
  List<Object> get props => [oldIndex, newIndex];

  @override
  String toString() =>
      'move category { oldIndex: $oldIndex , newIndex: $newIndex }';
}

class UpdateCategory extends CategoryManagerEvent {
  final String oldCategory;
  final String updatedCategory;

  const UpdateCategory(this.oldCategory, this.updatedCategory);

  @override
  List<Object> get props => [oldCategory, updatedCategory];

  @override
  String toString() =>
      'update category { oldIndex: $oldCategory , newIndex: $updatedCategory }';
}
