import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_event.dart';
import 'package:my_recipe_book/hive.dart';
import 'package:my_recipe_book/io/io_operations.dart' as IO;
import 'package:my_recipe_book/models/recipe.dart';
import '../../recipe.dart';
import './add_recipe.dart';

class AddRecipeBloc extends Bloc<AddRecipeEvent, AddRecipeState> {
  final RecipeManagerBloc recipeManagerBloc;

  AddRecipeBloc({@required this.recipeManagerBloc});

  @override
  AddRecipeState get initialState => LoadingAddRecipe();

  @override
  Stream<AddRecipeState> mapEventToState(
    AddRecipeEvent event,
  ) async* {
    if (event is InitializeEditing) {
      yield* _mapInitializeEditingToState(event);
    } else if (event is InitializeNewRecipe) {
      yield* _mapInitializeNewRecipeToState(event);
    } else if (event is SaveNewRecipe) {
      yield* _mapSaveNewRecipeToState(event);
    } else if (event is ModifyRecipe) {
      yield* _mapModifyRecipeToState(event);
    }
  }

  Stream<AddRecipeState> _mapInitializeEditingToState(
      InitializeEditing event) async* {
    List<String> categories = HiveProvider().getCategoryNames();

    yield LoadedAddRecipe(event.recipe, categories);
  }

  Stream<AddRecipeState> _mapInitializeNewRecipeToState(
      InitializeNewRecipe event) async* {
    List<String> categories = HiveProvider().getCategoryNames();
    Recipe recipe = HiveProvider().getTmpRecipe();

    yield LoadedAddRecipe(recipe, categories);
  }

  Stream<AddRecipeState> _mapSaveNewRecipeToState(SaveNewRecipe event) async* {
    // if we added images
    if (_hasRecipeImage(event.recipe)) {
      // TODO: Check if renameRecipeData is working
      await IO.copyRecipeDataToNewPath(
        'tmp',
        event.recipe.name,
      );
      await Directory(await PathProvider.pP.getRecipeDir('tmp'))
          .delete(recursive: true);
    }

    await HiveProvider().saveRecipe(event.recipe);
    recipeManagerBloc.add(RMAddRecipe(event.recipe));
  }

  Stream<AddRecipeState> _mapModifyRecipeToState(ModifyRecipe event) async* {
    recipeManagerBloc.add(RMDeleteRecipe(event.oldRecipe));

    bool hasFiles =
        Directory(await PathProvider.pP.getRecipeDir(event.oldRecipe.name))
            .existsSync();

    // if an image exists and the recipename changed
    if (hasFiles && event.oldRecipe.name != event.recipe.name) {
      await IO.copyRecipeDataToNewPath(event.oldRecipe.name, event.recipe.name);
      await HiveProvider().modifyRecipe(event.oldRecipe.name, event.recipe);
      await Directory(await PathProvider.pP.getRecipeDir(event.oldRecipe.name))
          .delete(recursive: true);
    } // if no image exist
    else {
      HiveProvider().modifyRecipe(event.oldRecipe.name, event.recipe);
    }
    imageCache.clear();

    recipeManagerBloc.add(RMAddRecipe(event.recipe));
  }

  bool _hasRecipeImage(Recipe recipe) {
    if (recipe.imagePath != "images/randomFood.jpg") {
      return true;
    }
    for (List<String> l in recipe.stepImages) {
      if (l.isNotEmpty) {
        return true;
      }
    }
    return false;
  }
}
