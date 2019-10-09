import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:my_recipe_book/theming.dart';

import 'generated/i18n.dart';

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
    MyThemeKeys _initialTheme =
        CustomTheme.instanceOf(context).getCurrentTheme();

    return IntroSlider(
      // List slides
      slides: [
        Slide(
          title: S.of(context).the_data_is_YOURS,
          colorBegin: Color(0xff7B7B7B),
          colorEnd: Color(0xff252525),
          styleTitle: titleStyle,
          description:
              S.of(context).data_will_never_leave_your_device,
          styleDescription: descStyle,
          pathImage: "images/shield.png",
          widthImage: MediaQuery.of(context).size.width / 2,
          heightImage: MediaQuery.of(context).size.height / 2.2,
        ),
        Slide(
          title: S.of(context).choose_a_theme,
          styleTitle: titleStyle.copyWith(color: Colors.black),
          
          widgetDescription: Container(
            child: ThemeSelector(
              initialTheme: _initialTheme,
            ),
            height: MediaQuery.of(context).size.height - 360,
          ),
          styleDescription: descStyle,
          backgroundImage: "images/theme.png",
          backgroundImageFit: BoxFit.cover,
          backgroundOpacity: 0,
        ),
        Slide(
          title: S.of(context).swype_your_recipes,
          styleTitle: titleStyle,
          description:
              S.of(context).if_you_cant_decide_random_recipe_explorer,
          styleDescription: descStyle,
          pathImage: "images/cards.png",
          colorBegin: Color(0xffE0CD1C),
          colorEnd: Color(0xffA07811),
          widthImage: MediaQuery.of(context).size.width / 2,
          heightImage: MediaQuery.of(context).size.height / 2.2,
        ),
        Slide(
          title: S.of(context).export_as_text_or_zip,
          styleTitle: titleStyle,
          description:
              S.of(context).multiple_devices_use_export_as_zip_etc,
          styleDescription: descStyle,
          heightImage: MediaQuery.of(context).size.height / 2.2,
          pathImage: "images/export.png",
          colorBegin: Color(0xff00CCF9),
          colorEnd: Color(0xff0087A5),
        ),
        Slide(
          title: S.of(context).add_to_shoppingcart,
          colorBegin: Color(0xff59CA00),
          colorEnd: Color(0xff347600),
          styleTitle: titleStyle,
          description:
              S.of(context).for_more_relaxed_shopping_add_to_shoppingcart,
          styleDescription: descStyle,
          widthImage: MediaQuery.of(context).size.width / 2,
          heightImage: MediaQuery.of(context).size.height / 3,
          pathImage: "images/bag.png",
        ),
      ],
      onDonePress: () {
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        Navigator.pop(context);
      },
    );
  }
}

class ThemeSelector extends StatefulWidget {
  final initialTheme;

  ThemeSelector({this.initialTheme, Key key}) : super(key: key);

  _ThemeSelectorState createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  MyThemeKeys _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.initialTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: _selectedTheme == MyThemeKeys.LIGHT
                ? Icon(
                    GroovinMaterialIcons.check_circle,
                    color: Colors.green,
                  )
                : Icon(
                    GroovinMaterialIcons.circle_outline,
                    color: Colors.grey[300],
                  ),
            onPressed: () {
              _handleValueChange(MyThemeKeys.LIGHT, context);
            },
            iconSize: 60,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: IconButton(
              icon: _selectedTheme == MyThemeKeys.DARK
                  ? Icon(
                      GroovinMaterialIcons.check_circle,
                      color: Colors.green,
                    )
                  : Icon(
                      GroovinMaterialIcons.circle_outline,
                      color: Colors.grey[300],
                    ),
              onPressed: () {
                _handleValueChange(MyThemeKeys.DARK, context);
              },
              iconSize: 60,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: _selectedTheme == MyThemeKeys.OLEDBLACK
                ? Icon(
                    GroovinMaterialIcons.check_circle,
                    color: Colors.green,
                  )
                : Icon(
                    GroovinMaterialIcons.circle_outline,
                    color: Colors.grey[300],
                  ),
            onPressed: () {
              _handleValueChange(MyThemeKeys.OLEDBLACK, context);
            },
            iconSize: 60,
          ),
        ),
      ],
    );
  }

  _handleValueChange(MyThemeKeys value, BuildContext context) {
    MyThemeKeys key;
    CustomTheme.instanceOf(context).changeTheme(key);

    setState(() {
      _selectedTheme = value;
    });
  }
}
