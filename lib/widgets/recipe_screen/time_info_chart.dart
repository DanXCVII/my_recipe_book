import 'package:flutter/material.dart';
import 'package:my_recipe_book/constants/global_settings.dart';
import 'package:my_recipe_book/generated/i18n.dart';

import '../../util/helper.dart';

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
      crossAxisAlignment: CrossAxisAlignment.center,
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
          getTimeHoursMinutes(totalTimeChart),
          style: TextStyle(
            color: textColor,
            fontFamily: fontFamily,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 7),
        Padding(
          padding: EdgeInsets.only(left: horizontal ? 0 : 8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  offset: Offset(2, 2),
                  blurRadius: 3,
                  spreadRadius: 1,
                  color: Colors.black26,
                ),
              ],
            ),
            child: ClipPath(
              clipper: horizontal
                  ? RoundRightLeftClipper()
                  : RoundTopBottomClipper(),
              child: TweenAnimationBuilder(
                duration: Duration(
                    milliseconds:
                        GlobalSettings().animationsEnabled() ? 700 : 0),
                curve: Curves.easeInOut,
                child: Stack(
                  alignment: horizontal
                      ? Alignment.centerLeft
                      : Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      height: horizontal ? 20 : null,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.yellow, Colors.yellow[800]]),
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
                          ? (cookingTime + preperationTime) /
                              totalTimeChart *
                              100
                          : null,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.blue, Colors.blue[800]]),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(horizontal ? 0 : 30),
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(horizontal ? 30 : 0)),
                      ),
                    ),
                    Container(
                      height: horizontal
                          ? 20
                          : preperationTime / totalTimeChart * 100,
                      width: horizontal
                          ? preperationTime / totalTimeChart * 100
                          : null,
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
