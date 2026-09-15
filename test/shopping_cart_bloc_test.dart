import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_screen_ingredients/recipe_screen_ingredients_bloc.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/local_storage/database.dart';
import 'package:my_recipe_book/local_storage/local_repository.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/models/recipe.dart';
import 'package:my_recipe_book/models/shopping_cart_recipe_addition.dart';

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

  test(
    'batch merge preserves sources and combines servings atomically',
    () async {
      await repository.saveRecipe(Recipe(name: 'Soup', servings: 4));
      await repository.saveRecipe(Recipe(name: 'Tea', servings: 1));
      await repository.addMultipleIngredientsToCart('Soup', const [
        Ingredient(name: 'Carrot', amount: 2, unit: 'pc'),
      ], servings: 4);
      await repository.addMultipleIngredientsToCart('Tea', const [
        Ingredient(name: 'Tea bag', amount: 1, unit: 'pc'),
      ], servings: 1);
      await repository.checkIngredient(
        'Soup',
        const CheckableIngredient('Carrot', 2, 'pc', true),
      );
      await _load(cart);

      final merged = cart.stream
          .where((state) => state is LoadedShoppingCart)
          .cast<LoadedShoppingCart>()
          .firstWhere((state) => state.data.recipeSources.length == 2);
      cart.add(
        const MergeShoppingCartRecipes([
          ShoppingCartRecipeAddition(
            recipeName: 'Soup',
            servings: 2,
            ingredients: [
              Ingredient(name: 'Carrot', amount: 1, unit: 'pc'),
              Ingredient(name: 'Onion', amount: 1, unit: 'pc'),
            ],
          ),
        ]),
      );
      final data = (await merged).data;
      final soup = data.recipeSources.singleWhere(
        (source) => source.displayName == 'Soup',
      );

      expect(soup.currentServings, 6);
      expect(soup.items.singleWhere((item) => item.name == 'Carrot').amount, 3);
      expect(
        soup.items.singleWhere((item) => item.name == 'Carrot').checked,
        isFalse,
      );
      expect(
        data.recipeSources.any((source) => source.displayName == 'Tea'),
        isTrue,
      );
      expect(
        data.consolidatedItems
            .singleWhere((item) => item.name == 'Carrot')
            .amount,
        3,
      );
    },
  );

  test('repeat batch exports consolidate amounts and servings', () async {
    await repository.saveRecipe(Recipe(name: 'Soup', servings: 4));
    const addition = ShoppingCartRecipeAddition(
      recipeName: 'Soup',
      servings: 2,
      ingredients: [Ingredient(name: 'Carrot', amount: 1, unit: 'pc')],
    );

    await repository.mergeRecipeIngredientsToCart(const [addition]);
    await repository.mergeRecipeIngredientsToCart(const [addition]);
    final data = await repository.getShoppingCartData();
    final source = data.recipeSources.single;

    expect(source.currentServings, 4);
    expect(source.items.single.amount, 2);
    expect(source.items.single.checked, isFalse);
    expect(data.consolidatedItems.single.amount, 2);
  });

  test('failed batch persistence restores the in-memory cart', () async {
    await repository.addMultipleIngredientsToCart(shoppingSummaryName, const [
      Ingredient(name: 'Carrot', amount: 2, unit: 'pc'),
    ]);
    final initial = await _load(cart);
    await database.close();
    databaseClosed = true;

    final failed = cart.stream
        .where((state) => state is LoadedShoppingCart)
        .cast<LoadedShoppingCart>()
        .firstWhere(
          (state) => state.actionError == ShoppingCartActionError.add,
        );
    cart.add(
      const MergeShoppingCartRecipes([
        ShoppingCartRecipeAddition(
          recipeName: 'Soup',
          servings: 2,
          ingredients: [
            Ingredient(name: 'Carrot', amount: 1, unit: 'pc'),
            Ingredient(name: 'Onion', amount: 1, unit: 'pc'),
          ],
        ),
      ]),
    );
    final failedState = await failed;

    expect(failedState.data, initial.data);
    expect(await repository.getShoppingCartData(), initial.data);
  });
}

Future<LoadedShoppingCart> _load(ShoppingCartBloc bloc) {
  final loaded = bloc.stream
      .where((state) => state is LoadedShoppingCart)
      .cast<LoadedShoppingCart>()
      .first;
  bloc.add(LoadShoppingCart());
  return loaded;
}
