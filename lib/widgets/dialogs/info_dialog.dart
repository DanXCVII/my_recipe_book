import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../generated/i18n.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String body;
  final String okText;
  final Function onPressedOk;

  const InfoDialog({
    @required this.title,
    @required this.body,
    this.onPressedOk,
    this.okText,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Container(
          width: MediaQuery.of(context).size.width > 360 ? 360 : null,
          child: Text(body)),
      actions: <Widget>[
        FlatButton(
          child: okText == null ? Text(I18n.of(context).alright) : Text(okText),
          textColor: Theme.of(context).backgroundColor == Colors.white
              ? null
              : Colors.amber,
          onPressed: () {
            if (onPressedOk != null) {
              Navigator.pop(context);
              onPressedOk();
            } else {
              Navigator.pop(context);
            }
          },
        )
      ],
    );
  }
}
