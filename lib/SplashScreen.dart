import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './database.dart';
import 'recipe.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  Future<SharedPreferences> prefs;
  bool recipeCatOverview;

  @override
  void initState() {
    super.initState();
    prefs = SharedPreferences.getInstance();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
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
          Container(height: 20),
          CircularProgressIndicator(),
        ],
      )),
    );
  }

  Future<void> loadData() async {
    prefs.then((prefs) {
      if (prefs.containsKey('recipeCatOverview')) {
        recipeCatOverview = prefs.getBool('recipeCatOverview');
      } else {
        recipeCatOverview = true;
      }
    });

    List<String> categories = await DBProvider.db.getCategories();
    int maxIndex;
    categories.length > 7 ? maxIndex = 7 : maxIndex = categories.length;
    for (int i = 0; i < maxIndex; i++) {
      List<Recipe> recipeList =
          await DBProvider.db.getRecipesOfCategory(categories[i]);
    }
    onDoneLoading();
  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage(recipeCatOverview)));
  }
}
