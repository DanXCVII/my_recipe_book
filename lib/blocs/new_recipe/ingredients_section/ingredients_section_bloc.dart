import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:my_recipe_book/models/ingredient.dart';

part 'ingredients_section_event.dart';
part 'ingredients_section_state.dart';

class IngredientsSectionBloc
    extends Bloc<IngredientsSectionEvent, IngredientsSectionState> {
  List<String> sectionTitles = [];
  List<List<Ingredient>> ingredients = [[]];

  IngredientsSectionBloc() : super(LoadedIngredientsSection([], [[]]));

  @override
  Stream<IngredientsSectionState> mapEventToState(
    IngredientsSectionEvent event,
  ) async* {
    if (event is InitializeIngredientsSection) {
      yield* _mapInitializeIngredientsSection(event);
    } else if (event is AddIngredient) {
      yield* _mapAddIngredientToState(event);
    } else if (event is RemoveIngredient) {
      yield* _mapRemoveIngredientToState(event);
    } else if (event is MoveIngredient) {
      yield* _mapMoveIngredientToState(event);
    } else if (event is EditIngredient) {
      yield* _mapEditIngredientToState(event);
    } else if (event is AddSectionTitle) {
      yield* _mapAddSectionTitleToState(event);
    } else if (event is EditSectionTitle) {
      yield* _mapEditSectionTitleToState(event);
    } else if (event is RemoveSection) {
      yield* _mapRemoveSectionToState(event);
    }
  }

  Stream<IngredientsSectionState> _mapInitializeIngredientsSection(
      InitializeIngredientsSection event) async* {
    sectionTitles = List<String>.from(event.sectionTitles);
    ingredients = [];

    for (int i = 0; i < event.ingredients.length; i++) {
      ingredients.add([]);
      for (Ingredient ingred in event.ingredients[i]) {
        ingredients[i].add(ingred);
      }
    }

    yield LoadedIngredientsSection(sectionTitles, ingredients);
  }

  Stream<IngredientsSectionState> _mapAddIngredientToState(
      AddIngredient event) async* {
    List<List<Ingredient>> stateIngredients = [];
    ingredients[event.index]..add(event.ingredient);

    for (int i = 0; i < ingredients.length; i++) {
      stateIngredients.add([]);
      for (Ingredient ingred in ingredients[i]) {
        stateIngredients[i].add(ingred);
      }
    }

    yield LoadedIngredientsSection(sectionTitles, stateIngredients);
  }

  Stream<IngredientsSectionState> _mapRemoveIngredientToState(
      RemoveIngredient event) async* {
    ingredients[event.sectionIndex]..removeAt(event.index);

    List<List<Ingredient>> stateIngredients = [];

    for (int i = 0; i < ingredients.length; i++) {
      stateIngredients.add([]);
      for (Ingredient ingred in ingredients[i]) {
        stateIngredients[i].add(ingred);
      }
    }

    yield LoadedIngredientsSection(sectionTitles, stateIngredients);
  }

  Stream<IngredientsSectionState> _mapMoveIngredientToState(
      MoveIngredient event) async* {
    Ingredient moveIngred =
        ingredients[event.sectionIndex].removeAt(event.oldIndex);
    ingredients[event.sectionIndex].insert(event.newIndex, moveIngred);

    yield LoadedIngredientsSection(
      sectionTitles,
      List<List<Ingredient>>.from(ingredients),
    );
  }

  Stream<IngredientsSectionState> _mapEditIngredientToState(
      EditIngredient event) async* {
    ingredients[event.sectionIndex][event.index] = event.newIngredient;

    yield LoadedIngredientsSection(
      sectionTitles,
      List<List<Ingredient>>.from(ingredients),
    );
  }

  Stream<IngredientsSectionState> _mapAddSectionTitleToState(
      AddSectionTitle event) async* {
    if (sectionTitles.isNotEmpty) {
      ingredients.add([]);
    }

    yield LoadedIngredientsSection(
        List<String>.from(sectionTitles..add(event.title)), ingredients);
  }

  Stream<IngredientsSectionState> _mapEditSectionTitleToState(
      EditSectionTitle event) async* {
    sectionTitles[event.sectionIndex] = event.newTitle;

    yield LoadedIngredientsSection(
        List<String>.from(sectionTitles), ingredients);
  }

  Stream<IngredientsSectionState> _mapRemoveSectionToState(
      RemoveSection event) async* {
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

    yield LoadedIngredientsSection(
      List<String>.from(sectionTitles..removeAt(event.index)),
      stateIngredients,
    );
  }
}
