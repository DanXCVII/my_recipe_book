import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../blocs/recipe_manager/recipe_manager_bloc.dart';
import '../blocs/recipe_tag_manager/recipe_tag_manager_bloc.dart';
import '../generated/l10n.dart';
import '../models/string_int_tuple.dart';
import '../widgets/dialogs/text_color_dialog.dart';
import '../widgets/icon_info_message.dart';

class RecipeTagManagerArguments {
  final RecipeTagManagerBloc? recipeTagManagerBloc;

  RecipeTagManagerArguments({
    this.recipeTagManagerBloc,
  });
}

class RecipeTagManager extends StatelessWidget {
  const RecipeTagManager();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeTagManagerBloc, RecipeTagManagerState>(
      builder: (context, state) {
        if (state is LoadingRecipeTagManager) {
          return _getLoadedScreen(context);
        } else if (state is LoadedRecipeTagManager) {
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
              title: Text(S.of(context).manage_recipe_tags),
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
                    builder: (_) => TextColorDialog(
                      validation: (String? name) {
                        if (state.recipeTags.firstWhereOrNull(
                                (element) => element.text == name) !=
                            null) {
                          return S.of(context).recipe_tag_already_exists;
                        } else if (name == "") {
                          return S.of(context).field_must_not_be_empty;
                        } else {
                          return null;
                        }
                      },
                      save: (String name, int color) {
                        BlocProvider.of<RecipeTagManagerBloc>(context)
                            .recipeManagerBloc
                            .add(
                              RMAddRecipeTag(
                                  [StringIntTuple(text: name, number: color)]),
                            );
                      },
                      hintText: S.of(context).recipe_tag,
                    ),
                  );
                }),
            body: state.recipeTags.isEmpty
                ? Center(
                    child: IconInfoMessage(
                    iconWidget: Icon(
                      MdiIcons.tag,
                      color: Colors.grey[300],
                      size: 70.0,
                    ),
                    description: S.of(context).you_have_no_recipe_tags,
                  ))
                : ListView(
                    children: List<Widget>.generate(
                      state.recipeTags.length * 2,
                      (index) => index % 2 != 0
                          ? Divider()
                          : ListTile(
                              key: Key(
                                  state.recipeTags[(index / 2).round()].text),
                              title: GestureDetector(
                                onTap: () {
                                  _showEditDialog(state.recipeTags, context,
                                      state.recipeTags[(index / 2).round()]);
                                },
                                child: Text(
                                    state.recipeTags[(index / 2).round()].text),
                              ),
                              leading: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteDialog(context,
                                      state.recipeTags[(index / 2).round()]);
                                },
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  _showEditDialog(state.recipeTags, context,
                                      state.recipeTags[(index / 2).round()]);
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(state
                                          .recipeTags[(index / 2).round()]
                                          .number)),
                                ),
                              ),
                            ),
                    ),
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
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [Color(0xffAF1E1E), Color(0xff641414)]),
          ),
        ),
        title: Text(S.of(context).manage_recipe_tags),
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

  _showEditDialog(List<StringIntTuple> recipeTags, BuildContext context,
      StringIntTuple currentTag) {
    showDialog(
      context: context,
      builder: (_) => TextColorDialog(
        validation: (String? name) {
          List<StringIntTuple> otherRecipeTags =
              List<StringIntTuple>.from(recipeTags)..remove(currentTag);
          if (otherRecipeTags
                  .firstWhereOrNull((element) => element.text == name) !=
              null) {
            return S.of(context).recipe_tag_already_exists;
          } else if (name == "") {
            return S.of(context).field_must_not_be_empty;
          } else {
            return null;
          }
        },
        selectedColor: currentTag.number,
        save: (String name, int number) {
          StringIntTuple newTag = StringIntTuple(text: name, number: number);
          if (newTag != currentTag) {
            BlocProvider.of<RecipeTagManagerBloc>(context)
                .recipeManagerBloc
                .add(
                  RMUpdateRecipeTag(
                    currentTag,
                    StringIntTuple(
                      text: name,
                      number: number,
                    ),
                  ),
                );
          }
        },
        hintText: S.of(context).recipe_tag,
        prefilledText: currentTag.text,
      ),
    );
  }

  _showDeleteDialog(BuildContext context, StringIntTuple recipeTag) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(S.of(context).delete_recipe_tag),
        content: Text(S.of(context).sure_you_want_to_delete_this_recipe_tag +
            " ${recipeTag.text}"),
        actions: <Widget>[
          TextButton(
            child: Text(S.of(context).no),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              foregroundColor: Theme.of(context).textTheme.bodyMedium!.color,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(S.of(context).yes),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.red[600],
              foregroundColor: Theme.of(context).textTheme.bodyMedium!.color,
            ),
            onPressed: () {
              BlocProvider.of<RecipeManagerBloc>(context)
                  .add(RMDeleteRecipeTag(recipeTag));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
