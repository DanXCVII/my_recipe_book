import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../generated/i18n.dart';
import '../../local_storage/hive.dart';
import '../../screens/add_recipe/general_info_screen/categories_section.dart';

class CalendarAddDialog extends StatelessWidget {
  final void Function(DateTime date, String recipeName) onFinished;

  const CalendarAddDialog(
    this.onFinished, {
    Key key,
  }) : super(key: key);

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
          padding: const EdgeInsets.fromLTRB(
              Consts.padding, Consts.padding, Consts.padding, 7),
          child: CalendarAddDialogContent(onFinished),
        ),
      ),
    );
  }
}

class CalendarAddDialogContent extends StatefulWidget {
  final void Function(DateTime date, String recipeName) onFinished;
  final focus = FocusNode();

  CalendarAddDialogContent(
    this.onFinished, {
    Key key,
  }) : super(key: key);

  @override
  _CalendarAddDialogContentState createState() =>
      _CalendarAddDialogContentState();
}

class _CalendarAddDialogContentState extends State<CalendarAddDialogContent>
    with SingleTickerProviderStateMixin {
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompletionTextField =
      new GlobalKey();
  TextEditingController recipeNameController = new TextEditingController();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  DateTime selectedDate;

  @override
  void dispose() {
    recipeNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((Duration _) {
      FocusScope.of(context).requestFocus(widget.focus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          I18n.of(context).add_to_calendar,
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 16),
        SimpleAutoCompleteTextField(
          key: autoCompletionTextField,
          focusNode: widget.focus,
          suggestions: HiveProvider().getRecipeNames(),
          controller: recipeNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: I18n.of(context).recipe_name,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        selectedDate == null
            ? Center(
                child: OutlineButton.icon(
                  icon: Icon(Icons.add_circle),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(I18n.of(context).add_date),
                  ),
                  onPressed: () async {
                    _onSelectDate();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  _onSelectDate();
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      border: Border.all(
                          width: 1,
                          color:
                              Theme.of(context).backgroundColor == Colors.white
                                  ? Colors.grey[500]
                                  : Colors.white),
                    ),
                    child: Text(
                      "${selectedDate.day}.${selectedDate.month}.${selectedDate.year}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text(I18n.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(width: 6),
            FlatButton(
              child: Text(
                I18n.of(context).add,
                style: TextStyle(color: Colors.black),
              ),
              color: Theme.of(context).backgroundColor == Colors.white
                  ? null
                  : Colors.amber,
              textTheme: ButtonTextTheme.primary,
              onPressed: () {
                if (HiveProvider()
                    .getRecipeNames()
                    .contains(recipeNameController.text)) {
                  if (selectedDate != null) {
                    widget.onFinished(selectedDate, recipeNameController.text);

                    Navigator.of(context).pop();
                  } else {
                    Flushbar(
                      flushbarPosition: FlushbarPosition.TOP,
                      animationDuration: Duration(milliseconds: 300),
                      flushbarStyle: FlushbarStyle.FLOATING,
                      reverseAnimationCurve: Curves.decelerate,
                      forwardAnimationCurve: Curves.elasticOut,
                      duration: Duration(seconds: 4),
                      icon: Icon(Icons.info),
                      messageText: Text(I18n.of(context).select_a_date_first),
                    )..show(context);
                  }
                } else {
                  Flushbar(
                    flushbarPosition: FlushbarPosition.TOP,
                    animationDuration: Duration(milliseconds: 300),
                    flushbarStyle: FlushbarStyle.FLOATING,
                    reverseAnimationCurve: Curves.decelerate,
                    forwardAnimationCurve: Curves.elasticOut,
                    duration: Duration(seconds: 4),
                    icon: Icon(Icons.info),
                    messageText:
                        Text(I18n.of(context).no_recipe_with_this_name),
                  )..show(context);
                }
              },
            )
          ],
        )
      ],
    );
  }

  void _onSelectDate() {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now().subtract(Duration(days: 31)),
      maxTime: DateTime.now().add(Duration(days: 60)),
      onConfirm: (date) {
        setState(() {
          selectedDate = date;
        });
      },
      currentTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      locale: LocaleType.de,
    );
  }
}
