import "dart:io";

import 'package:collection/collection.dart' show IterableNullableExtension;
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:image_picker/image_picker.dart";
import 'package:my_recipe_book/widgets/dialogs/are_you_sure_dialog.dart';
import 'package:my_recipe_book/widgets/dialogs/textfield_dialog.dart';
import 'package:reorderables/reorderables.dart';

import '../../../blocs/new_recipe/step_images/step_images_bloc.dart';
import '../../../constants/global_constants.dart' as Constants;
import '../../../generated/i18n.dart';

class Steps extends StatefulWidget {
  final String? editRecipeName;

  Steps({
    this.editRecipeName = Constants.newRecipeLocalPathString,
  });

  @override
  State<StatefulWidget> createState() {
    return _StepsState();
  }
}

class _StepsState extends State<Steps> {
  TextEditingController stepsDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Column with all the data of the steps inside like heading, textFields etc.
    return BlocBuilder<StepImagesBloc, StepImagesState>(
        builder: (context, state) {
      if (state is LoadedStepImages) {
        bool editingRecipe =
            widget.editRecipeName == Constants.newRecipeLocalPathString
                ? false
                : true;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // the heading of the Column
            Padding(
              padding: const EdgeInsets.only(left: 56, top: 12, bottom: 12),
              child: Text(
                I18n.of(context)!.steps + ':',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ]
            ..add(
              // the sections
              state.stepImages.every((element) => element.isEmpty)
                  ? ReorderableColumn(
                      scrollController: ScrollController(),
                      onReorder: (i, j) {
                        BlocProvider.of<StepImagesBloc>(context)
                            .add(MoveStep(i, j));
                      },
                      children: List<Widget>.generate(
                        state.steps.length,
                        (i) => Step(
                          i,
                          state.stepTitles[i],
                          state.steps[i],
                          state.stepImages[i],
                          (title) => BlocProvider.of<StepImagesBloc>(context)
                              .add(EditStepTitle(title, i)),
                          (step) => BlocProvider.of<StepImagesBloc>(context)
                              .add(EditStep(step, i)),
                          () => BlocProvider.of<StepImagesBloc>(context).add(
                              RemoveStep(widget.editRecipeName!, DateTime.now(),
                                  stepNumber: i)),
                          true,
                          (File imageFile) =>
                              BlocProvider.of<StepImagesBloc>(context)
                                  .add(AddImage(imageFile, i, editingRecipe)),
                          (index) => BlocProvider.of<StepImagesBloc>(context)
                              .add(RemoveImage(i, index, editingRecipe)),
                          key: state.stepKeys[i],
                        ),
                      ),
                    )
                  : Column(
                      children: List<Widget>.generate(
                        state.steps.length,
                        (i) => Step(
                          i,
                          state.stepTitles[i],
                          state.steps[i],
                          state.stepImages[i],
                          (title) => BlocProvider.of<StepImagesBloc>(context)
                              .add(EditStepTitle(title, i)),
                          (step) => BlocProvider.of<StepImagesBloc>(context)
                              .add(EditStep(step, i)),
                          () => BlocProvider.of<StepImagesBloc>(context).add(
                              RemoveStep(widget.editRecipeName!, DateTime.now(),
                                  stepNumber: i)),
                          false,
                          (File imageFile) =>
                              BlocProvider.of<StepImagesBloc>(context)
                                  .add(AddImage(imageFile, i, editingRecipe)),
                          (index) => BlocProvider.of<StepImagesBloc>(context)
                              .add(RemoveImage(i, index, editingRecipe)),
                          key: state.stepKeys[i],
                        ),
                      ),
                    ),
            )
            ..add(
              Padding(
                padding: const EdgeInsets.fromLTRB(58, 8, 8, 8),
                child: TextFormField(
                  controller: stepsDescriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: I18n.of(context)!.description,
                  ),
                  minLines: 3,
                  maxLines: 10,
                ),
              ),
            )
            ..add(
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    state.steps.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: OutlinedButton.icon(
                              icon: Icon(Icons.remove_circle),
                              label: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(I18n.of(context)!.remove_step(
                                    MediaQuery.of(context).size.width < 412
                                        ? "\n"
                                        : "")),
                              ),
                              onPressed: () {
                                _removeStep(widget.editRecipeName);
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          )
                        : null,
                    OutlinedButton.icon(
                      icon: Icon(Icons.add_circle),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(I18n.of(context)!.add_step(
                            MediaQuery.of(context).size.width < 412
                                ? "\n"
                                : "")),
                      ),
                      onPressed: () {
                        _addStep(widget.editRecipeName);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ].whereType<Widget>().toList(),
                ),
              ),
            ),
        );
      } else {
        return Text('invalid state ${state.toString()}');
      }
    });
  }

  void _addStep(String? recipeName) {
    BlocProvider.of<StepImagesBloc>(context)
        .add(AddStep(stepsDescriptionController.text, DateTime.now()));
    stepsDescriptionController.text = "";
  }

  void _removeStep(String? recipeName) {
    BlocProvider.of<StepImagesBloc>(context)
        .add(RemoveStep(widget.editRecipeName!, DateTime.now()));
  }
}

class ImageBox extends StatelessWidget {
  final void Function() onPress;
  final String imagePath;
  final double size;

  const ImageBox({
    required this.onPress,
    required this.imagePath,
    this.size = 80,
    Key? key,
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

class Step extends StatelessWidget {
  final int stepIndex;
  final String stepTitle;
  final String step;
  final List<String> stepImages;
  final void Function(String title) onEditTitle;
  final void Function(String step) onEditStep;
  final void Function() onRemoveStep;
  final void Function(int index) onRemoveImage;
  final void Function(File image) onAddImage;
  final bool removeOption;

  const Step(
    this.stepIndex,
    this.stepTitle,
    this.step,
    this.stepImages,
    this.onEditTitle,
    this.onEditStep,
    this.onRemoveStep,
    this.removeOption,
    this.onAddImage,
    this.onRemoveImage, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        stepTitle == "" || stepTitle == null
            ? OutlinedButton.icon(
                icon: Icon(Icons.add_circle),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(I18n.of(context)!.add_title),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (cntxt) => TextFieldDialog(
                      validation: (_) => null,
                      save: (String name) {
                        onEditTitle(name);
                      },
                      hintText: I18n.of(context)!.categoryname,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 62.0, right: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 150 > 350
                          ? 350
                          : MediaQuery.of(context).size.width - 150,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (cntxt) => TextFieldDialog(
                              validation: (_) => null,
                              save: (String name) {
                                onEditTitle(name);
                              },
                              prefilledText: stepTitle,
                              hintText: I18n.of(context)!.categoryname,
                            ),
                          );
                        },
                        child: Center(
                          child: Text(
                            stepTitle,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () {
                        onEditTitle("");
                      },
                    ),
                  ],
                ),
              ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => TextFieldDialog(
                validation: (String? name) => null,
                save: (String newStep) {
                  BlocProvider.of<StepImagesBloc>(context)
                      .add(EditStep(newStep, stepIndex));
                },
                prefilledText: step,
                hintText: I18n.of(context)!.categoryname,
                showExpanded: true,
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 17.0),
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF790604),
                      ),
                      child: Center(
                        child: Text(
                          "${stepIndex + 1}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(height: 12),
                  removeOption ? Icon(Icons.reorder) : null,
                ].whereType<Widget>().toList(),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(step),
                ),
              ),
              removeOption
                  ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (cntxt) => AreYouSureDialog(
                            I18n.of(context)!.remove_step("") + "?",
                            I18n.of(context)!.remove_step_desc,
                            () {
                              onRemoveStep();
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    )
                  : null,
            ].whereType<Widget>().toList(),
          ),
        )
      ]..add(
          FractionallySizedBox(
            widthFactor: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(58.0, 12.0, 12.0, 8),
              child: Wrap(
                spacing: 5.0,
                runSpacing: 3.0,
                children: List.generate(
                  stepImages.length,
                  (i) => ImageBox(
                    size: 70,
                    onPress: () {
                      onRemoveImage(i);
                    },
                    imagePath: stepImages[i],
                  ),
                )..add(
                    AddImageBox(
                      size: stepImages.isEmpty ? 40 : 70,
                      iconSize: 20,
                      onNewImage: (File newImage) {
                        onAddImage(newImage);
                      },
                    ),
                  ),
              ),
            ),
          ),
        ),
    );
  }
}

class AddImageBox extends StatelessWidget {
  final void Function(File newImage) onNewImage;
  final double size;
  final double? iconSize;

  const AddImageBox({
    this.size = 80,
    this.iconSize,
    required this.onNewImage,
    Key? key,
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
    final _picker = ImagePicker();
    File newImage = File((await _picker.getImage(
      source: ImageSource.gallery,
    ))!
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
