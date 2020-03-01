import 'package:flutter/material.dart';

class IconInfoMessage extends StatelessWidget {
  final Widget iconWidget;
  final String description;

  const IconInfoMessage({
    @required this.iconWidget,
    @required this.description,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor == Colors.white
                ? Color.fromRGBO(0, 0, 0, 0.4)
                : Color.fromRGBO(0, 0, 0, 0.5),
            shape: BoxShape.circle,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height / 800 * 80,
            child: iconWidget,
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).backgroundColor == Colors.white
                    ? Colors.grey[800]
                    : Colors.white),
          ),
        ),
      ],
    );
  }
}
