import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 0,
          right: 0,
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width > 400
                    ? 400
                    : MediaQuery.of(context).size.width,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 24),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, top: 5),
                        child: Center(
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              focusNode: widget.focus,
                              controller: nameController,
                              validator: (value) {
                                return widget.validation(value);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        validateAddModifyItem();
                      },
                    ),
                    SizedBox(width: 8)
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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
