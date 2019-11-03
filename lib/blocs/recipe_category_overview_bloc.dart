import 'package:my_recipe_book/models/recipe.dart';
import '../hive.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';
import 'package:hive/hive.dart';

class RecipeCategoryOverviewBloc implements BlocBase {
  LazyBox _lazyBoxRecipes;
  Box<List<String>> _boxRecipeCategories;
  Box<List<String>> _boxOrder;
  Box<String> _boxCategories;

  List<List<Recipe>> _categoryRecipesList = [[]];
  List<String> _categoryNamesList = [];

  PublishSubject<List<String>> _categoryNames = PublishSubject<List<String>>();
  Sink<List<String>> get _inCategories => _categoryNames.sink;
  Stream<List<String>> get outCategories => _categoryNames.stream;

  PublishSubject<List<List<Recipe>>> _categoryRecipes =
      PublishSubject<List<List<Recipe>>>();
  Sink<List<List<Recipe>>> get _inCategoryRecipes => _categoryRecipes.sink;
  Stream<List<List<Recipe>>> get outCategoryRecipes => _categoryRecipes.stream;

  /// Either vegetable or category MUST be specified
  RecipeCategoryOverviewBloc() {
    _lazyBoxRecipes = Hive.box('recipes') as LazyBox;
    _boxRecipeCategories = Hive.box<List<String>>('recipeCategories');
    _boxOrder = Hive.box<List<String>>('order');
    _boxCategories = Hive.box<String>('categories');

    _initializeCategories();
    _listenCategoryChanges();
  }

  Future<void> _initializeCategories() async {
    _categoryNamesList = [];
    _categoryRecipesList = [[]];

    for (String categoryKey in _boxOrder.get('categories')) {
      String categoryName = _boxCategories.get(categoryKey);
      List<Recipe> categoryRecipes = await getCategoryRecipes(categoryName);
      if (categoryRecipes.isNotEmpty) {
        _categoryNamesList.add(_boxCategories.get(categoryKey));
        _categoryRecipesList.add(categoryRecipes.sublist(
            0, categoryRecipes.length > 8 ? 8 : categoryRecipes.length));
      }
    }

    _inCategories.add(_categoryNamesList);
    _inCategoryRecipes.add(_categoryRecipesList);
  }

  void _listenCategoryChanges() {
    _boxOrder.watch(key: 'categories').listen((event) async {
      if (event.deleted) {
        _categoryNamesList = [];
        _categoryRecipesList = [[]];
      } else {
        _initializeCategories();
        return;
      }
      _inCategories.add(_categoryNamesList);
      _inCategoryRecipes.add(_categoryRecipesList);
    });
  }

  void dispose() {
    _boxCategories.close();
    _boxOrder.close();
    _boxRecipeCategories.close();
    _lazyBoxRecipes.close();
    _categoryNames.close();
    _categoryRecipes.close();
  }
}
