import "dart:io";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:path_provider/path_provider.dart";
import "dart:async";

import "../recipe.dart";
import "../database.dart";

const double categories = 14;
const double topPadding = 8;
Vegetable newRecipeVegetable;
File newRecipeImage;

// TODO ~: Put the AddRecipe Scaffold in a stateless widget
class AddRecipeForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddRecipeFormState();
  }
}

class AddRecipeFormState extends State<AddRecipeForm> {
  final _formKey = GlobalKey<FormState>();
  IconButton saveButton;
  bool buttonEnabled = true;

  String imageLocalPath = "";
  // Controllers for the fixed textFields
  TextEditingController nameController = new TextEditingController();
  TextEditingController preperationTimeController = new TextEditingController();
  TextEditingController cookingTimeController = new TextEditingController();
  TextEditingController totalTimeController = new TextEditingController();
  TextEditingController servingsController = new TextEditingController();
  // TODO: implement controllers for the ingredients and steps
  TextEditingController notesController = new TextEditingController();
  // corresponding key

  /// global lists of controllers for the dynamic amout of text fields data like ingredients
  /// and steps
  List<List<TextEditingController>> ingredientNameController =
      new List<List<TextEditingController>>();
  List<List<TextEditingController>> ingredientAmountController =
      new List<List<TextEditingController>>();
  List<List<TextEditingController>> ingredientUnitController =
      new List<List<TextEditingController>>();
  List<TextEditingController> ingredientGlossary =
      new List<TextEditingController>();
  List<TextEditingController> stepsList = new List<TextEditingController>();

  @override
  void initState() {
    super.initState();
    newRecipeVegetable = Vegetable.NON_VEGETARIAN;
    // initialize list of controllers for the dynamic textFields with one element
    ingredientNameController.add(new List<TextEditingController>());
    ingredientNameController[0].add(new TextEditingController());
    ingredientAmountController.add(new List<TextEditingController>());
    ingredientAmountController[0].add(new TextEditingController());
    ingredientUnitController.add(new List<TextEditingController>());
    ingredientUnitController[0].add(new TextEditingController());
    ingredientGlossary.add(new TextEditingController());
    stepsList.add(new TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("add recipe"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              color: buttonEnabled == false ? Colors.grey : Colors.white,
              onPressed: () {
                if (buttonEnabled) {
                  if (_formKey.currentState.validate()) {
                    if (isIngredientListValid(ingredientNameController,
                        ingredientAmountController, ingredientUnitController)) {
                      /////////// Only do when all data is VALID! ///////////
                      saveRecipe().then((_) {
                        print('dataSAVED!!!!');
                      });
                      setState(() {
                        buttonEnabled = false;
                      });
                    } else {
                      // TODO: show alert with info that ingredients list need to be filled in properly
                      print(
                          "show alert with info that ingredients list needs to be filled in properly");
                    }
                  }
                } else {
                  return;
                }
              },
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(children: <Widget>[
            // top section with the add image button
            ImageSelector(),
            // name textField
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a name";
                  }
                },
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "name",
                  icon: Icon(Icons.android),
                ),
              ),
            ),
            // time textFields
            Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      validator: (value) {
                        if (validateNumber(value) == false) {
                          return "no valid number";
                        }
                      },
                      controller: preperationTimeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: "preperation time",
                        icon: Icon(Icons.access_time),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextFormField(
                      validator: (value) {
                        if (validateNumber(value) == false) {
                          return "no valid number";
                        }
                      },
                      controller: cookingTimeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        labelText:
                            "cooking time", // TODO: Maybe change name to something which isn"t so much related to cooking with heat
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 52, top: 12, right: 12, bottom: 12),
              child: TextFormField(
                validator: (value) {
                  if (validateNumber(value) == false) {
                    return "no valid number";
                  }
                },
                controller: totalTimeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  helperText: "in minutes",
                  filled: true,
                  labelText: "total time",
                ),
              ),
            ),
            // servings textField
            Padding(
              padding: const EdgeInsets.only(
                  left: 12, top: 12, bottom: 12, right: 200),
              child: TextFormField(
                validator: (value) {
                  if (validateNumber(value) == false) {
                    return "no valid number";
                  }
                  if (value.isEmpty) {
                    return "data required";
                  }
                },
                controller: servingsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "servings",
                  icon: Icon(Icons.local_dining),
                ),
              ),
            ),

            // ingredients section with it's heading and text fields and buttons
            Ingredients(
              ingredientNameController,
              ingredientAmountController,
              ingredientUnitController,
              ingredientGlossary,
            ),
            // category for vegetarian heading
            Padding(
              padding: const EdgeInsets.only(left: 56, top: 12),
              child: Text(
                "select a category:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[700]),
              ),
            ),
            // category for radio buttons for vegetarian selector
            Vegetarian(),
            // heading with textFields for steps section
            StepsSection(stepsList),
            // notes textField
            Padding(
              padding: const EdgeInsets.only(
                  right: 12, top: 12, left: 18, bottom: 12),
              child: TextField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: "notes",
                  filled: true,
                  icon: Icon(Icons.assignment),
                ),
                maxLines: 3,
              ),
            ),
            // heading for the subcategory selector section
            Padding(
                padding: const EdgeInsets.only(left: 54, right: 6, top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // TODO: Add button to add a new category
                    Text(
                      "select subcategories:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey[700]),
                    ),
                  ],
                )),
            // category chips
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Wrap(
                  spacing: 5.0,
                  runSpacing: 3.0,
                  children: <Widget>[
                    MyFilterChip(chipName: "meat"),
                    MyFilterChip(chipName: "salat"),
                    MyFilterChip(chipName: "noodles"),
                    MyFilterChip(chipName: "salat"),
                    MyFilterChip(chipName: "breakfast"),
                    MyFilterChip(chipName: "rice"),
                  ],
                ),
              ),
            )
          ]),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    preperationTimeController.dispose();
    cookingTimeController.dispose();
    totalTimeController.dispose();
    servingsController.dispose();
    notesController.dispose();
    ingredientNameController.forEach((list) {
      list.forEach((controller) {
        controller.dispose();
      });
    });
    ingredientAmountController.forEach((list) {
      list.forEach((controller) {
        controller.dispose();
      });
    });
    ingredientUnitController.forEach((list) {
      list.forEach((controller) {
        controller.dispose();
      });
    });
    ingredientGlossary.forEach((controller) {
      controller.dispose();
    });
  }

  Future<void> saveRecipe() async {
    print('start saveRecipe()');

    // get the lists for the data of the ingredients
    Map<String, List<List<dynamic>>> ingredients = getCleanIngredientData(
        ingredientNameController,
        ingredientAmountController,
        ingredientUnitController);

    int recipeId = await DBProvider.db.getNewIDforTable("Recipe");
    await saveFile(newRecipeImage, nameController.text, recipeId);
    Recipe newRecipe = new Recipe(
      id: recipeId,
      name: nameController.text,
      image: imageLocalPath,
      preperationTime: preperationTimeController.text.isEmpty
          ? 0
          : double.parse(preperationTimeController.text),
      cookingTime: cookingTimeController.text.isEmpty
          ? 0
          : double.parse(cookingTimeController.text),
      totalTime: totalTimeController.text.isEmpty
          ? 0
          : double.parse(totalTimeController.text),
      servings: double.parse(servingsController.text),
      steps: removeEmptyStrings(stepsList),
      notes: notesController.text,
      vegetable: newRecipeVegetable,
      ingredientsGlossary: getCleanGlossary(ingredientGlossary, ingredients),
      ingredientsList: ingredients["ingredients"],
      amount: ingredients["amount"],
      unit: ingredients["unit"],
    );
    int i = await DBProvider.db.newRecipe(newRecipe);
/*
    print('---------------');
    print(ingredients["ingredients"]);
    print(newRecipeVegetable);
    print(stepsList.length);
    print(getCleanGlossary(ingredientGlossary, ingredients));
    print(ingredients["ingredients"]);
    print(ingredients["amount"]);
    print(ingredients["unit"]);
    print('---------------');
*/
    // DELETE
    var result = await DBProvider.db.getRecipeById(recipeId);
    print(result.ingredientsList.toString());

    // DELETE

    print('end saveRecipe()');
  }

  bool isIngredientListValid(
      List<List<TextEditingController>> ingredients,
      List<List<TextEditingController>> amount,
      List<List<TextEditingController>> unit) {
    int validator = 0;
    for (int i = 0; i < ingredients.length; i++) {
      for (int j = 0; j < ingredients[i].length; j++) {
        validator = 0;
        if (ingredients[i][j].text == "") validator++;
        if (amount[i][j].text == "") validator++;
        if (unit[i][j].text == "") validator++;
        if (validator == 1 || validator == 2) return false;
      }
    }
    return true;
  }

  List<String> removeEmptyStrings(List<TextEditingController> list) {
    List<String> output = new List<String>();

    for (int i = 0; i < list.length; i++) {
      if (list[i].text != "") {
        output.add(list[i].text);
      }
    }
    return output;
  }

  List<String> getCleanGlossary(List<TextEditingController> glossary,
      Map<String, List<List<dynamic>>> cleanIngredientsData) {
    List<String> output = new List<String>();
    for (int i = 0; i < glossary.length; i++) {
      output.add(glossary[i].text);
    }

    for (int i = cleanIngredientsData["ingredients"].length;
        i < glossary.length;
        i++) {
      output.removeLast();
    }

    return output;
  }

  /// removes all leading and trailing whitespaces and empty ingredients from the lists
  /// of ingredients and
  Map<String, List<List<dynamic>>> getCleanIngredientData(
      List<List<TextEditingController>> ingredients,
      List<List<TextEditingController>> amount,
      List<List<TextEditingController>> unit) {
    /// creating the three lists with the data of the ingredients
    /// by getting the data of the controllers.
    List<List<String>> ingredientsNames = new List<List<String>>();
    for (int i = 0; i < ingredients.length; i++) {
      ingredientsNames.add(new List<String>());
      for (int j = 0; j < ingredients[i].length; j++) {
        ingredientsNames[i].add(ingredients[i][j].text);
      }
    }

    List<List<double>> ingredientsAmount = new List<List<double>>();
    for (int i = 0; i < amount.length; i++) {
      ingredientsAmount.add(new List<double>());
      for (int j = 0; j < amount[i].length; j++) {
        String addValue = "-1";
        if (amount[i][j].text != "") addValue = amount[i][j].text;
        ingredientsAmount[i].add(double.parse(addValue));
      }
    }

    List<List<String>> ingredientsUnit = new List<List<String>>();
    for (int i = 0; i < unit.length; i++) {
      ingredientsUnit.add(new List<String>());
      for (int j = 0; j < unit[i].length; j++) {
        ingredientsUnit[i].add(unit[i][j].text);
      }
    }

    /// Map which will be the clean map with the list of the ingredients
    /// data.
    Map<String, List<List<dynamic>>> output =
        new Map<String, List<List<dynamic>>>();

    output.addAll({"ingredients": new List<List<String>>()});
    output["ingredients"].addAll(ingredientsNames);
    output.addAll({"amount": new List<List<double>>()});
    output["amount"].addAll(ingredientsAmount);
    output.addAll({"unit": new List<List<String>>()});
    output["unit"].addAll(ingredientsUnit);

    for (int i = 0; i < output["ingredients"].length; i++) {
      for (int j = 0; j < output["ingredients"][i].length; j++) {
        // remove leading and trailing white spaces
        output["ingredients"][i][j] = output["ingredients"][i][j].trim();
        output["unit"][i][j] = output["unit"][i][j].trim();
        // remove all ingredients from the list, when all three fields are empty
        if (output["ingredients"][i][j] == "" &&
            output["amount"][i][j] == -1 &&
            output["unit"][i][j] == "") {
          output["ingredients"][i].removeAt(j);
          output["amount"][i].removeAt(j);
          output["unit"][i].removeAt(j);
        }
      }
    }
    // create the output list with the clean ingredient lists
    for (int i = 0; i < output["ingredients"].length; i++) {
      if (output["ingredients"][i].isEmpty) {
        output["ingredients"].remove(output["ingredients"][i]);
        output["amount"].remove(output["amount"][i]);
        output["unit"].remove(output["unit"][i]);
      }
    }

    return output;
  }

  Future<void> saveFile(File image, String name, int recipeId) async {
    print('start saveFile()');
    Directory appDir = await getApplicationDocumentsDirectory();

    String imageLocalPath = appDir.path;
    if (image != null) {
      final File newImage =
          await image.copy("$imageLocalPath/$name$recipeId.png");
      newRecipeImage = null;
    }
    print('end saveFile()');
  }
}

/*
class SaveData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SaveDataState();
  }
}

class SaveDataState extends State<SaveData> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
*/
bool validateNumber(String text) {
  if (text.isEmpty) {
    return true;
  }
  String pattern = r"^(?!0*[.,]?0+$)\d*[.,]?\d+$";

  RegExp regex = new RegExp(pattern);
  if (regex.hasMatch(text)) {
    return true;
  } else {
    return false;
  }
}

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
    return IngredientsState();
  }
}

class IngredientsState extends State<Ingredients> {
  int _sectionAmount = 1;

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
    for (int i = 0; i < _sectionAmount; i++) {
      sections.children.add(IngredientSection(
        (int id) {
          setState(() {
            widget.ingredientGlossary.removeLast();

            if (_sectionAmount > 1) {
              _sectionAmount--;
            }
          });
        },
        // i number of the section in the column
        i,
        // callback for when section add is tapped
        () {
          setState(() {
            _sectionAmount++;
            widget.ingredientGlossary.add(new TextEditingController());
            widget.ingredientNameController
                .add(new List<TextEditingController>());
            widget.ingredientAmountController
                .add(new List<TextEditingController>());
            widget.ingredientUnitController
                .add(new List<TextEditingController>());
          });
        },
        i == _sectionAmount - 1 ? true : false,
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
            _sectionAmount > 1
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: OutlineButton.icon(
                      icon: Icon(Icons.remove_circle),
                      label: Text("Remove section"),
                      onPressed: () {
                        setState(() {
                          // TODO: Callback when a section gets removed
                          if (_sectionAmount > 1) {
                            widget.ingredientGlossary.removeLast();

                            _sectionAmount--;
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
                  _sectionAmount++;
                  widget.ingredientGlossary.add(new TextEditingController());
                  widget.ingredientNameController
                      .add(new List<TextEditingController>());
                  widget.ingredientNameController[_sectionAmount - 1]
                      .add(new TextEditingController());
                  widget.ingredientAmountController
                      .add(new List<TextEditingController>());
                  widget.ingredientAmountController[_sectionAmount - 1]
                      .add(new TextEditingController());
                  widget.ingredientUnitController
                      .add(new List<TextEditingController>());
                  widget.ingredientUnitController[_sectionAmount - 1]
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
  int _ingredientFieldsCount = 1;

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
    for (int i = 0; i < _ingredientFieldsCount; i++) {
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
          _ingredientFieldsCount > 1
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: OutlineButton.icon(
                      icon: Icon(Icons.remove_circle_outline),
                      label: Text("Remove ingredient"),
                      onPressed: () {
                        setState(() {
                          _ingredientFieldsCount--;
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

                  _ingredientFieldsCount += 1;
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

typedef SectionsCountCallback = void Function(int sections);
typedef SectionAddCallback = void Function();

class StepsSection extends StatefulWidget {
  final List<TextEditingController> stepsList;

  StepsSection(this.stepsList);

  @override
  State<StatefulWidget> createState() {
    return StepsSectionState();
  }
}

class StepsSectionState extends State<StepsSection> {
  int _stepsFieldCount = 1;

  /// returns a list of Rows (inside the padding) in which
  /// you can write your steps description.
  List<Widget> getIngredientFields() {
    List<Widget> output = [];

    for (int i = 0; i < _stepsFieldCount; i++) {
      output.add(Row(
        children: <Widget>[
          SizedBox(
            width: 14,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 17.0),
            child: ClipPath(
              clipper: CustomIngredientsClipper(),
              child: Container(
                width: 26,
                height: 26,
                child: Center(
                  child: Text(
                    "${i + 1}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                color: Color(0xFF790604),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 12),
              child: TextFormField(
                controller: widget.stepsList[i],
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  filled: true,
                  hintText: "description",
                ),
                maxLines: null,
              ),
            ),
          ),
        ],
      ));
    }

    return output;
  }

  // builds the steps section with it"s corresponding heading
  @override
  Widget build(BuildContext context) {
    Column _ingredients = Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 56, right: 6, top: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "steps:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ],
    );
    _ingredients.children.addAll(getIngredientFields());
    _ingredients.children.addAll([
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _stepsFieldCount > 1
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: OutlineButton.icon(
                      icon: Icon(Icons.remove_circle_outline),
                      label: Text("Remove step"),
                      onPressed: () {
                        setState(() {
                          _stepsFieldCount--;
                          widget.stepsList.removeLast();
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                )
              : null,
          OutlineButton.icon(
              icon: Icon(Icons.add_circle_outline),
              label: Text("Add step"),
              onPressed: () {
                // TODO: Add new ingredient to the section
                setState(() {
                  widget.stepsList.add(new TextEditingController());
                  _stepsFieldCount++;
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0))),
        ].where((c) => c != null).toList(),
      )
    ]);

    return _ingredients;
  }
}

// Widget for the radio buttons (vegetarian, vegan, etc.)
class Vegetarian extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _VegetarianState();
  }
}

class _VegetarianState extends State<Vegetarian> {
  int _radioValue = 0;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          // TODO: save vegetable to editRecipe
          newRecipeVegetable = Vegetable.NON_VEGETARIAN;
          break;
        case 1:
          newRecipeVegetable = Vegetable.VEGETARIAN;
          break;
        case 2:
          newRecipeVegetable = Vegetable.VEGAN;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: Radio(
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
              ),
              Text(
                "non vegetarian",
                style: TextStyle(fontSize: 16),
              ),
            ]),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  child: Radio(
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                Text(
                  "vegetarian",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  child: Radio(
                    value: 2,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                Text(
                  "vegan",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            )
          ]),
    );
  }
}

// clips a shape with 8 edges
class CustomIngredientsClipper extends CustomClipper<Path> {
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(size.width / 3 * 2, 0);
    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, size.height / 3 * 2);
    path.lineTo(size.width / 3 * 2, size.height);
    path.lineTo(size.width / 3, size.height);
    path.lineTo(0, size.height / 3 * 2);
    path.lineTo(0, size.height / 3);
    path.lineTo(size.width / 3, 0);
    path.close();
    return path;
  }

  bool shouldReclip(CustomIngredientsClipper oldClipper) => false;
}

// clips a diamond shape
class CustomStepsClipper extends CustomClipper<Path> {
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);
    path.lineTo(size.width / 2, 0);
    path.close();
    return path;
  }

  bool shouldReclip(CustomStepsClipper oldClipper) => false;
}

// Top section of the screen where you can select an image for the dish
class ImageSelector extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ImageSelectorState();
  }
}

enum Answers { GALLERY, PHOTO }

class ImageSelectorState extends State<ImageSelector> {
  File pictureFile;

  Future _askUser() async {
    switch (await showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              title: Text("Change Picture"),
              children: <Widget>[
                SimpleDialogOption(
                  child: Text("Select an image from your gallery"),
                  onPressed: () {
                    Navigator.pop(context, Answers.GALLERY);
                  },
                ),
                SimpleDialogOption(
                  child: Text("Take a new photo with camera"),
                  onPressed: () {
                    Navigator.pop(context, Answers.PHOTO);
                  },
                ),
              ],
            ))) {
      case Answers.GALLERY:
        {
          pictureFile = await ImagePicker.pickImage(
            source: ImageSource.gallery,
            // maxHeight: 50.0,
            // maxWidth: 50.0,
          );
          newRecipeImage = pictureFile;

          print("You selected gallery image : " + pictureFile.path);
          setState(() {});
          break;
        }
      case Answers.PHOTO:
        {
          pictureFile = await ImagePicker.pickImage(
            source: ImageSource.camera,
            //maxHeight: 50.0,
            //maxWidth: 50.0,
          );
          newRecipeImage = pictureFile;

          print("You selected camera image : " + pictureFile.path);
          setState(() {});
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: pictureFile == null
            ? Container(
                child: Center(
                    child: IconButton(
                  onPressed: () {
                    _askUser();
                  },
                  color: Colors.white,
                  icon: Icon(Icons.add_a_photo),
                  iconSize: 32,
                )),
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF790604),
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  child: Image.file(
                    pictureFile,
                    fit: BoxFit.cover,
                  ),
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                )),
      ),
    );
  }
}

// creates a filterClip with the given name
class MyFilterChip extends StatefulWidget {
  final String chipName;

  MyFilterChip({Key key, this.chipName});

  @override
  State<StatefulWidget> createState() {
    return MyFilterChipState();
  }
}

class MyFilterChipState extends State<MyFilterChip> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      selected: _isSelected,
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
      },
    );
  }
}

class FutureB extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FutureBState();
  }
}

class FutureBState extends State<FutureB> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  }
}

Future<int> future() async {
  var completer = new Completer<int>();

  print('kek');
  int i = 0;
  completer.complete(i);
  return completer.future;
}
