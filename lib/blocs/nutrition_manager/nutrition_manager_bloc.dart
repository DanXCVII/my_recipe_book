import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../local_storage/hive.dart';

part 'nutrition_manager_event.dart';
part 'nutrition_manager_state.dart';

class NutritionManagerBloc
    extends Bloc<NutritionManagerEvent, NutritionManagerState> {
  @override
  NutritionManagerState get initialState => InitialNutritionManagerState();

  @override
  Stream<NutritionManagerState> mapEventToState(
    NutritionManagerEvent event,
  ) async* {
    if (event is LoadNutritionManager) {
      yield* _mapLoadingNutritionManagerToState();
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

  Stream<NutritionManagerState> _mapLoadingNutritionManagerToState() async* {
    final List<String> nutritions = HiveProvider().getNutritions();

    yield LoadedNutritionManager(nutritions);
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
      await HiveProvider().deleteNutrition(event.nutrition);
      final List<String> nutritions =
          List<String>.from((state as LoadedNutritionManager).nutritions)
            ..remove(event.nutrition);

      yield LoadedNutritionManager(nutritions);
    }
  }

  Stream<NutritionManagerState> _mapUpdateNutritionToState(
      UpdateNutrition event) async* {
    if (state is LoadedNutritionManager) {
      await HiveProvider()
          .renameNutrition(event.oldNutrition, event.updatedNutrition);
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
      final List<String> nutritions = HiveProvider().getNutritions();

      yield LoadedNutritionManager(nutritions);
    }
  }
}
