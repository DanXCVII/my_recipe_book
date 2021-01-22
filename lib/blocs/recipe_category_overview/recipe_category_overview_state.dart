part of 'recipe_category_overview_bloc.dart';

abstract class RecipeCategoryOverviewState {
  const RecipeCategoryOverviewState();
}

class LoadingRecipeCategoryOverviewState extends RecipeCategoryOverviewState {}

class LoadedRecipeCategoryOverview extends RecipeCategoryOverviewState {
  // Not a map because the oder may change
  final List<Tuple2<String, List<Recipe>>> rCategoryOverview;

  const LoadedRecipeCategoryOverview([this.rCategoryOverview = const []]);
}
