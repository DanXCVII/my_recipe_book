import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart'
    as RM;

import '../../local_storage/hive.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';

part 'shopping_cart_event.dart';
part 'shopping_cart_state.dart';

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  StreamSubscription subscription;

  ShoppingCartBloc(this.recipeManagerBloc) :super(LoadingShoppingCart()) {
    subscription = recipeManagerBloc.listen((rmState) {
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
  }

  @override
  Stream<ShoppingCartState> mapEventToState(
    ShoppingCartEvent event,
  ) async* {
    if (event is LoadShoppingCart) {
      yield* _mapLoadShoppingCartToState(event);
    } else if (event is CleanAddIngredients) {
      yield* _mapCleanAddIngredientsToState(event);
    } else if (event is CheckIngredients) {
      yield* _mapCheckIngredientsToState(event);
    } else if (event is RemoveIngredients) {
      yield* _mapRemoveIngredientsToState(event);
    }
  }

  Stream<ShoppingCartState> _mapLoadShoppingCartToState(
      ShoppingCartEvent event) async* {
    Map<Recipe, List<CheckableIngredient>> shoppingCart =
        await HiveProvider().getShoppingCart();

    yield LoadedShoppingCart(shoppingCart);
  }

  Stream<ShoppingCartState> _mapCleanAddIngredientsToState(
      CleanAddIngredients event) async* {
    for (Ingredient ingredient in event.ingredients) {
      if (!HiveProvider().getIngredientNames().contains(ingredient.name)) {
        await HiveProvider().addIngredient(ingredient.name);
      }
    }
    await HiveProvider()
        .removeAndAddIngredients(event.recipeName, event.ingredients);

    yield LoadedShoppingCart(await HiveProvider().getShoppingCart());
  }

  Stream<ShoppingCartState> _mapRemoveIngredientsToState(
      RemoveIngredients event) async* {
    if (event.ingredients == null) {
      await HiveProvider().removeRecipeFromCart(event.recipeName.name);
    } else {
      await HiveProvider()
          .removeIngredientsFromCart(event.recipeName.name, event.ingredients);
    }

    yield LoadedShoppingCart(await HiveProvider().getShoppingCart());
  }

  Stream<ShoppingCartState> _mapCheckIngredientsToState(
      CheckIngredients event) async* {
    for (CheckableIngredient i in event.ingredients) {
      await HiveProvider().checkIngredient(
          event.recipeName.name, i.copyWith(checked: !i.checked));
    }

    Map<Recipe, List<CheckableIngredient>> shoppingCart =
        await HiveProvider().getShoppingCart();

    yield LoadedShoppingCart(shoppingCart);
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
