import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_book/blocs/ad_manager/ad_manager_bloc.dart';
import 'package:my_recipe_book/widgets/dialogs/info_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ad_related/ad.dart';
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
          BlocListener<AdManagerBloc, AdManagerState>(
            listener: (context, state) {
              if (state is NotConnected) {
                _showInfoFlushBar(I18n.of(context).no_internet_connection,
                    I18n.of(context).no_internet_connection_desc, context);
              } else if (state is FailedLoadingRewardedVideo) {
                _showInfoFlushBar(I18n.of(context).failed_loading_ad,
                    I18n.of(context).failed_loading_ad_desc, context);
              }
            },
            child: BlocBuilder<AdManagerBloc, AdManagerState>(
                builder: (context, state) {
              if (state is IsPurchased) {
                return Container();
              } else {
                return Column(
                  children: <Widget>[
                    Divider(),
                    ListTile(
                        title: Text(
                          I18n.of(context).watch_video_remove_ads,
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        leading: Icon(Icons.movie),
                        trailing: state is ShowAds
                            ? null
                            : state is AdFreeUntil
                                ? Text(
                                    "${I18n.of(context).ad_free_until}:\n${state.time.hour}:" +
                                        (state.time.minute < 10
                                            ? "0${state.time.minute}"
                                            : "${state.time.minute}"),
                                    textAlign: TextAlign.center,
                                  )
                                : state is LoadingVideo
                                    ? CircularProgressIndicator()
                                    : state is FailedLoadingRewardedVideo
                                        ? Icon(Icons.cancel, color: Colors.red)
                                        : null,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => InfoDialog(
                              title: I18n.of(context).video_to_remove_ads,
                              body: I18n.of(context).video_to_remove_ads_desc,
                              onOk: () {
                                Navigator.pop(context);
                                BlocProvider.of<AdManagerBloc>(context)
                                    .add(StartWatchingVideo(DateTime.now()));
                              },
                              okText: I18n.of(context).watch,
                            ),
                          );
                        }),
                    Divider(),
                    ListTile(
                        title: Text(I18n.of(context).purchase_pro),
                        onTap: () {
                          BlocProvider.of<AdManagerBloc>(context)
                              .add(PurchaseProVersion());
                        })
                  ],
                );
              }
            }),
          ),
          Divider(),
          ListTile(
              title: Text(I18n.of(context).manage_nutritions),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.manageNutritions)
                    .then((_) => Ads.hideBottomBannerAd());
              }),
          Divider(),
          ListTile(
              title: Text(I18n.of(context).manage_ingredients),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.manageIngredients)
                    .then((_) => Ads.hideBottomBannerAd());
              }),
          Divider(),
          ListTile(
            onTap: () {
              _importSingleRecipe(context).then((_) {});
            },
            title: Text(I18n.of(context).import_recipe_s),
          ),
          Divider(),
          ListTile(
            title: Text(I18n.of(context).export_recipe_s),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ExportRecipes()));
            },
          ),
          Divider(),
          ListTile(
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
            title: Text(I18n.of(context).view_intro),
            onTap: () {
              Navigator.of(context).pushNamed(RouteNames.intro);
            },
          ),
          Divider(),
          ListTile(
              onTap: () {
                Navigator.pushNamed(context, RouteNames.aboutMe);
              },
              title: Text(I18n.of(context).about_me)),
          Divider(),
          ListTile(title: Text(I18n.of(context).rate_app)),
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

  void _showInfoFlushBar(String title, String body, BuildContext context) {
    Flushbar flush;
    flush = Flushbar<bool>(
      animationDuration: Duration(milliseconds: 300),
      leftBarIndicatorColor: Colors.blue[300],
      title: I18n.of(context).failed_loading_ad,
      message: I18n.of(context).failed_loading_ad_desc,
      icon: Icon(
        Icons.info_outline,
        color: Colors.blue,
      ),
      mainButton: FlatButton(
        onPressed: () {
          flush.dismiss(true); // result = true
        },
        child: Text(
          "OK",
          style: TextStyle(color: Colors.amber),
        ),
      ),
    )..show(context).then((result) {});
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
