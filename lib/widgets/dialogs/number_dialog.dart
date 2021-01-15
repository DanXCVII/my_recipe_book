import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../generated/i18n.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
}

class NumberDialog extends StatefulWidget {
  // only needs to be specified when editing an item
  final String prefilledText;
  final String hintText;
  final String Function(String name) validation;
  final void Function(String name) save;
  final focus = FocusNode();
  final bool number;

  NumberDialog({
    @required this.validation,
    @required this.save,
    this.hintText,
    this.prefilledText,
    this.number = false,
  });

  @override
  State<StatefulWidget> createState() {
    return NumberDialogState();
  }
}

class NumberDialogState extends State<NumberDialog> {
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
        Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width > 150
                  ? 150
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
                            style:
                                TextStyle(fontFamily: "Orbitron", fontSize: 22),
                            focusNode: widget.focus,
                            onFieldSubmitted: (_) {
                              validateAddModifyItem();
                            },
                            controller: nameController,
                            keyboardType: TextInputType.number,
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
