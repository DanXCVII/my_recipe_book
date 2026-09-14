import 'package:bloc/bloc.dart';

import '../../../constants/global_constants.dart' as Constants;
import '../../../local_storage/local_repository.dart';
import '../../../local_storage/io_operations.dart' as IO;
import '../../../models/recipe.dart';

part 'clear_recipe_event.dart';
part 'clear_recipe_state.dart';

class ClearRecipeBloc extends Bloc<ClearRecipeEvent, ClearRecipeState> {
  ClearRecipeBloc(this.repository) : super(InitialClearRecipeState()) {
    on<Clear>((event, emit) async {
      Recipe clearedRecipe = Recipe(name: "");
      if (event.editingRecipe) {
        await repository.saveTmpEditingRecipe(clearedRecipe);
        await IO.deleteRecipeData(Constants.editRecipeLocalPathString);
      } else {
        await repository.saveTmpRecipe(clearedRecipe);
        await IO.deleteRecipeData(Constants.newRecipeLocalPathString);
      }

      emit(ClearedRecipe(clearedRecipe));
    });

    on<RemoveRecipeImage>((event, emit) async {
      emit(RemovedRecipeImage());
    });
  }

  final LocalRepository repository;
}
