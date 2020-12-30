import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../local_storage/hive.dart';

part 'ingredients_manager_event.dart';
part 'ingredients_manager_state.dart';

class IngredientsManagerBloc
    extends Bloc<IngredientsManagerEvent, IngredientsManagerState> {
  IngredientsManagerBloc():super(IngredientsManagerInitial());

  @override
  Stream<IngredientsManagerState> mapEventToState(
    IngredientsManagerEvent event,
  ) async* {
    if (event is LoadIngredientsManager) {
      yield* _mapLoadingIngredientsManagerToState();
    } else if (event is AddIngredient) {
      yield* _mapAddIngredientToState(event);
    } else if (event is DeleteIngredient) {
      yield* _mapDeleteIngredientToState(event);
    } else if (event is UpdateIngredient) {
      yield* _mapUpdateIngredientToState(event);
    }
  }

  Stream<IngredientsManagerState>
      _mapLoadingIngredientsManagerToState() async* {
    final List<String> ingredients = HiveProvider().getIngredientNames()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    yield LoadedIngredientsManager(ingredients);
  }

  Stream<IngredientsManagerState> _mapAddIngredientToState(
      AddIngredient event) async* {
    if (state is LoadedIngredientsManager) {
      await HiveProvider().addIngredient(event.ingredient);

      List<String> ingredients =
          List<String>.from((state as LoadedIngredientsManager).ingredients)
            ..add(event.ingredient)
            ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

      yield LoadedIngredientsManager(ingredients);
    }
  }

  Stream<IngredientsManagerState> _mapDeleteIngredientToState(
      DeleteIngredient event) async* {
    if (state is LoadedIngredientsManager) {
      await HiveProvider().deleteIngredient(event.ingredient);
      final List<String> ingredients =
          List<String>.from((state as LoadedIngredientsManager).ingredients)
            ..remove(event.ingredient);

      yield LoadedIngredientsManager(ingredients);
    }
  }

  Stream<IngredientsManagerState> _mapUpdateIngredientToState(
      UpdateIngredient event) async* {
    if (state is LoadedIngredientsManager) {
      await HiveProvider().deleteIngredient(event.oldIngredient);
      await HiveProvider().addIngredient(event.updatedIngredient);
      final List<String> ingredients =
          (state as LoadedIngredientsManager).ingredients
            ..remove(event.oldIngredient)
            ..add(event.updatedIngredient)
            ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

      yield LoadedIngredientsManager(ingredients);
    }
  }
}
