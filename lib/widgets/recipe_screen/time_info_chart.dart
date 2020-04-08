import 'package:flutter/material.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:my_recipe_book/screens/recipe_screen/recipe_screen.dart';

import '../../helper.dart';

class TimeInfoChart extends StatelessWidget {
  final Color textColor;
  final double preperationTime;
  final double cookingTime;
  final double totalTime;
  final bool horizontal;

  final String fontFamily;

  const TimeInfoChart(
    this.textColor,
    this.preperationTime,
    this.cookingTime,
    this.totalTime,
    this.fontFamily, {
    this.horizontal = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalTimeChart = 0;
    if (totalTime >= preperationTime + cookingTime)
      totalTimeChart = totalTime;
    else
      totalTimeChart = preperationTime + cookingTime;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "${I18n.of(context).total_time}:",
          style: TextStyle(
            color: textColor,
            fontFamily: fontFamily,
            fontSize: 12,
          ),
        ),
        Text(
          getTimeHoursMinutes(totalTime),
          style: TextStyle(
            color: textColor,
            fontFamily: fontFamily,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 7),
        Padding(
          padding: EdgeInsets.only(left: horizontal ? 0 : 8.0),
          child: ClipPath(
            clipper:
                horizontal ? RoundRightLeftClipper() : RoundTopBottomClipper(),
            child: TweenAnimationBuilder(
              duration: Duration(milliseconds: 700),
              curve: Curves.easeInOut,
              child: Stack(
                alignment:
                    horizontal ? Alignment.centerLeft : Alignment.bottomCenter,
                children: <Widget>[
                  Container(
                    height: 20,
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
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(horizontal ? 0 : 30),
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(horizontal ? 30 : 0)),
                      color: Colors.yellow,
                    ),
                  ),
                  Container(
                    height: horizontal
                        ? 20
                        : (cookingTime + preperationTime) /
                            totalTimeChart *
                            100,
                    width: horizontal
                        ? (cookingTime + preperationTime) / totalTimeChart * 100
                        : null,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(horizontal ? 0 : 30),
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(horizontal ? 30 : 0)),
                      color: Colors.blue,
                    ),
                  ),
                  Container(
                    height: horizontal ? 20 : preperationTime / totalTime * 100,
                    width:
                        horizontal ? preperationTime / totalTime * 100 : null,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(horizontal ? 0 : 30),
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(horizontal ? 30 : 0)),
                      color: Colors.pink,
                    ),
                  )
                ],
              ),
              tween: Tween<double>(begin: 10, end: 100),
              builder: (_, double animatedSize, myChild) => Column(
                children: <Widget>[
                  Container(
                      height: horizontal ? null : 100 - animatedSize,
                      width: horizontal ? 100 - animatedSize : 20),
                  Container(
                      width: horizontal ? animatedSize : 20,
                      height: horizontal ? null : animatedSize,
                      child: myChild),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RoundTopBottomClipper extends CustomClipper<Path> {
  RoundTopBottomClipper();

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.width / 2)
      ..arcToPoint(
        Offset(size.width, size.width / 2),
        clockwise: true,
        radius: Radius.circular(size.width / 2),
      )
      ..lineTo(size.width, size.height - size.width / 2)
      ..arcToPoint(
        Offset(0, size.height - size.width / 2),
        clockwise: true,
        radius: Radius.circular(size.width / 2),
      )
      ..lineTo(0, size.width / 2);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(RoundTopBottomClipper oldClipper) => true;
}

class RoundRightLeftClipper extends CustomClipper<Path> {
  RoundRightLeftClipper();

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(size.height / 2, 0)
      ..arcToPoint(
        Offset(size.height / 2, size.height),
        clockwise: false,
        radius: Radius.circular(size.height / 2),
      )
      ..lineTo(size.width - size.height / 2, size.height)
      ..arcToPoint(
        Offset(size.width - size.height / 2, 0),
        clockwise: false,
        radius: Radius.circular(size.height / 2),
      )
      ..lineTo(size.height / 2, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(RoundRightLeftClipper oldClipper) => true;
}
