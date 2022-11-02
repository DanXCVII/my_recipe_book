import 'package:another_flushbar/flushbar.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_book/blocs/new_recipe/ingredients_section/ingredients_section_bloc.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/screens/recipe_screen.dart';
import 'package:my_recipe_book/widgets/dialogs/are_you_sure_dialog.dart';
import 'package:reorderables/reorderables.dart';

import '../generated/i18n.dart';
import '../util/helper.dart';
import 'dialogs/ingredient_add_dialog.dart';
import 'dialogs/textfield_dialog.dart';

class Ingredients extends StatefulWidget {
  final List<String> ingredientNames;

  final TextEditingController servingsController;
  final TextEditingController servingsNameController;

  Ingredients(
    this.servingsController,
    this.servingsNameController,
    this.ingredientNames,
  );

  @override
  State<StatefulWidget> createState() {
    return _IngredientsState();
  }
}

class _IngredientsState extends State<Ingredients> {
  bool initializedServingsNameController = false;
  Flushbar? _flush;

  @override
  Widget build(BuildContext context) {
    if (!initializedServingsNameController &&
        widget.servingsNameController.text == "") {
      widget.servingsNameController.text = I18n.of(context)!.servings;
      initializedServingsNameController = true;
    }

    // Column with all the data of the ingredients inside like heading, textFields etc.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 12, top: 22, bottom: 12, right: 50),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: widget.servingsController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (getDoubleFromString(value!) == null && value != "") {
                      return I18n.of(context)!.no_valid_number;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: I18n.of(context)!.amount,
                    icon: Icon(Icons.local_dining),
                  ),
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: widget.servingsNameController,
                  validator: (value) {
                    if (value == "") {
                      return I18n.of(context)!.field_must_not_be_empty;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: I18n.of(context)!.servings,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 56, top: 12, bottom: 12),
          child: Text(
            I18n.of(context)!.ingredients + ':',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        BlocBuilder<IngredientsSectionBloc, IngredientsSectionState>(
          builder: (context, state) {
            if (state is LoadedIngredientsSection) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(state.ingredients.length,
                    (index) {
                  return Column(
                    children: [
                      ReorderableColumn(
                        scrollController: ScrollController(),
                        onReorder: (oldIndex, newIndex) {
                          BlocProvider.of<IngredientsSectionBloc>(context)
                              .add(MoveIngredient(index, oldIndex, newIndex));
                        },
                        children: List<Widget>.generate(
                          state.ingredients[index].length,
                          (indexTwo) {
                            Ingredient currentIngred =
                                state.ingredients[index][indexTwo];
                            return Container(
                                key: Key(currentIngred.toString()),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (bContext) =>
                                          IngredientAddDialog(
                                        (ingredient, sectionIndex) =>
                                            BlocProvider.of<
                                                        IngredientsSectionBloc>(
                                                    context)
                                                .add(
                                          EditIngredient(
                                            ingredient,
                                            index,
                                            indexTwo,
                                            sectionIndex,
                                          ),
                                        ),
                                        currentIngred,
                                        sectionTitles: state.sectionTitles,
                                        selectedDropdownIndex: index,
                                      ),
                                    );
                                  },
                                  child: Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 21, 26, 21),
                                      child: Icon(Icons.reorder),
                                    ),
                                    Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    500
                                                ? 380
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    120,
                                            child: Text(
                                              currentIngred.name,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          currentIngred.amount == null &&
                                                  (currentIngred.unit == "" ||
                                                      currentIngred.unit ==
                                                          null)
                                              ? null
                                              : Text(
                                                  "${currentIngred.amount == null ? "" : cutDouble(currentIngred.amount!)}" +
                                                      " ${currentIngred.unit ?? ""}",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                        ].whereType<Widget>().toList()),
                                    Spacer(),
                                    IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          BlocProvider.of<
                                                      IngredientsSectionBloc>(
                                                  context)
                                              .add(
                                            RemoveIngredient(index, indexTwo),
                                          );
                                        }),
                                  ]),
                                ));
                          },
                        ),
                      )
                    ]
                      ..insert(
                        0,
                        state.sectionTitles.isNotEmpty
                            ? ListTile(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (bContext) => TextFieldDialog(
                                      validation: (title) => title == ""
                                          ? I18n.of(context)!
                                              .field_must_not_be_empty
                                          : null,
                                      prefilledText: state.sectionTitles[index],
                                      save: (title) => BlocProvider.of<
                                              IngredientsSectionBloc>(context)
                                          .add(
                                        EditSectionTitle(title, index),
                                      ),
                                    ),
                                  );
                                },
                                trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      if ((state.ingredients.length == 1 &&
                                              state.sectionTitles.length ==
                                                  1) ||
                                          state.ingredients[index].isEmpty) {
                                        BlocProvider.of<IngredientsSectionBloc>(
                                                context)
                                            .add(
                                          RemoveSection(index),
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (bcontext) =>
                                              AreYouSureDialog(
                                                  I18n.of(context)!
                                                      .delete_section,
                                                  I18n.of(context)!
                                                      .delete_section_desc, () {
                                            BlocProvider.of<
                                                        IngredientsSectionBloc>(
                                                    context)
                                                .add(
                                              RemoveSection(index),
                                            );
                                            Navigator.pop(context);
                                          }),
                                        );
                                      }
                                    }),
                                title: Text(
                                  "   " + state.sectionTitles[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            : state.ingredients.first.isEmpty
                                ? Container()
                                : OutlinedButton.icon(
                                    icon: Icon(Icons.add_circle_outline),
                                    label: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(I18n.of(context)!.add_title),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (bContext) => TextFieldDialog(
                                          validation: (title) => title == ""
                                              ? I18n.of(context)!
                                                  .field_must_not_be_empty
                                              : null,
                                          save: (title) => BlocProvider.of<
                                                      IngredientsSectionBloc>(
                                                  context)
                                              .add(
                                            AddSectionTitle(title),
                                          ),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.orange[900] ??
                                                  Colors.orange),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                  ),
                      )
                      ..insert(
                          1,
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Divider(),
                          ))
                      ..add(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            OutlinedButton.icon(
                              icon: Icon(Icons.add_circle_outline),
                              label: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child:
                                    Text(I18n.of(context)!.add_ingredient("")),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (bContext) => IngredientAddDialog(
                                    (ingredient, sectionIndex) => BlocProvider
                                            .of<IngredientsSectionBloc>(context)
                                        .add(AddIngredient(ingredient, index)),
                                    Ingredient(
                                      name: "",
                                      amount: null,
                                      unit: "",
                                    ),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.orange[900] ?? Colors.orange),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  );
                }).whereType<Widget>().toList()
                  ..add(
                    state.ingredients.length == 1 &&
                            state.ingredients.first.isEmpty
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: OutlinedButton.icon(
                              icon: Icon(Icons.add_circle_outline),
                              label: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(I18n.of(context)!.add_section("")),
                              ),
                              onPressed: () {
                                if (state.sectionTitles.isEmpty) {
                                  _showFlushInfo(I18n.of(context)!.add_title,
                                      I18n.of(context)!.add_title_desc);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (bContext) => TextFieldDialog(
                                      validation: (title) => title == ""
                                          ? I18n.of(context)!
                                              .field_must_not_be_empty
                                          : null,
                                      save: (title) => BlocProvider.of<
                                              IngredientsSectionBloc>(context)
                                          .add(
                                        AddSectionTitle(title),
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.orange[900] ?? Colors.orange),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(5.0))),
                              ),
                            ),
                          ),
                  ),
              );
            } else {
              return Text(state.toString());
            }
          },
        )
      ],
    );
  }

  void _showFlushInfo(String title, String body) {
    if (_flush != null && _flush!.isShowing()) {
    } else {
      _flush = Flushbar<bool>(
        animationDuration: Duration(milliseconds: 300),
        leftBarIndicatorColor: Colors.blue[300],
        title: title,
        message: body,
        icon: Icon(
          Icons.info_outline,
          color: Colors.blue,
        ),
        mainButton: TextButton(
          onPressed: () {
            _flush!.dismiss(true); // result = true
          },
          child: Text(
            "OK",
            style: TextStyle(color: Colors.amber),
          ),
        ),
      ) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
        ..show(context).then((result) {});
    }
  }
}
