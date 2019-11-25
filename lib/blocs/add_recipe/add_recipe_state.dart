import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/models/recipe.dart';

abstract class AddRecipeState extends Equatable {
  const AddRecipeState();
}

class LoadingAddRecipe extends AddRecipeState {
  @override
  List<Object> get props => [];
}

class LoadedAddRecipe extends AddRecipeState {
  final Recipe recipe;
  final List<String> categories;

  LoadedAddRecipe([this.recipe, this.categories]);

  @override
  List<Object> get props => [recipe, categories];

  @override
  String toString() =>
      'Loaded add recipe { recipe : $recipe , categories : $categories }';
}
