import 'package:flutter/material.dart';
import 'package:my_recipe_book/dialogs/add_nut_cat_dialog.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_recipe_book/generated/i18n.dart';

class CategoryManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).manage_categories),
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
            showDialog(context: context, builder: (_) => AddDialog(false));
          }),
      body: ScopedModelDescendant<RecipeKeeper>(
          builder: (context, child, rKeeper) {
        if (rKeeper.categories.length == 1) {
          return Center(
            child: Text(S.of(context).you_have_no_categories),
          );
        } else {
          return ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              rKeeper.moveCategory(oldIndex, newIndex);
            },
            children: rKeeper.categories.map((categoryName) {
              return ListTile(
                key: Key(categoryName),
                title: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => AddDialog(
                              false,
                              modifiedItem: categoryName,
                            ));
                  },
                  child: Text(categoryName),
                ),
                leading: Icon(Icons.reorder),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteDialog(context, categoryName);
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

  _showDeleteDialog(BuildContext context, String categoryName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(S.of(context).delete_category),
        content: Text(S.of(context).sure_you_want_to_delete_this_category +
            " $categoryName"),
        actions: <Widget>[
          FlatButton(
            child: Text(S.of(context).no),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textColor: Theme.of(context).textTheme.body1.color,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ScopedModelDescendant<RecipeKeeper>(
            builder: (context, child, rKeeper) => FlatButton(
              child: Text(S.of(context).yes),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Colors.red[600],
              textColor: Theme.of(context).textTheme.body1.color,
              onPressed: () {
                rKeeper.removeCategory(categoryName);
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
