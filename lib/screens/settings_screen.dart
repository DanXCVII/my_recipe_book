import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ad_related/ad.dart';
import '../blocs/ad_manager/ad_manager_bloc.dart';
import '../blocs/import_recipe/import_recipe_bloc.dart';
import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../constants/global_constants.dart' as Constants;
import '../constants/global_settings.dart';
import '../constants/routes.dart';
import '../generated/i18n.dart';
import '../theming.dart';
import '../widgets/dialogs/import_dialog.dart';
import '../widgets/dialogs/info_dialog.dart';
import 'export_recipes_screen.dart';
import 'import_from_website.dart';

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
                        leading: Icon(
                          MdiIcons.crown,
                          color: Colors.amber,
                        ),
                        title: Text(I18n.of(context).purchase_pro),
                        onTap: () {
                          BlocProvider.of<AdManagerBloc>(context)
                              .add(PurchaseProVersion());
                        }),
                    Divider(),
                    ListTile(
                        title: Text(
                          I18n.of(context).watch_video_remove_ads,
                          style: Theme.of(context).textTheme.subtitle1,
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
                              onPressedOk: () {
                                BlocProvider.of<AdManagerBloc>(context)
                                    .add(StartWatchingVideo(
                                  DateTime.now(),
                                  true,
                                  true,
                                ));
                              },
                              okText: I18n.of(context).watch,
                            ),
                          );
                        }),
                  ],
                );
              }
            }),
          ),
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
            trailing: IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => InfoDialog(
                    title: I18n.of(context).info,
                    body: I18n.of(context).import_recipe_description,
                  ),
                );
              },
            ),
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
              BlocProvider.of<AdManagerBloc>(context).add(LoadVideo());
              Navigator.pushNamed(context, RouteNames.importFromWebsite,
                  arguments: ImportFromWebsiteArguments(
                    BlocProvider.of<ShoppingCartBloc>(context),
                    BlocProvider.of<AdManagerBloc>(context),
                  )).then((_) => Ads.hideBottomBannerAd());
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.laptop),
            title: Text(I18n.of(context).import_pc_title_info),
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteNames.computerImportInfo,
              );
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(MdiIcons.nutrition),
              title: Text(I18n.of(context).manage_nutritions),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.manageNutritions)
                    .then((_) => Ads.hideBottomBannerAd());
              }),
          Divider(),
          ListTile(
              leading: Icon(MdiIcons.fruitPineapple),
              title: Text(I18n.of(context).manage_ingredients),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.manageIngredients)
                    .then((_) => Ads.hideBottomBannerAd());
              }),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.tag),
            title: Text(I18n.of(context).manage_recipe_tags),
            onTap: () {
              Navigator.pushNamed(context, RouteNames.manageRecipeTags)
                  .then((_) => Ads.hideBottomBannerAd());
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
              ).then((_) => Ads.hideBottomBannerAd());
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.powerStandby),
            trailing: DisableStandbyCheckbox(),
            title: Text(I18n.of(context).keep_screen_on),
            subtitle: Text(I18n.of(context).only_recipe_screen),
          ),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.animation),
            trailing: AnimationCheckbox(),
            title: Text(I18n.of(context).complex_animations),
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
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .color),
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
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .color),
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
                            color: Theme.of(context).textTheme.bodyText2.color),
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
                            color: Theme.of(context).textTheme.bodyText2.color),
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
                            color: Theme.of(context).textTheme.bodyText2.color),
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
              onTap: () {
                launch(
                    "http://play.google.com/store/apps/details?id=com.release.my_recipe_book");
              },
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

  void _showInfoFlushBar(String title, String body, BuildContext context) {
    Flushbar flush;
    flush = Flushbar<bool>(
      margin: EdgeInsets.only(bottom: Ads.shouldShowAds() ? Ads.adHeight : 0),
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
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.any);
    String _path;

    _path = result.files.single.path;

    if (_path == null) return;

    showDialog(
      context: ctxt,
      builder: (context) => BlocProvider<ImportRecipeBloc>.value(
          value: BlocProvider.of<ImportRecipeBloc>(ctxt)
            ..add(StartImportRecipes(File(_path),
                delay: Duration(milliseconds: 1000))),
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

class DisableStandbyCheckbox extends StatefulWidget {
  DisableStandbyCheckbox({Key key}) : super(key: key);

  @override
  _DisableStandbyCheckboxState createState() => _DisableStandbyCheckboxState();
}

class _DisableStandbyCheckboxState extends State<DisableStandbyCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: GlobalSettings().standbyDisabled(),
      onChanged: (value) {
        SharedPreferences.getInstance().then((prefs) {
          setState(() {
            prefs.setBool(Constants.disableStandby, value);
            GlobalSettings().disableStandby(value);
          });
        });
      },
    );
  }
}

class AnimationCheckbox extends StatefulWidget {
  AnimationCheckbox({Key key}) : super(key: key);

  @override
  _AnimationCheckboxState createState() => _AnimationCheckboxState();
}

class _AnimationCheckboxState extends State<AnimationCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: GlobalSettings().animationsEnabled(),
      onChanged: (value) {
        SharedPreferences.getInstance().then((prefs) {
          setState(() {
            prefs.setBool(Constants.enableAnimations, value);
            GlobalSettings().enableAnimations(value);
          });
        });
      },
    );
  }
}
