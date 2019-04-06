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
            subtitle: Text(
                "steps: ${recipes[i].steps.length}, total time: ${recipes[i].totalTime}"),
            trailing: Favorite(recipes[i]),
            backgroundColor: Colors.black45,
          ),
        ),
      );
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category'),
      ),
      body: FutureBuilder<List<Widget>>(
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
      ),
    );
  }
}

class Favorite extends StatefulWidget {
  final Recipe recipe;

  Favorite(this.recipe);

  @override
  State<StatefulWidget> createState() => FavoriteState();
}

class FavoriteState extends State<Favorite> {
  bool isFavorite;

  @override
  void initState() {
    isFavorite = widget.recipe.isFavorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isFavorite ? Icons.favorite_border : Icons.favorite),
      onPressed: () {
        setState(() {
          if (isFavorite) {
            DBProvider.db.updateFavorite(false, widget.recipe.id).then((_) {
              widget.recipe.isFavorite = false;
              isFavorite = false;
            });
          } else {
            DBProvider.db.updateFavorite(true, widget.recipe.id).then((_) {
              widget.recipe.isFavorite = true;
              isFavorite = true;
            });
          }
        });
      },
    );
  }
}
