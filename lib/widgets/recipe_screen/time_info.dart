import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/generated/i18n.dart';

import '../../helper.dart';

class TimeInfo extends StatelessWidget {
  final double preperationTime;
  final double cookingTime;
  final double totalTime;
  final String fontFamily;
  final Color textColor;

  const TimeInfo(
    this.textColor,
    this.fontFamily,
    this.preperationTime,
    this.totalTime,
    this.cookingTime, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double remainingTimeChart = 0;
    if (totalTime <= cookingTime + preperationTime)
      remainingTimeChart = 0;
    else
      remainingTimeChart = totalTime - cookingTime - preperationTime;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        preperationTime != 0
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
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
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      MdiIcons.knife,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${I18n.of(context).prep_time}:",
                        style: TextStyle(
                          color: textColor,
                          fontFamily: fontFamily,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        getTimeHoursMinutes(preperationTime),
                        style: TextStyle(
                          color: textColor,
                          fontFamily: fontFamily,
                          fontSize: 16,
                        ),
                      )
                    ],
                  )
                ]..removeWhere((item) => item == null))
            : null,
        SizedBox(height: 10),
        cookingTime != 0
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
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
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      MdiIcons.stove,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${I18n.of(context).cook_time}:",
                        style: TextStyle(
                          color: textColor,
                          fontFamily: fontFamily,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        getTimeHoursMinutes(cookingTime),
                        style: TextStyle(
                          color: textColor,
                          fontFamily: fontFamily,
                          fontSize: 16,
                        ),
                      )
                    ],
                  )
                ],
              )
            : null,
        SizedBox(height: 10),
        remainingTimeChart == 0
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Colors.yellow,
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
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.hourglass_empty,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  remainingTimeChart != 0
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${I18n.of(context).remaining_time}:",
                              style: TextStyle(
                                color: textColor,
                                fontFamily: fontFamily,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              getTimeHoursMinutes(remainingTimeChart),
                              style: TextStyle(
                                color: textColor,
                                fontFamily: fontFamily,
                                fontSize: 16,
                              ),
                            )
                          ],
                        )
                      : null
                ]..removeWhere((item) => item == null))
      ]..removeWhere((item) => item == null),
    );
  }
}
