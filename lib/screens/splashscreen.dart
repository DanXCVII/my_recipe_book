import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:my_recipe_book/blocs/splash_screen/splash_screen_bloc.dart';

import '../ad_related/ad.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  SequenceAnimation _sequenceAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
    );

    _sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 1),
            from: Duration(milliseconds: 0),
            to: Duration(milliseconds: 700),
            tag: "first")
        .addAnimatable(
            animatable: Tween<double>(begin: 1, end: 10),
            from: Duration(milliseconds: 1000),
            to: Duration(milliseconds: 1300),
            curve: Curves.easeInOutCubic,
            tag: "second")
        .animate(_controller);

    _controller.forward();
    Future.delayed(Duration(milliseconds: 1300)).then(
        (_) => BlocProvider.of<SplashScreenBloc>(context).add(SPFinished()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        child: Transform.scale(
          scale: 1,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Opacity(
              opacity: _sequenceAnimation['first'].value,
              child: Transform.scale(
                scale: _sequenceAnimation['second'].value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      'images/cookingHat.png',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.45 > 230
                          ? 230
                          : MediaQuery.of(context).size.width * 0.45,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Material(
                        color: Colors.transparent,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7 > 380
                              ? 380
                              : MediaQuery.of(context).size.width * 0.7,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Text(
                              "My RecipeBook",
                              style: TextStyle(
                                fontFamily: "Righteous",
                                color: Colors.black,
                                fontSize: 42,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
