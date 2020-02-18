import 'package:flutter/material.dart';

import '../../generated/i18n.dart';

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
      content: Text(body),
      actions: <Widget>[
        FlatButton(
          child: Text(I18n.of(context).alright),
          textColor: Theme.of(context).backgroundColor == Colors.white
              ? null
              : Colors.amber,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
