import 'package:flutter/material.dart';
import 'package:my_recipe_book/database.dart';

import 'add_recipe_screen/categories_section.dart';

class CategoryManager extends StatefulWidget {
  CategoryManager({Key key}) : super(key: key);

  _CategoryManagerState createState() => _CategoryManagerState();
}

class _CategoryManagerState extends State<CategoryManager> {
  List<String> categories;

  @override
  Widget build(BuildContext context) {
    print(categories.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('manage categories'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              DBProvider.db.updateCategoryOrder(categories).then((_) {
                Navigator.pop(context);
              });
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF790604),
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(context: context, builder: (_) => CategoryAddDialog());
          }),
      body: FutureBuilder<List<String>>(
        future: DBProvider.db.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (categories == null)
              categories = snapshot.data;
            else if (categories.length == snapshot.data.length - 1)
              categories.add(snapshot.data.last);
            if (categories.isEmpty) {
              return Center(
                child: Text('You have no categories'),
              );
            }
            return ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                _updateItems(oldIndex, newIndex);
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
    for (int i = 0; i < categories.length; i++) {
      categoryTiles.add(
        ListTile(
          key: Key(categories[i]),
          title: Text(categories[i]),
          leading: Icon(Icons.reorder),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              DBProvider.db.removeCategory(categories[i]).then((_) {
                setState(() {
                  categories.remove(categories[i]);
                });
              });
            },
          ),
        ),
      );
    }
    return categoryTiles;
  }

  void _updateItems(int oldIndex, newIndex) {
    setState(() {
      print(oldIndex.toString() + '--------->' + newIndex.toString());
      if (newIndex > oldIndex) newIndex -= 1;
      String tmp = categories[oldIndex];
      categories[oldIndex] = categories[newIndex];
      categories[newIndex] = tmp;
      print(categories.toString());
    });
  }
}
