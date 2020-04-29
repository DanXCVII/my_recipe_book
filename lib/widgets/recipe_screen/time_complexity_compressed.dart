import 'package:flutter/material.dart';
import 'package:my_recipe_book/generated/i18n.dart';

import '../../util/helper.dart';

class TimeComplexityCompressed extends StatelessWidget {
  final double preperationTime;
  final double cookingTime;
  final double totalTime;
  final int effort;
  final String fontFamily;
  final bool showComplexity;

  const TimeComplexityCompressed(
    this.preperationTime,
    this.cookingTime,
    this.totalTime,
    this.effort,
    this.fontFamily, {
    this.showComplexity = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      runSpacing: 10,
      spacing: 10,
      children: <Widget>[
        (preperationTime != 0 || cookingTime != 0 || totalTime != 0)
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: Colors.grey[800]),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
                  child: Text(
                    _getTimeString(
                      preperationTime,
                      cookingTime,
                      totalTime,
                      context,
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: fontFamily,
                    ),
                  ),
                ),
              )
            : null,
        showComplexity
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: _getEffortColor(effort)),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
                  child: Text(
                    "${I18n.of(context).complexity}: $effort",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: fontFamily,
                    ),
                  ),
                ),
              )
            : null,
      ]..removeWhere((item) => item == null),
    );
  }

  Color _getEffortColor(int effort) {
    switch (effort) {
      case 1:
        return Color(0xff10C800);
      case 2:
        return Color(0xff10C800);
      case 3:
        return Color(0xff70C800);
      case 4:
        return Color(0xff70C800);
      case 5:
        return Color(0xffC8C000);
      case 6:
        return Color(0xffC8C000);
      case 7:
        return Color(0xffD27910);
      case 8:
        return Color(0xffE08315);
      case 9:
        return Color(0xffB94F4F);
      case 10:
        return Color(0xffBD4242);
      default:
        return null;
    }
  }

  String _getTimeString(double preperationTime, double cookingTime,
      double totalTime, BuildContext context) {
    if (totalTime != 0)
      return "${I18n.of(context).total_time}: " + cutDouble(totalTime);
    if (cookingTime != 0)
      return "${I18n.of(context).cook_time}: " + cutDouble(cookingTime);
    return "${I18n.of(context).prep_time}: " + cutDouble(preperationTime);
  }
}
