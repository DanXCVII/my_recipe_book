// import 'package:buy_me_a_coffee_widget/buy_me_a_coffee_widget.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../generated/i18n.dart';
import '../widgets/dialogs/info_dialog.dart';

class AboutMeScreen extends StatelessWidget {
  const AboutMeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [Color(0xffAF1E1E), Color(0xff641414)],
        ),
        title: Text(I18n.of(context).about_me),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 18, 0, 8),
              child: ClipOval(
                child: Image.asset(
                  "images/icon.png",
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              I18n.of(context).recipe_bible,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            SizedBox(height: 10),
            OutlineButton.icon(
              icon: Icon(Icons.info_outline),
              label: Text("Disclaimer"),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => InfoDialog(
                    title: "disclaimer",
                    body: I18n.of(context).disclaimer_description,
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            Share.share(
                                I18n.of(context).share_this_app_desc(
                                    "http://play.google.com/store/apps/details?id=com.release.my_recipe_book"),
                                subject: I18n.of(context).share_this_app_title);
                          },
                          child: Container(
                            height: 160,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Center(
                                    child: Text(
                                      I18n.of(context).share_this_app,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 130,
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            Icon(MdiIcons.whatsapp, size: 30),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            Icon(MdiIcons.facebook, size: 30),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            Icon(MdiIcons.instagram, size: 30),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(MdiIcons.twitter, size: 30),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        child: InkWell(
                          onTap: () async {
                            if (await canLaunch(
                                "mailto:daniel.weissen.developer@gmail.com")) {
                              await launch(
                                  "mailto:daniel.weissen.developer@gmail.com");
                            }
                          },
                          child: Container(
                            height: 160,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Center(
                                    child: Text(
                                      I18n.of(context).contact_me,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 2,
                                          color: Theme.of(context)
                                                      .backgroundColor ==
                                                  Colors.white
                                              ? Colors.grey[500]
                                              : Colors.white)),
                                  child: Icon(Icons.mail, size: 40),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 1,
                      spreadRadius: 0.5,
                      color: Colors.black26,
                    ),
                  ],
                  color: Theme.of(context).backgroundColor == Colors.white
                      ? Colors.white
                      : Colors.grey[800],
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                width: 300,
                child: Center(
                  child: Text(
                    "If you want to show some 💖 and support future development😊",
                    textAlign: TextAlign.center,
                  ),
                )),
            SizedBox(
              height: 12,
            ),
            Container(
              width: 250.0, child: Container(),
              // BuyMeACoffeeWidget(
              //   sponsorID: "DanielDev",
              // ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "- MADE WITH ❤ IN MÜNSTER -",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            )
          ],
        ),
      ),
    );
  }
}
