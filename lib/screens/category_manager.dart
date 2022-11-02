import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_recipe_book/widgets/icon_info_message.dart';

import '../blocs/category_manager/category_manager_bloc.dart';
import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../generated/i18n.dart';
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
            appBar: NewGradientAppBar(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [Color(0xffAF1E1E), Color(0xff641414)],
              ),
              title: Text(I18n.of(context)!.manage_categories),
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
                                return I18n.of(context)!
                                    .category_already_exists;
                              } else if (name == "") {
                                return I18n.of(context)!
                                    .field_must_not_be_empty;
                              } else {
                                return null;
                              }
                            },
                            save: (String name) {
                              BlocProvider.of<CategoryManagerBloc>(context)
                                  .recipeManagerBloc
                                  .add(RMAddCategories([name]));
                            },
                            hintText: I18n.of(context)!.categoryname,
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
                      description: I18n.of(context)!.you_have_no_categories,
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
                                    return I18n.of(context)!
                                        .category_already_exists;
                                  } else if (name == "") {
                                    return I18n.of(context)!
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
                                hintText: I18n.of(context)!.categoryname,
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
      appBar: NewGradientAppBar(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [Color(0xffAF1E1E), Color(0xff641414)],
        ),
        title: Text(I18n.of(context)!.manage_categories),
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
        title: Text(I18n.of(context)!.delete_category),
        content: Text(I18n.of(context)!.sure_you_want_to_delete_this_category +
            " $categoryName"),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              foregroundColor: Theme.of(context).textTheme.bodyText2!.color,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(I18n.of(context)!.no),
          ),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.red[600],
              foregroundColor: Theme.of(context).textTheme.bodyText2!.color,
            ),
            child: Text(I18n.of(context)!.yes),
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
