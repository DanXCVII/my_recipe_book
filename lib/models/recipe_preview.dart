
import 'package:my_recipe_book/models/recipe.dart';

import 'enums.dart';

class RecipePreview {
  String name;
  String imagePreviewPath;
  String totalTime;
  int ingredientsAmount;
  int effort;
  bool isFavorite;
  Vegetable vegetable;
  List<String> categories;

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
}