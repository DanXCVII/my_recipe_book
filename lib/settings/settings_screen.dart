import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:my_recipe_book/models/selected_index.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../intro_screen.dart';
import '../theming.dart';
import './import_recipe.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          ScopedModelDescendant<RecipeKeeper>(
            builder: (context, child, model) => GestureDetector(
              onTap: () {
                _importSingleRecipe(model).then((_) {});
              },
              child: ListTile(
                title: Text('import Recipe'),
              ),
            ),
          ),
          Divider(),
          ListTile(
            title: Text('switch theme'),
            trailing: Container(
              width: 130,
              height: 25,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _changeTheme(context, MyThemeKeys.AUTOMATIC);
                      });
                    },
                    child: Stack(
                      children: <Widget>[
                        ClipPath(
                          clipper: CustomLeftHalfClipper(),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 1,
                                  color:
                                      Theme.of(context).textTheme.body1.color),
                              color: Color(0xffFEF3E1),
                            ),
                          ),
                        ),
                        ClipPath(
                          clipper: CustomRightHalfClipper(),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 1,
                                  color:
                                      Theme.of(context).textTheme.body1.color),
                              color: Color(0xff454545),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _changeTheme(context, MyThemeKeys.LIGHT);
                      });
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context).textTheme.body1.color),
                        color: Color(0xffFEF3E1),
                      ),
                    ),
                  ),
                  Container(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _changeTheme(context, MyThemeKeys.DARK);
                      });
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context).textTheme.body1.color),
                        color: Color(0xff454545),
                      ),
                    ),
                  ),
                  Container(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // TODO: Maybe not nessesary to setState but probably it is. Check
                        _changeTheme(context, MyThemeKeys.OLEDBLACK);
                      });
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context).textTheme.body1.color),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          ScopedModelDescendant<MainPageNavigator>(
            builder: (context, child, model) => SwitchListTile(
              title: Text('switch shopping cart look'),
              value: model.showFancyShoppingList,
              onChanged: (value) {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setBool('showFancyShoppingList', value);
                  model.changeFancyShoppingList(value);
                });
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('view intro'),
            onTap: () {
              _pushViewIntroScreen();
            },
          ),
          Divider(),
          ListTile(title: Text('about me')),
          Divider(),
          ListTile(title: Text('rate this app')),
          Divider(),
        ],
      ),
    );
  }

  void _pushViewIntroScreen() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => IntroScreen(onDonePop: true)));
  }

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
    SharedPreferences.getInstance().then((prefs) {
      switch (key) {
        case MyThemeKeys.AUTOMATIC:
          prefs.setInt('theme', 0);
          return;
        case MyThemeKeys.LIGHT:
          prefs.setInt('theme', 1);
          return;
        case MyThemeKeys.DARK:
          prefs.setInt('theme', 2);
          return;
        case MyThemeKeys.OLEDBLACK:
          prefs.setInt('theme', 3);
          return;
        default:
      }
    });
  }

  Future<void> _importSingleRecipe(RecipeKeeper rKeeper) async {
    // Let the user select the .zip file
    String _path = await FilePicker.getFilePath(
        type: FileType.CUSTOM, fileExtension: 'zip');
    if (_path == null) return;
    importRecipe(rKeeper, _path);
  }
}

class CustomRightHalfClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = new Path()
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CustomLeftHalfClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = new Path()
      ..lineTo(0.0, size.height)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width / 2, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
