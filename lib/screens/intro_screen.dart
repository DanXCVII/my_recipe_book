import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:my_recipe_book/constants/global_settings.dart';

import '../generated/i18n.dart';

class IntroScreen extends StatelessWidget {
  //making list of pages needed to pass in IntroViewsFlutter constructor.
  final TextStyle titleStyle = TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
  final TextStyle descStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      // List slides
      nameDoneBtn: I18n.of(context).done,
      nameNextBtn: I18n.of(context).next,
      namePrevBtn: I18n.of(context).back,
      widthSkipBtn: 130,
      nameSkipBtn: I18n.of(context).skip,
      slides: [
        Slide(
          title: I18n.of(context).choose_a_theme,
          maxLineTitle: 3,
          styleTitle: titleStyle.copyWith(color: Colors.black),
          styleDescription: descStyle,
          backgroundImage: "images/theme.png",
          backgroundImageFit: BoxFit.cover,
          backgroundOpacity: 0,
        ),
        Slide(
          title: I18n.of(context).swype_your_recipes,
          maxLineTitle: 3,
          styleTitle: titleStyle,
          description:
              I18n.of(context).if_you_cant_decide_random_recipe_explorer,
          styleDescription: descStyle,
          pathImage: "images/cards.png",
          colorBegin: Color(0xffE0CD1C),
          colorEnd: Color(0xffA07811),
          widthImage: MediaQuery.of(context).size.width / 2,
          heightImage: MediaQuery.of(context).size.height / 2.2,
        ),
        Slide(
          title: I18n.of(context).export_as_text_or_zip,
          maxLineTitle: 3,
          styleTitle: titleStyle,
          description: I18n.of(context).multiple_devices_use_export_as_zip_etc,
          styleDescription: descStyle,
          widthImage: MediaQuery.of(context).size.width / 1.3,
          pathImage: "images/export.png",
          colorBegin: Color(0xff00CCF9),
          colorEnd: Color(0xff0087A5),
        ),
        Slide(
          title: I18n.of(context).add_to_shoppingcart,
          maxLineTitle: 3,
          colorBegin: Color(0xff59CA00),
          colorEnd: Color(0xff347600),
          styleTitle: titleStyle,
          description:
              I18n.of(context).for_more_relaxed_shopping_add_to_shoppingcart,
          styleDescription: descStyle,
          widthImage: MediaQuery.of(context).size.width / 2,
          heightImage: MediaQuery.of(context).size.height / 3,
          pathImage: "images/bag.png",
        ),
        GlobalSettings().isFirstStart()
            ? Slide(
                title: I18n.of(context).first_start_recipes,
                maxLineTitle: 3,
                colorBegin: Color(0xff009EF8),
                colorEnd: Color(0xff0054B6),
                styleTitle: titleStyle,
                description: I18n.of(context).first_start_recipes_desc,
                styleDescription: descStyle,
                widthImage: MediaQuery.of(context).size.width / 2,
                heightImage: MediaQuery.of(context).size.height / 3,
                pathImage: "images/finishFlag.png",
              )
            : null,
      ]..removeWhere((item) => item == null),
      onDonePress: () {
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        Navigator.pop(context);
      },
    );
  }
}
