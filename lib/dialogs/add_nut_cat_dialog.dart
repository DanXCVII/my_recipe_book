import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_book/blocs/category_manager/category_manager.dart';
import 'package:my_recipe_book/blocs/nutrition_manager/nutrition_manager_bloc.dart';
import 'package:my_recipe_book/blocs/nutrition_manager/nutrition_manager_event.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_bloc.dart';
import 'package:my_recipe_book/blocs/recipe_manager/recipe_manager_event.dart';
import 'package:my_recipe_book/generated/i18n.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
}

class AddDialog extends StatefulWidget {
  // only needs to be specified when editing an item
  final String modifiedItem;
  final bool modifyNutrition;
  final List<String> elements;
  final RecipeManagerBloc recipeManagerBloc;
  final NutritionManagerBloc nutritionManagerBloc;
  final CategoryManagerBloc categoryManagerBloc;

  AddDialog(
    this.modifyNutrition,
    this.elements, {
    this.recipeManagerBloc,
    this.nutritionManagerBloc,
    this.categoryManagerBloc,
    this.modifiedItem,
  });

  @override
  State<StatefulWidget> createState() {
    return AddDialogState();
  }
}

class AddDialogState extends State<AddDialog> {
  TextEditingController nameController;
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    nameController = new TextEditingController();
    if (widget.modifiedItem != null) {
      nameController.text = widget.modifiedItem;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              SizedBox(height: 16.0),
              TextFormField(
                controller: nameController,
                validator: (value) {
                  return validateNameField(value);
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText:
                      widget.modifyNutrition ? 'nutrition' : 'category name',
                ),
              ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                      child: Text(S.of(context).cancel),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  FlatButton(
                    child: Text(S.of(context).save),
                    onPressed: () {
                      validateAddModifyItem();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String validateNameField(String name) {
    if (widget.elements.contains(name)) {
      return widget.modifyNutrition
          ? 'nutrition already exists'
          : 'category already exists';
    } else {
      return null;
    }
  }

  void validateAddModifyItem() {
    if (_formKey.currentState.validate()) {
      if (widget.modifiedItem == null) {
        widget.modifyNutrition
            ? BlocProvider.of<NutritionManagerBloc>(context)
                .add(AddNutrition(nameController.text))
            : widget.recipeManagerBloc.add(RMAddCategory(nameController.text));
      } else {
        widget.modifyNutrition
            ? BlocProvider.of<NutritionManagerBloc>(context)
                .add(UpdateNutrition(widget.modifiedItem, nameController.text))
            : widget.recipeManagerBloc.add(
                RMUpdateCategory(widget.modifiedItem, nameController.text));
      }
      Navigator.pop(context);
    }
  }
}
