import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:my_recipe_book/blocs/ad_manager/ad_manager_bloc.dart';
import 'package:my_recipe_book/generated/i18n.dart';

class IngredinetSearchPreviewScreen extends StatelessWidget {
  const IngredinetSearchPreviewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [Color(0xffAF1E1E), Color(0xff641414)],
        ),
        title: Text(I18n.of(context).ingredient_search),
      ),
      body: Stack(
        children: <Widget>[
          Container(
              width: double.infinity,
              child:
                  Image.asset('images/tableVegetable.jpg', fit: BoxFit.cover)),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black38,
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.width * 1.4 + 60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Container(
                              height: MediaQuery.of(context).size.width * 1.4,
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                color: Color(0xff161616),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                              ),
                              child: Center(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width * 1.5 -
                                          30,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7 -
                                          20,
                                  child: Image.asset(
                                      "images/ingredient_search_preview.gif"),
                                ),
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 65,
                decoration: BoxDecoration(
                    color: Colors.green[800],
                    border: Border.all(color: Colors.green[900], width: 2)),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      BlocProvider.of<AdManagerBloc>(context)
                          .add(PurchaseProVersion());
                    },
                    child: Container(
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 22.0),
                              child: Icon(Icons.shopping_cart,
                                  color: Colors.white),
                            ),
                            Spacer(),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text('buy pro version',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    )),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  'du erhälst: Zutatenfilter, Entfernung der Werbung und \nUnterstützung zukünftiger Entwicklung',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: 35,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
