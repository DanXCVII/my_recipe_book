import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../generated/i18n.dart';
import '../../local_storage/hive.dart';
import '../../models/ingredient.dart';
import '../../screens/add_recipe/general_info_screen/categories_section.dart';
import '../../util/helper.dart';

class IngredientAddDialog extends StatelessWidget {
  final void Function(Ingredient ingredient, int selectedDropdownIndex)
      onFinished;
  final Ingredient prefilledData;
  final List<String> sectionTitles;
  final int selectedDropdownIndex;

  const IngredientAddDialog(
    this.onFinished,
    this.prefilledData, {
    this.sectionTitles = const [],
    this.selectedDropdownIndex = 0,
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
          child: IngredientAddDialogContent(
            onFinished,
            prefilledData,
            sectionTitles: sectionTitles,
            selectedDropdownIndex: selectedDropdownIndex,
          ),
        ),
      ),
    );
  }
}

class IngredientAddDialogContent extends StatefulWidget {
  final void Function(Ingredient ingredient, int selectedDropdownIndex)
      onFinished;
  final Ingredient prefilledData;
  final focus = FocusNode();
  final List<String> sectionTitles;
  final int/*!*/ selectedDropdownIndex;

  IngredientAddDialogContent(
    this.onFinished,
    this.prefilledData, {
    this.sectionTitles,
    this.selectedDropdownIndex,
    Key key,
  }) : super(key: key);

  @override
  _IngredientAddDialogContentState createState() =>
      _IngredientAddDialogContentState(selectedDropdownIndex, sectionTitles);
}

class _IngredientAddDialogContentState extends State<IngredientAddDialogContent>
    with SingleTickerProviderStateMixin {
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompletionTextField =
      GlobalKey();
  TextEditingController ingredientNameController = TextEditingController();
  TextEditingController ingredientAmountController = TextEditingController();
  TextEditingController ingredientUnitController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isExpanded = false;

  int/*!*/ selectedDropdownIndex;
  List<String/*!*//*!*/> dropdownItems = [];

  _IngredientAddDialogContentState(
      this.selectedDropdownIndex, List<String> sectionTitles) {
    for (int i = 0; i < sectionTitles.length; i++) {
      dropdownItems.add("${i + 1}: ${sectionTitles[i]}");
    }
  }

  @override
  void dispose() {
    ingredientNameController.dispose();
    ingredientAmountController.dispose();
    ingredientUnitController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    ingredientNameController.text = widget.prefilledData.name;
    ingredientAmountController.text = widget.prefilledData.amount == null
        ? ""
        : widget.prefilledData.amount.toString();
    ingredientUnitController.text = widget.prefilledData.unit;

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
          I18n.of(context).add_ingredient(""),
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 12),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              dropdownItems.isEmpty
                  ? null
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: DropdownButton<String>(
                          value: dropdownItems[selectedDropdownIndex],
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(fontSize: 18),
                          underline: Container(
                            height: 2,
                            color: Colors.orange,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              selectedDropdownIndex =
                                  dropdownItems.indexOf(newValue);
                            });
                          },
                          items: dropdownItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                width: MediaQuery.of(context).size.width - 150 >
                                        270
                                    ? 270
                                    : MediaQuery.of(context).size.width - 150,
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
              Form(
                key: formKey,
                child: AnimatedSize(
                  vsync: this,
                  duration: Duration(milliseconds: 150),
                  curve: Curves.fastOutSlowIn,
                  child: Column(
                    children: <Widget>[
                      SimpleAutoCompleteTextField(
                        key: autoCompletionTextField,
                        focusNode: widget.focus,
                        suggestions: HiveProvider().getIngredientNames(),
                        controller: ingredientNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: I18n.of(context).ingredient,
                        ),
                        textCapitalization:
                            I18n.of(context).two_char_locale == "EN"
                                ? TextCapitalization.none
                                : TextCapitalization.sentences,
                      ),
                      SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: ingredientAmountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: I18n.of(context).amnt,
                              ),
                              validator: (value) {
                                if (value == "" ||
                                    getDoubleFromString(value) != null) {
                                  if (value == "" &&
                                      ingredientUnitController.text != "") {
                                    return I18n.of(context).fill_remove_unit;
                                  }
                                  return null;
                                }
                                return I18n.of(context).no_valid_number;
                              },
                            ),
                          ),
                          Container(width: 6),
                          Expanded(
                            child: TextField(
                              controller: ingredientUnitController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: I18n.of(context).unit,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ]..removeWhere((element) => element == null),
          ),
        ),
        SizedBox(
          height: 12,
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
                dropdownItems.isNotEmpty
                    ? I18n.of(context).save
                    : I18n.of(context).add,
                style: TextStyle(color: Colors.black),
              ),
              color: Theme.of(context).backgroundColor == Colors.white
                  ? null
                  : Colors.amber,
              textTheme: ButtonTextTheme.primary,
              onPressed: () {
                if (formKey.currentState.validate()) {
                  widget.onFinished(
                    Ingredient(
                      name: ingredientNameController.text,
                      amount: ingredientAmountController.text == ""
                          ? null
                          : getDoubleFromString(
                              ingredientAmountController.text),
                      unit: ingredientUnitController.text,
                    ),
                    selectedDropdownIndex,
                  );

                  Navigator.of(context).pop();
                }
              },
            )
          ],
        )
      ],
    );
  }
}
