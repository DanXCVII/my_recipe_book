import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../generated/i18n.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
}

class TextColorDialog extends StatefulWidget {
  // only needs to be specified when editing an item
  final String prefilledText;
  final int selectedColor;
  final String hintText;
  final String Function(String name) validation;
  final void Function(String name, int color) save;
  final focus = FocusNode();

  TextColorDialog({
    @required this.validation,
    @required this.save,
    this.selectedColor = 4278238420,
    this.hintText,
    this.prefilledText,
  });

  @override
  State<StatefulWidget> createState() {
    return TextColorDialogState(selectedColor);
  }
}

class TextColorDialogState extends State<TextColorDialog> {
  TextEditingController nameController;
  int/*!*/ selectedColor;

  TextColorDialogState(int/*!*//*!*/ wSelectedColor) {
    selectedColor = wSelectedColor;
  }

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
      child: Container(
        width: MediaQuery.of(context).size.width > 360 ? 360 : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: TextFormField(
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
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showColorSelectDialog();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 5),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(selectedColor),
                          ),
                        ),
                      ),
                    )
                  ],
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
      ),
    );
  }

  void _showColorSelectDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(I18n.of(context).delete_category),
        content: BlockPicker(
          pickerColor: Color(selectedColor),
          onColorChanged: (color) {
            setState(() {
              selectedColor = color.value;
            });
          },
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("ok"),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textColor: Theme.of(context).textTheme.bodyText2.color,
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void validateAddModifyItem() {
    if (_formKey.currentState.validate()) {
      widget.save(nameController.text, selectedColor);
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => Navigator.pop(context));
    }
  }
}
