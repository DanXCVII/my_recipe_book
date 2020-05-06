import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import "package:flutter/material.dart";

import '../generated/i18n.dart';
import '../util/helper.dart';

class Ingredients extends StatefulWidget {
  final List<List<TextEditingController>> ingredientNameController;
  final List<List<TextEditingController>> ingredientAmountController;
  final List<List<TextEditingController>> ingredientUnitController;
  final List<TextEditingController> ingredientGlossary;
  final List<String> ingredientNames;

  final TextEditingController servingsController;

  Ingredients(
      this.servingsController,
      this.ingredientNameController,
      this.ingredientAmountController,
      this.ingredientUnitController,
      this.ingredientGlossary,
      this.ingredientNames);

  @override
  State<StatefulWidget> createState() {
    return _IngredientsState();
  }
}

class _IngredientsState extends State<Ingredients> {
  @override
  Widget build(BuildContext context) {
    // Column with all the data of the ingredients inside like heading, textFields etc.
    Column sections = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 12, top: 22, bottom: 12, right: 200),
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
              labelText: I18n.of(context).servings,
              icon: Icon(Icons.local_dining),
            ),
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
        )
      ],
    );
    // add all the sections to the column
    for (int i = 0; i < widget.ingredientGlossary.length; i++) {
      sections.children.add(IngredientSection(
          // i number of the section in the column
          i,
          // callback for when section add is tapped
          i == widget.ingredientGlossary.length - 1 ? true : false,
          widget.ingredientNameController,
          widget.ingredientAmountController,
          widget.ingredientUnitController,
          widget.ingredientGlossary,
          widget.ingredientNames));
    }
    // Add remove and add section button
    sections.children.add(
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.ingredientGlossary.length > 1
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: OutlineButton.icon(
                      icon: Icon(Icons.remove_circle),
                      label: Container(
                        padding: MediaQuery.of(context).size.width < 412
                            ? EdgeInsets.symmetric(vertical: 8)
                            : null,
                        width:
                            MediaQuery.of(context).size.width < 412 ? 80 : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(I18n.of(context).remove_section(
                              MediaQuery.of(context).size.width < 412
                                  ? "\n"
                                  : "")),
                        ),
                      ),
                      onPressed: () {
                        updateAndRemoveController();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                  )
                : null,
            OutlineButton.icon(
              icon: Icon(Icons.add_circle),
              label: Text(I18n.of(context).add_section(
                  MediaQuery.of(context).size.width < 412 ? "\n" : "")),
              onPressed: () {
                updateAndAddController();
              },
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
            ),
          ].where((c) => c != null).toList()),
    );
    return sections;
  }

  void updateAndRemoveController() {
    setState(() {
      if (widget.ingredientGlossary.length > 1) {
        widget.ingredientGlossary.removeLast();
        widget.ingredientAmountController.removeLast();
        widget.ingredientNameController.removeLast();
        widget.ingredientUnitController.removeLast();
      }
    });
  }

  void updateAndAddController() {
    setState(() {
      widget.ingredientGlossary.add(new TextEditingController());
      widget.ingredientNameController.add(new List<TextEditingController>());
      widget.ingredientNameController[widget.ingredientGlossary.length - 1]
          .add(new TextEditingController());
      widget.ingredientAmountController.add(new List<TextEditingController>());
      widget.ingredientAmountController[widget.ingredientGlossary.length - 1]
          .add(new TextEditingController());
      widget.ingredientUnitController.add(new List<TextEditingController>());
      widget.ingredientUnitController[widget.ingredientGlossary.length - 1]
          .add(new TextEditingController());
    });
  }
}

class IngredientSection extends StatefulWidget {
  // lists for saving the data

  final List<List<TextEditingController>> ingredientNameController;
  final List<List<TextEditingController>> ingredientAmountController;
  final List<List<TextEditingController>> ingredientUnitController;
  final List<TextEditingController> ingredientGlossary;
  final List<String> ingredientNames;

  final int sectionNumber;
  final bool lastRow;

  IngredientSection(
      this.sectionNumber,
      this.lastRow,
      this.ingredientNameController,
      this.ingredientAmountController,
      this.ingredientUnitController,
      this.ingredientGlossary,
      this.ingredientNames);

  @override
  State<StatefulWidget> createState() {
    return _IngredientSectionState();
  }
}

class _IngredientSectionState extends State<IngredientSection> {
  List<List<GlobalKey<AutoCompleteTextFieldState<String>>>> keys = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.ingredientNameController.length; i++) {
      keys.add([]);
      for (int j = 0; j < widget.ingredientNameController[i].length; j++) {
        keys[i].add(GlobalKey());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 12),
          child: Row(
              children: <Widget>[
            Expanded(
              child: TextField(
                controller: widget.ingredientGlossary[widget.sectionNumber],
                decoration: InputDecoration(
                  icon: Icon(Icons.receipt),
                  helperText:
                      I18n.of(context).not_required_eg_ingredients_of_sauce,
                  labelText: I18n.of(context).section_name,
                  filled: true,
                ),
              ),
            ),
          ].where((c) => c != null).toList()),
        )
      ]
        ..addAll(
          List.generate(
            widget.ingredientNameController[widget.sectionNumber].length,
            (i) => Padding(
              padding: EdgeInsets.fromLTRB(
                widget.ingredientNameController[widget.sectionNumber].length > 1
                    ? 4
                    : 52,
                12.0,
                12,
                12,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  widget.ingredientNameController[widget.sectionNumber].length >
                          1
                      ? IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () {
                            setState(() {
                              widget.ingredientNameController[
                                      widget.sectionNumber]
                                  .removeAt(i);
                              widget.ingredientAmountController[
                                      widget.sectionNumber]
                                  .removeAt(i);
                              widget.ingredientUnitController[
                                      widget.sectionNumber]
                                  .removeAt(i);
                              keys[widget.sectionNumber].removeAt(i);
                            });
                          },
                        )
                      : null,
                  Expanded(
                    flex: 9,
                    child: SimpleAutoCompleteTextField(
                      key: keys[widget.sectionNumber][i],
                      controller: widget
                          .ingredientNameController[widget.sectionNumber][i],
                      suggestions: widget.ingredientNames,
                      decoration: InputDecoration(
                        hintText: I18n.of(context).name,
                        filled: true,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        validator: (value) {
                          if (stringIsValidDouble(value) == false &&
                              value != "")
                            return I18n.of(context).no_valid_number;
                          return null;
                        },
                        autovalidate: false,
                        controller: widget.ingredientAmountController[
                            widget.sectionNumber][i],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: I18n.of(context).amnt,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        controller: widget
                            .ingredientUnitController[widget.sectionNumber][i],
                        decoration: InputDecoration(
                          filled: true,
                          hintText: I18n.of(context).unit,
                        ),
                      ),
                    ),
                  ),
                ]..removeWhere((c) => c == null),
              ),
            ),
          ),
        )
        ..add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton.icon(
                  icon: Icon(Icons.add_circle_outline),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(I18n.of(context).add_ingredient(
                        MediaQuery.of(context).size.width < 412 ? "\n" : "")),
                  ),
                  onPressed: () {
                    setState(() {
                      widget.ingredientNameController[widget.sectionNumber]
                          .add(new TextEditingController());
                      widget.ingredientAmountController[widget.sectionNumber]
                          .add(new TextEditingController());
                      widget.ingredientUnitController[widget.sectionNumber]
                          .add(new TextEditingController());
                      keys[widget.sectionNumber].add(GlobalKey());
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0))),
            ].where((c) => c != null).toList(),
          ),
        ),
    );
  }
}
