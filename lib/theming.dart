
import 'package:flutter/material.dart';

enum MyThemeKeys { LIGHT, DARK }

class _CustomTheme extends InheritedWidget {
  final CustomThemeState data;

  _CustomTheme({
    this.data,
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_CustomTheme oldWidget) {
    return true;
  }
}

class CustomTheme extends StatefulWidget {
  final Widget child;
  final MyThemeKeys initialThemeKey;

  const CustomTheme({
    Key key,
    this.initialThemeKey,
    @required this.child,
  }) : super(key: key);

  @override
  CustomThemeState createState() => new CustomThemeState();

  static ThemeData of(BuildContext context) {
    _CustomTheme inherited =
        (context.inheritFromWidgetOfExactType(_CustomTheme) as _CustomTheme);
    return inherited.data.theme;
  }

  static CustomThemeState instanceOf(BuildContext context) {
    _CustomTheme inherited =
        (context.inheritFromWidgetOfExactType(_CustomTheme) as _CustomTheme);
    return inherited.data;
  }
}

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF790604), // maybe brown[700]
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Color(0xffFEF3E1),
    canvasColor: Colors.white,
    /* textSelectionColor: Colors.white,
         hintColor: Colors.white,
         textSelectionHandleColor: Colors.white, */
    iconTheme: IconThemeData(color: Colors.grey[700]),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Color(0xFF790604),
    brightness: Brightness.dark,
    backgroundColor: Color(0xff212225),
    scaffoldBackgroundColor: Color(0xff212225),
    accentColor: Colors.grey[800],
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;

      default:
        return lightTheme;
    }
  }
}

class CustomThemeState extends State<CustomTheme> {
  ThemeData _theme;

  ThemeData get theme => _theme;

  @override
  void initState() {
    _theme = MyThemes.getThemeFromKey(widget.initialThemeKey);
    super.initState();
  }

  void changeTheme(MyThemeKeys themeKey) {
    setState(() {
      _theme = MyThemes.getThemeFromKey(themeKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _CustomTheme(
      data: this,
      child: widget.child,
    );
  }
}
