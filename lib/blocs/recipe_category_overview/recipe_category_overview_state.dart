import 'package:equatable/equatable.dart';

import '../../models/recipe.dart';
import '../../models/tuple.dart';

abstract class RecipeCategoryOverviewState extends Equatable {
  const RecipeCategoryOverviewState();
}

class LoadingRecipeCategoryOverviewState extends RecipeCategoryOverviewState {
  @override
  List<Object> get props => [];
}

class LoadedRecipeCategoryOverview extends RecipeCategoryOverviewState {
  // Not a map because the oder may change
  final List<Tuple2<String, List<Recipe>>> rCategoryOverview;

  const LoadedRecipeCategoryOverview([this.rCategoryOverview = const []]);

  @override
  List<Object> get props => [rCategoryOverview];

  @override
  String toString() =>
      'recipe category overview loaded { overview: $rCategoryOverview }';
}
