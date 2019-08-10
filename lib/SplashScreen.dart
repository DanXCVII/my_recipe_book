import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();

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
    MainScreenRecipes r = MainScreenRecipes();
    List<RecipeCategory> categories = await DBProvider.db.getCategories();
    int maxIndex;
    categories.length > 7 ? maxIndex = 7 : maxIndex = categories.length;
    for (int i = 0; i < maxIndex; i++) {
      List<Recipe> recipeList =
          await DBProvider.db.getRecipesOfCategory(categories[i].name);
      r.addRecipes(categories[i].name, recipeList);
    }
    onDoneLoading();
  }

  onDoneLoading() async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage()));
  }
}
