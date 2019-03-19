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
  TextEditingController nameController;
  TextEditingController preperationTimeController;
  TextEditingController cookingTimeController;
  TextEditingController totalTimeController;
  TextEditingController servingsController;
  // TODO: implement controllers for the ingredients and steps
  TextEditingController notesController;
  final _formKey = GlobalKey<FormState>();
  List<List<String>> ingredientsList = new List<List<String>>();
  List<String> ingredientsGlossary = new List<String>();
  List<List<double>> amount = new List<List<double>>();
  List<List<String>> unit = new List<List<String>>();
  List<String> steps = new List<String>();
  Vegetable vegetable;

  @override
  void initState() {
    super.initState();

    nameController = new TextEditingController();
    preperationTimeController = new TextEditingController();
    cookingTimeController = new TextEditingController();
    totalTimeController = new TextEditingController();
    servingsController = new TextEditingController();
    // TODO: implement controllers for the ingredients and steps
    notesController = new TextEditingController();
    ingredientsList.add(new List<String>());
    ingredientsList[0].add('');
    amount.add(new List<double>());
    amount[0].add(-1);
    unit.add(new List<String>());
    unit[0].add('');
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
                  // TODO: when data is not valid
                }
                // TODO: Implement save recipt functionality
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
                  ingredientsGlossary: ingredientsGlossary
                      .where((string) => string.isNotEmpty)
                      .toList(),
                  ingredientsList: cleanUpListString(ingredientsList),
                  amount: cleanUpListDouble(amount),
                  unit: cleanUpListString(unit),
                );
                print(nameController.text);
                print(preperationTimeController.text);
                print(cookingTimeController.text);
                print(totalTimeController.text);
                print(notesController.text);

                print(cleanUpListString(ingredientsList));
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
            // ingredients heading

            // ingredients text fields for a section and the corresponding ingredients

            Ingredients(
              ingredientsGlossary,
              ingredientsList,
              amount,
              unit,
            ),
            // button for adding a new ingredient section

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
            Vegetarian(vegetable),
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

  List<List<String>> cleanUpListString(List<List<String>> list) {
    List<List<String>> output = new List<List<String>>();
    list.forEach((listInList) {
      output.add((listInList.where((element) => element.isNotEmpty)).toList());
    });
    for (int i = 0; i < output.length; i++) {
      if (output[i].isEmpty) {
        output.removeAt(i);
      }
    }
    return output;
  }

  List<List<double>> cleanUpListDouble(List<List<double>> list) {
    List<List<double>> output = new List<List<double>>();
    list.forEach((listInList) {
      output.add((listInList.where((element) => element != -1)).toList());
    });
    for (int i = 0; i < output.length; i++) {
      if (output[i].isEmpty) {
        output.removeAt(i);
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
  List<String> ingredientsGlossary;
  List<List<String>> ingredientsList;
  List<List<double>> amount;
  List<List<String>> unit;

  Ingredients(
      this.ingredientsGlossary, this.ingredientsList, this.amount, this.unit);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return IngredientsState();
  }
}

class IngredientsState extends State<Ingredients> {
  int _sectionAmount = 1;

  @override
  Widget build(BuildContext context) {
    Column sections = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    );
    // add the heading to the outputColumn
    sections.children.add(Padding(
      padding: const EdgeInsets.only(left: 52, top: 12, bottom: 12),
      child: Text(
        'ingredients:',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[700]),
      ),
    ));
    // add all the text fields with heading textField for every section to the output

    // add all the sections to the children of the column
    for (int i = 0; i < _sectionAmount; i++) {
      sections.children.add(IngredientSection(
          widget.ingredientsGlossary,
          widget.ingredientsList,
          widget.amount,
          widget.unit,
          (int id) {
            setState(() {
              // TODO: Callback when a section gets removed
              widget.ingredientsGlossary.removeLast();
              if (_sectionAmount > 1) {
                _sectionAmount--;
              }
            });
          },
          // i position of the section in the column
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
    sections.children.add(
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlineButton.icon(
              icon: Icon(Icons.add_circle),
              label: Text('Add section'),
              onPressed: () {
                // TODO: Add a new section with one ingredient
                setState(() {
                  // TODO: Callback when a section gets removed
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
            _sectionAmount > 1
                ? Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: OutlineButton.icon(
                      icon: Icon(Icons.remove_circle),
                      label: Text('Remove section'),
                      onPressed: () {
                        // TODO: Add a new section with one ingredient
                        setState(() {
                          // TODO: Callback when a section gets removed
                          widget.ingredientsGlossary.removeLast();
                          if (_sectionAmount > 1) {
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
          ].where((c) => c != null).toList()),
    );
    return sections;
  }
}

class IngredientSection extends StatefulWidget {
  List<String> ingredientsGlossary;
  List<List<String>> ingredientsList;
  List<List<double>> amount;
  List<List<String>> unit;

  SectionsCountCallback callbackRemoveSection;
  SectionAddCallback callbackAddSection;
  int sectionNumber;
  bool lastRow;

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

  // returns a list of the Rows
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
        // TODO: Only add button to last section and remove it properly?
      ].where((c) => c != null).toList()),
    ));

    for (int i = 0; i < _ingredientFieldsCount; i++) {
      // add empty string to list of ingredients for being able to edit it later
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
    output.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
          _ingredientFieldsCount > 1
              ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: OutlineButton.icon(
                      icon: Icon(Icons.remove_circle_outline),
                      label: Text('Remove ingredient'),
                      onPressed: () {
                        // TODO: Add new ingredient to the section
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
  List<String> steps;

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
          _stepsFieldCount > 1
              ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: OutlineButton.icon(
                      icon: Icon(Icons.remove_circle_outline),
                      label: Text('Remove step'),
                      onPressed: () {
                        // TODO: Add new ingredient to the section
                        setState(() {
                          _stepsFieldCount--;
                          widget.steps.removeLast();
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                )
              : null,
        ].where((c) => c != null).toList(),
      )
    ]);

    return _ingredients;
  }
}

// Widget for the radio buttons (vegetarian, vegan, etc.)
class Vegetarian extends StatefulWidget {
  Vegetable vegetable;
  Vegetarian(this.vegetable);

  State<StatefulWidget> createState() {
    return _VegetarianState();
  }
}

class _VegetarianState extends State<Vegetarian> {
  int _radioValue = 0;
  double _result = 0.0;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          // TODO: save vegetable to editRecipe
          widget.vegetable = Vegetable.non_vegetarian;
          break;
        case 1:
          widget.vegetable = Vegetable.vegetarian;
          break;
        case 2:
          widget.vegetable = Vegetable.vegan;
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
