import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../local_storage/local_repository.dart';
import '../../models/ingredient.dart';
import '../shopping_cart/shopping_cart_bloc.dart';

part 'recipe_screen_ingredients_event.dart';
part 'recipe_screen_ingredients_state.dart';

class RecipeScreenIngredientsBloc
    extends Bloc<RecipeScreenIngredientsEvent, RecipeScreenIngredientsState> {
  final ShoppingCartBloc shoppingCartBloc;
  final LocalRepository repository;
  String? _recipeName;

  RecipeScreenIngredientsBloc({
    required this.shoppingCartBloc,
    required this.repository,
  }) : super(InitialRecipeScreenIngredientsState()) {
    on<InitializeIngredients>((event, emit) async {
      _recipeName = event.recipeName;
      List<List<CheckableIngredient>> checkableIngredients = [[]];

      for (int i = 0; i < event.ingredients.length; i++) {
        if (i != 0) checkableIngredients.add([]);
        for (Ingredient ingred in event.ingredients[i]) {
          checkableIngredients[i].add(
            CheckableIngredient(
              ingred.name,
              ingred.amount,
              ingred.unit,
              repository.checkForRecipeIngredient(event.recipeName, ingred),
            ),
          );
        }
      }

      final List<bool> sectionCheck = checkableIngredients
          .map((list) => _isSectionChecked(list))
          .toList();

      emit(
        LoadedRecipeIngredients(
          checkableIngredients,
          event.servings,
          sectionCheck,
        ),
      );
    });

    on<AddToCart>((event, emit) async {
      if (state is LoadedRecipeIngredients) {
        await repository.addMultipleIngredientsToCart(
          event.recipeName,
          event.ingredients,
          servings: event.servings,
        );

        List<Ingredient> checkedIngredients = event.ingredients;

        final List<List<CheckableIngredient>> ingredients =
            (state as LoadedRecipeIngredients).ingredients
                .map(
                  (list) => list.map((item) {
                    for (Ingredient i in checkedIngredients) {
                      if (i == item.getIngredient()) {
                        return item.copyWith(checked: true);
                      }
                    }
                    return item;
                  }).toList(),
                )
                .toList();

        final List<bool> sectionCheck = ingredients
            .map((list) => _isSectionChecked(list))
            .toList();

        shoppingCartBloc.add(LoadShoppingCart());

        emit(
          LoadedRecipeIngredients(
            ingredients,
            (state as LoadedRecipeIngredients).servings,
            sectionCheck,
          ),
        );
      }
    });

    on<RemoveFromCart>((event, emit) async {
      if (state is LoadedRecipeIngredients) {
        await repository.removeIngredientsFromCart(
          event.recipeName,
          event.ingredients,
        );

        List<Ingredient> checkedIngredients = event.ingredients;

        final List<List<CheckableIngredient>> ingredients =
            (state as LoadedRecipeIngredients).ingredients
                .map(
                  (list) => list.map((item) {
                    for (Ingredient i in checkedIngredients) {
                      if (i == item.getIngredient()) {
                        checkedIngredients.remove(i);
                        return item.copyWith(checked: false);
                      }
                    }
                    return item;
                  }).toList(),
                )
                .toList();

        final List<bool> sectionCheck = ingredients
            .map((list) => _isSectionChecked(list))
            .toList();

        shoppingCartBloc.add(LoadShoppingCart());

        emit(
          LoadedRecipeIngredients(
            ingredients,
            (state as LoadedRecipeIngredients).servings,
            sectionCheck,
          ),
        );
      }
    });

    on<UpdateServings>((event, emit) async {
      if (state is LoadedRecipeIngredients) {
        final loaded = state as LoadedRecipeIngredients;
        final hasCartIngredients = loaded.ingredients
            .expand((section) => section)
            .any((ingredient) => ingredient.checked);
        if (hasCartIngredients && _recipeName != null) {
          try {
            await repository.updateShoppingCartServings(
              _recipeName!,
              event.newServings,
            );
            shoppingCartBloc.add(LoadShoppingCart());
          } on StateError {
            // A stale checked state can outlive a removed cart source. The
            // visible recipe quantities should still remain adjustable.
          }
        }
        final List<List<CheckableIngredient>> ingredients = loaded.ingredients
            .map(
              (list) => list.map((item) {
                if (item.amount != null) {
                  return item.copyWith(
                    amount:
                        (event.newServings / event.oldServings!) * item.amount!,
                  );
                }
                return item;
              }).toList(),
            )
            .toList();

        emit(
          LoadedRecipeIngredients(
            ingredients,
            event.newServings,
            loaded.sectionCheck,
          ),
        );
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
