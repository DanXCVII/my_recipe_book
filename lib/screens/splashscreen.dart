import 'package:flutter/material.dart';
import 'package:my_recipe_book/ad_related/ad.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Not nice but don't know any alternative yet
    double deviceWidth = MediaQuery.of(context).size.width;
    if (deviceWidth >= 468) {
      Ads.showWideBannerAds();
    }
    return Container(
      color: Colors.amber,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/cookingHat.png',
            fit: BoxFit.cover,
            height: 150,
          ),
        ],
      )),
    );
  }
}
