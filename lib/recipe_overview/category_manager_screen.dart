import 'package:flutter/material.dart';
import 'package:my_recipe_book/database.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:scoped_model/scoped_model.dart';

import 'add_recipe_screen/categories_section.dart';

/// TODO: Maybe change to StatelessWidget by calling changeOrderMethods in
/// RecipeKeeper which notifies this widget for changes so that no internal
/// list is needed
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
          ScopedModelDescendant<RecipeKeeper>(
            builder: (context, child, model) => IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                model.updateCategoryOrder(categories);
                DBProvider.db.updateCategoryOrder(categories).then((_) {
                  Navigator.pop(context);
                });
              },
            ),
          ),
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
        this.categories = model.categories;
        if (model.categories.length == 1) {
          return Center(
            child: Text('You have no categories'),
          );
        } else {
          return ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              _updateItems(oldIndex, newIndex);
            },
            children: this.categories.map((categoryName) {
              return ListTile(
                key: Key(categoryName),
                title: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => CategoryAddDialog(
                              modifiedCategory: categoryName,
                            ));
                  },
                  child: Text(categoryName),
                ),
                leading: Icon(Icons.reorder),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    DBProvider.db.removeCategory(categoryName).then((_) {
                      setState(() {
                        model.removeCategory(categoryName);
                        categories.remove(categoryName);
                      });
                    });
                  },
                ),
              );
            }).toList()
              ..removeLast(),
          );
        }
      }),
    );
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
