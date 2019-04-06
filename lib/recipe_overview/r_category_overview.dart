import 'package:flutter/material.dart';
import "package:path_provider/path_provider.dart";
import "dart:io";

import '../database.dart';
import '../recipe.dart';
import './recipe_overview.dart';

class RCategoryOverview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RCategoryOverviewState();
}

class _RCategoryOverviewState extends State<RCategoryOverview> {
  @override
  Widget build(BuildContext context) {
    return CategoryGridView();
  }
}

class CategoryGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: getCategoryCards(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.extent(
            maxCrossAxisExtent: 300,
            padding: const EdgeInsets.all(4),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: snapshot.data,
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

Future<List<Widget>> getCategoryCards() async {
  Categories.setCategories(await DBProvider.db.getCategories());
  Directory appDir = await getApplicationDocumentsDirectory();
  String imageLocalPath = appDir.path;

  List<Widget> output = new List<Widget>();
  List<String> categories = Categories.getCategories();
  for (int i = 0; i < categories.length; i++) {
    output.add(
      GestureDetector(
        onTap: () {
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  new RecipeGridView(category: "${categories[i]}"));
        },
        child: GridTile(
          child: Image.asset(
            '$imageLocalPath/${categories[i].replaceAll(new RegExp(r'[^\w\v]+'), '')}.png',
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            title: Text("${categories[i]}"),
            backgroundColor: Colors.black45,
          ),
        ),
      ),
    );
  }
  return output;
}

List<Widget> createDummyCategoryCards() {
  return [
    GridTile(
      child: Image.asset(
        'images/noodle.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("noodles"),
        backgroundColor: Colors.black45,
      ),
    ),
    GridTile(
      child: Image.asset(
        'images/salat.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("salat"),
        backgroundColor: Colors.black45,
      ),
    ),
    GridTile(
      child: Image.asset(
        'images/breakfast.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("breakfast"),
        backgroundColor: Colors.black45,
      ),
    ),
    GridTile(
      child: Image.asset(
        'images/meat.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("meat"),
        backgroundColor: Colors.black45,
      ),
    ),
    GridTile(
      child: Image.asset(
        'images/vegetables.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("vegan"),
        backgroundColor: Colors.black45,
      ),
    ),
    GridTile(
      child: Image.asset(
        'images/rice.jpg',
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        title: Text("rice"),
        backgroundColor: Colors.black45,
      ),
    )
  ];
}
