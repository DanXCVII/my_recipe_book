import 'dart:async';

import 'package:bloc/bloc.dart';

import './ingredients.dart';
import '../../../hive.dart';
import '../../../models/recipe.dart';

class IngredientsBloc extends Bloc<IngredientsEvent, IngredientsState> {
  @override
  IngredientsState get initialState => ICanSave();

  @override
  Stream<IngredientsState> mapEventToState(
    IngredientsEvent event,
  ) async* {
    if (event is SetCanSave) {
      yield* _mapSetCanSaveToState(event);
    } else if (event is FinishedEditing) {
      yield* _mapFinishedEditingToState(event);
    }
  }

  Stream<IngredientsState> _mapSetCanSaveToState(SetCanSave event) async* {
    yield ICanSave();
  }

  Stream<IngredientsState> _mapFinishedEditingToState(
      FinishedEditing event) async* {
    if (event.goBack) {
      yield IEditingFinishedGoBack();
    } else {
      yield IEditingFinished();
    }

    Recipe newRecipe;
    if (!event.editingRecipe) {
      newRecipe = HiveProvider().getTmpRecipe().copyWith(
            servings: event.servings,
            ingredients: event.ingredients,
            ingredientsGlossary: event.ingredientsGlossary,
            vegetable: event.vegetable,
          );
      await HiveProvider().saveTmpRecipe(newRecipe);
    } else {
      newRecipe = HiveProvider().getTmpEditingRecipe().copyWith(
            servings: event.servings,
            ingredients: event.ingredients,
            ingredientsGlossary: event.ingredientsGlossary,
            vegetable: event.vegetable,
          );
      await HiveProvider().saveTmpEditingRecipe(newRecipe);
    }

    if (event.goBack) {
      yield ISavedGoBack();
    } else {
      yield ISaved(newRecipe);
    }
  }
}
