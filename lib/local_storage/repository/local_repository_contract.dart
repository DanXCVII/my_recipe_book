import '../../models/enums.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../models/recipe_sort.dart';
import '../../models/string_int_tuple.dart';
import '../../models/tuple.dart';

const String newRecipeDraftSlot = 'new';
const String editingRecipeDraftSlot = 'editing';
const String noCategoryName = 'no category';
const String shoppingSummaryName = 'summary';

abstract interface class LocalRepository {
  Future<void> initialize();
  Future<int> unresolvedMigrationIssueCount();
  Future<List<MigrationIssueSummary>> migrationIssues();
  Future<void> reopenBoxes();
  Future<void> saveRecipe(Recipe recipe);
  Future<void> modifyRecipe(String oldName, Recipe recipe);
  Future<void> deleteRecipe(String name, {String? deletionDate});
  Future<List<Recipe>> getAllRecipes();
  Future<Recipe?> getRecipeByName(String name);
  Future<bool> doesRecipeExist(String name);
  Future<List<Tuple2<int, Recipe>>> getRecipesWithIngredients(
    List<String> ingredients,
  );
  List<String> getRecipeNames();
  Future<List<Recipe>> getFavoriteRecipes();
  Future<List<Recipe>> getVegetableRecipes(Vegetable vegetable);
  Future<List<Recipe>> getRecipeTagRecipes(String tag);
  Future<List<Recipe>> getCategoryRecipes(String category);
  Future<Recipe?> getRandomRecipeOfCategory({
    String? category,
    Recipe? excludedRecipe,
  });
  Future<Recipe?> getRandomRecipeOfVegetable(
    Vegetable vegetable, {
    Recipe? excludedRecipe,
  });
  Future<Recipe?> getRandomRecipeOfRecipeTag(
    String tag, {
    Recipe? excludedRecipe,
  });
  Future<Recipe?> getRandomRecipeFromKeyList(
    List<String> recipeNames, {
    Recipe? excludedRecipe,
  });
  Future<void> addToFavorites(Recipe recipe);
  bool isRecipeFavorite(String recipeName);
  Future<void> removeFromFavorites(Recipe recipe);
  Future<void> saveTmpRecipe(Recipe recipe);
  Future<void> saveTmpEditingRecipe(Recipe recipe);
  Future<void> deleteTmpEditingRecipe();
  Future<void> resetTmpRecipe();
  Recipe? getTmpRecipe();
  Recipe? getTmpEditingRecipe();
  Future<void> addCategory(String name);
  Future<void> renameCategory(String oldName, String newName);
  Future<void> deleteCategory(String name);
  Future<void> moveCategory(int oldIndex, int newIndex);
  List<String> getCategoryNames();
  int getRecipeAmountCategory(String category);
  Future<void> changeSortOrder(RSort sort, String category);
  Future<RSort> getSortOrder(String category);
  Future<void> addRecipeTag(String name, int color);
  Future<void> deleteRecipeTag(String name);
  Future<void> updateRecipeTag(String oldName, String newName, int color);
  List<StringIntTuple> getRecipeTags();
  List<String> getIngredientNames();
  Future<void> addIngredient(String ingredient);
  Future<void> deleteIngredient(String ingredient);
  List<String> getNutritions();
  Future<void> addNutrition(String name);
  Future<void> renameNutrition(String oldName, String newName);
  Future<void> moveNutrition(int oldIndex, int newIndex);
  Future<void> deleteNutrition(String name);
  Future<void> addRecipeToCalendar(DateTime date, String recipeName);
  Future<void> removeRecipeFromCalendar(String recipeName);
  Future<void> removeRecipeFromDateCalendar(DateTime date, String recipeName);
  Future<Map<DateTime, List<String>>> getRecipeCalendar();
  bool wasDeletedBefore(String recipeName);
  DateTime? getDeletionDate(String recipeName);
  Map<String, DateTime> getDeletions();
  Future<void> clearDeletions();
  Future<Map<Recipe, List<CheckableIngredient>>> getShoppingCart();
  Future<void> addMultipleIngredientsToCart(
    String recipeName,
    List<Ingredient> ingredients,
  );
  Future<void> addSingleIngredientToCart(
    String recipeName,
    Ingredient ingredient,
  );
  Future<void> removeAndAddIngredient(String recipeName, Ingredient ingredient);
  Future<void> removeAndAddIngredients(
    String recipeName,
    List<Ingredient> ingredients,
  );
  Future<void> removeIngredientsFromCart(
    String recipeName,
    List<Ingredient> ingredients,
  );
  bool checkForRecipeIngredient(String recipeName, Ingredient ingredient);
  bool checkForRecipeIngredients(
    String recipeName,
    List<Ingredient> ingredients,
  );
  Future<void> checkIngredient(
    String recipeName,
    CheckableIngredient ingredient,
  );
  Future<void> removeRecipeFromCart(String recipeName);
  Future<void> removeIngredientFromCart(
    String recipeName,
    Ingredient ingredient,
  );
}

class MigrationIssueSummary {
  const MigrationIssueSummary(this.legacyKey, this.errorCode);
  final String legacyKey;
  final String errorCode;
}
