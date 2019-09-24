import 'package:flutter/material.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:scoped_model/scoped_model.dart';

import 'add_recipe_screen/categories_section.dart';

class CategoryManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('manage categories'),
        actions: <Widget>[
          ScopedModelDescendant<RecipeKeeper>(
            builder: (context, child, rKeeper) => IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                rKeeper.updateCategoryOrder(rKeeper.categories).then((_) {
                  Navigator.pop(context);
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF790604),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(context: context, builder: (_) => CategoryAddDialog());
          }),
      body: ScopedModelDescendant<RecipeKeeper>(
          builder: (context, child, rKeeper) {
        if (rKeeper.categories.length == 1) {
          return Center(
            child: Text('You have no categories'),
          );
        } else {
          return ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              rKeeper.updateItems(oldIndex, newIndex);
            },
            children: rKeeper.categories.map((categoryName) {
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
                    rKeeper.removeCategory(categoryName);
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
}
