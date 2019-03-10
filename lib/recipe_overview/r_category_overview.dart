import 'package:flutter/material.dart';

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
    return GridView.extent(
      maxCrossAxisExtent: 300,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: <Widget>[
        GridTile(
          child: Image.asset(
            'images/noodle.jpg',
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            title: Text("Beschreibung Kat."),
            backgroundColor: Colors.black45,
          ),
        )
      ],
    );
  }
}
