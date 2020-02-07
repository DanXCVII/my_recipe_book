import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/import_recipe/import_recipe_bloc.dart';
import '../generated/i18n.dart';
import '../intro_screen.dart';
import '../routes.dart';
import '../theming.dart';
import '../widgets/dialogs/import_dialog.dart';
import 'export_recipes_screen.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Divider(),
          ListTile(
              title: Text(S.of(context).manage_nutritions),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.manageNutritions);
              }),
          Divider(),
          GestureDetector(
            onTap: () {
              _importSingleRecipe(context).then((_) {});
            },
            child: ListTile(
              title: Text(S.of(context).import_recipe_s),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(S.of(context).export_recipe_s),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ExportRecipes()));
            },
          ),
          Divider(),
          ListTile(
            title: Text(S.of(context).switch_theme),
            trailing: Container(
              width: 130,
              height: 25,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _changeTheme(context, MyThemeKeys.AUTOMATIC);
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
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
                      _changeTheme(context, MyThemeKeys.LIGHT);
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
                      _changeTheme(context, MyThemeKeys.DARK);
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
                      _changeTheme(context, MyThemeKeys.OLEDBLACK);
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
          SwitchListTile(
            title: Text(S.of(context).switch_shopping_cart_look),
            value: true,
            onChanged: (value) {},
          ),
          Divider(),
          ListTile(
            title: Text(S.of(context).view_intro),
            onTap: () {
              _pushViewIntroScreen(context);
            },
          ),
          Divider(),
          ListTile(title: Text(S.of(context).about_me)),
          Divider(),
          ListTile(title: Text(S.of(context).rate_app)),
          Divider(),
        ],
      ),
    );
  }

  void _pushViewIntroScreen(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WillPopScope(
            onWillPop: () async {
              SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
              return true;
            },
            child: IntroScreen())));
  }

  void _changeTheme(BuildContext context, MyThemeKeys key) {
    CustomTheme.instanceOf(context).changeTheme(key);
    final scaffold = Scaffold.of(context);
    scaffold.hideCurrentSnackBar();
    SharedPreferences.getInstance().then((prefs) {
      switch (key) {
        case MyThemeKeys.AUTOMATIC:
          prefs.setInt('theme', 0);
          scaffold.showSnackBar(
            SnackBar(
              content: Text(S.of(context).snackbar_automatic_theme_applied),
              action: SnackBarAction(
                label: S.of(context).dismiss,
                onPressed: scaffold.hideCurrentSnackBar,
              ),
            ),
          );
          return;
        case MyThemeKeys.LIGHT:
          prefs.setInt('theme', 1);
          scaffold.showSnackBar(
            SnackBar(
              content: Text(S.of(context).snackbar_bright_theme_applied),
              action: SnackBarAction(
                label: S.of(context).dismiss,
                onPressed: scaffold.hideCurrentSnackBar,
              ),
            ),
          );
          return;
        case MyThemeKeys.DARK:
          prefs.setInt('theme', 2);
          scaffold.showSnackBar(
            SnackBar(
              content: Text(S.of(context).snackbar_dark_theme_applied),
              action: SnackBarAction(
                label: S.of(context).dismiss,
                onPressed: scaffold.hideCurrentSnackBar,
              ),
            ),
          );
          return;
        case MyThemeKeys.OLEDBLACK:
          prefs.setInt('theme', 3);
          scaffold.showSnackBar(
            SnackBar(
              content: Text(S.of(context).snackbar_midnight_theme_applied),
              action: SnackBarAction(
                label: S.of(context).dismiss,
                onPressed: scaffold.hideCurrentSnackBar,
              ),
            ),
          );
          return;
        default:
      }
    });
  }

  Future<void> _importSingleRecipe(BuildContext ctxt) async {
    // Let the user select the .zip file
    String _path = await FilePicker.getFilePath(
        type: FileType.CUSTOM, fileExtension: 'zip');

    if (_path == null) return;

    showDialog(
      context: ctxt,
      builder: (context) => BlocProvider<ImportRecipeBloc>.value(
          value: BlocProvider.of<ImportRecipeBloc>(ctxt),
          child: ImportDialog()),
    );
    BlocProvider.of<ImportRecipeBloc>(ctxt)
      ..add(
          StartImportRecipes(File(_path), delay: Duration(milliseconds: 300)));
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
