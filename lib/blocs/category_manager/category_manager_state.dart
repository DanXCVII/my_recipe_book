part of 'category_manager_bloc.dart';

abstract class CategoryManagerState extends Equatable {
  const CategoryManagerState();
}

class LoadingCategoryManager extends CategoryManagerState {
  @override
  List<Object> get props => [];
}

class LoadedCategoryManager extends CategoryManagerState {
  final List<String> categories;

  const LoadedCategoryManager([this.categories = const []]);

  @override
  List<Object> get props => [categories];

  @override
  String toString() => 'Categories loaded { categories: $categories }';
}
