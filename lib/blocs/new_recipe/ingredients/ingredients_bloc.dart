import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../hive.dart';
import './ingredients.dart';

class IngredientsBloc extends Bloc<IngredientsEvent, IngredientsState> {
  @override
  IngredientsState get initialState => ICanSave();

  @override
  Stream<IngredientsState> mapEventToState(
    IngredientsEvent event,
  ) async* {
    if (event is FinishedEditing) {
      yield* _mapFinishedEditingToState(event);
    }
  }

  Stream<IngredientsState> _mapFinishedEditingToState(
      FinishedEditing event) async* {
    if (event.goBack) {
      yield IEditingFinishedGoBack();
    } else {
      yield IEditingFinished();
    }

    if (!event.editingRecipe) {
      await HiveProvider().saveTmpRecipe(
        HiveProvider().getTmpRecipe().copyWith(
              ingredients: event.ingredients,
              ingredientsGlossary: event.ingredientsGlossary,
              vegetable: event.vegetable,
            ),
      );
    } else {
      await HiveProvider()
          .saveTmpEditingRecipe(HiveProvider().getTmpEditingRecipe().copyWith(
                ingredients: event.ingredients,
                ingredientsGlossary: event.ingredientsGlossary,
                vegetable: event.vegetable,
              ));
    }

    if (event.goBack) {
      yield ISaved();
    } else {
      yield ISavedGoBack();
    }
  }
}
