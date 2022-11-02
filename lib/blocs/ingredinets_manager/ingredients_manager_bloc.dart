import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../local_storage/hive.dart';

part 'ingredients_manager_event.dart';
part 'ingredients_manager_state.dart';

class IngredientsManagerBloc
    extends Bloc<IngredientsManagerEvent, IngredientsManagerState> {
  IngredientsManagerBloc() : super(IngredientsManagerInitial()) {
    on<LoadIngredientsManager>((event, emit) async {
      final List<String > ingredients = HiveProvider()
          .getIngredientNames()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

      emit(LoadedIngredientsManager(ingredients));
    });

    on<AddIngredient>((event, emit) async {
      if (state is LoadedIngredientsManager) {
        await HiveProvider().addIngredient(event.ingredient);

        List<String> ingredients =
            List<String>.from((state as LoadedIngredientsManager).ingredients)
              ..add(event.ingredient)
              ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

        emit(LoadedIngredientsManager(ingredients));
      }
    });

    on<DeleteIngredient>((event, emit) async {
      if (state is LoadedIngredientsManager) {
        await HiveProvider().deleteIngredient(event.ingredient);
        final List<String> ingredients =
            List<String>.from((state as LoadedIngredientsManager).ingredients)
              ..remove(event.ingredient);

        emit(LoadedIngredientsManager(ingredients));
      }
    });

    on<UpdateIngredient>((event, emit) async {
      if (state is LoadedIngredientsManager) {
        await HiveProvider().deleteIngredient(event.oldIngredient);
        await HiveProvider().addIngredient(event.updatedIngredient);
        final List<String /*!*/ > ingredients =
            (state as LoadedIngredientsManager).ingredients
              ..remove(event.oldIngredient)
              ..add(event.updatedIngredient)
              ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

        emit(LoadedIngredientsManager(ingredients));
      }
    });
  }
}
