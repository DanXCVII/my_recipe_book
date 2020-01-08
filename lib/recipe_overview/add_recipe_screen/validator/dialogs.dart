import 'package:flutter/material.dart';
import 'package:my_recipe_book/generated/i18n.dart';

class MyDialogs {
  static void showInfoDialog(String title, String body, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          body,
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
}
