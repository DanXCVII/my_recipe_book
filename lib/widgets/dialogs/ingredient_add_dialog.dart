import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../generated/i18n.dart';
import '../../util/helper.dart';
import '../../local_storage/hive.dart';
import '../../models/ingredient.dart';
import '../../screens/add_recipe/general_info_screen/categories_section.dart';

class IngredientAddDialog extends StatelessWidget {
  final void Function(Ingredient ingredient) onFinished;
  final Ingredient prefilledData;

  const IngredientAddDialog(
    this.onFinished,
    this.prefilledData, {
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
          child: IngredientAddDialogContent(onFinished, prefilledData),
        ),
      ),
    );
  }
}

class IngredientAddDialogContent extends StatefulWidget {
  final void Function(Ingredient ingredient) onFinished;
  final Ingredient prefilledData;
  final focus = FocusNode();

  IngredientAddDialogContent(
    this.onFinished,
    this.prefilledData, {
    Key key,
  }) : super(key: key);

  @override
  _IngredientAddDialogContentState createState() =>
      _IngredientAddDialogContentState();
}

class _IngredientAddDialogContentState extends State<IngredientAddDialogContent>
    with SingleTickerProviderStateMixin {
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompletionTextField =
      new GlobalKey();
  TextEditingController ingredientNameController = new TextEditingController();
  TextEditingController ingredientAmountController =
      new TextEditingController();
  TextEditingController ingredientUnitController = new TextEditingController();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  bool isExpanded = false;

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
                                if (value == "" || stringIsValidDouble(value)) {
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
            ],
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
                I18n.of(context).add,
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
                          : double.parse(ingredientAmountController.text),
                      unit: ingredientUnitController.text,
                    ),
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
