import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_screen_ingredients/recipe_screen_ingredients_bloc.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';

void main() {
  late AppDatabase database;
  late DriftRepository repository;
  late RecipeManagerBloc manager;
  late ShoppingCartBloc cart;
  late bool databaseClosed;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    databaseClosed = false;
    repository = DriftRepository(database: database);
    await repository.initialize();
    manager = RecipeManagerBloc(repository);
    cart = ShoppingCartBloc(manager, repository);
  });

  tearDown(() async {
    await cart.close();
    await manager.close();
    if (!databaseClosed) await database.close();
  });

  test('recipe ingredient additions retain the active serving count', () async {
    await repository.saveRecipe(Recipe(name: 'Soup', servings: 4));
    final ingredients = RecipeScreenIngredientsBloc(
      shoppingCartBloc: cart,
      repository: repository,
    );
    addTearDown(ingredients.close);

    final initialized = ingredients.stream
        .where((state) => state is LoadedRecipeIngredients)
        .cast<LoadedRecipeIngredients>()
        .first;
    ingredients.add(
      const InitializeIngredients('Soup', 4, [
        [Ingredient(name: 'Carrot', amount: 2, unit: 'pc')],
      ]),
    );
    await initialized;

    final scaled = ingredients.stream
        .where((state) => state is LoadedRecipeIngredients)
        .cast<LoadedRecipeIngredients>()
        .firstWhere((state) => state.servings == 6);
    ingredients.add(const UpdateServings(4, 6));
    final active = await scaled;
    final added = ingredients.stream
        .where((state) => state is LoadedRecipeIngredients)
        .cast<LoadedRecipeIngredients>()
        .firstWhere((state) => state.ingredients.first.first.checked);
    ingredients.add(
      AddToCart('Soup', [
        active.ingredients.first.first.getIngredient(),
      ], servings: active.servings),
    );
    await added;

    final source =
        (await repository.getShoppingCartData()).recipeSources.single;
    expect(source.currentServings, 6);
    expect(source.items.single.amount, 3);
  });

  test('remove checked emits an undo snapshot and restores it', () async {
    await repository.addMultipleIngredientsToCart('Soup', const [
      Ingredient(name: 'Carrot', amount: 2, unit: 'pc'),
    ]);
    await repository.checkIngredient(
      shoppingSummaryName,
      const CheckableIngredient('Carrot', 2, 'pc', true),
    );
    final initial = await _load(cart);

    final removed = cart.stream
        .where((state) => state is LoadedShoppingCart)
        .cast<LoadedShoppingCart>()
        .firstWhere((state) => state.undoSnapshot != null);
    cart.add(RemoveCheckedIngredients());
    final removedState = await removed;
    expect(removedState.data.consolidatedItems, isEmpty);
    expect(removedState.undoSnapshot, initial.data);

    final restored = cart.stream
        .where((state) => state is LoadedShoppingCart)
        .cast<LoadedShoppingCart>()
        .firstWhere(
          (state) =>
              state.undoSnapshot == null &&
              state.data.consolidatedItems.isNotEmpty,
        );
    cart.add(RestoreShoppingCart(removedState.undoSnapshot!));
    expect((await restored).data, initial.data);
  });

  test(
    'action failure preserves loaded data with a recoverable error',
    () async {
      await repository.saveRecipe(Recipe(name: 'Soup', servings: 4));
      await repository.addMultipleIngredientsToCart('Soup', const [
        Ingredient(name: 'Carrot', amount: 2, unit: 'pc'),
      ], servings: 2);
      final initial = await _load(cart);
      await database.close();
      databaseClosed = true;

      final failed = cart.stream
          .where((state) => state is LoadedShoppingCart)
          .cast<LoadedShoppingCart>()
          .firstWhere((state) => state.actionError != null);
      cart.add(const UpdateShoppingCartServings('Soup', 3));
      final failedState = await failed;

      expect(failedState.data, initial.data);
      expect(failedState.actionError, ShoppingCartActionError.servings);
    },
  );
}

Future<LoadedShoppingCart> _load(ShoppingCartBloc bloc) {
  final loaded = bloc.stream
      .where((state) => state is LoadedShoppingCart)
      .cast<LoadedShoppingCart>()
      .first;
  bloc.add(LoadShoppingCart());
  return loaded;
}
