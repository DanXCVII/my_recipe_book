import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_sort.dart';
import 'package:rxdart/rxdart.dart';

import '../helper.dart';
import 'bloc_provider.dart';
import 'package:hive/hive.dart';

class FavoriteRecipesBloc implements BlocBase {
  LazyBox _lazyBoxRecipes;
  Box<String> _boxFavorites;

  List<Recipe> _favoriteRecipesList = [];
  Map<String, Recipe> _favoriteRecipesMap = {};

  PublishSubject<List<Recipe>> _favoriteRecipes =
      PublishSubject<List<Recipe>>();
  Sink<List<Recipe>> get _inRecipeList => _favoriteRecipes.sink;
  Stream<List<Recipe>> get outRecipeList => _favoriteRecipes.stream;

  /// Either vegetable or category MUST be specified
  FavoriteRecipesBloc() {
    _lazyBoxRecipes = Hive.box('recipes') as LazyBox;
    _boxFavorites = Hive.box<String>('favorites');

    _initializeFavorites();
    _listenFavoriteChanges();
  }

  Future<void> _initializeFavorites() async {
    for (var key in _boxFavorites.keys) {
      Recipe currentRecipe = await _lazyBoxRecipes.get(_boxFavorites.get(key));
      _favoriteRecipesList.add(currentRecipe);
      _favoriteRecipesMap.addAll({key: currentRecipe});
    }

    _inRecipeList.add(_favoriteRecipesList);
  }

  void _listenFavoriteChanges() {
    _boxFavorites.watch().listen((event) async {
      if (event.deleted) {
        _favoriteRecipesList.remove(_lazyBoxRecipes.get(event.value));
      } else {
        Recipe newRecipe = await _lazyBoxRecipes.get(event.value);
        Recipe oldRecipe = _favoriteRecipesMap[event.key];

        _favoriteRecipesList.removeWhere((recipe) => recipe == oldRecipe);
        _favoriteRecipesList.add(newRecipe);

        _favoriteRecipesMap.remove(event.key);
        _favoriteRecipesMap
            .addAll({event.key: await _lazyBoxRecipes.get(event.value)});
      }
      _inRecipeList.add(_favoriteRecipesList);
    });
  }

  void changeOrder(RSort recipeSort) {
    switch (recipeSort.sort) {
      case RecipeSort.BY_NAME:
        _favoriteRecipesList.sort((a, b) => recipeSort.ascending
            ? a.name.compareTo(b.name)
            : b.name.compareTo((a.name)));
        break;
      case RecipeSort.BY_EFFORT:
        _favoriteRecipesList.sort((a, b) => recipeSort.ascending
            ? a.effort.compareTo(b.effort)
            : b.effort.compareTo(a.effort));
        break;
      case RecipeSort.BY_INGREDIENT_COUNT:
        _favoriteRecipesList.sort((a, b) => recipeSort.ascending
            ? getIngredientCount(a.ingredients)
                .compareTo(getIngredientCount(b.ingredients))
            : getIngredientCount(b.ingredients)
                .compareTo(getIngredientCount(a.ingredients)));
        break;
    }

    _inRecipeList.add(_favoriteRecipesList);
  }

  void dispose() {
    _favoriteRecipes.close();
    _lazyBoxRecipes.close();
    _boxFavorites.close();
  }
}
