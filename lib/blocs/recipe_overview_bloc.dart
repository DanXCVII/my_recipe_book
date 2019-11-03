import 'dart:async';
import 'dart:math';

import 'package:hive/hive.dart';
import 'package:my_recipe_book/hive.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/recipe_sort.dart';
import 'package:rxdart/rxdart.dart';

import '../helper.dart';
import 'bloc_provider.dart';

class RecipeOverviewBloc implements BlocBase {
  LazyBox _lazyBoxRecipes;
  Box<String> _boxVegetable;
  Box<List<String>> _boxCategory;

  // Only needed, when vegatable instead of category is needed
  Map<String, Recipe> _vegetableRecipes = {};

  List<Recipe> _recipeList = [];
  Vegetable _vegetable;
  String _category;

  PublishSubject<List<Recipe>> _recipes = PublishSubject<List<Recipe>>();
  Sink<List<Recipe>> get _inRecipeList => _recipes.sink;
  Stream<List<Recipe>> get outRecipeList => _recipes.stream;

  PublishSubject<String> _randomImage = PublishSubject<String>();
  Sink<String> get _inRandomImage => _randomImage.sink;
  Stream<String> get outRandomImage => _randomImage.stream;

  /// Either vegetable or category MUST be specified
  RecipeOverviewBloc({Vegetable vegetable, String category}) {
    _vegetable = vegetable;
    _category = category;

    _boxVegetable = Hive.box<String>(vegetable.toString());
    _boxCategory = Hive.box<List<String>>('category');
    _lazyBoxRecipes = Hive.box<Recipe>('recipes') as LazyBox;

    _initializeAndListen(vegetable: vegetable, category: category);
  }

  Future<void> _initializeAndListen(
      {Vegetable vegetable, String category}) async {
    if (vegetable != null) {
      await _initializeVegetableRecipes(vegetable);
      _listenVegetableChanges();
    } else {
      await _initializeCategoryRecipes(category);
      _listenCategoryChanges();
    }

    _inRecipeList.add(_recipeList);
  }

  Future<void> _initializeVegetableRecipes(Vegetable vegetable) async {
    _vegetableRecipes = await getVegetableRecipes(vegetable);
    for (var key in _vegetableRecipes.keys) {
      _recipeList.add(_vegetableRecipes[key]);
    }
    _setRandomImage();

    _inRecipeList.add(_recipeList);
  }

  void _listenVegetableChanges() {
    _boxVegetable.watch().listen((event) async {
      if (event.deleted) {
        _recipeList.remove(_lazyBoxRecipes.get(event.value));
      } else {
        Recipe newRecipe = await _lazyBoxRecipes.get(event.value);
        Recipe oldRecipe = _vegetableRecipes[event.key];

        _recipeList.removeWhere((recipe) => recipe == oldRecipe);
        _recipeList.add(newRecipe);

        _vegetableRecipes.remove(event.key);
        _vegetableRecipes
            .addAll({event.key: await _lazyBoxRecipes.get(event.value)});
      }
      _setRandomImage();

      _inRecipeList.add(_recipeList);
    });
  }

  Future<void> _initializeCategoryRecipes(String category) async {
    _recipeList = await getCategoryRecipes(category);
    _setRandomImage();

    _inRecipeList.add(_recipeList);
  }

  void _listenCategoryChanges() {
    _boxCategory.watch().listen((event) async {
      _recipeList = [];
      for (var key in _boxCategory.get(_category)) {
        _recipeList.add(await _lazyBoxRecipes.get(_boxCategory.get(key)));
      }
      _setRandomImage();

      _inRecipeList.add(_recipeList);
    });
  }

  void _setRandomImage() {
    if (_recipeList.isNotEmpty) {
      Random r = Random();
      String randomImage = _recipeList[
              _recipeList.length == 1 ? 1 : r.nextInt(_recipeList.length - 1)]
          .imagePreviewPath;

      _inRandomImage.add(randomImage);
    }
  }

  void changeOrder(RSort recipeSort) {
    switch (recipeSort.sort) {
      case RecipeSort.BY_NAME:
        _recipeList.sort((a, b) => recipeSort.ascending
            ? a.name.compareTo(b.name)
            : b.name.compareTo((a.name)));
        break;
      case RecipeSort.BY_EFFORT:
        _recipeList.sort((a, b) => recipeSort.ascending
            ? a.effort.compareTo(b.effort)
            : b.effort.compareTo(a.effort));
        break;
      case RecipeSort.BY_INGREDIENT_COUNT:
        _recipeList.sort((a, b) => recipeSort.ascending
            ? getIngredientCount(a.ingredients)
                .compareTo(getIngredientCount(b.ingredients))
            : getIngredientCount(b.ingredients)
                .compareTo(getIngredientCount(a.ingredients)));
        break;
    }

    _inRecipeList.add(_recipeList);
  }

  void dispose() {
    _recipes.close();
    _lazyBoxRecipes.close();
    _boxCategory.close();
    _boxVegetable.close();
  }
}
