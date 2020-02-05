import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import './favorite_recipes.dart';
import '../../hive.dart';
import '../../models/recipe.dart';
import '../recipe_manager/recipe_manager_bloc.dart';
import '../recipe_manager/recipe_manager_state.dart' as RMState;

class FavoriteRecipesBloc
    extends Bloc<FavoriteRecipesEvent, FavoriteRecipesState> {
  final RecipeManagerBloc recipeManagerBloc;
  StreamSubscription subscription;

  FavoriteRecipesBloc({@required this.recipeManagerBloc}) {
    subscription = recipeManagerBloc.listen((state) {
      if (state is RMState.AddFavoriteState) {
        add(AddFavorite(state.recipe));
      } else if (state is RMState.RemoveFavoriteState) {
        add(RemoveFavorite(state.recipe));
      } else if (state is RMState.DeleteRecipeState) {
        if (state.recipe.isFavorite) {
          add(RemoveFavorite(state.recipe));
        }
      }
    });
  }

  @override
  FavoriteRecipesState get initialState => LoadingFavorites();

  @override
  Stream<FavoriteRecipesState> mapEventToState(
    FavoriteRecipesEvent event,
  ) async* {
    if (event is LoadFavorites) {
      yield* _mapLoadFavoritesToState(event);
    } else if (event is AddFavorite) {
      yield* _mapAddFavoriteToState(event);
    } else if (event is RemoveFavorite) {
      yield* _mapRemoveFavoriteToState(event);
    }
  }

  Stream<FavoriteRecipesState> _mapLoadFavoritesToState(
      LoadFavorites event) async* {
    final favoriteRecipes = await HiveProvider().getFavoriteRecipes();

    yield LoadedFavorites(favoriteRecipes);
  }

  // TODO: Keep track of the sort order
  Stream<FavoriteRecipesState> _mapAddFavoriteToState(
      AddFavorite event) async* {
    if (state is LoadedFavorites) {
      final recipes = List<Recipe>.from(
          (state as LoadedFavorites).recipes..add(event.recipe));

      yield LoadedFavorites(recipes);
    }
  }

  Stream<FavoriteRecipesState> _mapRemoveFavoriteToState(
      RemoveFavorite event) async* {
    if (state is LoadedFavorites) {
      final recipes = List<Recipe>.from((state as LoadedFavorites).recipes
        ..removeWhere((recipe) => event.recipe.name == recipe.name));

      yield LoadedFavorites(recipes);
    }
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
