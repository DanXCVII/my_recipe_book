import 'dart:math';

import 'package:bloc/bloc.dart';

import '../../../models/ingredient.dart';

part 'ingredients_section_event.dart';
part 'ingredients_section_state.dart';

class IngredientsSectionBloc
    extends Bloc<IngredientsSectionEvent, IngredientsSectionState> {
  List<String> sectionTitles = [];
  List<List<Ingredient>> ingredients = [[]];

  IngredientsSectionBloc() : super(LoadedIngredientsSection([], [[]])) {
    on<InitializeIngredientsSection>((event, emit) async {
      sectionTitles = List<String>.from(event.sectionTitles);
      ingredients = [];
      int iterations;

      if (event.ingredients.length == 1) {
        iterations = 1;
      } else {
        iterations = min(event.ingredients.length, event.sectionTitles.length);
      }

      for (int i = 0; i < iterations; i++) {
        ingredients.add([]);
        for (Ingredient ingred in event.ingredients[i]) {
          ingredients[i].add(ingred);
        }
      }

      emit(LoadedIngredientsSection(sectionTitles, ingredients));
    });

    on<AddIngredient>((event, emit) async {
      List<List<Ingredient>> stateIngredients = [];
      ingredients[event.index]..add(event.ingredient);

      for (int i = 0; i < ingredients.length; i++) {
        stateIngredients.add([]);
        for (Ingredient ingred in ingredients[i]) {
          stateIngredients[i].add(ingred);
        }
      }

      emit(LoadedIngredientsSection(sectionTitles, stateIngredients));
    });

    on<RemoveIngredient>((event, emit) async {
      ingredients[event.sectionIndex]..removeAt(event.index);

      List<List<Ingredient>> stateIngredients = [];

      for (int i = 0; i < ingredients.length; i++) {
        stateIngredients.add([]);
        for (Ingredient ingred in ingredients[i]) {
          stateIngredients[i].add(ingred);
        }
      }

      emit(LoadedIngredientsSection(sectionTitles, stateIngredients));
    });

    on<MoveIngredient>((event, emit) async {
      Ingredient moveIngred =
          ingredients[event.sectionIndex].removeAt(event.oldIndex);
      ingredients[event.sectionIndex].insert(event.newIndex, moveIngred);

      emit(LoadedIngredientsSection(
        sectionTitles,
        List<List<Ingredient>>.from(ingredients),
      ));
    });

    on<EditIngredient>((event, emit) async {
      if (event.sectionIndex != event.newSectionIndex) {
        ingredients[event.sectionIndex].removeAt(event.index);
        ingredients[event.newSectionIndex].add(event.newIngredient);
      } else {
        ingredients[event.sectionIndex][event.index] = event.newIngredient;
      }

      emit(LoadedIngredientsSection(
        sectionTitles,
        List<List<Ingredient>>.from(ingredients),
      ));
    });

    on<AddSectionTitle>((event, emit) async {
      if (sectionTitles.isNotEmpty) {
        ingredients.add([]);
      }

      emit(LoadedIngredientsSection(
          List<String>.from(sectionTitles..add(event.title)), ingredients));
    });

    on<EditSectionTitle>((event, emit) async {
      sectionTitles[event.sectionIndex] = event.newTitle;

      emit(LoadedIngredientsSection(
          List<String>.from(sectionTitles), ingredients));
    });

    on<RemoveSection>((event, emit) async {
      List<List<Ingredient>> stateIngredients = [];

      if (ingredients.length > 1) {
        ingredients.removeAt(event.index);
      }

      if (sectionTitles.length > 1) {
        for (int i = 0; i < ingredients.length; i++) {
          stateIngredients.add([]);
          for (Ingredient ingred in ingredients[i]) {
            stateIngredients[i].add(ingred);
          }
        }
      } else {
        stateIngredients = ingredients;
      }

      emit(LoadedIngredientsSection(
        List<String>.from(sectionTitles..removeAt(event.index)),
        stateIngredients,
      ));
    });
  }
}
