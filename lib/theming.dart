import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/culinary_editorial_theme.dart';

enum MyThemeKeys { AUTOMATIC, LIGHT, DARK, OLEDBLACK }

class _CustomTheme extends InheritedWidget {
  final CustomThemeState? data;

  _CustomTheme({this.data, Key? key, required Widget child})
    : super(key: key, child: child);

  @override
  bool updateShouldNotify(_CustomTheme oldWidget) {
    return true;
  }
}

class CustomTheme extends StatefulWidget {
  final Widget child;
  final MyThemeKeys? initialThemeKey;

  const CustomTheme({Key? key, this.initialThemeKey, required this.child})
    : super(key: key);

  @override
  CustomThemeState createState() => new CustomThemeState();

  static ThemeData? of(BuildContext context) {
    _CustomTheme inherited = context
        .dependOnInheritedWidgetOfExactType<_CustomTheme>()!;
    return inherited.data!.theme;
  }

  static CustomThemeState? instanceOf(BuildContext context) {
    _CustomTheme inherited = context
        .dependOnInheritedWidgetOfExactType<_CustomTheme>()!;
    return inherited.data;
  }
}

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: CulinaryEditorialPalette.light.primary,

    scaffoldBackgroundColor: Colors.grey[200],
    canvasColor: Colors.white,
    // cardColor: Color(0xffFFE8C2),
    focusColor: Colors.grey[800],
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: CulinaryEditorialPalette.light.primary,
      onPrimary: CulinaryEditorialPalette.light.onPrimary,
      secondary: Colors.orange[700],
      brightness: Brightness.light,
      surface: Colors.white,
    ),
    filledButtonTheme: _primaryButtonTheme(CulinaryEditorialPalette.light),
    //  textSelectionColor: Colors.white,
    //      hintColor: Colors.white,
    //      textSelectionHandleColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.grey[700]),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: CulinaryEditorialPalette.dark.primary,
    unselectedWidgetColor: Colors.grey[100],
    appBarTheme: AppBarTheme(
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(
      displayMedium: TextStyle(color: Colors.grey[400]),
      titleMedium: TextStyle(color: Colors.grey[100]),
    ),
    cardColor: Color(0xff34363D),
    focusColor: Colors.white,
    scaffoldBackgroundColor: Color(0xff212225),
    colorScheme: ThemeData().colorScheme.copyWith(
      primary: CulinaryEditorialPalette.dark.primary,
      onPrimary: CulinaryEditorialPalette.dark.onPrimary,
      secondary: Colors.orange[700],
      brightness: Brightness.dark,
      surface: Color(0xff212225),
    ),
    filledButtonTheme: _primaryButtonTheme(CulinaryEditorialPalette.dark),
  );

  static final ThemeData oledblackTheme = ThemeData(
    primaryColor: CulinaryEditorialPalette.oled.primary,
    snackBarTheme: SnackBarThemeData(
      actionBackgroundColor: Colors.red,
      backgroundColor: Colors.red,
      disabledActionTextColor: Colors.red,
      disabledActionBackgroundColor: Colors.red,
    ),
    appBarTheme: AppBarTheme(
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: TextTheme(titleMedium: TextStyle(color: Colors.grey[100])),
    unselectedWidgetColor: Colors.grey[100],
    cardColor: Color(0xff34363D),
    focusColor: Colors.white,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: CulinaryEditorialPalette.oled.primary,
      onPrimary: CulinaryEditorialPalette.oled.onPrimary,
      secondary: Colors.orange[700],
      brightness: Brightness.dark,
      surface: Colors.black,
    ),
    filledButtonTheme: _primaryButtonTheme(CulinaryEditorialPalette.oled),
  );

  static ThemeData getThemeFromKey(MyThemeKeys? themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      case MyThemeKeys.OLEDBLACK:
        return oledblackTheme;

      default:
        return lightTheme;
    }
  }
}

FilledButtonThemeData _primaryButtonTheme(CulinaryEditorialPalette palette) {
  return FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size(0, 52),
      disabledBackgroundColor: palette.surfaceContainerHigh,
      disabledForegroundColor: palette.onSurfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: CulinaryEditorialType.body(
        palette,
        size: 14,
        weight: FontWeight.w700,
      ),
    ),
  );
}

class CustomThemeState extends State<CustomTheme> {
  ThemeData? _theme;
  MyThemeKeys? _currentTheme;

  ThemeData? get theme => _theme;

  @override
  void initState() {
    _currentTheme = widget.initialThemeKey;
    _theme = MyThemes.getThemeFromKey(widget.initialThemeKey);
    super.initState();
  }

  void changeTheme(MyThemeKeys themeKey) {
    setState(() {
      _currentTheme = themeKey;
      _theme = MyThemes.getThemeFromKey(themeKey);
    });
  }

  MyThemeKeys? getCurrentTheme() {
    return _currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    return new _CustomTheme(data: this, child: widget.child);
  }
}
