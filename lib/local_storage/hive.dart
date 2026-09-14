import 'package:hive_ce/hive_ce.dart';
import 'package:path_provider/path_provider.dart';

import '../models/enums.dart';
import '../models/recipe.dart';
import '../models/recipe_sort.dart';
import '../models/string_int_tuple.dart';
import '../models/string_string_tuple.dart';
import 'legacy_hive_adapters.dart';

const String tmpRecipeKey = '000';
const String tmpEditingRecipeKey = '001';

/// Names are part of the deployed Hive 2 on-device format and must not change.
class BoxNames {
  static const recipes = 'recipes';
  static const keyString = 'keyString';
  static const recipeNames = 'recipeNames';
  static const tmpRecipe = 'tmpRecipe';
  static const ratings = 'ratings';
  static const favorites = 'favorites';
  static const ingredientNames = 'ingredientNames';
  static const order = 'order';
  static const recipeSort = 'recipeSort';
  static const shoppingCart = 'shoppingCart';
  static const recipeCategories = 'recipeCategories';
  static const recipeTags = 'recipeTags';
  static const recipeTagsList = 'recipeTagsList';
  static const recipeCalendar = 'recipeCalendar';
  static const syncDeletionRecipes = 'syncDeletionRecipes';
  static final vegetarian = Vegetable.VEGETARIAN.toString();
  static final vegan = Vegetable.VEGAN.toString();
  static final nonVegetarain = Vegetable.NON_VEGETARIAN.toString();
}

/// Opens the legacy store only for migration/recovery reads.
///
/// The registered adapters deliberately throw from `write`, and no normal app
/// service receives this reader. Hive remains closed after migration.
Future<LegacyHiveReader> openLegacyHive() async {
  Hive.init((await getApplicationDocumentsDirectory()).path);
  _registerLegacyAdapter(IngredientAdapter());
  _registerLegacyAdapter(CheckableIngredientAdapter());
  _registerLegacyAdapter(VegetableAdapter());
  _registerLegacyAdapter(RecipeSortAdapter());
  _registerLegacyAdapter(RSortAdapter());
  _registerLegacyAdapter(RecipeAdapter());
  _registerLegacyAdapter(StringIntTupleAdapter());
  _registerLegacyAdapter(StringStringTupleAdapter());

  await Future.wait([
    Hive.openLazyBox<Recipe>(BoxNames.recipes),
    Hive.openBox<String>(BoxNames.nonVegetarain),
    Hive.openBox<String>(BoxNames.vegetarian),
    Hive.openBox<String>(BoxNames.vegan),
    Hive.openBox<String>(BoxNames.keyString),
    Hive.openBox<String>(BoxNames.recipeNames),
    Hive.openBox<Recipe>(BoxNames.tmpRecipe),
    Hive.openBox<String>(BoxNames.favorites),
    Hive.openBox<String>(BoxNames.ingredientNames),
    Hive.openBox<List<String>>(BoxNames.order),
    Hive.openBox<RSort>(BoxNames.recipeSort),
    Hive.openBox<List>(BoxNames.shoppingCart),
    Hive.openBox<List<String>>(BoxNames.recipeCategories),
    Hive.openBox<StringIntTuple>(BoxNames.recipeTags),
    Hive.openBox<List<String>?>(BoxNames.recipeTagsList),
    Hive.openBox<List<String>>(BoxNames.ratings),
    Hive.openBox<String>(BoxNames.recipeCalendar),
    Hive.openBox<StringStringTuple>(BoxNames.syncDeletionRecipes),
  ]);

  return LegacyHiveReader._();
}

void _registerLegacyAdapter<T>(TypeAdapter<T> adapter) {
  if (!Hive.isAdapterRegistered(adapter.typeId)) {
    Hive.registerAdapter<T>(adapter);
  }
}

class LegacyHiveReader {
  LegacyHiveReader._()
    : lazyBoxRecipes = Hive.lazyBox<Recipe>(BoxNames.recipes),
      boxKeyString = Hive.box<String>(BoxNames.keyString),
      boxRecipeNames = Hive.box<String>(BoxNames.recipeNames),
      boxTmpRecipe = Hive.box<Recipe>(BoxNames.tmpRecipe),
      boxFavorites = Hive.box<String>(BoxNames.favorites),
      boxIngredientNames = Hive.box<String>(BoxNames.ingredientNames),
      boxOrder = Hive.box<List<String>>(BoxNames.order),
      boxRecipeSort = Hive.box<RSort>(BoxNames.recipeSort),
      boxShoppingCart = Hive.box<List>(BoxNames.shoppingCart),
      boxRecipeTags = Hive.box<StringIntTuple>(BoxNames.recipeTags),
      boxRecipeCalendar = Hive.box<String>(BoxNames.recipeCalendar),
      boxSyncDeletionRecipes = Hive.box<StringStringTuple>(
        BoxNames.syncDeletionRecipes,
      );

  final LazyBox<Recipe> lazyBoxRecipes;
  final Box<String> boxKeyString;
  final Box<String> boxRecipeNames;
  final Box<Recipe> boxTmpRecipe;
  final Box<String> boxFavorites;
  final Box<String> boxIngredientNames;
  final Box<List<String>> boxOrder;
  final Box<RSort> boxRecipeSort;
  final Box<List> boxShoppingCart;
  final Box<StringIntTuple> boxRecipeTags;
  final Box<String> boxRecipeCalendar;
  final Box<StringStringTuple> boxSyncDeletionRecipes;
}
