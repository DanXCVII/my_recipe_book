import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:my_recipe_book/hive.dart';
import 'package:my_recipe_book/local_storage/io_operations.dart' as IO;
import 'package:my_recipe_book/models/recipe.dart';
import './clear_recipe.dart';

class ClearRecipeBloc extends Bloc<ClearRecipeEvent, ClearRecipeState> {
  @override
  ClearRecipeState get initialState => InitialClearRecipeState();

  @override
  Stream<ClearRecipeState> mapEventToState(
    ClearRecipeEvent event,
  ) async* {
    if (event is Clear) {
      yield* _mapCearToState(event);
    }
  }

  Stream<ClearRecipeState> _mapCearToState(Clear event) async* {
    Recipe clearedRecipe = Recipe(name: "");
    if (event.editingRecipe) {
      await HiveProvider().saveTmpEditingRecipe(clearedRecipe);
      await IO.deleteRecipeData('edit');
    } else {
      await HiveProvider().saveTmpRecipe(clearedRecipe);
      await IO.deleteRecipeData('tmp');
    }

    yield ClearedRecipe(clearedRecipe, event.dateTime);
  }
}
