import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/screens/add_recipe/general_info_screen/categories_section.dart';

import '../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../generated/i18n.dart';
import '../../helper.dart';
import '../../local_storage/hive.dart';
import '../../models/ingredient.dart';

class ShoppingCartAddDialog extends StatelessWidget {
  const ShoppingCartAddDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            Consts.padding, Consts.padding, Consts.padding, 7),
        child: ShoppingCartAddDialogContent(),
      ),
    );
  }
}

class ShoppingCartAddDialogContent extends StatefulWidget {
  final focus = FocusNode();

  ShoppingCartAddDialogContent({Key key}) : super(key: key);

  @override
  _ShoppingCartAddDialogContentState createState() =>
      _ShoppingCartAddDialogContentState();
}

class _ShoppingCartAddDialogContentState
    extends State<ShoppingCartAddDialogContent>
    with SingleTickerProviderStateMixin {
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompletionTextField =
      new GlobalKey();
  TextEditingController recipeNameController = new TextEditingController();
  TextEditingController ingredientNameController = new TextEditingController();
  TextEditingController ingredientAmountController =
      new TextEditingController();
  TextEditingController ingredientUnitController = new TextEditingController();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  bool isExpanded = false;

  @override
  void dispose() {
    recipeNameController.dispose();
    ingredientNameController.dispose();
    ingredientAmountController.dispose();
    ingredientUnitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'add ingredient',
              style: Theme.of(context).textTheme.title,
            ),
            IconButton(
              icon: Icon(
                  isExpanded ? MdiIcons.arrowCollapse : MdiIcons.arrowExpand),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            )
          ],
        ),
        SizedBox(height: 12),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              AnimatedSize(
                vsync: this,
                duration: Duration(milliseconds: 150),
                curve: Curves.fastOutSlowIn,
                child: isExpanded
                    ? Column(
                        children: <Widget>[
                          TextFormField(
                            controller: recipeNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: I18n.of(context).recipe_name,
                            ),
                          ),
                          Container(height: 3),
                          Divider(),
                          Container(height: 3),
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
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: ingredientUnitController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: I18n.of(context).unit,
                                  ),
                                ),
                              ),
                              Container(width: 6),
                              Expanded(
                                child: TextFormField(
                                  controller: ingredientAmountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: I18n.of(context).amnt,
                                  ),
                                  validator: (value) {
                                    if (stringIsValidDouble(value)) {
                                      return null;
                                    }
                                    return I18n.of(context).no_valid_number;
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : SimpleAutoCompleteTextField(
                        key: autoCompletionTextField,
                        suggestions: HiveProvider().getIngredientNames(),
                        controller: ingredientNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: I18n.of(context).ingredient,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text(I18n.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(I18n.of(context).add),
              onPressed: () {
                if (formKey.currentState.validate()) {
                  BlocProvider.of<ShoppingCartBloc>(context).add(
                    CleanAddIngredients(
                        [
                          Ingredient(
                              name: ingredientNameController.text,
                              amount:
                                  double.parse(ingredientAmountController.text),
                              unit: ingredientUnitController.text)
                        ],
                        recipeNameController.text == ''
                            ? I18n.of(context).summary
                            : recipeNameController.text),
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
