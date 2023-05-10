import 'package:flutter/material.dart';
import '../../generated/i18n.dart';

class AreYouSureDialog extends StatelessWidget {
  final String title;
  final String description;
  final Function onPressedYes;

  const AreYouSureDialog(
    this.title,
    this.description,
    this.onPressedYes, {
    Key? key,
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
          TextButton(
              child: Text(I18n.of(context)!.no),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          TextButton(
              child: Text(I18n.of(context)!.yes),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                onPressedYes();
              }),
        ]);
  }
}
