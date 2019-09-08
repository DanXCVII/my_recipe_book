import "package:flutter/material.dart";
import 'package:my_recipe_book/io/io_operations.dart' as IO;
import 'package:my_recipe_book/recipe.dart';
import "package:image_picker/image_picker.dart";
import 'package:path_provider/path_provider.dart';

import "dart:io";
import "./add_recipe.dart";

class Steps extends StatefulWidget {
  final List<TextEditingController> stepsDecriptionController;
  final List<List<String>> stepImages;
  final String recipeName;

  Steps(this.stepsDecriptionController, this.stepImages,
      {this.recipeName = 'tmp'});

  @override
  State<StatefulWidget> createState() {
    return _StepsState();
  }
}

class _StepsState extends State<Steps> {
  @override
  Widget build(BuildContext context) {
    // Column with all the data of the steps inside like heading, textFields etc.
    Column steps = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[],
    );
    // add the heading to the Column
    steps.children.add(Padding(
      padding: const EdgeInsets.only(left: 56, top: 12, bottom: 12),
      child: Text(
        "steps:",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ));
    // add all the sections to the column
    for (int i = 0; i < widget.stepsDecriptionController.length; i++) {
      steps.children.add(Step(
        widget.stepsDecriptionController,
        // i number of the section in the column
        i,
        i == widget.stepsDecriptionController.length - 1 ? true : false,
        widget.stepImages, widget.recipeName,
      ));
    }
    // add "add section" and "remove section" button to column
    steps.children.add(
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.stepsDecriptionController.length > 1
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: OutlineButton.icon(
                      icon: Icon(Icons.remove_circle),
                      label: Text("Remove step"),
                      onPressed: () {
                        removeStep(widget.stepsDecriptionController.length,
                            widget.recipeName);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                  )
                : null,
            OutlineButton.icon(
              icon: Icon(Icons.add_circle),
              label: Text("Add step"),
              onPressed: () {
                setState(() {
                  widget.stepImages.add(new List<String>());
                  widget.stepsDecriptionController
                      .add(new TextEditingController());
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
            ),
          ].where((c) => c != null).toList()),
    );
    return steps;
  }

  void removeStep(int stepNumber, String recipeName) {
    PathProvider.pP
        .getRecipeStepNumberDirFull(recipeName, stepNumber)
        .then((path) {
      Directory(path).deleteSync(recursive: true);
    });
    PathProvider.pP
        .getRecipeStepPreviewNumberDirFull(recipeName, stepNumber)
        .then((path) {
      Directory(path).deleteSync(recursive: true);
    });

    setState(() {
      if (widget.stepsDecriptionController.length > 1) {
        widget.stepsDecriptionController.removeLast();
        widget.stepImages.removeLast();
      }
    });
  }
}

class Step extends StatefulWidget {
  // lists for saving the data

  final List<TextEditingController> stepsContoller;
  final List<List<String>> stepImages;

  final int stepNumber;
  final bool lastRow;
  final String recipeName;

  Step(this.stepsContoller, this.stepNumber, this.lastRow, this.stepImages,
      this.recipeName);

  @override
  State<StatefulWidget> createState() {
    return _StepState();
  }
}

class _StepState extends State<Step> {
  List<File> selectedImageFiles = [];

  @override
  void initState() {
    super.initState();

    /// When editing a recipe, it initializes the data for the images:
    /// - adds the files to the selectedFiles
    /// - removes the applicationDirectory afterwars
    for (int i = 0; i < widget.stepImages[widget.stepNumber].length; i++) {
      String currentImage = widget.stepImages[widget.stepNumber][i];
      selectedImageFiles.add(File(currentImage));
    }
    getApplicationDocumentsDirectory().then((appDir) {
      for (int i = 0; i < widget.stepImages[widget.stepNumber].length; i++) {
        String currentImage = widget.stepImages[widget.stepNumber][i];
        widget.stepImages[widget.stepNumber][i] =
            currentImage.substring(appDir.path.length, currentImage.length);
      }
    });
  }

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
          // showSavingDialog(context);
          File newImage = await ImagePicker.pickImage(
            source: ImageSource.gallery,
            // maxHeight: 50.0,
            // maxWidth: 50.0,
          );

          if (newImage != null) {
            widget.stepImages[widget.stepNumber].add(await IO.saveStepImage(
                newImage, widget.stepNumber,
                recipeName: widget.recipeName));
          }
          setState(() {
            selectedImageFiles.add(newImage);
            selectedImageFiles = this.selectedImageFiles;
          });
          break;
        }
      case Answers.PHOTO:
        {
          /*
          File newImage = await ImagePicker.pickImage(
            source: ImageSource.camera,
            //maxHeight: 50.0,
            //maxWidth: 50.0,
          );

          if (newImage != null) {
            widget.stepImages[widget.stepNumber].add(newImage.path);
          }
          setState(() {
            selectedImageFiles.add(newImage);
            selectedImageFiles = this.selectedImageFiles;
          });
          */
        }
        break;
    }
  }

  // returns a list of the Rows with the TextFields for the ingredients
  Wrap getStepImages() {
    Wrap output = Wrap(spacing: 5.0, runSpacing: 3.0, children: <Widget>[]);

    // add rows with the ingredient textFields to the List of widgets
    for (int i = 0; i < widget.stepImages[widget.stepNumber].length + 1; i++) {
      output.children.add(widget.stepImages[widget.stepNumber].length == i
          ? Container(
              child: Center(
                  child: IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: (() {
                  _askUser();
                }),
              )),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(const Radius.circular(7.0)),
                border: Border.all(
                  width: 1.5,
                  color: Colors.grey,
                ),
              ),
            )
          : Stack(children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Container(
                    child: Image.file(
                      // widget.stepImages[widget.stepNumber][i],
                      selectedImageFiles[i],
                      fit: BoxFit.cover,
                    ),
                    width: 80,
                    height: 80,
                  )),
              Opacity(
                opacity: 0.3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.black87,
                  ),
                  width: 80,
                  height: 80,
                ),
              ),
              Container(
                width: 80,
                height: 80,
                child: IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  color: Colors.white,
                  onPressed: () {
                    print(i+1);
                    removeImage(widget.recipeName, widget.stepNumber, i);
                  },
                ),
              ),
            ]));
    }

    return output;
  }

  /// TODO: Doesn't really work, because the naming of the pictures is related to the position of them
  /// but the position is not fixed so..
  void removeImage(String recipeName, int stepNumber, int number) {
    print('stepnumber $stepNumber');
    print('number $number');
    print(widget.stepImages);
    String stepImageName = widget.stepImages[stepNumber][number]
        .substring(widget.stepImages[stepNumber][number].lastIndexOf('/')+1);
    print(stepImageName);
    

    IO.deleteStepImage(recipeName, stepNumber, stepImageName);

    setState(() {
      widget.stepImages[stepNumber].removeAt(number);
      selectedImageFiles.removeAt(number);
    });
  }

  @override
  Widget build(BuildContext context) {
    Column _steps = Column(
      children: <Widget>[
        Row(
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
                      "${widget.stepNumber + 1}",
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
                  controller: widget.stepsContoller[widget.stepNumber],
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
        )
      ],
    );
    _steps.children.add(FractionallySizedBox(
        widthFactor: 1,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(58.0, 12.0, 12.0, 0),
            child: getStepImages())));

    return _steps;
  }
}
