import 'package:flutter/material.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:scoped_model/scoped_model.dart';

import 'add_recipe_screen/categories_section.dart';

class CategoryManager extends StatefulWidget {
  CategoryManager({Key key}) : super(key: key);

  _CategoryManagerState createState() => _CategoryManagerState();
}

class _CategoryManagerState extends State<CategoryManager> {
  List<String> categories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('manage categories'),
        actions: <Widget>[
          ScopedModelDescendant<RecipeKeeper>(builder: (context, child, model) {
            return IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                model.updateCategoryOrder(categories);
                DBProvider.db.updateCategoryOrder(categories).then((_) {
                  Navigator.pop(context);
                });
              },
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF790604),
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(context: context, builder: (_) => CategoryAddDialog());
          }),
      body:
          ScopedModelDescendant<RecipeKeeper>(builder: (context, child, model) {
        this.categories = model.rCategories;
        if (model.rCategories.length == 1) {
          return Center(
            child: Text('You have no categories'),
          );
        } else {
          return ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              _updateItems(oldIndex, newIndex);
            },
            children: buildCategories(this.categories, model),
          );
        }
      }),
    );
  }

  List<Widget> buildCategories(List<String> categories, RecipeKeeper rKeeper) {
    List<Widget> categoryTiles = [];
    for (int i = 0; i < categories.length-1; i++) {
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
                  rKeeper.removeCategory(categories[i]);
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
      if (newIndex > oldIndex) newIndex -= 1;
      String tmp = categories[oldIndex];
      categories[oldIndex] = categories[newIndex];
      categories[newIndex] = tmp;
    });
  }
}
