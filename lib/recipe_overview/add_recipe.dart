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
          title: Text('add recipe'),
        ),
        body: ListView(
          children: <Widget>[
            ImageSelector(),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 52),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'name',
                  icon: Icon(Icons.android),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 200),
              child: TextField(
                  decoration: InputDecoration(
                labelText: 'preperation time',
                icon: Icon(Icons.access_time),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 56, right: 200),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'cooking time',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 56, right: 200),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'total time',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 200),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'portions',
                  icon: Icon(Icons.local_dining),
                ),
              ),
            ),
            IngredientSection(),
            SizedBox(height: 12),
           Padding(
             padding: const EdgeInsets.only(left: 56),
             child: Text(
                  'select a category:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey[700]),
                ),
           ),
            
            Vegetarian(),
            StepsSection(),
            Padding(
              padding: const EdgeInsets.only(
                  right: 53, top: 12, left: 18, bottom: 12),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'notes',
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.assignment),
                ),
                maxLines: 3,
              ),
            )
          ],
        ));
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

  List<Widget> getIngredientFields() {
    List<Widget> output = [];

    for (int i = 0; i < _count; i++) {
      output.add(Row(
        children: <Widget>[
          SizedBox(
            width: 14,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: ClipPath(
              clipper: CustomIngredientsClipper(),
              child: Container(
                width: 24,
                height: 24,
                child: Center(
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                color: Colors.redAccent,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'name',
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'amnt',
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'unit',
                ),
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

  @override
  Widget build(BuildContext context) {
    Column _ingredients = Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 56, right: 6, top: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'ingredients:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey[700]),
                ),
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
              clipper: CustomStepsClipper(),
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
                color: Color(0xFF9C27B0),
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
                  border: OutlineInputBorder(),
                  hintText: 'description',
                ),
                maxLines: 4,
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
              Radio(
                value: 0,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              Text('non vegetarian', style: TextStyle(fontSize: 16),),
            ]),
            Row(
              children: <Widget>[
                Radio(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                Text('vegetarian', style: TextStyle(fontSize: 16),),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 2,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                Text('vegan', style: TextStyle(fontSize: 16),),
              ],
            )
          ]),
    );
  }
}

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
                  color: Colors.lightBlue,
                ),
              )
            : Image.file(
                pictureFile,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
