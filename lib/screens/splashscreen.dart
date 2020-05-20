import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/splash_screen/splash_screen_bloc.dart';
import '../generated/i18n.dart';
import '../constants/routes.dart';
import '../screens/homepage_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 1200)).then(
        (_) => BlocProvider.of<SplashScreenBloc>(context).add(SPFinished()));
  }

  @override
  Widget build(BuildContext context) {
    double _imageHeight = MediaQuery.of(context).size.width * 0.55 > 320
        ? 320
        : MediaQuery.of(context).size.width * 0.55;

    return BlocListener<SplashScreenBloc, SplashScreenState>(
      listener: (context, state) {
        if (state is InitializedData) {
          Future.delayed(Duration(milliseconds: 100)).then((value) {
            Navigator.popAndPushNamed(
              context,
              RouteNames.home,
              arguments: MyHomePageArguments(
                state.showIntro,
                context,
                state.recipeCategoryOverview,
              ),
            );
            if (state.showIntro) {
              Navigator.of(context).pushNamed(RouteNames.intro);
            }
          });
        }
      },
      child: Scaffold(
        body: Container(
          color: Colors.amber,
          child: Center(
            child: Column(
              children: <Widget>[
                Spacer(flex: 2),
                Container(
                  height: _imageHeight,
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(milliseconds: 500),
                    curve: Curves.linear,
                    builder: (_, double opacity, myChild) => Opacity(
                      opacity: opacity,
                      child: Image.asset(
                        'images/cookingHat.png',
                        fit: BoxFit.cover,
                        height: _imageHeight,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7 > 380
                      ? 380
                      : MediaQuery.of(context).size.width * 0.7,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      I18n.of(context).recipe_bible,
                      style: TextStyle(
                        fontFamily: "Righteous",
                        color: Colors.black,
                        fontSize: 42,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  "Loading data...",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 16),
                ),
                SizedBox(height: 12),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red[900]),
                ),
                Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
