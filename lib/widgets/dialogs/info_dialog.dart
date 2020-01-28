import 'package:flutter/material.dart';
import 'package:my_recipe_book/generated/i18n.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String body;

  const InfoDialog({
    @required this.title,
    @required this.body,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
    );
  }
}
