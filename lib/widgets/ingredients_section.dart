import 'package:flushbar/flushbar.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_recipe_book/blocs/new_recipe/ingredients_section/ingredients_section_bloc.dart';
import 'package:my_recipe_book/models/ingredient.dart';
import 'package:my_recipe_book/widgets/dialogs/are_you_sure_dialog.dart';

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
  Flushbar _flush;

  @override
  Widget build(context) {
    if (!initializedServingsNameController &&
        widget.servingsNameController.text == "") {
      widget.servingsNameController.text = I18n.of(context).servings;
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
            children: <Widget>[
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: widget.servingsController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (stringIsValidDouble(value) == false && value != "") {
                      return I18n.of(context).no_valid_number;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: I18n.of(context).amount,
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
                      return I18n.of(context).field_must_not_be_empty;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    labelText: I18n.of(context).servings,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 56, top: 12, bottom: 12),
          child: Text(
            I18n.of(context).ingredients + ':',
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
                children: List<Widget>.generate(
                  state.ingredients.length,
                  (index) => Column(
                    children: List<Widget>.generate(
                        state.ingredients[index].length, (indexTwo) {
                      return ListTile(
                        // leading: Icon(Icons.reorder),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (bContext) => IngredientAddDialog(
                              (ingredient) =>
                                  BlocProvider.of<IngredientsSectionBloc>(
                                          context)
                                      .add(
                                EditIngredient(ingredient, index, indexTwo),
                              ),
                              state.ingredients[index][indexTwo],
                            ),
                          );
                        },
                        trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              BlocProvider.of<IngredientsSectionBloc>(context)
                                  .add(
                                RemoveIngredient(index, indexTwo),
                              );
                            }),
                        title: Text(state.ingredients[index][indexTwo].name),
                        subtitle: state.ingredients[index][indexTwo].amount ==
                                    null &&
                                state.ingredients[index][indexTwo].unit == ""
                            ? null
                            : Text(
                                "${cutDouble(state.ingredients[index][indexTwo].amount) ?? ""} ${state.ingredients[index][indexTwo].unit ?? ""}"),
                      );
                    })
                      ..insert(
                        0,
                        state.sectionTitles.isNotEmpty
                            ? ListTile(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (bContext) => TextFieldDialog(
                                      validation: (title) => title == ""
                                          ? I18n.of(context)
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
                                                  I18n.of(context)
                                                      .delete_section,
                                                  I18n.of(context)
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
                                ? null
                                : RaisedButton.icon(
                                    icon: Icon(Icons.add_circle_outline),
                                    label: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text("add title"),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (bContext) => TextFieldDialog(
                                          validation: (title) => title == ""
                                              ? I18n.of(context)
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
                                    color: Colors.orange[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
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
                            RaisedButton.icon(
                              icon: Icon(Icons.add_circle_outline),
                              label: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child:
                                    Text(I18n.of(context).add_ingredient("")),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (bContext) => IngredientAddDialog(
                                    (ingredient) =>
                                        BlocProvider.of<IngredientsSectionBloc>(
                                                context)
                                            .add(
                                      AddIngredient(ingredient, index),
                                    ),
                                    Ingredient(
                                        name: "", amount: null, unit: ""),
                                  ),
                                );
                              },
                              color: Colors.orange[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                              ),
                            ),
                          ],
                        ),
                      )
                      ..removeWhere((element) => element == null),
                  ),
                )
                  ..add(
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RaisedButton.icon(
                          icon: Icon(Icons.add_circle_outline),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(I18n.of(context).add_section("")),
                          ),
                          onPressed: () {
                            if (state.sectionTitles.isEmpty) {
                              _showFlushInfo(I18n.of(context).add_title,
                                  I18n.of(context).add_title_desc);
                            } else {
                              showDialog(
                                context: context,
                                builder: (bContext) => TextFieldDialog(
                                  validation: (title) => title == ""
                                      ? I18n.of(context).field_must_not_be_empty
                                      : null,
                                  save: (title) =>
                                      BlocProvider.of<IngredientsSectionBloc>(
                                              context)
                                          .add(
                                    AddSectionTitle(title),
                                  ),
                                ),
                              );
                            }
                          },
                          color: Colors.orange[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0))),
                    ),
                  )
                  ..removeWhere((element) => (element == null)),
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
    if (_flush != null && _flush.isShowing()) {
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
        mainButton: FlatButton(
          onPressed: () {
            _flush.dismiss(true); // result = true
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
