import 'package:flutter/material.dart';
import 'package:my_recipe_book/hive.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_recipe_book/generated/i18n.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
}

class AddDialog extends StatefulWidget {
  final String modifiedItem;
  final bool modifyNutrition;

  AddDialog(this.modifyNutrition, {this.modifiedItem});

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
          child: ScopedModelDescendant<RecipeKeeper>(
            builder: (context, child, rKeeper) => Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                SizedBox(height: 16.0),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    return validateNameField(value, rKeeper);
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
                        validateAddModifyItem(rKeeper);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String validateNameField(String name, RecipeKeeper rKeeper) {
    if (widget.modifyNutrition
        ? doesNutritionExist(nameController.text)
        : rKeeper.doesCategoryExist(nameController.text)) {
      return widget.modifyNutrition
          ? 'nutrition already exists'
          : 'category already exists';
    } else {
      return null;
    }
  }

  void validateAddModifyItem(RecipeKeeper rKeeper) {
    if (_formKey.currentState.validate()) {
      if (widget.modifiedItem == null) {
        widget.modifyNutrition
            ? addNutrition(nameController.text)
            : addCategory(nameController.text);
      } else {
        widget.modifyNutrition
            ? renameNutrition(widget.modifiedItem, nameController.text)
            : renameCategory(widget.modifiedItem, nameController.text);
      }
      Navigator.pop(context);
    }
  }
}
