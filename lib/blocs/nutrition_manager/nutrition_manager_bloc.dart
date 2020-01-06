import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../hive.dart';
import './nutrition_manager.dart';

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
      // TODO: Add to hive
      final List<String> nutritions =
          List<String>.from((state as LoadedNutritionManager).nutritions)
            ..add(event.nutrition);

      yield LoadedNutritionManager(nutritions);
    }
  }

  Stream<NutritionManagerState> _mapDeleteNutritionToState(
      DeleteNutrition event) async* {
    if (state is LoadedNutritionManager) {
      // TODO: Delete in hive
      final List<String> nutritions =
          List<String>.from((state as LoadedNutritionManager).nutritions)
            ..remove(event.nutrition);

      yield LoadedNutritionManager(nutritions);
    }
  }

  Stream<NutritionManagerState> _mapUpdateNutritionToState(
      UpdateNutrition event) async* {
    if (state is LoadedNutritionManager) {
      // TODO: implement in hive
      final List<String> nutritions = (state as LoadedNutritionManager)
          .nutritions
          .map((nutrition) => nutrition == event.oldNutrition
              ? event.updatedNutrition
              : nutrition);

      yield LoadedNutritionManager(nutritions);
    }
  }

  Stream<NutritionManagerState> _mapMoveNutritionToState(
      MoveNutrition event) async* {
    if (state is LoadedNutritionManager) {
      // List in HiveProvider() is already updated of the recipeManager
      final List<String> nutritions = HiveProvider().getNutritions();

      yield LoadedNutritionManager(nutritions);
    }
  }
}
