import 'package:flutter/material.dart';

import '../../generated/i18n.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String body;
  final String okText;
  final Function onOk;

  const InfoDialog({
    @required this.title,
    @required this.body,
    this.okText,
    this.onOk,
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
          child: okText == null ? Text(I18n.of(context).alright) : Text(okText),
          textColor: Theme.of(context).backgroundColor == Colors.white
              ? null
              : Colors.amber,
          onPressed: () {
            if (onOk == null) {
              Navigator.pop(context);
            }
            onOk();
          },
        )
      ],
    );
  }
}
