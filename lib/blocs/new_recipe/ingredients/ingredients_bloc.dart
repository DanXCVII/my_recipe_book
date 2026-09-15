import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../local_storage/local_repository.dart';
import '../../../models/enums.dart';
import '../../../models/ingredient.dart';
import '../../../models/recipe.dart';

part 'ingredients_event.dart';
part 'ingredients_state.dart';

class IngredientsBloc extends Bloc<IngredientsEvent, IngredientsState> {
  IngredientsBloc(this.repository) : super(ICanSave()) {
    on<SetCanSave>((event, emit) async {
      emit(ICanSave());
    });

    on<FinishedEditing>((event, emit) async {
      if (event.goBack!) {
        emit(IEditingFinishedGoBack());
      } else {
        emit(IEditingFinished());
      }

      List<String> recipeIngredientSections = [];
      List<List<Ingredient>> recipeIngredients = [[]];

      if (event.ingredients!.isNotEmpty &&
          event.ingredients!.first.isNotEmpty) {
        recipeIngredientSections = event.ingredientsGlossary!;
        recipeIngredients = event.ingredients!;
      }

      final validIngredientIds = recipeIngredients
          .expand((group) => group)
          .map((ingredient) => ingredient.id)
          .whereType<String>()
          .toSet();
      final currentRecipe = event.editingRecipe!
          ? repository.getTmpEditingRecipe()!
          : repository.getTmpRecipe()!;
      final retainedAssignments = List<List<String>>.generate(
        currentRecipe.steps.length,
        (index) => index < currentRecipe.stepIngredientIds.length
            ? currentRecipe.stepIngredientIds[index]
                  .where(validIngredientIds.contains)
                  .toList()
            : <String>[],
      );

      Recipe newRecipe;
      if (!event.editingRecipe!) {
        newRecipe = currentRecipe.copyWith(
          servings: event.servings,
          servingName: event.servingName,
          ingredients: recipeIngredients,
          ingredientsGlossary: recipeIngredientSections,
          vegetable: event.vegetable,
          stepIngredientIds: retainedAssignments,
        );
        await repository.saveTmpRecipe(newRecipe);
      } else {
        newRecipe = currentRecipe.copyWith(
          servings: event.servings,
          servingName: event.servingName,
          ingredients: recipeIngredients,
          ingredientsGlossary: recipeIngredientSections,
          vegetable: event.vegetable,
          stepIngredientIds: retainedAssignments,
        );
        await repository.saveTmpEditingRecipe(newRecipe);
      }

      if (event.goBack!) {
        emit(ISavedGoBack());
      } else {
        emit(ISaved(newRecipe));
      }
    });
  }

  final LocalRepository repository;
}
