import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:page_transition/page_transition.dart';

import 'main.dart';

class IntroScreen extends StatelessWidget {
  final bool recipeCatOverview;

  IntroScreen(this.recipeCatOverview);

  //making list of pages needed to pass in IntroViewsFlutter constructor.
  final pages = [
    PageViewModel(
      pageColor: const Color(0xFF607D8B),
      iconImageAssetPath: 'images/key.png',
      body: Text(
        'Your data is securely saved on your device and will NEVER leave it!',
        style: TextStyle(fontSize: 30),
      ),
      title: Text(
        'Secure',
        style: TextStyle(fontSize: 60),
      ),
      mainImage: Image.asset(
        'images/lock.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.white, fontFamily: 'Rancho'),
    ),
    PageViewModel(
      pageColor: const Color(0xFF953A55),
      iconImageAssetPath: 'images/spielfigur.png',
      body: Text(
        'With the random recipe explorer, you can tinder swype you recipes.',
        style: TextStyle(fontSize: 30),
      ),
      title: Text(
        'Have fun ;)',
        style: TextStyle(fontSize: 60),
      ),
      mainImage: Image.asset(
        'images/dices.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.white, fontFamily: 'Rancho'),
    ),
    PageViewModel(
      pageColor: const Color(0xFFA33E3E),
      iconImageAssetPath: 'images/postbox.png',
      body: Text(
        'Easily share and export your recipes as .zip file.',
        style: TextStyle(fontSize: 30),
      ),
      title: Text(
        'import/export',
        style: TextStyle(fontSize: 60),
      ),
      mainImage: Image.asset(
        'images/letter.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.white, fontFamily: 'Rancho'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      pages,
      onTapDoneButton: () {
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        Navigator.of(context).pushReplacement(PageTransition(
            type: PageTransitionType.fade,
            child: MyHomePage(recipeCatOverview)));
      },
      pageButtonTextStyles: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
    );
  }
}
