import '../../models/enums.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../models/recipe_sort.dart';
import '../../models/shopping_cart_data.dart';
import '../../models/string_int_tuple.dart';
import '../../models/tuple.dart';
import '../database.dart';
import 'calendar_store.dart';
import 'catalog_store.dart';
import 'draft_deletion_store.dart';
import 'drift_repository_context.dart';
import 'legacy_snapshot.dart';
import 'local_repository_contract.dart';
import 'migration_store.dart';
import 'recipe_store.dart';
import 'shopping_cart_store.dart';

class DriftRepository implements LocalRepository {
  static const int currentMigrationVersion = 1;
  static const int currentSchemaVersion = 2;

  DriftRepository({AppDatabase? database})
    : _context = DriftRepositoryContext(database) {
    _catalogs = CatalogStore(_context, _reloadAll);
    _recipes = RecipeStore(_context, _catalogs, _reloadAll);
    _drafts = DraftDeletionStore(_context, _reloadAll);
    _calendar = CalendarStore(_context);
    _cart = ShoppingCartStore(_context, _recipes.getRecipeByName);
    _migration = MigrationStore(_context, _recipes, _drafts, _cart, _reloadAll);
  }

  final DriftRepositoryContext _context;
  late final CatalogStore _catalogs;
  late final RecipeStore _recipes;
  late final DraftDeletionStore _drafts;
  late final CalendarStore _calendar;
  late final ShoppingCartStore _cart;
  late final MigrationStore _migration;

  Future<void> _reloadAll() async {
    await _recipes.reload();
    await _catalogs.reload();
    await _drafts.reload();
    await _cart.reload();
  }

  @override
  Future<void> initialize() async {
    await _context.initialize();
    await _reloadAll();
  }

  Future<bool> hasCompletedLegacyMigration() =>
      _migration.hasCompletedLegacyMigration();
  Future<bool> hasAnyStoredData() => _migration.hasAnyStoredData();
  Future<bool> isFreshSeedPending() => _migration.isFreshSeedPending();
  Future<void> markFreshSeedComplete() => _migration.markFreshSeedComplete();
  Future<void> initializeFresh() => _migration.initializeFresh();
  Future<void> importLegacySnapshot(LegacySnapshot value) =>
      _migration.importLegacySnapshot(value);
  Future<List<LegacyMigrationIssue>> unresolvedMigrationIssues() =>
      _migration.unresolvedMigrationIssues();
  Future<bool> recoverLegacyRecipe(String key, Recipe recipe) =>
      _migration.recoverLegacyRecipe(key, recipe);
  Future<void> cleanupLegacyFilesIfDue() =>
      _migration.cleanupLegacyFilesIfDue();
  @override
  Future<int> unresolvedMigrationIssueCount() =>
      _migration.unresolvedMigrationIssueCount();
  @override
  Future<List<MigrationIssueSummary>> migrationIssues() =>
      _migration.migrationIssues();
  @override
  Future<void> reopenBoxes() => _reloadAll();
  @override
  Future<void> saveRecipe(Recipe value) => _recipes.saveRecipe(value);
  @override
  Future<void> modifyRecipe(String oldName, Recipe value) =>
      _recipes.modifyRecipe(oldName, value);
  @override
  Future<void> deleteRecipe(String name, {String? deletionDate}) =>
      _recipes.deleteRecipe(name, deletionDate: deletionDate);
  @override
  Future<List<Recipe>> getAllRecipes() => _recipes.getAllRecipes();
  @override
  Future<Recipe?> getRecipeByName(String name) =>
      _recipes.getRecipeByName(name);
  @override
  Future<bool> doesRecipeExist(String name) => _recipes.doesRecipeExist(name);
  @override
  Future<List<Tuple2<int, Recipe>>> getRecipesWithIngredients(
    List<String> values,
  ) => _recipes.getRecipesWithIngredients(values);
  @override
  List<String> getRecipeNames() => _recipes.getRecipeNames();
  @override
  Future<List<Recipe>> getFavoriteRecipes() => _recipes.getFavoriteRecipes();
  @override
  Future<List<Recipe>> getVegetableRecipes(Vegetable value) =>
      _recipes.getVegetableRecipes(value);
  @override
  Future<List<Recipe>> getRecipeTagRecipes(String tag) =>
      _recipes.getRecipeTagRecipes(tag);
  @override
  Future<List<Recipe>> getCategoryRecipes(String category) =>
      _recipes.getCategoryRecipes(category);
  @override
  Future<Recipe?> getRandomRecipeOfCategory({
    String? category,
    Recipe? excludedRecipe,
  }) => _recipes.getRandomRecipeOfCategory(
    category: category,
    excludedRecipe: excludedRecipe,
  );
  @override
  Future<Recipe?> getRandomRecipeOfVegetable(
    Vegetable value, {
    Recipe? excludedRecipe,
  }) => _recipes.getRandomRecipeOfVegetable(
    value,
    excludedRecipe: excludedRecipe,
  );
  @override
  Future<Recipe?> getRandomRecipeOfRecipeTag(
    String tag, {
    Recipe? excludedRecipe,
  }) =>
      _recipes.getRandomRecipeOfRecipeTag(tag, excludedRecipe: excludedRecipe);
  @override
  Future<Recipe?> getRandomRecipeFromKeyList(
    List<String> names, {
    Recipe? excludedRecipe,
  }) => _recipes.getRandomRecipeFromKeyList(
    names,
    excludedRecipe: excludedRecipe,
  );
  @override
  Future<void> addToFavorites(Recipe value) => _recipes.addToFavorites(value);
  @override
  bool isRecipeFavorite(String name) => _recipes.isRecipeFavorite(name);
  @override
  Future<void> removeFromFavorites(Recipe value) =>
      _recipes.removeFromFavorites(value);
  @override
  Future<void> saveTmpRecipe(Recipe value) => _drafts.saveTmpRecipe(value);
  @override
  Future<void> saveTmpEditingRecipe(Recipe value) =>
      _drafts.saveTmpEditingRecipe(value);
  @override
  Future<void> deleteTmpEditingRecipe() => _drafts.deleteTmpEditingRecipe();
  @override
  Future<void> resetTmpRecipe() => _drafts.resetTmpRecipe();
  @override
  Recipe? getTmpRecipe() => _drafts.getTmpRecipe();
  @override
  Recipe? getTmpEditingRecipe() => _drafts.getTmpEditingRecipe();
  @override
  bool wasDeletedBefore(String name) => _drafts.wasDeletedBefore(name);
  @override
  DateTime? getDeletionDate(String name) => _drafts.getDeletionDate(name);
  @override
  Map<String, DateTime> getDeletions() => _drafts.getDeletions();
  @override
  Future<void> clearDeletions() => _drafts.clearDeletions();
  @override
  Future<void> addCategory(String name) => _catalogs.addCategory(name);
  @override
  Future<void> renameCategory(String oldName, String newName) =>
      _catalogs.renameCategory(oldName, newName);
  @override
  Future<void> deleteCategory(String name) => _catalogs.deleteCategory(name);
  @override
  Future<void> moveCategory(int oldIndex, int newIndex) =>
      _catalogs.moveCategory(oldIndex, newIndex);
  @override
  List<String> getCategoryNames() => _catalogs.getCategoryNames();
  @override
  int getRecipeAmountCategory(String name) =>
      _catalogs.getRecipeAmountCategory(name);
  @override
  Future<void> changeSortOrder(RSort sort, String category) =>
      _catalogs.changeSortOrder(sort, category);
  @override
  Future<RSort> getSortOrder(String category) =>
      _catalogs.getSortOrder(category);
  @override
  Future<void> addRecipeTag(String name, int color) =>
      _catalogs.addRecipeTag(name, color);
  @override
  Future<void> deleteRecipeTag(String name) => _catalogs.deleteRecipeTag(name);
  @override
  Future<void> updateRecipeTag(String oldName, String newName, int color) =>
      _catalogs.updateRecipeTag(oldName, newName, color);
  @override
  List<StringIntTuple> getRecipeTags() => _catalogs.getRecipeTags();
  @override
  List<String> getIngredientNames() => _catalogs.getIngredientNames();
  @override
  Future<void> addIngredient(String name) => _catalogs.addIngredient(name);
  @override
  Future<void> deleteIngredient(String name) =>
      _catalogs.deleteIngredient(name);
  @override
  List<String> getNutritions() => _catalogs.getNutritions();
  @override
  Future<void> addNutrition(String name) => _catalogs.addNutrition(name);
  @override
  Future<void> renameNutrition(String oldName, String newName) =>
      _catalogs.renameNutrition(oldName, newName);
  @override
  Future<void> moveNutrition(int oldIndex, int newIndex) =>
      _catalogs.moveNutrition(oldIndex, newIndex);
  @override
  Future<void> deleteNutrition(String name) => _catalogs.deleteNutrition(name);
  @override
  Future<void> addRecipeToCalendar(DateTime date, String name) =>
      _calendar.addRecipeToCalendar(date, name);
  @override
  Future<void> removeRecipeFromCalendar(String name) =>
      _calendar.removeRecipeFromCalendar(name);
  @override
  Future<void> removeRecipeFromDateCalendar(DateTime date, String name) =>
      _calendar.removeRecipeFromDateCalendar(date, name);
  @override
  Future<Map<DateTime, List<String>>> getRecipeCalendar() =>
      _calendar.getRecipeCalendar();
  @override
  Future<Map<Recipe, List<CheckableIngredient>>> getShoppingCart() =>
      _cart.getShoppingCart();
  @override
  Future<ShoppingCartData> getShoppingCartData() => _cart.getShoppingCartData();
  @override
  Future<void> addMultipleIngredientsToCart(
    String name,
    List<Ingredient> values, {
    double? servings,
  }) => _cart.addMultipleIngredientsToCart(name, values, servings: servings);
  @override
  Future<void> addSingleIngredientToCart(String name, Ingredient value) =>
      _cart.addSingleIngredientToCart(name, value);
  @override
  Future<void> removeAndAddIngredient(String name, Ingredient value) =>
      _cart.removeAndAddIngredient(name, value);
  @override
  Future<void> removeAndAddIngredients(String name, List<Ingredient> values) =>
      _cart.removeAndAddIngredients(name, values);
  @override
  Future<void> removeIngredientsFromCart(
    String name,
    List<Ingredient> values,
  ) => _cart.removeIngredientsFromCart(name, values);
  @override
  bool checkForRecipeIngredient(String name, Ingredient value) =>
      _cart.checkForRecipeIngredient(name, value);
  @override
  bool checkForRecipeIngredients(String name, List<Ingredient> values) =>
      _cart.checkForRecipeIngredients(name, values);
  @override
  Future<void> checkIngredient(String name, CheckableIngredient value) =>
      _cart.checkIngredient(name, value);
  @override
  Future<void> removeRecipeFromCart(String name) =>
      _cart.removeRecipeFromCart(name);
  @override
  Future<void> removeIngredientFromCart(String name, Ingredient value) =>
      _cart.removeIngredientFromCart(name, value);
  @override
  Future<void> updateShoppingCartServings(String name, double newServings) =>
      _cart.updateSourceServings(name, newServings);
  @override
  Future<ShoppingCartData?> removeCheckedShoppingCartItems() =>
      _cart.removeCheckedItems();
  @override
  Future<void> restoreShoppingCart(ShoppingCartData snapshot) =>
      _cart.restore(snapshot);
}
