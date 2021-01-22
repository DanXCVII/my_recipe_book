import 'package:flutter/material.dart';
import 'package:my_recipe_book/generated/i18n.dart';

class AreYouSureDialog extends StatelessWidget {
  final String title;
  final String description;
  final Function onPressedYes;

  const AreYouSureDialog(
    this.title,
    this.description,
    this.onPressedYes, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Container(
          width: MediaQuery.of(context).size.width > 360 ? 360 : null,
          child: Text(description),
        ),
        actions: <Widget>[
          FlatButton(
              child: Text(I18n.of(context).no),
              textColor: Theme.of(context).textTheme.bodyText1.color,
              onPressed: () {
                Navigator.pop(context);
              }),
          FlatButton(
              child: Text(I18n.of(context).yes),
              textColor: Theme.of(context).textTheme.bodyText1.color,
              color: Colors.red,
              onPressed: () {
                onPressedYes();
              }),
        ]);
  }
}
