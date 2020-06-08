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

  RecipeScreenIngredientsBloc({@required this.shoppingCartBloc});

  @override
  RecipeScreenIngredientsState get initialState =>
      InitialRecipeScreenIngredientsState();

  @override
  Stream<RecipeScreenIngredientsState> mapEventToState(
    RecipeScreenIngredientsEvent event,
  ) async* {
    if (event is InitializeIngredients) {
      yield* _mapInitializeIngredientsToState(event);
    } else if (event is AddToCart) {
      yield* _mapAddToCartToState(event);
    } else if (event is RemoveFromCart) {
      yield* _mapRemoveFromCartToState(event);
    } else if (event is DecreaseServings) {
      yield* _mapDecreaseServingsToState(event);
    } else if (event is IncreaseServings) {
      yield* _mapIncreaseServingsToState(event);
    }
  }

  Stream<RecipeScreenIngredientsState> _mapInitializeIngredientsToState(
      InitializeIngredients event) async* {
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

    yield LoadedRecipeIngredients(
      checkableIngredients,
      event.servings,
      sectionCheck,
    );
  }

  Stream<RecipeScreenIngredientsState> _mapRemoveFromCartToState(
      RemoveFromCart event) async* {
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

      yield LoadedRecipeIngredients(
        ingredients,
        (state as LoadedRecipeIngredients).servings,
        sectionCheck,
      );
    }
  }

  Stream<RecipeScreenIngredientsState> _mapAddToCartToState(
      AddToCart event) async* {
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

      yield LoadedRecipeIngredients(
        ingredients,
        (state as LoadedRecipeIngredients).servings,
        sectionCheck,
      );
    }
  }

  Stream<RecipeScreenIngredientsState> _mapDecreaseServingsToState(
      DecreaseServings event) async* {
    if (state is LoadedRecipeIngredients) {
      if (event.newServings == 0) return;
      final List<List<CheckableIngredient>> ingredients =
          (state as LoadedRecipeIngredients)
              .ingredients
              .map((list) => list.map((item) {
                    if (item.amount != null) {
                      return item.copyWith(
                          amount:
                              (event.newServings / (event.newServings + 1)) *
                                  item.amount);
                    }
                    return item;
                  }).toList())
              .toList();

      yield LoadedRecipeIngredients(
        ingredients,
        event.newServings,
        (state as LoadedRecipeIngredients).sectionCheck,
      );
    }
  }

  Stream<RecipeScreenIngredientsState> _mapIncreaseServingsToState(
      IncreaseServings event) async* {
    if (state is LoadedRecipeIngredients) {
      final List<List<CheckableIngredient>> ingredients =
          (state as LoadedRecipeIngredients)
              .ingredients
              .map((list) => list.map((item) {
                    if (item.amount != null) {
                      return item.copyWith(
                          amount:
                              (event.newServings / (event.newServings - 1)) *
                                  item.amount);
                    }
                    return item;
                  }).toList())
              .toList();

      yield LoadedRecipeIngredients(
        ingredients,
        event.newServings,
        (state as LoadedRecipeIngredients).sectionCheck,
      );
    }
  }

  bool _isSectionChecked(List<CheckableIngredient> ingredients) {
    for (CheckableIngredient i in ingredients) {
      if (i.checked == false) return false;
    }

    return true;
  }
}
