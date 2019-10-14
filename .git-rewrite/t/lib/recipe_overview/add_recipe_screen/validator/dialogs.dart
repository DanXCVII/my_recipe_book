import 'package:flutter/material.dart';
import 'package:my_recipe_book/generated/i18n.dart';


  void showIngredientsIncompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.of(context).check_ingredients_input),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          S.of(context).check_ingredients_input_description,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(S.of(context).alright),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void showIngredientsGlossaryIncomplete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.of(context).check_ingredient_section_fields),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content:
            Text(S.of(context).check_ingredient_section_fields_description),
        actions: <Widget>[
          FlatButton(
            child: Text(S.of(context).alright),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

void showRequiredFieldsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(S.of(context).check_filled_in_information),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Text(
        S.of(context).check_filled_in_information_description,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(S.of(context).alright),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    ),
  );
}

void showRecipeNameTakenDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(S.of(context).recipename_taken),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Text(
        S.of(context).recipename_taken_description,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(S.of(context).alright),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    ),
  );
}
