import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart'
    as RM;
import 'package:shared_preferences/shared_preferences.dart';

import '../../local_storage/local_repository.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../models/shopping_cart_data.dart';
import '../../models/shopping_cart_recipe_addition.dart';

part 'shopping_cart_event.dart';
part 'shopping_cart_state.dart';

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  final LocalRepository repository;
  late SharedPreferences prefs;
  late StreamSubscription subscription;

  ShoppingCartBloc(this.recipeManagerBloc, this.repository)
    : super(LoadingShoppingCart()) {
    subscription = recipeManagerBloc.stream.listen((rmState) {
      if (state is LoadedShoppingCart) {
        if (rmState is RM.DeleteRecipeState) {
          add(RemoveIngredients(null, rmState.recipe));
        } else if (rmState is RM.UpdateCategoryState ||
            rmState is RM.DeleteCategoryState ||
            rmState is RM.UpdateRecipeTagState ||
            rmState is RM.DeleteRecipeTagState) {
          add(LoadShoppingCart());
        }
      }
    });

    on<LoadShoppingCart>((event, emit) async {
      try {
        emit(LoadedShoppingCart(await repository.getShoppingCartData()));
      } catch (error) {
        emit(FailedShoppingCart(error));
      }
    });

    on<CleanAddIngredients>((event, emit) async {
      try {
        for (Ingredient ingredient in event.ingredients) {
          if (!repository.getIngredientNames().contains(ingredient.name)) {
            await repository.addIngredient(ingredient.name);
          }
        }
        await repository.removeAndAddIngredients(
          event.recipeName,
          event.ingredients,
        );

        emit(LoadedShoppingCart(await repository.getShoppingCartData()));
      } catch (_) {
        emit(await _actionFailure(ShoppingCartActionError.add));
      }
    });

    on<MergeShoppingCartRecipes>((event, emit) async {
      try {
        await repository.mergeRecipeIngredientsToCart(event.additions);
        emit(LoadedShoppingCart(await repository.getShoppingCartData()));
      } catch (_) {
        emit(await _actionFailure(ShoppingCartActionError.add));
      }
    });

    on<AddShoppingCartIngredient>((event, emit) async {
      try {
        if (!repository.getIngredientNames().contains(event.ingredient.name)) {
          await repository.addIngredient(event.ingredient.name);
        }
        await repository.addSingleIngredientToCart(
          shoppingSummaryName,
          event.ingredient,
        );
        emit(LoadedShoppingCart(await repository.getShoppingCartData()));
      } catch (_) {
        emit(await _actionFailure(ShoppingCartActionError.add));
      }
    });

    on<CheckIngredients>((event, emit) async {
      try {
        for (CheckableIngredient i in event.ingredients) {
          await repository.checkIngredient(
            event.recipeName.name,
            i.copyWith(checked: !i.checked),
          );
        }

        emit(LoadedShoppingCart(await repository.getShoppingCartData()));
      } catch (_) {
        emit(await _actionFailure(ShoppingCartActionError.check));
      }
    });

    on<RemoveIngredients>((event, emit) async {
      try {
        if (event.ingredients == null) {
          await repository.removeRecipeFromCart(event.recipeName.name);
        } else {
          await repository.removeIngredientsFromCart(
            event.recipeName.name,
            event.ingredients!,
          );
        }

        emit(LoadedShoppingCart(await repository.getShoppingCartData()));
      } catch (_) {
        emit(await _actionFailure(ShoppingCartActionError.remove));
      }
    });

    on<UpdateShoppingCartServings>((event, emit) async {
      try {
        await repository.updateShoppingCartServings(
          event.recipeName,
          event.servings,
        );
        emit(LoadedShoppingCart(await repository.getShoppingCartData()));
      } catch (_) {
        emit(await _actionFailure(ShoppingCartActionError.servings));
      }
    });

    on<RemoveCheckedIngredients>((event, emit) async {
      try {
        final snapshot = await repository.removeCheckedShoppingCartItems();
        emit(
          LoadedShoppingCart(
            await repository.getShoppingCartData(),
            undoSnapshot: snapshot,
          ),
        );
      } catch (_) {
        emit(await _actionFailure(ShoppingCartActionError.remove));
      }
    });

    on<RestoreShoppingCart>((event, emit) async {
      final current = state;
      if (current is! LoadedShoppingCart ||
          current.undoSnapshot != event.snapshot) {
        return;
      }
      try {
        await repository.restoreShoppingCart(event.snapshot);
        emit(LoadedShoppingCart(await repository.getShoppingCartData()));
      } catch (_) {
        emit(await _actionFailure(ShoppingCartActionError.restore));
      }
    });
  }

  Future<LoadedShoppingCart> _actionFailure(
    ShoppingCartActionError error,
  ) async {
    try {
      return LoadedShoppingCart(
        await repository.getShoppingCartData(),
        actionError: error,
      );
    } catch (_) {
      final current = state;
      if (current is LoadedShoppingCart) {
        return LoadedShoppingCart(current.data, actionError: error);
      }
      rethrow;
    }
  }

  Future<Map<Recipe, List<CheckableIngredient>>> getSortedShoppingList() async {
    Map<Recipe, List<CheckableIngredient>> shoppingCart =
        (await repository.getShoppingCartData()).toLegacyMap();

    return shoppingCart.map((key, ingredientList) {
      List<CheckableIngredient> copyList = ingredientList
          .map((e) => e)
          .toList();
      copyList.sort((iOne, iTwo) {
        if (iOne.checked == iTwo.checked) {
          return 0;
        } else if (iOne.checked && !iTwo.checked) {
          return 1;
        } else {
          return -1;
        }
      });
      return MapEntry(key, copyList);
    });
  }

  bool showSummary() {
    bool showSummary = false;
    if (prefs.containsKey("shoppingCartSummary")) {
      showSummary = prefs.getBool("shoppingCartSummary")!;
    }

    return showSummary;
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
