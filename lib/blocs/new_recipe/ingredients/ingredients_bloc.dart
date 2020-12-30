import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_recipe_book/models/enums.dart';
import 'package:my_recipe_book/models/ingredient.dart';

import '../../../local_storage/hive.dart';
import '../../../models/recipe.dart';

part 'ingredients_event.dart';
part 'ingredients_state.dart';

class IngredientsBloc extends Bloc<IngredientsEvent, IngredientsState> {
  IngredientsBloc() : super(ICanSave());

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
            servingName: event.servingName,
            ingredients: event.ingredients,
            ingredientsGlossary: event.ingredientsGlossary,
            vegetable: event.vegetable,
          );
      await HiveProvider().saveTmpRecipe(newRecipe);
    } else {
      newRecipe = HiveProvider().getTmpEditingRecipe().copyWith(
            servings: event.servings,
            servingName: event.servingName,
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
