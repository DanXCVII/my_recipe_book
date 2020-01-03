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

class TextFieldDialog extends StatefulWidget {
  // only needs to be specified when editing an item
  final String prefilledText;
  final String hintText;
  final String Function(String name) validation;
  final void Function(String name) save;

  TextFieldDialog({
    @required this.validation,
    @required this.save,
    this.hintText,
    this.prefilledText,
  });

  @override
  State<StatefulWidget> createState() {
    return TextFieldDialogState();
  }
}

class TextFieldDialogState extends State<TextFieldDialog> {
  TextEditingController nameController;
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    nameController = new TextEditingController();
    if (widget.prefilledText != null) {
      nameController.text = widget.prefilledText;
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
                  return widget.validation(value);
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: widget.hintText,
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

  void validateAddModifyItem() {
    if (_formKey.currentState.validate()) {
      widget.save(nameController.text);
      Navigator.pop(context);
    }
  }
}
