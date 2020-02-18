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
    return AlertDialog(
      title: Text(I18n.of(context).add_to_cart),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: <Widget>[
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
                          amount: double.parse(ingredientAmountController.text),
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
      content: Container(
        width: MediaQuery.of(context).size.width > 350
            ? 350
            : MediaQuery.of(context).size.width * 0.9,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: recipeNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: I18n.of(context).recipe_name,
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
                        labelText: I18n.of(context).ingredient,
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
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
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
    );
  }
}
