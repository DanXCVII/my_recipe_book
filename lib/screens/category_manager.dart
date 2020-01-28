import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/category_manager/category_manager.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_event.dart';
import '../generated/i18n.dart';
import '../widgets/dialogs/textfield_dialog.dart';

class CategoryManager extends StatelessWidget {
  const CategoryManager();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryManagerBloc, CategoryManagerState>(
      builder: (context, state) {
        if (state is LoadingCategoryManager) {
          return _getLoadedScreen(context);
        } else if (state is LoadedCategoryManager) {
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).manage_categories),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xFF790604),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => TextFieldDialog(
                            validation: (String name) {
                              if (state.categories.contains(name)) {
                                return 'category already exists';
                              } else {
                                return null;
                              }
                            },
                            save: (String name) {
                              BlocProvider.of<CategoryManagerBloc>(context)
                                  .recipeManagerBloc
                                  .add(RMAddCategory(name));
                            },
                            hintText: 'category name',
                          ));
                }),
            body: state.categories.length == 1
                ? Center(
                    child: Text(S.of(context).you_have_no_categories),
                  )
                : ReorderableListView(
                    onReorder: (oldIndex, newIndex) {
                      BlocProvider.of<CategoryManagerBloc>(context)
                          .recipeManagerBloc
                          .add(RMMoveCategory(
                              oldIndex, newIndex, DateTime.now()));
                    },
                    children: state.categories.map((categoryName) {
                      return ListTile(
                        key: Key(categoryName),
                        title: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => TextFieldDialog(
                                validation: (String name) {
                                  if (state.categories.contains(name)) {
                                    return 'category already exists';
                                  } else {
                                    return null;
                                  }
                                },
                                save: (String name) {
                                  BlocProvider.of<CategoryManagerBloc>(context)
                                      .recipeManagerBloc
                                      .add(
                                        RMUpdateCategory(categoryName, name),
                                      );
                                },
                                hintText: 'category name',
                                prefilledText: categoryName,
                              ),
                            );
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
                  ),
          );
        } else {
          return Text(state.toString());
        }
      },
    );
  }

  Widget _getLoadedScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).manage_categories),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
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
          FlatButton(
            child: Text(S.of(context).yes),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.red[600],
            textColor: Theme.of(context).textTheme.body1.color,
            onPressed: () {
              BlocProvider.of<RecipeManagerBloc>(context)
                  .add(RMDeleteCategory(categoryName));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
