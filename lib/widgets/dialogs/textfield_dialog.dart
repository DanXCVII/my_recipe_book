import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../generated/i18n.dart';

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
  final focus = FocusNode();

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
    SchedulerBinding.instance.addPostFrameCallback((Duration _) {
      FocusScope.of(context).requestFocus(widget.focus);
    });
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
                focusNode: widget.focus,
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
                      child: Text(I18n.of(context).cancel),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  FlatButton(
                    child: Text(I18n.of(context).save),
                    onPressed: () {
                      validateAddModifyItem();
                    },
                  ),
                ],
              ),
              SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }

  void validateAddModifyItem() {
    if (_formKey.currentState.validate()) {
      widget.save(nameController.text);
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => Navigator.pop(context));
    }
  }
}
