import 'package:flutter/material.dart';
import 'package:my_recipe_book/generated/i18n.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

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
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
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
            child: ClipOval(
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [Colors.red, Color(0xEEF44336)],
                    [Colors.red[800], Color(0x77E57373)],
                    [Colors.orange, Color(0x66FF9800)],
                    [Colors.yellow, Color(0x55FFEB3B)]
                  ],
                  durations: [35000, 19440, 10800, 6000],
                  heightPercentages: [
                    effort == 10 ? 0 : (9 - effort) / 10,
                    effort == 10 ? 0 : (9 - effort) / 10,
                    effort == 10 ? 0 : (9 - effort) / 10,
                    effort == 10 ? 0 : (9 - effort) / 10,
                  ],
                  blur: MaskFilter.blur(BlurStyle.solid, 10),
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 0,
                backgroundColor: Colors.blue,
                size: Size(
                  double.infinity,
                  double.infinity,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
