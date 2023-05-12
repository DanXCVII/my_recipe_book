import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../widgets/icon_info_message.dart';

import '../blocs/category_manager/category_manager_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../generated/l10n.dart';
import '../widgets/dialogs/textfield_dialog.dart';

class CategoryManagerArguments {
  final CategoryManagerBloc? categoryManagerBloc;

  CategoryManagerArguments({
    this.categoryManagerBloc,
  });
}

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
              backgroundColor: Colors.black,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffAF1E1E), Color(0xff641414)]),
                ),
              ),
              title: Text(S.of(context).manage_categories),
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
                            validation: (String? name) {
                              if (state.categories.contains(name)) {
                                return S.of(context).category_already_exists;
                              } else if (name == "") {
                                return S.of(context).field_must_not_be_empty;
                              } else {
                                return null;
                              }
                            },
                            save: (String name) {
                              BlocProvider.of<CategoryManagerBloc>(context)
                                  .recipeManagerBloc
                                  .add(RMAddCategories([name]));
                            },
                            hintText: S.of(context).categoryname,
                          ));
                }),
            body: state.categories.length == 1
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                        child: IconInfoMessage(
                      iconWidget: Icon(
                        MdiIcons.apps,
                        color: Colors.grey[300],
                        size: 70.0,
                      ),
                      description: S.of(context).you_have_no_categories,
                    )),
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
                                validation: (String? name) {
                                  if (state.categories.contains(name)) {
                                    return S
                                        .of(context)!
                                        .category_already_exists;
                                  } else if (name == "") {
                                    return S
                                        .of(context)!
                                        .field_must_not_be_empty;
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
                                hintText: S.of(context).categoryname,
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
        backgroundColor: Colors.black,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [Color(0xffAF1E1E), Color(0xff641414)]),
          ),
        ),
        title: Text(S.of(context).manage_categories),
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
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              foregroundColor: Theme.of(context).textTheme.bodyMedium!.color,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(S.of(context).no),
          ),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.red[600],
              foregroundColor: Theme.of(context).textTheme.bodyMedium!.color,
            ),
            child: Text(S.of(context).yes),
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
