import "dart:io";

import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:image_picker/image_picker.dart";
import 'package:my_recipe_book/widgets/dialogs/are_you_sure_dialog.dart';
import 'package:my_recipe_book/widgets/dialogs/textfield_dialog.dart';

import '../../../blocs/new_recipe/step_images/step_images_bloc.dart';
import '../../../constants/global_constants.dart' as Constants;
import '../../../generated/i18n.dart';

class Steps extends StatefulWidget {
  final List<TextEditingController> stepsDescriptionController;
  final List<String> stepTitles;
  final String editRecipeName;

  Steps(
    this.stepsDescriptionController,
    this.stepTitles, {
    this.editRecipeName = Constants.newRecipeLocalPathString,
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
        buildWhen: (oldState, newState) {
      if (oldState is LoadedStepImages && newState is LoadedStepImages) {
        if (oldState.stepImages.length > newState.stepImages.length) {
          if (newState.removedStep != null) {
            widget.stepsDescriptionController.removeAt(newState.removedStep);
            widget.stepTitles.removeAt(newState.removedStep);
          } else {
            widget.stepsDescriptionController.removeLast();
            widget.stepTitles.removeLast();
          }
        } else if (oldState.stepImages.length < newState.stepImages.length &&
            widget.stepsDescriptionController.length <
                newState.stepImages.length) {
          widget.stepsDescriptionController.add(TextEditingController());
          widget.stepTitles.add("");
        }
      }
      return true;
    }, builder: (context, state) {
      if (state is LoadedStepImages) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // the heading of the Column
            Padding(
              padding: const EdgeInsets.only(left: 56, top: 12, bottom: 12),
              child: Text(
                I18n.of(context).steps + ':',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ]..addAll(
              // the sections
              List<Widget>.generate(
                widget.stepsDescriptionController.length,
                (i) => Column(
                  children: <Widget>[
                    widget.stepTitles.isEmpty || widget.stepTitles[i] == ""
                        ? OutlineButton.icon(
                            icon: Icon(Icons.add_circle),
                            label: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(I18n.of(context).add_title),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (cntxt) => TextFieldDialog(
                                  validation: (_) => null,
                                  save: (String name) {
                                    setState(() {
                                      widget.stepTitles[i] = name;
                                    });
                                  },
                                  hintText: I18n.of(context).categoryname,
                                ),
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(left: 62.0, right: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width -
                                              150 >
                                          350
                                      ? 350
                                      : MediaQuery.of(context).size.width - 150,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (cntxt) => TextFieldDialog(
                                          validation: (_) => null,
                                          save: (String name) {
                                            setState(() {
                                              widget.stepTitles[i] = name;
                                            });
                                          },
                                          prefilledText: widget.stepTitles[i],
                                          hintText:
                                              I18n.of(context).categoryname,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      widget.stepTitles[i],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  onPressed: () {
                                    setState(() {
                                      widget.stepTitles[i] = "";
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                    Row(
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 17.0),
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF790604),
                                ),
                                child: Center(
                                  child: Text(
                                    "${i + 1}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            state.stepImages
                                        .every((element) => element.isEmpty) &&
                                    widget.stepsDescriptionController.length > 1
                                ? IconButton(
                                    icon: Icon(Icons.remove_circle),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (cntxt) => AreYouSureDialog(
                                          I18n.of(context).remove_step("") +
                                              "?",
                                          I18n.of(context).remove_step_desc,
                                          () {
                                            BlocProvider.of<StepImagesBloc>(
                                                    context)
                                                .add(
                                              RemoveStep(
                                                widget.editRecipeName,
                                                DateTime.now(),
                                                stepNumber: i,
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    },
                                  )
                                : null,
                          ]..removeWhere((element) => element == null),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, right: 12),
                              child: TextFormField(
                                controller:
                                    widget.stepsDescriptionController[i],
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  filled: true,
                                  labelText: I18n.of(context).description,
                                ),
                                minLines: 3,
                                maxLines: 10,
                              )),
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
                              i > state.stepImages.length - 1
                                  ? 0
                                  : state.stepImages[i].length,
                              (j) => ImageBox(
                                onPress: () {
                                  BlocProvider.of<StepImagesBloc>(context)
                                      .add(RemoveImage(
                                    state.stepImages[i][j],
                                    i,
                                    widget.editRecipeName ==
                                            Constants.newRecipeLocalPathString
                                        ? false
                                        : true,
                                  ));
                                },
                                imagePath: state.stepImages[i][j],
                              ),
                            )..add(
                                AddImageBox(
                                  size: state.stepImages.length > i
                                      ? state.stepImages[i].length > 0
                                          ? 80
                                          : 50
                                      : 50,
                                  iconSize: state.stepImages.length > i
                                      ? state.stepImages[i].length > 0
                                          ? null
                                          : 20
                                      : 20,
                                  onNewImage: (File newImage) {
                                    BlocProvider.of<StepImagesBloc>(context)
                                        .add(AddImage(
                                      newImage,
                                      i,
                                      widget.editRecipeName ==
                                              Constants.newRecipeLocalPathString
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
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        widget.stepsDescriptionController.length > 1
                            ? Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: OutlineButton.icon(
                                  icon: Icon(Icons.remove_circle),
                                  label: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(I18n.of(context).remove_step(
                                        MediaQuery.of(context).size.width < 412
                                            ? "\n"
                                            : "")),
                                  ),
                                  onPressed: () {
                                    _removeStep(widget.editRecipeName);
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              )
                            : null,
                        OutlineButton.icon(
                          icon: Icon(Icons.add_circle),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(I18n.of(context).add_step(
                                MediaQuery.of(context).size.width < 412
                                    ? "\n"
                                    : "")),
                          ),
                          onPressed: () {
                            _addStep(widget.editRecipeName);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ].where((c) => c != null).toList(),
                    ),
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
  final double size;

  const ImageBox({
    @required this.onPress,
    @required this.imagePath,
    this.size = 80,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Container(
          child: Image.file(
            // widget.stepImages[widget.stepNumber][i],
            File(imagePath),
            fit: BoxFit.cover,
          ),
          width: size,
          height: size,
        ),
      ),
      Opacity(
        opacity: 0.3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.black87,
          ),
          width: size,
          height: size,
        ),
      ),
      Container(
        width: size,
        height: size,
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
  final double size;
  final double iconSize;

  const AddImageBox({
    this.size = 80,
    this.iconSize,
    @required this.onNewImage,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: IconButton(
          icon: Icon(
            Icons.add_a_photo,
            size: iconSize,
          ),
          onPressed: (() {
            _askUser(context);
          }),
        ),
      ),
      width: size,
      height: size,
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
    File newImage = File((await ImagePicker().getImage(
      source: ImageSource.gallery,
    ))
        .path);

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
