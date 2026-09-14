import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../local_storage/local_repository.dart';

part 'nutrition_manager_event.dart';
part 'nutrition_manager_state.dart';

class NutritionManagerBloc
    extends Bloc<NutritionManagerEvent, NutritionManagerState> {
  List<String> modifiedRecipeNutritions = [];
  final LocalRepository repository;

  NutritionManagerBloc(this.repository) : super(InitialNutritionManagerState()) {
    on<LoadNutritionManager>((event, emit) async {
      final List<String> nutritions =
          List<String>.from(repository.getNutritions());

      if (event.modifiedRecipe != null) {
        List<String> editingRecipeNutritions =
            (await repository.getRecipeByName(event.modifiedRecipe!))!
                .nutritions
                .map((n) => n.name)
                .toList();

        for (String nutrition in editingRecipeNutritions) {
          if (!nutritions.contains(nutrition)) {
            modifiedRecipeNutritions.add(nutrition);
          }
        }
      }

      List<String> allNutritions = List<String>.from(nutritions)
        ..addAll(modifiedRecipeNutritions);

      emit(LoadedNutritionManager(allNutritions));
    });

    on<AddNutrition>((event, emit) async {
      if (state is LoadedNutritionManager) {
        await repository.addNutrition(event.nutrition);

        final List<String> nutritions =
            List<String>.from((state as LoadedNutritionManager).nutritions);
        nutritions.add(event.nutrition);

        emit(LoadedNutritionManager(nutritions));
      }
    });

    on<DeleteNutrition>((event, emit) async {
      if (state is LoadedNutritionManager) {
        if (!modifiedRecipeNutritions.contains(event.nutrition)) {
          await repository.deleteNutrition(event.nutrition);
        }
        final List<String> nutritions =
            List<String>.from((state as LoadedNutritionManager).nutritions)
              ..remove(event.nutrition);

        emit(LoadedNutritionManager(nutritions));
      }
    });

    on<UpdateNutrition>((event, emit) async {
      if (state is LoadedNutritionManager) {
        if (modifiedRecipeNutritions.contains(event.oldNutrition)) {
          modifiedRecipeNutritions.remove(event.oldNutrition);
          await repository.addNutrition(event.updatedNutrition);
        } else {
          await repository
              .renameNutrition(event.oldNutrition, event.updatedNutrition);
        }
        final List<String> nutritions = (state as LoadedNutritionManager)
            .nutritions
            .map((nutrition) => nutrition == event.oldNutrition
                ? event.updatedNutrition
                : nutrition)
            .toList();

        emit(LoadedNutritionManager(nutritions));
      }
    });

    on<MoveNutrition>((event, emit) async {
      if (state is LoadedNutritionManager) {
        await repository.moveNutrition(event.oldIndex, event.newIndex);

        List<String> newNutritionList =
            List<String>.from((state as LoadedNutritionManager).nutritions);

        newNutritionList
          ..insert(event.newIndex, newNutritionList[event.oldIndex])
          ..removeAt(event.oldIndex > event.newIndex
              ? event.oldIndex + 1
              : event.oldIndex);

        emit(LoadedNutritionManager(newNutritionList));
      }
    });
  }
}
