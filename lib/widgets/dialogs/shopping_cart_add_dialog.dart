import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../../generated/i18n.dart';
import '../../helper.dart';
import '../../hive.dart';
import '../../models/ingredient.dart';

class AddShoppingCartDialog extends StatefulWidget {
  const AddShoppingCartDialog({Key key}) : super(key: key);

  @override
  _AddShoppingCartDialogState createState() => _AddShoppingCartDialogState();
}

class _AddShoppingCartDialogState extends State<AddShoppingCartDialog> {
  TextEditingController recipeNameController = new TextEditingController();
  TextEditingController ingredientNameController = new TextEditingController();
  TextEditingController ingredientAmountController =
      new TextEditingController();
  TextEditingController ingredientUnitController = new TextEditingController();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  GlobalKey<AutoCompleteTextFieldState<String>> autoCompletionTextField =
      new GlobalKey();

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
    return Container(
      height: 245,
      child: Column(
        children: <Widget>[
          Text(
            S.of(context).add_to_cart,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 21),
          ),
          SizedBox(height: 16),
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: recipeNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: S.of(context).recipe_name,
                  ),
                ),
                Container(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: SimpleAutoCompleteTextField(
                        key: autoCompletionTextField,
                        suggestions: HiveProvider().getIngredientNames(),
                        controller: ingredientNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: S.of(context).ingredient,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: ingredientAmountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: S.of(context).amnt,
                        ),
                        validator: (value) {
                          if (validateNumber(value)) {
                            return null;
                          }
                          return S.of(context).no_valid_number;
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: ingredientUnitController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: S.of(context).unit,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text(S.of(context).cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(width: 3),
              FlatButton(
                child: Text(S.of(context).add),
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    BlocProvider.of<ShoppingCartBloc>(context).add(
                      CleanAddIngredients(
                          [
                            Ingredient(
                                name: ingredientNameController.text,
                                amount: double.parse(
                                    ingredientAmountController.text),
                                unit: ingredientUnitController.text)
                          ],
                          recipeNameController.text == ''
                              ? 'summary'
                              : recipeNameController.text),
                    );

                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
