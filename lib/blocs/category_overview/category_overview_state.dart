import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/models/tuple.dart';

abstract class CategoryOverviewState extends Equatable {
  const CategoryOverviewState();

  @override
  List<Object> get props => [];
}

class LoadingCategoryOverview extends CategoryOverviewState {}

class LoadedCategoryOverview extends CategoryOverviewState {
  // Tuple because every category is connected to a random image
  // Not a map because the order is important and may change
  final List<Tuple2<String, String>> categories;

  const LoadedCategoryOverview([this.categories = const []]);

  @override
  List<Object> get props => [categories];

  @override
  String toString() => 'Categorie Overview loaded { overview: $categories }';
}
