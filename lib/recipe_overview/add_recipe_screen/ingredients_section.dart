import "package:flutter/material.dart";

import "./add_recipe.dart";


class Ingredients extends StatefulWidget {
  final List<List<TextEditingController>> ingredientNameController;
  final List<List<TextEditingController>> ingredientAmountController;
  final List<List<TextEditingController>> ingredientUnitController;
  final List<TextEditingController> ingredientGlossary;

  Ingredients(
    this.ingredientNameController,
    this.ingredientAmountController,
    this.ingredientUnitController,
    this.ingredientGlossary,
  );

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
      children: <Widget>[],
    );
    // add the heading to the Column
    sections.children.add(Padding(
      padding: const EdgeInsets.only(left: 52, top: 12, bottom: 12),
      child: Text(
        "ingredients:",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[700]),
      ),
    ));
    // add all the sections to the column
    for (int i = 0; i < widget.ingredientGlossary.length; i++) {
      sections.children.add(IngredientSection(
        (int id) {
          setState(() {
            if (widget.ingredientGlossary.length > 1) {
              widget.ingredientGlossary.removeLast();
            }
          });
        },
        // i number of the section in the column
        i,
        // callback for when section add is tapped
        () {
          setState(() {
            widget.ingredientGlossary.add(new TextEditingController());
            widget.ingredientNameController
                .add(new List<TextEditingController>());
            widget.ingredientAmountController
                .add(new List<TextEditingController>());
            widget.ingredientUnitController
                .add(new List<TextEditingController>());
          });
        },
        i == widget.ingredientGlossary.length - 1 ? true : false,
        widget.ingredientNameController,
        widget.ingredientAmountController,
        widget.ingredientUnitController,
        widget.ingredientGlossary,
      ));
    }
    // add "add section" and "remove section" button to column
    sections.children.add(
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.ingredientGlossary.length > 1
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: OutlineButton.icon(
                      icon: Icon(Icons.remove_circle),
                      label: Text("Remove section"),
                      onPressed: () {
                        setState(() {
                          // TODO: Callback when a section gets removed
                          if (widget.ingredientGlossary.length > 1) {
                            widget.ingredientGlossary.removeLast();
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                  )
                : null,
            OutlineButton.icon(
              icon: Icon(Icons.add_circle),
              label: Text("Add section"),
              onPressed: () {
                setState(() {
                  widget.ingredientGlossary.add(new TextEditingController());
                  widget.ingredientNameController
                      .add(new List<TextEditingController>());
                  widget.ingredientNameController[
                          widget.ingredientGlossary.length - 1]
                      .add(new TextEditingController());
                  widget.ingredientAmountController
                      .add(new List<TextEditingController>());
                  widget.ingredientAmountController[
                          widget.ingredientGlossary.length - 1]
                      .add(new TextEditingController());
                  widget.ingredientUnitController
                      .add(new List<TextEditingController>());
                  widget.ingredientUnitController[
                          widget.ingredientGlossary.length - 1]
                      .add(new TextEditingController());
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
            ),
          ].where((c) => c != null).toList()),
    );
    return sections;
  }
}

class IngredientSection extends StatefulWidget {
  // lists for saving the data

  final List<List<TextEditingController>> ingredientNameController;
  final List<List<TextEditingController>> ingredientAmountController;
  final List<List<TextEditingController>> ingredientUnitController;
  final List<TextEditingController> ingredientGlossary;

  final SectionsCountCallback callbackRemoveSection;
  final SectionAddCallback callbackAddSection;
  final int sectionNumber;
  final bool lastRow;

  IngredientSection(
    this.callbackRemoveSection,
    this.sectionNumber,
    this.callbackAddSection,
    this.lastRow,
    this.ingredientNameController,
    this.ingredientAmountController,
    this.ingredientUnitController,
    this.ingredientGlossary,
  );

  @override
  State<StatefulWidget> createState() {
    return _IngredientSectionState();
  }
}

class _IngredientSectionState extends State<IngredientSection> {
  // returns a list of the Rows with the TextFields for the ingredients
  List<Widget> getIngredientFields() {
    List<Widget> output = [];
    output.add(Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 12),
      child: Row(
          children: <Widget>[
        Expanded(
          child: TextField(
            controller: widget.ingredientGlossary[widget.sectionNumber],
            decoration: InputDecoration(
              icon: Icon(Icons.fastfood),
              helperText: "not required (e.g. ingredients of sauce)",
              labelText: "section name",
              filled: true,
            ),
          ),
        ),
      ].where((c) => c != null).toList()),
    ));
    // add rows with the ingredient textFields to the List of widgets
    for (int i = 0; i < widget.ingredientNameController[widget.sectionNumber].length; i++) {
      output.add(Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12, 12),
        child: Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 9,
                child: TextFormField(
                  controller:
                      widget.ingredientNameController[widget.sectionNumber][i],
                  decoration: InputDecoration(
                    hintText: "name",
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
                      if (validateNumber(value) == false) {
                        return "no valid number";
                      }
                    },
                    controller: widget
                        .ingredientAmountController[widget.sectionNumber][i],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "amnt",
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
                      hintText: "unit",
                    ),
                  ),
                ),
              ),
            ].where((c) => c != null).toList(),
          ),
        ),
      ));
    }
    // add "add ingredient" and "remove ingredient" to the list
    output.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.ingredientNameController[widget.sectionNumber].length > 1
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: OutlineButton.icon(
                      icon: Icon(Icons.remove_circle_outline),
                      label: Text("Remove ingredient"),
                      onPressed: () {
                        setState(() {
                          widget.ingredientNameController[widget.sectionNumber]
                              .removeLast();
                          widget
                              .ingredientAmountController[widget.sectionNumber]
                              .removeLast();
                          widget.ingredientUnitController[widget.sectionNumber]
                              .removeLast();
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                )
              : null,
          OutlineButton.icon(
              icon: Icon(Icons.add_circle_outline),
              label: Text("Add ingredient"),
              onPressed: () {
                // TODO: Add new ingredient to the section
                setState(() {
                  widget.ingredientNameController[widget.sectionNumber]
                      .add(new TextEditingController());
                  widget.ingredientAmountController[widget.sectionNumber]
                      .add(new TextEditingController());
                  widget.ingredientUnitController[widget.sectionNumber]
                      .add(new TextEditingController());
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0))),
        ].where((c) => c != null).toList(),
      ),
    );
    return output;
  }

  @override
  Widget build(BuildContext context) {
    Column _ingredients = Column(
      children: <Widget>[],
    );
    _ingredients.children.addAll(getIngredientFields());

    return _ingredients;
  }
}