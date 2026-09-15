import 'package:bloc/bloc.dart';

import '../../../models/ingredient.dart';

part 'ingredients_section_event.dart';
part 'ingredients_section_state.dart';

class IngredientsSectionBloc
    extends Bloc<IngredientsSectionEvent, IngredientsSectionState> {
  List<String> sectionTitles = [];
  List<List<Ingredient>> ingredients = [[]];
  int _nextIngredientId = 0;

  Ingredient _withId(Ingredient ingredient) => ingredient.id != null
      ? ingredient
      : ingredient.copyWith(
          id: 'ing-${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}-${_nextIngredientId++}',
        );

  LoadedIngredientsSection _snapshot() => LoadedIngredientsSection(
    List<String>.from(sectionTitles),
    ingredients
        .map((section) => List<Ingredient>.from(section))
        .toList(growable: false),
  );

  IngredientsSectionBloc() : super(LoadedIngredientsSection([], [[]])) {
    on<InitializeIngredientsSection>((event, emit) async {
      sectionTitles = List<String>.from(event.sectionTitles);
      final sectionCount = [
        1,
        event.ingredients.length,
        event.sectionTitles.length,
      ].reduce((value, element) => value > element ? value : element);
      ingredients = List.generate(sectionCount, (index) {
        if (index >= event.ingredients.length) return <Ingredient>[];
        return event.ingredients[index].map(_withId).toList();
      });
      if (sectionCount > 1 && sectionTitles.length < sectionCount) {
        sectionTitles.addAll(
          List<String>.filled(sectionCount - sectionTitles.length, ''),
        );
      }
      emit(_snapshot());
    });

    on<AddIngredient>((event, emit) async {
      ingredients[event.index].add(_withId(event.ingredient));
      emit(_snapshot());
    });

    on<RemoveIngredient>((event, emit) async {
      ingredients[event.sectionIndex]..removeAt(event.index);

      emit(_snapshot());
    });

    on<MoveIngredient>((event, emit) async {
      Ingredient moveIngred = ingredients[event.sectionIndex].removeAt(
        event.oldIndex,
      );
      ingredients[event.sectionIndex].insert(event.newIndex, moveIngred);

      emit(_snapshot());
    });

    on<EditIngredient>((event, emit) async {
      final ingredientId = ingredients[event.sectionIndex][event.index].id;
      if (event.sectionIndex != event.newSectionIndex) {
        ingredients[event.sectionIndex].removeAt(event.index);
        ingredients[event.newSectionIndex].add(
          event.newIngredient.copyWith(id: ingredientId),
        );
      } else {
        ingredients[event.sectionIndex][event.index] = event.newIngredient
            .copyWith(id: ingredientId);
      }

      emit(_snapshot());
    });

    on<AddSectionTitle>((event, emit) async {
      if (sectionTitles.isNotEmpty) {
        ingredients.add([]);
      }
      sectionTitles.add(event.title);
      emit(_snapshot());
    });

    on<EditSectionTitle>((event, emit) async {
      sectionTitles[event.sectionIndex] = event.newTitle;

      emit(_snapshot());
    });

    on<RemoveSection>((event, emit) async {
      if (ingredients.length > 1) {
        ingredients.removeAt(event.index);
      } else {
        ingredients[0] = [];
      }
      if (event.index < sectionTitles.length) {
        sectionTitles.removeAt(event.index);
      }
      if (ingredients.length == 1 && sectionTitles.length > 1) {
        sectionTitles = [sectionTitles.first];
      }
      emit(_snapshot());
    });
  }
}
