import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../local_storage/hive.dart';
import '../../models/recipe.dart';
import '../recipe_manager/recipe_manager_bloc.dart' as RM;

part 'favorite_recipes_event.dart';
part 'favorite_recipes_state.dart';

class FavoriteRecipesBloc
    extends Bloc<FavoriteRecipesEvent, FavoriteRecipesState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  late StreamSubscription subscription;

  FavoriteRecipesBloc({required this.recipeManagerBloc})
      : super(LoadingFavorites()) {
    subscription = recipeManagerBloc.stream.listen((rmState) {
      if (rmState is RM.AddFavoriteState) {
        add(AddFavorite(rmState.recipe));
      } else if (rmState is RM.RemoveFavoriteState) {
        add(RemoveFavorite(rmState.recipe));
      } else if (rmState is RM.DeleteRecipeState) {
        if (rmState.recipe.isFavorite) {
          add(RemoveFavorite(rmState.recipe));
        }
      } else if (rmState is RM.DeleteRecipeTagState ||
          rmState is RM.UpdateRecipeTagState ||
          rmState is RM.UpdateCategoryState) {
        add(LoadFavorites());
      }
    });

    on<LoadFavorites>((event, emit) async {
      final favoriteRecipes = await HiveProvider().getFavoriteRecipes();

      emit(LoadedFavorites(favoriteRecipes));
    });

    on<AddFavorite>((event, emit) async {
      if (state is LoadedFavorites) {
        final recipes = List<Recipe>.from((state as LoadedFavorites).recipes)
          ..add(event.recipe);

        emit(LoadedFavorites(recipes));
      }
    });

    on<RemoveFavorite>((event, emit) async {
      if (state is LoadedFavorites) {
        final recipes = List<Recipe>.from((state as LoadedFavorites).recipes)
          ..removeWhere((recipe) => event.recipe.name == recipe.name);

        emit(LoadedFavorites(recipes));
      }
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
