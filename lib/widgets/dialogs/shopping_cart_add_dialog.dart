import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/generated/l10n.dart';
import '../../util/helper.dart';
import '../../local_storage/hive.dart';
import '../../models/ingredient.dart';
import '../../screens/add_recipe/general_info_screen/categories_section.dart';

class ShoppingCartAddDialog extends StatelessWidget {
  const ShoppingCartAddDialog({Key? key}) : super(key: key);

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
          child: ShoppingCartAddDialogContent(),
        ),
      ),
    );
  }
}

class ShoppingCartAddDialogContent extends StatefulWidget {
  final focus = FocusNode();

  ShoppingCartAddDialogContent({Key? key}) : super(key: key);

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
  initState() {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              S.of(context).add_ingredient(""),
              style: Theme.of(context).textTheme.titleLarge,
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
              Form(
                key: formKey,
                child: AnimatedSize(
                  duration: Duration(milliseconds: 150),
                  curve: Curves.fastOutSlowIn,
                  child: isExpanded
                      ? Column(
                          children: <Widget>[
                            TextFormField(
                              controller: recipeNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: S.of(context).recipe_name,
                              ),
                            ),
                            Container(height: 3),
                            Divider(),
                            Container(height: 3),
                            SimpleAutoCompleteTextField(
                              key: autoCompletionTextField,
                              suggestions: HiveProvider().getIngredientNames(),
                              controller: ingredientNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: S.of(context).ingredient,
                              ),
                              textCapitalization:
                                  S.of(context).two_char_locale == "EN"
                                      ? TextCapitalization.none
                                      : TextCapitalization.sentences,
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                    controller: ingredientAmountController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: S.of(context).amnt,
                                    ),
                                    validator: (value) {
                                      if (value == "" ||
                                          getDoubleFromString(value!) != null) {
                                        return null;
                                      }
                                      return S.of(context).no_valid_number;
                                    },
                                  ),
                                ),
                                Container(width: 6),
                                Expanded(
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
                        )
                      : SimpleAutoCompleteTextField(
                          key: autoCompletionTextField,
                          focusNode: widget.focus,
                          suggestions: HiveProvider().getIngredientNames(),
                          controller: ingredientNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: S.of(context).ingredient,
                          ),
                          textCapitalization:
                              S.of(context).two_char_locale == "EN"
                                  ? TextCapitalization.none
                                  : TextCapitalization.sentences,
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
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(width: 6),
            TextButton(
              child: Text(
                S.of(context).add,
                style: TextStyle(color: Colors.black),
              ),
              style: TextButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.background == Colors.white
                        ? null
                        : Colors.amber,
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  BlocProvider.of<ShoppingCartBloc>(context).add(
                    CleanAddIngredients(
                        [
                          Ingredient(
                              name: ingredientNameController.text,
                              amount: ingredientAmountController.text == ""
                                  ? null
                                  : getDoubleFromString(
                                      ingredientAmountController.text),
                              unit: ingredientUnitController.text)
                        ],
                        recipeNameController.text == ''
                            ? "summary"
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
