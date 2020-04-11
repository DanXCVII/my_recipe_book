import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_book/constants/global_settings.dart';
import 'package:wakelock/wakelock.dart';

import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as Constants;
import '../constants/routes.dart';
import '../models/recipe.dart';
import '../screens/recipe_screen/recipe_screen.dart';

class RecipeBubble extends StatefulWidget {
  final Offset initialPosition;
  final Recipe recipe;

  RecipeBubble({
    @required this.initialPosition,
    @required this.recipe,
    Key key,
  }) : super(key: key);

  @override
  _RecipeBubbleState createState() => _RecipeBubbleState();
}

class _RecipeBubbleState extends State<RecipeBubble> {
  double width = 100.0, height = 100.0;
  Offset position;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        child: _getRecipeBubble(),
        feedback: _getRecipeBubble(),
        childWhenDragging: Container(),
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          setState(() => position = offset);
        },
      ),
    );
  }

  Widget _getRecipeBubble() {
    return GestureDetector(
      onTap: () {
        if (GlobalSettings().standbyDisabled()) {
          Wakelock.enable();
        }
        Navigator.pushNamed(
          context,
          RouteNames.recipeScreen,
          arguments: RecipeScreenArguments(
            BlocProvider.of<ShoppingCartBloc>(context),
            widget.recipe,
            widget.recipe.name + "##bubble#",
            BlocProvider.of<RecipeManagerBloc>(context),
          ),
        ).then((_) => Wakelock.disable());
      },
      child: Hero(
        tag: GlobalSettings().animationsEnabled()
            ? widget.recipe.name + "##bubble#"
            : widget.recipe.name + "##bubble#4",
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                spreadRadius: 1,
                color: Theme.of(context).backgroundColor == Colors.white
                    ? Colors.grey[400]
                    : Colors.black,
              ),
            ],
          ),
          width: 70,
          height: 70,
          child: ClipOval(
            child: widget.recipe.imagePath == Constants.noRecipeImage
                ? Image.asset(Constants.noRecipeImage,
                    width: double.infinity, fit: BoxFit.cover)
                : Image.file(File(widget.recipe.imagePath),
                    width: double.infinity, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
