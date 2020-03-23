import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../local_storage/hive.dart';
import '../../models/recipe.dart';
import '../recipe_manager/recipe_manager_bloc.dart' as RM;

part 'favorite_recipes_event.dart';
part 'favorite_recipes_state.dart';

class FavoriteRecipesBloc
    extends Bloc<FavoriteRecipesEvent, FavoriteRecipesState> {
  final RM.RecipeManagerBloc recipeManagerBloc;
  StreamSubscription subscription;

  FavoriteRecipesBloc({@required this.recipeManagerBloc}) {
    subscription = recipeManagerBloc.listen((rmState) {
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
