import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/intro_slider.dart';

class IntroScreen extends StatelessWidget {
  //making list of pages needed to pass in IntroViewsFlutter constructor.

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      // List slides
      slides: [
        Slide(
          title: "SECURE",
          styleTitle: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono'),
          description:
              "Your data is securely saved on your device and will NEVER leave it!",
          styleDescription: TextStyle(
              color: Colors.white, fontSize: 20.0, fontFamily: 'Raleway'),
          pathImage: "images/lock.png",
        ),
        Slide(
          title: "ENJOY",
          backgroundColor: Colors.lightBlue,
          styleTitle: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono'),
          description:
              "With the random recipe explorer, you can tinder swype you recipes.",
          styleDescription: TextStyle(
              color: Colors.white, fontSize: 20.0, fontFamily: 'Raleway'),
          pathImage: "images/dices.png",
        ),
        Slide(
          title: "IMPORT/EXPORT",
          backgroundColor: Colors.orange,
          styleTitle: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono'),
          description: "Easily share and export your recipes as .zip file.",
          styleDescription: TextStyle(
              color: Colors.white, fontSize: 20.0, fontFamily: 'Raleway'),
          pathImage: "images/letter.png",
        ),
      ],
      onDonePress: () {
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        Navigator.pop(context);
      },
    );
  }
}
