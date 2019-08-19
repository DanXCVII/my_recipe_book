import 'package:flutter/material.dart';
import 'package:my_recipe_book/database.dart';

import 'add_recipe_screen/categories_section.dart';

class CategoryManager extends StatefulWidget {
  CategoryManager({Key key}) : super(key: key);

  _CategoryManagerState createState() => _CategoryManagerState();
}

class _CategoryManagerState extends State<CategoryManager> {
  List<String> categories;
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {},
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF790604),
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context, builder: (_) => CategoryAddDialog(formKey));
          }),
      body: FutureBuilder<List<String>>(
        future: DBProvider.db.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            categories = snapshot.data;
            if (categories.isEmpty) {
              return Center(
                child: Text('You have no categories'),
              );
            }
            return ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  _updateItems(oldIndex, newIndex);
                });
              },
              children: buildCategories(categories),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  List<Widget> buildCategories(List<String> categories) {
    List<Widget> categoryTiles = [];
    for (final c in categories) {
      categoryTiles.add(ListTile(
        key: Key(c),
        title: Text(c),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {},
        ),
      ));
      categoryTiles.add(Divider());
    }
    return categoryTiles;
  }

  void _updateItems(int oldIndex, newIndex) {
    String tmp = categories[oldIndex];
    categories[oldIndex] = categories[newIndex];
    categories[newIndex] = tmp;
  }
}
