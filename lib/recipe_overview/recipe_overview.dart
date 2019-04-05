import 'package:flutter/material.dart';
import "package:path_provider/path_provider.dart";
import "dart:io";

import '../database.dart';
import '../recipe.dart';

class RecipeGridView extends StatelessWidget {
  final String category;

  RecipeGridView({@required this.category});

  Future<List<Widget>> getRecipeCards() async {
    List<Recipe> recipes = await DBProvider.db.getRecipesOfCategory(category);
    Directory appDir = await getApplicationDocumentsDirectory();
    String imageLocalPath = appDir.path;

    List<Widget> output = new List<Widget>();
    for (int i = 0; i < recipes.length; i++) {
      output.add(
        GridTile(
          child: Image.file(
            recipes[i].image,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            title: Text("${recipes[i].name}"),
            backgroundColor: Colors.black45,
          ),
        ),
      );
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: getRecipeCards(),
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
