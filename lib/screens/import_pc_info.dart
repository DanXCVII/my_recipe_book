import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import '../generated/i18n.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/gestures.dart';

class ImportPcInfo extends StatelessWidget {
  const ImportPcInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFamily: "Roboto",
    );

    return Scaffold(
      appBar: NewGradientAppBar(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [Color(0xffAF1E1E), Color(0xff641414)],
        ),
        title: Text(I18n.of(context)!.import_from_website_short),
      ),
      body: ListView(
        padding: EdgeInsets.all(22),
        children: [
          Text(
            I18n.of(context)!.recipe_import_pc_title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 22,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: I18n.of(context)!.visit, style: style),
                TextSpan(
                  text: "https://danxcvii.github.io/#/ ",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Roboto",
                    color: Colors.blue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(Uri.parse('https://danxcvii.github.io/#/'));
                    },
                ),
                TextSpan(
                  style: style,
                  text: I18n.of(context)!.import_computer_info,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
