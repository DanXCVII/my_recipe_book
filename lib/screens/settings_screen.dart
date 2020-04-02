import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/blocs/shopping_cart/shopping_cart_bloc.dart';
import 'package:my_recipe_book/screens/import_from_website.dart';
import 'package:my_recipe_book/widgets/dialogs/info_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/import_recipe/import_recipe_bloc.dart';
import '../constants/routes.dart';
import '../generated/i18n.dart';
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
            leading: Icon(MdiIcons.export),
            trailing: IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => InfoDialog(
                    title: I18n.of(context).information,
                    body: I18n.of(context).info_export_description,
                  ),
                );
              },
            ),
            title: Text(I18n.of(context).export_recipe_s),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ExportRecipes()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.import),
            onTap: () {
              _importSingleRecipe(context).then((_) {});
            },
            title: Text(I18n.of(context).import_recipe_s),
          ),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.cloudDownload),
            title: Text(I18n.of(context).import_from_website),
            onTap: () {
              Navigator.pushNamed(context, RouteNames.importFromWebsite,
                  arguments: ImportFromWebsiteArguments(
                      BlocProvider.of<ShoppingCartBloc>(context)));
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(MdiIcons.nutrition),
              title: Text(I18n.of(context).manage_nutritions),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.manageNutritions);
              }),
          Divider(),
          ListTile(
              leading: Icon(MdiIcons.fruitPineapple),
              title: Text(I18n.of(context).manage_ingredients),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.manageIngredients);
              }),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.tag),
            title: Text(I18n.of(context).manage_recipe_tags),
            onTap: () {
              Navigator.pushNamed(context, RouteNames.manageRecipeTags);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.apps),
            title: Text(I18n.of(context).manage_categories),
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteNames.manageCategories,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.themeLightDark),
            title: Text(I18n.of(context).switch_theme),
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
                            color: Colors.grey[100],
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
                        color: Colors.grey[100],
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
          ListTile(
            leading: Icon(MdiIcons.compass),
            title: Text(I18n.of(context).view_intro),
            onTap: () {
              Navigator.of(context).pushNamed(RouteNames.intro);
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.info),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.aboutMe);
              },
              title: Text(I18n.of(context).about_me)),
          Divider(),
          ListTile(
              leading: Icon(Icons.star),
              title: Text(I18n.of(context).rate_app)),
          Divider(),
        ],
      ),
    );
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
              content: Text(I18n.of(context).snackbar_automatic_theme_applied),
              action: SnackBarAction(
                label: I18n.of(context).dismiss,
                onPressed: scaffold.hideCurrentSnackBar,
              ),
            ),
          );
          return;
        case MyThemeKeys.LIGHT:
          prefs.setInt('theme', 1);
          scaffold.showSnackBar(
            SnackBar(
              content: Text(I18n.of(context).snackbar_bright_theme_applied),
              action: SnackBarAction(
                label: I18n.of(context).dismiss,
                onPressed: scaffold.hideCurrentSnackBar,
              ),
            ),
          );
          return;
        case MyThemeKeys.DARK:
          prefs.setInt('theme', 2);
          scaffold.showSnackBar(
            SnackBar(
              content: Text(I18n.of(context).snackbar_dark_theme_applied),
              action: SnackBarAction(
                label: I18n.of(context).dismiss,
                onPressed: scaffold.hideCurrentSnackBar,
              ),
            ),
          );
          return;
        case MyThemeKeys.OLEDBLACK:
          prefs.setInt('theme', 3);
          scaffold.showSnackBar(
            SnackBar(
              content: Text(I18n.of(context).snackbar_midnight_theme_applied),
              action: SnackBarAction(
                label: I18n.of(context).dismiss,
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
          value: BlocProvider.of<ImportRecipeBloc>(ctxt)
            ..add(StartImportRecipes(File(_path),
                delay: Duration(milliseconds: 300))),
          child: ImportDialog()),
    );
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
