import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/shopping_cart/shopping_cart_bloc.dart';
import '../blocs/website_import/website_import_bloc.dart';
import '../constants/routes.dart';
import '../generated/i18n.dart';
import '../widgets/icon_info_message.dart';
import 'add_recipe/general_info_screen/general_info_screen.dart';

class ImportFromWebsiteArguments {
  final ShoppingCartBloc shoppingCartBloc;

  ImportFromWebsiteArguments(this.shoppingCartBloc);
}

class ImportFromWebsiteScreen extends StatelessWidget {
  const ImportFromWebsiteScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: GradientAppBar(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [Color(0xffAF1E1E), Color(0xff641414)],
        ),
        title: Text(I18n.of(context).import_from_website_short),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("images/salatLowRes.jpg"),
              fit: BoxFit.cover,
            )),
            height: MediaQuery.of(context).size.height - kToolbarHeight,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: WebsiteSearch(),
                ),
                Spacer(),
                BlocListener<WebsiteImportBloc, WebsiteImportState>(
                  listener: (context, state) {
                    if (state is ImportedRecipe) {
                      imageCache.clear();
                      Navigator.pushNamed(
                        context,
                        RouteNames.addRecipeGeneralInfo,
                        arguments: GeneralInfoArguments(
                          state.recipe,
                          BlocProvider.of<ShoppingCartBloc>(context),
                        ),
                      );
                    }
                  },
                  child: BlocBuilder<WebsiteImportBloc, WebsiteImportState>(
                    builder: (context, state) {
                      if (state is ReadyToImport) {
                        return Container();
                      } else if (state is ImportedRecipe) {
                        return Container();
                      } else if (state is ImportingRecipe) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 100.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).backgroundColor ==
                                          Colors.white
                                      ? Colors.grey[100]
                                      : Colors.grey[900]),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CircularProgressIndicator(),
                              )),
                        );
                      } else if (state is AlreadyExists) {
                        return Container(
                          width: 300,
                          child: IconInfoMessage(
                            iconWidget: Icon(
                              MdiIcons.contentDuplicate,
                              color: Colors.lightBlue[100],
                              size: 70.0,
                            ),
                            description: I18n.of(context)
                                .recipe_already_exists(state.recipeName),
                            backgroundText: true,
                            textColor: Colors.white,
                          ),
                        );
                      } else if (state is FailedImportingRecipe) {
                        return Container(
                          width: 300,
                          child: IconInfoMessage(
                            iconWidget: Icon(
                              MdiIcons.alertCircle,
                              color: Colors.red,
                              size: 70.0,
                            ),
                            description: I18n.of(context)
                                .failed_to_import_recipe_unknown_reason,
                            backgroundText: true,
                            textColor: Colors.white,
                          ),
                        );
                      } else if (state is FailedToConnect) {
                        return Container(
                          width: 300,
                          child: IconInfoMessage(
                            iconWidget: Icon(
                              MdiIcons.flashCircle,
                              color: Colors.orange,
                              size: 70.0,
                            ),
                            description:
                                I18n.of(context).failed_to_connect_to_url,
                            backgroundText: true,
                            textColor: Colors.white,
                          ),
                        );
                      } else if (state is InvalidUrl) {
                        return Container(
                          width: 300,
                          child: IconInfoMessage(
                            iconWidget: Icon(
                              MdiIcons.messageAlertOutline,
                              color: Colors.red[800],
                              size: 70.0,
                            ),
                            description: I18n.of(context).invalid_url,
                            backgroundText: true,
                            textColor: Colors.white,
                          ),
                        );
                      }
                    },
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: RecipeWebsiteImportInfo()),
        ],
      ),
    );
  }
}

class WebsiteSearch extends StatefulWidget {
  WebsiteSearch({Key key}) : super(key: key);

  @override
  _WebsiteSearchState createState() => _WebsiteSearchState();
}

class _WebsiteSearchState extends State<WebsiteSearch> {
  TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).backgroundColor == Colors.white
            ? Colors.grey[100]
            : Colors.grey[800],
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).backgroundColor == Colors.white
                ? Colors.black12
                : Colors.black45,
            blurRadius: 2.0,
            spreadRadius: 1.0,
            offset: Offset(
              0,
              1.0,
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              I18n.of(context).enter_url,
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: I18n.of(context).recipe_url,
                border: OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: const BorderSide(
                    color: Colors.amber,
                    width: 2,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: const BorderSide(
                      color: Color.fromRGBO(210, 210, 210, 1), width: 2),
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: <Widget>[
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.yellow[800],
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      BlocProvider.of<WebsiteImportBloc>(context)
                          .add(ImportRecipe(_urlController.text));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(width: 12),
                        Icon(Icons.search),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 12, 15, 12),
                          child: Text(
                            "import",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RecipeWebsiteImportInfo extends StatefulWidget {
  RecipeWebsiteImportInfo({Key key}) : super(key: key);

  @override
  _RecipeWebsiteImportInfoState createState() =>
      _RecipeWebsiteImportInfoState();
}

class _RecipeWebsiteImportInfoState extends State<RecipeWebsiteImportInfo>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;
  List<String> _supportedWebsites = ["chefkoch.de"];
  List<String> _websiteUrls = ["https://www.chefkoch.de"];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor == Colors.white
          ? Colors.grey[100]
          : Colors.grey[800],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                child: Icon(
                  MdiIcons.lightbulbOutline,
                  size: 35,
                  color: Colors.amber,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 110,
                child: Text(I18n.of(context)
                    .website_must_be_under_the_supported_websites),
              ),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(_isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              )
            ],
          ),
          AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 150),
            curve: Curves.fastOutSlowIn,
            child: _isExpanded
                ? Container(
                    height: 150,
                    child: ListView(
                      children: List<Widget>.generate(
                        _supportedWebsites.length * 2 + 1,
                        (index) => index % 2 == 0 ||
                                index == (_supportedWebsites.length * 2 + 1)
                            ? Divider()
                            : ListTile(
                                title: RichText(
                                  text: TextSpan(
                                    text: _supportedWebsites[
                                        (index / 2).round() - 1],
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 16),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launch(_websiteUrls[
                                            (index / 2).round() - 1]);
                                      },
                                  ),
                                ),
                              ),
                      )..add(
                          ListTile(
                            title: Text(I18n.of(context).more_coming_soon),
                          ),
                        ),
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
