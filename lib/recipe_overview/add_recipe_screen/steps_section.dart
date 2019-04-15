import "package:flutter/material.dart";
import "dart:io";
import "./add_recipe.dart";
import "package:image_picker/image_picker.dart";

class Steps extends StatefulWidget {
  final List<TextEditingController> stepsDecriptionController;
  final List<List<File>> stepImages;

  Steps(this.stepsDecriptionController, this.stepImages);

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
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[700]),
      ),
    ));
    // add all the sections to the column
    for (int i = 0; i < widget.stepsDecriptionController.length; i++) {
      steps.children.add(Step(
        widget.stepsDecriptionController,
        // i number of the section in the column
        i,
        // callback for when add step is tapped
        () {
          setState(() {
            widget.stepsDecriptionController.add(new TextEditingController());
          });
        },
        // callback for when remove step is tapped
        (int id) {
          setState(() {
            if (widget.stepsDecriptionController.length > 1) {
              widget.stepsDecriptionController.removeLast();
            }
          });
        },

        i == widget.stepsDecriptionController.length - 1 ? true : false,
        widget.stepImages,
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
                        setState(() {
                          // TODO: Callback when a section gets removed
                          if (widget.stepsDecriptionController.length > 1) {
                            widget.stepsDecriptionController.removeLast();
                            widget.stepImages.removeLast();
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
              label: Text("Add step"),
              onPressed: () {
                setState(() {
                  widget.stepImages.add(new List<File>());
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
}

class Step extends StatefulWidget {
  // lists for saving the data

  final List<TextEditingController> stepsContoller;
  final List<List<File>> stepImages;

  final SectionsCountCallback callbackRemoveStep;
  final SectionAddCallback callbackAddStep;
  final int stepNumber;
  final bool lastRow;

  Step(
    this.stepsContoller,
    this.stepNumber,
    this.callbackAddStep,
    this.callbackRemoveStep,
    this.lastRow,
    this.stepImages,
  );

  @override
  State<StatefulWidget> createState() {
    return _StepState();
  }
}

class _StepState extends State<Step> {
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
          File newImage = await ImagePicker.pickImage(
            source: ImageSource.gallery,
            // maxHeight: 50.0,
            // maxWidth: 50.0,
          );

          if (newImage != null) {
            widget.stepImages[widget.stepNumber].add(newImage);
          }
          setState(() {});
          break;
        }
      case Answers.PHOTO:
        {
          File newImage = await ImagePicker.pickImage(
            source: ImageSource.camera,
            //maxHeight: 50.0,
            //maxWidth: 50.0,
          );

          if (newImage != null) {
            widget.stepImages[widget.stepNumber].add(newImage);
          }
          setState(() {});
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
                  // TODO: Select image
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
                      widget.stepImages[widget.stepNumber][i],
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
                    setState(() {
                      widget.stepImages[widget.stepNumber].removeAt(i);
                    });
                  },
                ),
              ),
            ]));
    }

    return output;
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
