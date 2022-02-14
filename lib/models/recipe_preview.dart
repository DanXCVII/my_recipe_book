import 'package:equatable/equatable.dart';

import 'enums.dart';

class RecipePreview extends Equatable {
  final String/*!*/ name;
  final String/*!*/ imagePreviewPath;
  final String/*!*/ totalTime;
  final int/*!*/ ingredientsAmount;
  final int/*!*/ effort;
  final bool/*!*/ isFavorite;
  final Vegetable/*!*/ vegetable;
  final List<String>/*!*/ categories;

  RecipePreview({
    this.name,
    this.totalTime,
    this.imagePreviewPath,
    this.ingredientsAmount,
    this.effort,
    this.vegetable,
    this.isFavorite,
    this.categories,
  });

  get rName => name;
  get rTotalTime => totalTime;
  get rIngredientsAmount => ingredientsAmount;
  get rEffort => effort;
  get rVegetable => vegetable;
  get rIsFavorite => isFavorite;
  get rImagePreviewPath => imagePreviewPath;
  get rCategories => categories;

  @override
  List<Object> get props => [
        name,
        totalTime,
        imagePreviewPath,
        ingredientsAmount,
        effort,
        vegetable,
        isFavorite,
        categories,
      ];
}
