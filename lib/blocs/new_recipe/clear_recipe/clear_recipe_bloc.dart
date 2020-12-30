import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../constants/global_constants.dart' as Constants;
import '../../../local_storage/hive.dart';
import '../../../local_storage/io_operations.dart' as IO;
import '../../../models/recipe.dart';

part 'clear_recipe_event.dart';
part 'clear_recipe_state.dart';

class ClearRecipeBloc extends Bloc<ClearRecipeEvent, ClearRecipeState> {
  ClearRecipeBloc() : super(InitialClearRecipeState());

  @override
  Stream<ClearRecipeState> mapEventToState(
    ClearRecipeEvent event,
  ) async* {
    if (event is Clear) {
      yield* _mapCearToState(event);
    } else if (event is RemoveRecipeImage) {
      yield* _mapRemoveRecipeImageToState(event);
    }
  }

  Stream<ClearRecipeState> _mapCearToState(Clear event) async* {
    Recipe clearedRecipe = Recipe(name: "");
    if (event.editingRecipe) {
      await HiveProvider().saveTmpEditingRecipe(clearedRecipe);
      await IO.deleteRecipeData(Constants.editRecipeLocalPathString);
    } else {
      await HiveProvider().saveTmpRecipe(clearedRecipe);
      await IO.deleteRecipeData(Constants.newRecipeLocalPathString);
    }

    yield ClearedRecipe(clearedRecipe);
  }

  Stream<ClearRecipeState> _mapRemoveRecipeImageToState(
      RemoveRecipeImage event) async* {
    yield RemovedRecipeImage();
  }
}
