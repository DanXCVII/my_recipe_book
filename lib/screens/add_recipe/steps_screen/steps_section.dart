import "dart:io";

import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:image_picker/image_picker.dart";

import '../../../blocs/new_recipe/step_images/step_images_bloc.dart';
import '../../../blocs/new_recipe/step_images/step_images_event.dart';
import '../../../blocs/new_recipe/step_images/step_images_state.dart';
import '../../../generated/i18n.dart';

class Steps extends StatefulWidget {
  final List<TextEditingController> stepsDecriptionController;
  final String editRecipeName;

  Steps(
    this.stepsDecriptionController, {
    this.editRecipeName = 'tmp',
  });

  @override
  State<StatefulWidget> createState() {
    return _StepsState();
  }
}

class _StepsState extends State<Steps> {
  @override
  Widget build(BuildContext context) {
    // Column with all the data of the steps inside like heading, textFields etc.
    return BlocBuilder<StepImagesBloc, StepImagesState>(
        condition: (oldState, newState) {
      if (oldState is LoadedStepImages && newState is LoadedStepImages) {
        if (oldState.stepImages.length > newState.stepImages.length) {
          widget.stepsDecriptionController.removeLast();
        } else if (oldState.stepImages.length < newState.stepImages.length) {
          widget.stepsDecriptionController.add(TextEditingController());
        }
      }
      return true;
    }, builder: (context, state) {
      List<List<String>> stepImages;
      if (state is LoadedStepImages) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // the heading of the Column
            Padding(
              padding: const EdgeInsets.only(left: 56, top: 12, bottom: 12),
              child: Text(
                S.of(context).steps + ':',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ]..addAll(
              // the sections
              List<Widget>.generate(
                stepImages.length,
                (i) => Column(
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
                                  "${i + 1}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
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
                              controller: widget.stepsDecriptionController[i],
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                filled: true,
                                labelText: S.of(context).description,
                              ),
                              minLines: 3,
                              maxLines: 10,
                            ),
                          ),
                        ),
                      ],
                    )
                  ]..add(
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(58.0, 12.0, 12.0, 0),
                          child: Wrap(
                            spacing: 5.0,
                            runSpacing: 3.0,
                            children: List.generate(
                              state.stepImages[i].length,
                              (j) => ImageBox(
                                onPress: () {
                                  BlocProvider.of<StepImagesBloc>(context)
                                      .add(RemoveImage(
                                    state.stepImages[i][j],
                                    i,
                                    widget.editRecipeName == null
                                        ? false
                                        : true,
                                  ));
                                },
                                imagePath: state.stepImages[i][j],
                              ),
                            )..add(
                                AddImageBox(
                                  onNewImage: (File newImage) {
                                    BlocProvider.of<StepImagesBloc>(context)
                                        .add(AddImage(
                                      newImage,
                                      i,
                                      widget.editRecipeName == null
                                          ? false
                                          : true,
                                    ));
                                  },
                                ),
                              ),
                          ),
                        ),
                      ),
                    ),
                ),
              )..add(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      widget.stepsDecriptionController.length > 1
                          ? Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: OutlineButton.icon(
                                icon: Icon(Icons.remove_circle),
                                label: Text(S.of(context).remove_step),
                                onPressed: () {
                                  _removeStep(widget.editRecipeName);
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                              ),
                            )
                          : null,
                      OutlineButton.icon(
                        icon: Icon(Icons.add_circle),
                        label: Text(S.of(context).add_step),
                        onPressed: () {
                          _addStep(widget.editRecipeName);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                    ].where((c) => c != null).toList(),
                  ),
                ),
            ),
        );
      } else {
        return Text('invalid state ${state.toString()}');
      }
    });
  }

  void _addStep(String recipeName) {
    BlocProvider.of<StepImagesBloc>(context).add(AddStep(DateTime.now()));
    // stepDescController will be added in condition in BlocBuilder
  }

  void _removeStep(String recipeName) {
    BlocProvider.of<StepImagesBloc>(context)
        .add(RemoveStep(widget.editRecipeName, DateTime.now()));
    // stepDescController will be removed in condition in BlocBuilder
  }
}

class ImageBox extends StatelessWidget {
  final void Function() onPress;
  final String imagePath;

  const ImageBox({
    @required this.onPress,
    @required this.imagePath,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Container(
          child: Image.asset(
            // widget.stepImages[widget.stepNumber][i],
            imagePath,
            fit: BoxFit.cover,
          ),
          width: 80,
          height: 80,
        ),
      ),
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
            onPress();
          },
        ),
      ),
    ]);
  }
}

class AddImageBox extends StatelessWidget {
  final void Function(File newImage) onNewImage;

  const AddImageBox({
    @required this.onNewImage,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: (() {
            _askUser(context);
          }),
        ),
      ),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(const Radius.circular(7.0)),
        border: Border.all(
          width: 1.5,
          color: Colors.grey,
        ),
      ),
    );
  }

  Future _askUser(BuildContext context) async {
    File newImage = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (newImage != null) {
      onNewImage(newImage);
    }
  }
}

// clips a shape of an octagon
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