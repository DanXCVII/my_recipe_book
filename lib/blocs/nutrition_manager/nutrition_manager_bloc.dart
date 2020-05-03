import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../local_storage/hive.dart';

part 'nutrition_manager_event.dart';
part 'nutrition_manager_state.dart';

class NutritionManagerBloc
    extends Bloc<NutritionManagerEvent, NutritionManagerState> {
  List<String> modifiedRecipeNutritions = [];

  @override
  NutritionManagerState get initialState => InitialNutritionManagerState();

  @override
  Stream<NutritionManagerState> mapEventToState(
    NutritionManagerEvent event,
  ) async* {
    if (event is LoadNutritionManager) {
      yield* _mapLoadingNutritionManagerToState(event);
    } else if (event is AddNutrition) {
      yield* _mapAddNutritionToState(event);
    } else if (event is DeleteNutrition) {
      yield* _mapDeleteNutritionToState(event);
    } else if (event is UpdateNutrition) {
      yield* _mapUpdateNutritionToState(event);
    } else if (event is MoveNutrition) {
      yield* _mapMoveNutritionToState(event);
    }
  }

  Stream<NutritionManagerState> _mapLoadingNutritionManagerToState(
      LoadNutritionManager event) async* {
    final List<String> nutritions =
        List<String>.from(HiveProvider().getNutritions());

    if (event.modifiedRecipe != null) {
      List<String> editingRecipeNutritions =
          (await HiveProvider().getRecipeByName(event.modifiedRecipe))
              .nutritions
              .map((n) => n.name)
              .toList();

      if (editingRecipeNutritions != null) {
        for (String nutrition in editingRecipeNutritions) {
          if (!nutritions.contains(nutrition)) {
            modifiedRecipeNutritions.add(nutrition);
          }
        }
      }
    }

    List<String> allNutritions = List<String>.from(nutritions)
      ..addAll(modifiedRecipeNutritions);

    yield LoadedNutritionManager(allNutritions);
  }

  Stream<NutritionManagerState> _mapAddNutritionToState(
      AddNutrition event) async* {
    if (state is LoadedNutritionManager) {
      await HiveProvider().addNutrition(event.nutrition);

      final List<String> nutritions =
          List<String>.from((state as LoadedNutritionManager).nutritions);
      nutritions.add(event.nutrition);

      yield LoadedNutritionManager(nutritions);
    }
  }

  Stream<NutritionManagerState> _mapDeleteNutritionToState(
      DeleteNutrition event) async* {
    if (state is LoadedNutritionManager) {
      if (!modifiedRecipeNutritions.contains(event.nutrition)) {
        await HiveProvider().deleteNutrition(event.nutrition);
      }
      final List<String> nutritions =
          List<String>.from((state as LoadedNutritionManager).nutritions)
            ..remove(event.nutrition);

      yield LoadedNutritionManager(nutritions);
    }
  }

  Stream<NutritionManagerState> _mapUpdateNutritionToState(
      UpdateNutrition event) async* {
    if (state is LoadedNutritionManager) {
      if (modifiedRecipeNutritions.contains(event.oldNutrition)) {
        modifiedRecipeNutritions.remove(event.oldNutrition);
        await HiveProvider().addNutrition(event.updatedNutrition);
      } else {
        await HiveProvider()
            .renameNutrition(event.oldNutrition, event.updatedNutrition);
      }
      final List<String> nutritions = (state as LoadedNutritionManager)
          .nutritions
          .map((nutrition) => nutrition == event.oldNutrition
              ? event.updatedNutrition
              : nutrition)
          .toList();

      yield LoadedNutritionManager(nutritions);
    }
  }

  Stream<NutritionManagerState> _mapMoveNutritionToState(
      MoveNutrition event) async* {
    if (state is LoadedNutritionManager) {
      await HiveProvider().moveNutrition(event.oldIndex, event.newIndex);

      List<String> newNutritionList =
          List<String>.from((state as LoadedNutritionManager).nutritions);

      String moveNutrition = newNutritionList[event.oldIndex];
      int newIndex = event.newIndex;

      if (event.newIndex > event.oldIndex) newIndex -= 1;
      newNutritionList[event.oldIndex] = newNutritionList[newIndex];
      newNutritionList[newIndex] = moveNutrition;

      yield LoadedNutritionManager(newNutritionList);
    }
  }
}
