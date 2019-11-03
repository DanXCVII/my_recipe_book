import 'dart:math';

import 'package:my_recipe_book/models/recipe.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import 'bloc_provider.dart';
import 'package:hive/hive.dart';

class CategoryGridviewBloc implements BlocBase {
  LazyBox _lazyBoxRecipes;
  Box<List<String>> _boxRecipeCategories;
  Box<List<String>> _boxOrder;
  Box<String> _boxCategories;

  List<Tuple2<String, String>> _categoryTuples = [];

  PublishSubject<List<Tuple2<String, String>>> _categories =
      PublishSubject<List<Tuple2<String, String>>>();
  Sink<List<Tuple2<String, String>>> get _inCategories => _categories.sink;
  Stream<List<Tuple2<String, String>>> get outCategories => _categories.stream;

  /// Either vegetable or category MUST be specified
  CategoryGridviewBloc() {
    _lazyBoxRecipes = Hive.box('recipes') as LazyBox;
    _boxRecipeCategories = Hive.box<List<String>>('recipeCategories');
    _boxOrder = Hive.box<List<String>>('order');
    _boxCategories = Hive.box<String>('categories');

    _initializeCategories();
    _listenCategoryChanges();
  }

  Future<void> _initializeCategories() async {
    _categoryTuples = [];

    for (String categoryKey in _boxOrder.get('categories')) {
      List<Recipe> categoryRecipes = await _lazyBoxRecipes.get(categoryKey);
      if (categoryRecipes.isNotEmpty) {
        String categoryName = _boxCategories.get(categoryKey);

        Random r = new Random();
        int randomImage = categoryRecipes.length - 1 == 0
            ? 0
            : r.nextInt(categoryRecipes.length);
        String randomCategoryImage =
            categoryRecipes[randomImage].imagePreviewPath;

        _categoryTuples.add(Tuple2(categoryName, randomCategoryImage));
      }
    }

    _inCategories.add(_categoryTuples);
  }

  void _listenCategoryChanges() {
    _boxOrder.watch(key: 'categories').listen((event) async {
      // Should never happen
      if (event.deleted) {
        _categoryTuples = [];
      } else {
        // Could be improved by checked what explizitely changed
        _initializeCategories();
        return;
      }
      _inCategories.add(_categoryTuples);
    });
  }

  void dispose() {
    _boxCategories.close();
    _boxOrder.close();
    _boxRecipeCategories.close();
    _lazyBoxRecipes.close();
    _categories.close();
  }
}
