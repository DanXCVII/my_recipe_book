import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:my_recipe_book/local_storage/hive.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
}

class CalendarRecipeAddDialog extends StatefulWidget {
  // only needs to be specified when editing an item
  final void Function(String name) save;
  final focus = FocusNode();

  CalendarRecipeAddDialog({
    @required this.save,
  });

  @override
  State<StatefulWidget> createState() {
    return CalendarRecipeAddDialogState();
  }
}

class CalendarRecipeAddDialogState extends State<CalendarRecipeAddDialog> {
  TextEditingController recipeNameController;
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompletionTextField =
      new GlobalKey();
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    recipeNameController = new TextEditingController();

    SchedulerBinding.instance.addPostFrameCallback((Duration _) {
      FocusScope.of(context).requestFocus(widget.focus);
    });
  }

  @override
  void dispose() {
    recipeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Stack(
        children: <Widget>[
          Container(
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
                        child: SimpleAutoCompleteTextField(
                          key: autoCompletionTextField,
                          focusNode: widget.focus,
                          submitOnSuggestionTap: true,
                          suggestions: HiveProvider().getRecipeNames(),
                          controller: recipeNameController,
                          textSubmitted: (_) {
                            validateAddModifyItem();
                          },
                          decoration: InputDecoration(
                            // border: OutlineInputBorder(),
                            hintText: I18n.of(context).recipe_name,
                          ),
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
        ],
      ),
    );
  }

  void validateAddModifyItem() {
    if (HiveProvider().getRecipeNames().contains(recipeNameController.text)) {
      widget.save(recipeNameController.text);
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => Navigator.pop(context));
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        animationDuration: Duration(milliseconds: 300),
        flushbarStyle: FlushbarStyle.FLOATING,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.elasticOut,
        duration: Duration(seconds: 4),
        icon: Icon(Icons.info),
        messageText: Text(I18n.of(context).no_recipe_with_this_name),
      )..show(context);
    }
  }
}
