import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';

import '../../local_storage/hive.dart';
import '../../models/ingredient.dart';

part 'recipe_screen_ingredients_event.dart';
part 'recipe_screen_ingredients_state.dart';

class RecipeScreenIngredientsBloc
    extends Bloc<RecipeScreenIngredientsEvent, RecipeScreenIngredientsState> {
  final ShoppingCartBloc shoppingCartBloc;

  RecipeScreenIngredientsBloc({@required this.shoppingCartBloc})
      : super(InitialRecipeScreenIngredientsState()) {
    on<InitializeIngredients>((event, emit) async {
      List<List<CheckableIngredient>> checkableIngredients = [[]];

      for (int i = 0; i < event.ingredients.length; i++) {
        if (i != 0) checkableIngredients.add([]);
        for (Ingredient ingred in event.ingredients[i]) {
          checkableIngredients[i].add(CheckableIngredient(
            ingred.name,
            ingred.amount,
            ingred.unit,
            HiveProvider().checkForRecipeIngredient(event.recipeName, ingred),
          ));
        }
      }

      final List<bool> sectionCheck =
          checkableIngredients.map((list) => _isSectionChecked(list)).toList();

      emit(LoadedRecipeIngredients(
        checkableIngredients,
        event.servings,
        sectionCheck,
      ));
    });

    on<AddToCart>((event, emit) async {
      if (state is LoadedRecipeIngredients) {
        await HiveProvider()
            .addMultipleIngredientsToCart(event.recipeName, event.ingredients);

        List<Ingredient> checkedIngredients = event.ingredients;

        final List<List<CheckableIngredient>> ingredients =
            (state as LoadedRecipeIngredients)
                .ingredients
                .map((list) => list.map((item) {
                      for (Ingredient i in checkedIngredients) {
                        if (i == item.getIngredient()) {
                          return item.copyWith(checked: true);
                        }
                      }
                      return item;
                    }).toList())
                .toList();

        final List<bool> sectionCheck =
            ingredients.map((list) => _isSectionChecked(list)).toList();

        shoppingCartBloc.add(LoadShoppingCart());

        emit(LoadedRecipeIngredients(
          ingredients,
          (state as LoadedRecipeIngredients).servings,
          sectionCheck,
        ));
      }
    });

    on<RemoveFromCart>((event, emit) async {
      if (state is LoadedRecipeIngredients) {
        await HiveProvider()
            .removeIngredientsFromCart(event.recipeName, event.ingredients);

        List<Ingredient> checkedIngredients = event.ingredients;

        final List<List<CheckableIngredient>> ingredients =
            (state as LoadedRecipeIngredients)
                .ingredients
                .map((list) => list.map((item) {
                      for (Ingredient i in checkedIngredients) {
                        if (i == item.getIngredient()) {
                          checkedIngredients.remove(i);
                          return item.copyWith(checked: false);
                        }
                      }
                      return item;
                    }).toList())
                .toList();

        final List<bool> sectionCheck =
            ingredients.map((list) => _isSectionChecked(list)).toList();

        shoppingCartBloc.add(LoadShoppingCart());

        emit(LoadedRecipeIngredients(
          ingredients,
          (state as LoadedRecipeIngredients).servings,
          sectionCheck,
        ));
      }
    });

    on<UpdateServings>((event, emit) async {
      if (state is LoadedRecipeIngredients) {
        final List<List<CheckableIngredient>> ingredients =
            (state as LoadedRecipeIngredients)
                .ingredients
                .map((list) => list.map((item) {
                      if (item.amount != null) {
                        return item.copyWith(
                            amount: (event.newServings / (event.oldServings)) *
                                item.amount);
                      }
                      return item;
                    }).toList())
                .toList();

        emit(LoadedRecipeIngredients(
          ingredients,
          event.newServings,
          (state as LoadedRecipeIngredients).sectionCheck,
        ));
      }
    });
  }

  bool _isSectionChecked(List<CheckableIngredient> ingredients) {
    for (CheckableIngredient i in ingredients) {
      if (i.checked == false) return false;
    }

    return true;
  }
}
