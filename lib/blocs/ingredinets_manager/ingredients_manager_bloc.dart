import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../local_storage/local_repository.dart';

part 'ingredients_manager_event.dart';
part 'ingredients_manager_state.dart';

class IngredientsManagerBloc
    extends Bloc<IngredientsManagerEvent, IngredientsManagerState> {
  IngredientsManagerBloc(this.repository) : super(IngredientsManagerInitial()) {
    on<LoadIngredientsManager>((event, emit) async {
      final List<String> ingredients = repository.getIngredientNames()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

      emit(LoadedIngredientsManager(ingredients));
    });

    on<AddIngredient>((event, emit) async {
      if (state is LoadedIngredientsManager) {
        await repository.addIngredient(event.ingredient);

        List<String> ingredients =
            List<String>.from((state as LoadedIngredientsManager).ingredients)
              ..add(event.ingredient)
              ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

        emit(LoadedIngredientsManager(ingredients));
      }
    });

    on<DeleteIngredient>((event, emit) async {
      if (state is LoadedIngredientsManager) {
        await repository.deleteIngredient(event.ingredient);
        final List<String> ingredients = List<String>.from(
          (state as LoadedIngredientsManager).ingredients,
        )..remove(event.ingredient);

        emit(LoadedIngredientsManager(ingredients));
      }
    });

    on<UpdateIngredient>((event, emit) async {
      if (state is LoadedIngredientsManager) {
        await repository.deleteIngredient(event.oldIngredient);
        await repository.addIngredient(event.updatedIngredient);
        final List<String /*!*/> ingredients =
            (state as LoadedIngredientsManager).ingredients
              ..remove(event.oldIngredient)
              ..add(event.updatedIngredient)
              ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

        emit(LoadedIngredientsManager(ingredients));
      }
    });
  }

  final LocalRepository repository;
}
