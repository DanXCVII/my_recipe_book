import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as Constants;
import '../constants/routes.dart';
import '../models/recipe.dart';
import '../screens/recipe_screen.dart';

class RecipeImageHero extends StatelessWidget {
  final Recipe recipe;

  const RecipeImageHero(this.recipe, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteNames.recipeScreen,
          arguments: RecipeScreenArguments(
            BlocProvider.of<ShoppingCartBloc>(context),
            recipe,
            getRecipePrimaryColor(recipe.vegetable),
            recipe.name,
            BlocProvider.of<RecipeManagerBloc>(context),
          ),
        );
      },
      child: Hero(
        tag: recipe.name,
        child: ClipOval(
          child: Container(
            width: 30,
            height: 30,
            child: recipe.imagePreviewPath == Constants.noRecipeImage
                ? Image.asset(
                    recipe.imagePreviewPath,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(recipe.imagePreviewPath),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
