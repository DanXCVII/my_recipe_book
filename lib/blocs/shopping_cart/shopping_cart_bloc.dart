import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart'
    as RM;
import 'package:shared_preferences/shared_preferences.dart';

import '../../local_storage/hive.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';

part 'shopping_cart_event.dart';
part 'shopping_cart_state.dart';

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  late SharedPreferences prefs;
  late StreamSubscription subscription;

  ShoppingCartBloc(this.recipeManagerBloc) : super(LoadingShoppingCart()) {
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
      emit(LoadedShoppingCart(await HiveProvider().getShoppingCart()));
    });

    on<CleanAddIngredients>((event, emit) async {
      for (Ingredient ingredient in event.ingredients) {
        if (!HiveProvider().getIngredientNames().contains(ingredient.name)) {
          await HiveProvider().addIngredient(ingredient.name);
        }
      }
      await HiveProvider()
          .removeAndAddIngredients(event.recipeName, event.ingredients);

      emit(LoadedShoppingCart(await HiveProvider().getShoppingCart()));
    });

    on<CheckIngredients>((event, emit) async {
      for (CheckableIngredient i in event.ingredients) {
        await HiveProvider().checkIngredient(
            event.recipeName.name, i.copyWith(checked: !i.checked));
      }

      Map<Recipe, List<CheckableIngredient>> shoppingList =
          await HiveProvider().getShoppingCart();

      emit(LoadedShoppingCart(shoppingList));
    });

    on<RemoveIngredients>((event, emit) async {
      if (event.ingredients == null) {
        await HiveProvider().removeRecipeFromCart(event.recipeName.name);
      } else {
        await HiveProvider().removeIngredientsFromCart(
            event.recipeName.name, event.ingredients!);
      }

      emit(LoadedShoppingCart(await HiveProvider().getShoppingCart()));
    });
  }

  Future<Map<Recipe, List<CheckableIngredient>>> getSortedShoppingList() async {
    Map<Recipe, List<CheckableIngredient>> shoppingCart =
        await HiveProvider().getShoppingCart();

    return shoppingCart.map((key, ingredientList) {
      List<CheckableIngredient> copyList =
          ingredientList.map((e) => e).toList();
      copyList.sort((iOne, iTwo) {
        if (iOne.checked == iTwo.checked) {
          return 0;
        } else if (iOne.checked && !iTwo.checked) {
          return 1;
        } else {
          return -1;
        }
      });
      return MapEntry(
        key,
        copyList,
      );
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
