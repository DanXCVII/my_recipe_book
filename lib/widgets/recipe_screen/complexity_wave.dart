import 'package:flutter/material.dart';

import '../../generated/i18n.dart';

class ComplexityWave extends StatelessWidget {
  final Color textColor;
  final String fontFamily;
  final int effort;

  const ComplexityWave(
    this.textColor,
    this.fontFamily,
    this.effort, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(I18n.of(context).complexity + ':',
            style: TextStyle(
              fontSize: 15,
              color: textColor,
              fontFamily: fontFamily,
            )),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 2.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      0,
                      1.0,
                    ),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  effort.toString(),
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.grey[100],
                    fontWeight: FontWeight.w600,
                    fontFamily: "Questrial",
                  ),
                ),
              )),
        )
      ],
    );
  }
}
