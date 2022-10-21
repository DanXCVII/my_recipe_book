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
  IngredientsBloc() : super(ICanSave()) {
    on<SetCanSave>((event, emit) async {
      emit(ICanSave());
    });

    on<FinishedEditing>((event, emit) async {
      if (event.goBack) {
        emit(IEditingFinishedGoBack());
      } else {
        emit(IEditingFinished());
      }

      List<String> recipeIngredientSections = [];
      List<List<Ingredient>> recipeIngredients = [[]];

      if (event.ingredients.isNotEmpty && event.ingredients.first.isNotEmpty) {
        recipeIngredientSections = event.ingredientsGlossary;
        recipeIngredients = event.ingredients;
      }

      Recipe newRecipe;
      if (!event.editingRecipe) {
        newRecipe = HiveProvider().getTmpRecipe().copyWith(
              servings: event.servings,
              servingName: event.servingName,
              ingredients: recipeIngredients,
              ingredientsGlossary: recipeIngredientSections,
              vegetable: event.vegetable,
            );
        await HiveProvider().saveTmpRecipe(newRecipe);
      } else {
        newRecipe = HiveProvider().getTmpEditingRecipe().copyWith(
              servings: event.servings,
              servingName: event.servingName,
              ingredients: recipeIngredients,
              ingredientsGlossary: recipeIngredientSections,
              vegetable: event.vegetable,
            );
        await HiveProvider().saveTmpEditingRecipe(newRecipe);
      }

      if (event.goBack) {
        emit(ISavedGoBack());
      } else {
        emit(ISaved(newRecipe));
      }
    });
  }
}
