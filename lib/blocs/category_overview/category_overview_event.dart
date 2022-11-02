part of 'category_overview_bloc.dart';

abstract class CategoryOverviewEvent extends Equatable {
  const CategoryOverviewEvent();

  @override
  List<Object?> get props => [];
}

class COLoadCategoryOverview extends CategoryOverviewEvent {
  final bool reopenBoxes;
  final BuildContext? categoryOverviewContext;

  COLoadCategoryOverview(
      {this.reopenBoxes = false, this.categoryOverviewContext});

  @override
  List<Object?> get props => [reopenBoxes, categoryOverviewContext];
}

class COAddRecipes extends CategoryOverviewEvent {
  final List<Recipe> recipes;

  const COAddRecipes(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class CODeleteRecipe extends CategoryOverviewEvent {
  final Recipe recipe;

  const CODeleteRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
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
}
