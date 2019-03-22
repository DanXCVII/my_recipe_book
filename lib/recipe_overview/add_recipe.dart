import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../recipe.dart';

const double categories = 14;
const double topPadding = 8;

// TODO ~: Put the AddRecipe Scaffold in a stateless widget
class AddRecipe extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddRecipeState();
  }
}

class AddRecipeState extends State<AddRecipe> {
  // Controllers for the fixed textFields
  TextEditingController nameController = new TextEditingController();
  TextEditingController preperationTimeController = new TextEditingController();
  TextEditingController cookingTimeController = new TextEditingController();
  TextEditingController totalTimeController = new TextEditingController();
  TextEditingController servingsController = new TextEditingController();
  // TODO: implement controllers for the ingredients and steps
  TextEditingController notesController = new TextEditingController();
  // corresponding key
  final _formKey = GlobalKey<FormState>();

  /// global lists for the dynamic amout of text fields data like ingredients
  /// and steps
  List<List<String>> ingredientsList = new List<List<String>>();
  List<String> ingredientsGlossary = new List<String>();
  VegetarianNewRecipe vegetarianNewRecipe = new VegetarianNewRecipe(Vegetable.NON_VEGETARIAN);
  List<List<double>> amount = new List<List<double>>();
  List<List<String>> unit = new List<List<String>>();
  List<String> steps = new List<String>();
  Vegetable vegetable;

  @override
  void initState() {
    super.initState();
    // initialize lists with one element
    ingredientsList.add(new List<String>());
    ingredientsList[0].add('');
    amount.add(new List<double>());
    amount[0].add(-1);
    unit.add(new List<String>());
    unit[0].add('');
    ingredientsGlossary.add('');
    steps.add('');
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
          title: Text('add recipe'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  // TODO: Implement save recipt functionality
                  print('isIngredientListValid');
                  if (!isIngredientListValid(ingredientsList, amount, unit)) {
                    // TODO: show alert with info that ingredients list need to be filled in properly
                    print(
                        'show alert with info that ingredients list need to be filled in properly');
                    return;
                  }
                  // Map with the lists of the ingredients with the corresponding amount and unit
                  Map<String, List<List<dynamic>>> ingredients =
                      getCleanIngredientList(ingredientsList, amount, unit);

                  Recipe newRecipe = new Recipe(
                    name: nameController.text,
                    preperationTime: preperationTimeController.text.isEmpty
                        ? null
                        : double.parse(preperationTimeController.text),
                    cookingTime: cookingTimeController.text.isEmpty
                        ? null
                        : double.parse(cookingTimeController.text),
                    totalTime: totalTimeController.text.isEmpty
                        ? null
                        : double.parse(totalTimeController.text),
                    servings: servingsController.text.isEmpty
                        ? null
                        : double.parse(servingsController.text),
                    notes: notesController.text,
                    vegetable: vegetarianNewRecipe.getVegetable(),
                    ingredientsGlossary: ingredientsGlossary
                        .where((string) => string.isNotEmpty)
                        .toList(),
                    ingredientsList: ingredients['ingredients'],
                    amount: ingredients['amount'],
                    unit: ingredients['unit'],
                  );

                  print(ingredients['ingredients']);
                  print(vegetarianNewRecipe.getVegetable());
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
                    return 'Please enter a name';
                  }
                },
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'name',
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
                          return 'no valid number';
                        }
                      },
                      controller: preperationTimeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'preperation time',
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
                          return 'no valid number';
                        }
                      },
                      controller: cookingTimeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        labelText:
                            'cooking time', // TODO: Maybe change name to something which isn't so much related to cooking with heat
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
                    return 'no valid number';
                  }
                },
                controller: totalTimeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  helperText: 'in minutes',
                  filled: true,
                  labelText: 'total time',
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
                    return 'no valid number';
                  }
                },
                controller: servingsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'servings',
                  icon: Icon(Icons.local_dining),
                ),
              ),
            ),

            // ingredients section with it's heading and text fields and buttons
            Ingredients(
              ingredientsGlossary,
              ingredientsList,
              amount,
              unit,
            ),
            // category for vegetarian heading
            Padding(
              padding: const EdgeInsets.only(left: 56, top: 12),
              child: Text(
                'select a category:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[700]),
              ),
            ),
            // category for radio buttons for vegetarian selector
            Vegetarian(vegetarianNewRecipe),
            // heading with textFields for steps section
            StepsSection(steps),
            // notes textField
            Padding(
              padding: const EdgeInsets.only(
                  right: 12, top: 12, left: 18, bottom: 12),
              child: TextField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: 'notes',
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
                      'select subcategories:',
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
    // TODO: implement controllers for the ingredients and steps
    notesController.dispose();
  }

  bool isIngredientListValid(List<List<String>> ingredients,
      List<List<double>> amount, List<List<String>> unit) {
    int validator = 0;
    for (int i = 0; i < ingredients.length; i++) {
      for (int j = 0; j < ingredients[i].length; j++) {
        validator = 0;
        if (ingredients[i][j] == '') validator++;
        if (amount[i][j] == -1) validator++;
        if (unit[i][j] == '') validator++;
        if (validator == 1 || validator == 2) return false;
      }
    }
    return true;
  }

  /// removes all leading and trailing whitespaces, empty ingredients from the lists
  /// of ingredients and
  Map<String, List<List<dynamic>>> getCleanIngredientList(
      List<List<String>> ingredients,
      List<List<double>> amount,
      List<List<String>> unit) {
    /// Map which will be the clean map with the list of the ingredients
    /// data.
    Map<String, List<List<dynamic>>> output =
        new Map<String, List<List<dynamic>>>();
    output.addAll({'ingredients': new List<List<String>>()});
    output['ingredients'].addAll(ingredients);
    output.addAll({'amount': new List<List<double>>()});
    output['amount'].addAll(amount);
    output.addAll({'unit': new List<List<String>>()});
    output['unit'].addAll(unit);

    for (int i = 0; i < output['ingredients'].length; i++) {
      for (int j = 0; j < output['ingredients'][i].length; j++) {
        // remove leading and trailing white spaces
        output['ingredients'][i][j] = output['ingredients'][i][j].trim();
        output['unit'][i][j] = output['unit'][i][j].trim();
        // remove all ingredients from the list, when all three fields are empty
        if (output['ingredients'][i][j] == '' &&
            output['amount'][i][j] == -1 &&
            output['unit'][i][j] == '') {
          output['ingredients'][i].removeAt(j);
          output['amount'][i].removeAt(j);
          output['unit'][i].removeAt(j);
        }
      }
    }
    // create the output list with the clean ingredient lists
    for (int i = 0; i < output['ingredients'].length; i++) {
      if (output['ingredients'][i].isEmpty) {
        output['ingredients'].remove(output['ingredients'][i]);
        output['amount'].remove(output['amount'][i]);
        output['unit'].remove(output['unit'][i]);
      }
    }
    return output;
  }
}

bool validateNumber(String text) {
  if (text.isEmpty) {
    return true;
  }
  String pattern = r'^(?!0*[.,]?0+$)\d*[.,]?\d+$';

  RegExp regex = new RegExp(pattern);
  if (regex.hasMatch(text)) {
    return true;
  } else {
    return false;
  }
}

class Ingredients extends StatefulWidget {
  final List<String> ingredientsGlossary;
  final List<List<String>> ingredientsList;
  final List<List<double>> amount;
  final List<List<String>> unit;

  Ingredients(
      this.ingredientsGlossary, this.ingredientsList, this.amount, this.unit);

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
        'ingredients:',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[700]),
      ),
    ));
    // add all the sections to the column
    for (int i = 0; i < _sectionAmount; i++) {
      sections.children.add(IngredientSection(
          widget.ingredientsGlossary,
          widget.ingredientsList,
          widget.amount,
          widget.unit,
          (int id) {
            setState(() {
              widget.ingredientsGlossary.removeLast();
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
              widget.ingredientsGlossary.add('');
              widget.ingredientsList.add(new List<String>());
              widget.amount.add(new List<double>());
              widget.unit.add(new List<String>());
            });
          },
          i == _sectionAmount - 1 ? true : false));
    }
    // add 'add section' and 'remove section' button to column
    sections.children.add(
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _sectionAmount > 1
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: OutlineButton.icon(
                      icon: Icon(Icons.remove_circle),
                      label: Text('Remove section'),
                      onPressed: () {
                        setState(() {
                          // TODO: Callback when a section gets removed
                          if (_sectionAmount > 1) {
                            widget.ingredientsGlossary.removeLast();
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
              label: Text('Add section'),
              onPressed: () {
                setState(() {
                  _sectionAmount++;
                  widget.ingredientsGlossary.add('');
                  widget.ingredientsList.add(new List<String>());
                  widget.ingredientsList[_sectionAmount - 1].add('');
                  widget.amount.add(new List<double>());
                  widget.amount[_sectionAmount - 1].add(-1);
                  widget.unit.add(new List<String>());
                  widget.unit[_sectionAmount - 1].add('');
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
  final List<String> ingredientsGlossary;
  final List<List<String>> ingredientsList;
  final List<List<double>> amount;
  final List<List<String>> unit;

  final SectionsCountCallback callbackRemoveSection;
  final SectionAddCallback callbackAddSection;
  final int sectionNumber;
  final bool lastRow;

  IngredientSection(
      this.ingredientsGlossary,
      this.ingredientsList,
      this.amount,
      this.unit,
      this.callbackRemoveSection,
      this.sectionNumber,
      this.callbackAddSection,
      this.lastRow);

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
            onChanged: (changed) {
              widget.ingredientsGlossary[0] = changed;
            },
            decoration: InputDecoration(
              icon: Icon(Icons.fastfood),
              helperText: 'not required (e.g. ingredients of sauce)',
              labelText: 'section name',
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
                child: TextField(
                  onChanged: (changed) {
                    widget.ingredientsList[widget.sectionNumber][i] = changed;
                  },
                  decoration: InputDecoration(
                    hintText: 'name',
                    filled: true,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    onChanged: (changed) {
                      if (changed == '') changed = '-1';
                      widget.amount[widget.sectionNumber][i] =
                          double.parse(changed);
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'amnt',
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    onChanged: (changed) {
                      widget.unit[widget.sectionNumber][i] = changed;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'unit',
                    ),
                  ),
                ),
              ),
            ].where((c) => c != null).toList(),
          ),
        ),
      ));
    }
    // add 'add ingredient' and 'remove ingredient' to the list
    output.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _ingredientFieldsCount > 1
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: OutlineButton.icon(
                      icon: Icon(Icons.remove_circle_outline),
                      label: Text('Remove ingredient'),
                      onPressed: () {
                        setState(() {
                          _ingredientFieldsCount--;
                          widget.ingredientsList[widget.sectionNumber]
                              .removeLast();
                          widget.amount[widget.sectionNumber].removeLast();
                          widget.unit[widget.sectionNumber].removeLast();
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                )
              : null,
          OutlineButton.icon(
              icon: Icon(Icons.add_circle_outline),
              label: Text('Add ingredient'),
              onPressed: () {
                // TODO: Add new ingredient to the section
                setState(() {
                  widget.ingredientsList[widget.sectionNumber].add('');
                  widget.amount[widget.sectionNumber].add(-1);
                  widget.unit[widget.sectionNumber].add('');
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
  final List<String> steps;

  StepsSection(this.steps);

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
                    '${i + 1}',
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
              child: TextField(
                onChanged: (changed) {
                  widget.steps[i] = changed;
                },
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'description',
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

  // builds the steps section with it's corresponding heading
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
                'steps:',
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
                      label: Text('Remove step'),
                      onPressed: () {
                        setState(() {
                          _stepsFieldCount--;
                          widget.steps.removeLast();
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                )
              : null,
          OutlineButton.icon(
              icon: Icon(Icons.add_circle_outline),
              label: Text('Add step'),
              onPressed: () {
                // TODO: Add new ingredient to the section
                setState(() {
                  widget.steps.add('');
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

class VegetarianNewRecipe {
  Vegetable _vegetable;

  VegetarianNewRecipe(this._vegetable);

  void setVegetable(Vegetable vegetable) {
    this._vegetable =vegetable;
  }

Vegetable getVegetable() {
  return _vegetable;
}
}

// Widget for the radio buttons (vegetarian, vegan, etc.)
class Vegetarian extends StatefulWidget {
  final VegetarianNewRecipe vegetarianNewRecipe;

  Vegetarian(this.vegetarianNewRecipe);

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
          widget.vegetarianNewRecipe.setVegetable(Vegetable.NON_VEGETARIAN);
          break;
        case 1:
          widget.vegetarianNewRecipe.setVegetable(Vegetable.VEGETARIAN);
          break;
        case 2:
          widget.vegetarianNewRecipe.setVegetable(Vegetable.VEGAN);
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
                'non vegetarian',
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
                  'vegetarian',
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
                  'vegan',
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
              title: Text('Change Picture'),
              children: <Widget>[
                SimpleDialogOption(
                  child: Text('Select an image from your gallery'),
                  onPressed: () {
                    Navigator.pop(context, Answers.GALLERY);
                  },
                ),
                SimpleDialogOption(
                  child: Text('Take a new photo with camera'),
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
