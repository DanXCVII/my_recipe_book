import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const double categories = 14;
const double topPadding = 8;

class AddRecipe extends StatelessWidget {
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
                // TODO: Implement save recipt functionality
              },
            )
          ],
        ),
        body: ListView(children: <Widget>[
          // top section with the add image button
          ImageSelector(),
          // name textField
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
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
                  child: TextField(
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
                  child: TextField(
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
            padding:
                const EdgeInsets.only(left: 52, top: 12, right: 12, bottom: 12),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                helperText: 'in minutes',
                filled: true,
                labelText: 'total time',
              ),
            ),
          ),
          // portions textField
          Padding(
            padding: const EdgeInsets.only(
                left: 12, top: 12, bottom: 12, right: 200),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                labelText: 'portions',
                icon: Icon(Icons.local_dining),
              ),
            ),
          ),
          // ingredients heading with the textFields
          IngredientSection(),
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
          Vegetarian(),
          // heading with textFields for steps section
          StepsSection(),
          // notes textField
          Padding(
            padding:
                const EdgeInsets.only(right: 53, top: 12, left: 18, bottom: 12),
            child: TextField(
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
        ]));
  }
}

class IngredientSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IngredientSectionState();
  }
}

class _IngredientSectionState extends State<IngredientSection> {
  int _count = 1;

  // returns a list of the Rows 
  List<Widget> getIngredientFields() {
    List<Widget> output = [];

    for (int i = 0; i < _count; i++) {
      output.add(Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 8, 12),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.fastfood),
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
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'unit',
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {},
            ),
          ],
        ),
      ));
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    Column _ingredients = Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 54, right: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'ingredients:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[700]),
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle,
                ),
                onPressed: () {
                  setState(() {
                    _count += 1;
                  });
                },
              )
            ],
          ),
        ),
      ],
    );
    _ingredients.children.addAll(getIngredientFields());

    return _ingredients;
  }
}

class StepsSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StepsSectionState();
  }
}

class StepsSectionState extends State<StepsSection> {
  int _count = 1;

  /// returns a list of Rows (inside the padding) in which
  /// you can write your steps description.
  List<Widget> getIngredientFields() {
    List<Widget> output = [];

    for (int i = 0; i < _count; i++) {
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
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'description',
                ),
                maxLines: null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {},
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
              IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () {
                  setState(() {
                    _count += 1;
                  });
                },
              )
            ],
          ),
        ),
      ],
    );
    _ingredients.children.addAll(getIngredientFields());

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
  double _result = 0.0;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
        case 2:
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
