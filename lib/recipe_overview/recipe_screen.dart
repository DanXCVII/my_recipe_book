import 'package:flutter/material.dart';
import '../recipe.dart';

class RecipeScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeScreen({@required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        expandedHeight: 200.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          background: Hero(
            tag: "${recipe.image}",
            child: Material(
              color: Colors.transparent,
              child: Image.file(
                recipe.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Hero(
              tag: recipe.name,
              child: Material(
                  color: Colors.transparent, child: Text(
                "${recipe.name}",
                style: TextStyle(
                    fontSize: 19.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ))),
        ),
      ),
      SliverList(delegate: SliverChildListDelegate(<Widget>[]))
    ]));
  }
}
