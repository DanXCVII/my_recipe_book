part of 'category_overview_bloc.dart';

abstract class CategoryOverviewEvent extends Equatable {
  const CategoryOverviewEvent();

  @override
  List<Object> get props => [];
}

class COLoadCategoryOverview extends CategoryOverviewEvent {}

class COAddRecipe extends CategoryOverviewEvent {
  final Recipe recipe;

  const COAddRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'AddRecipe { recipe: $recipe }';
}

class COUpdateRecipe extends CategoryOverviewEvent {
  final Recipe oldRecipe;
  final Recipe updatedRecipe;

  const COUpdateRecipe(this.oldRecipe, this.updatedRecipe);

  @override
  List<Object> get props => [oldRecipe, updatedRecipe];

  @override
  String toString() => 'UpdateRecipe { updatedRecipe: $updatedRecipe }';
}

class CODeleteRecipe extends CategoryOverviewEvent {
  final Recipe recipe;

  const CODeleteRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() => 'DeleteRecipe { recipe: $recipe }';
}

class COAddCategory extends CategoryOverviewEvent {
  final List<String> categories;

  const COAddCategory(this.categories);

  @override
  List<Object> get props => [categories];
}

class CODeleteCategory extends CategoryOverviewEvent {
  final String category;

  const CODeleteCategory(this.category);

  @override
  List<Object> get props => [category];
}

class COUpdateCategory extends CategoryOverviewEvent {
  final String oldCategory;
  final String updatedCategory;

  const COUpdateCategory(this.oldCategory, this.updatedCategory);

  @override
  List<Object> get props => [oldCategory, updatedCategory];
}

class COMoveCategory extends CategoryOverviewEvent {
  final int oldIndex;
  final int newIndex;

  const COMoveCategory(this.oldIndex, this.newIndex);

  @override
  List<Object> get props => [oldIndex, newIndex];

  @override
  String toString() =>
      'move category { oldIndex: $oldIndex , newIndex: $newIndex }';
}
