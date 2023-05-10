import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/new_recipe/clear_recipe/clear_recipe_bloc.dart';
import '../constants/global_constants.dart' as Constants;

class ImageSelector extends StatefulWidget {
  final String prefilledImage;
  final double circleSize;
  final void Function(File imageFile) onNewImage;
  final Color color;
  final Function onCancel;

  ImageSelector({
    required this.prefilledImage,
    required this.onNewImage,
    required this.circleSize,
    required this.color,
    required this.onCancel,
  });

  @override
  createState() {
    return _ImageSelectorState();
  }
}

class _ImageSelectorState extends State<ImageSelector> {
  File? selectedImageFile;

  @override
  void initState() {
    super.initState();
    if (widget.prefilledImage != Constants.noRecipeImage) {
      selectedImageFile = File(widget.prefilledImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.circleSize + 22,
      child: BlocListener<ClearRecipeBloc, ClearRecipeState>(
        listener: (context, state) {
          if (state is ClearedRecipe || state is RemovedRecipeImage) {
            setState(() {
              selectedImageFile = null;
            });
          }
        },
        child: selectedImageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: widget.circleSize,
                    height: widget.circleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color,
                    ),
                    child: Center(
                        child: IconButton(
                      onPressed: () {
                        _askUser();
                      },
                      color: Colors.white,
                      icon: Icon(Icons.add_a_photo),
                      iconSize: widget.circleSize / 3,
                    )),
                  ),
                ],
              )
            : Container(
                width: widget.circleSize + 26,
                child: Center(
                  child: Stack(children: <Widget>[
                    Center(
                      child: ClipOval(
                        child: Container(
                          child: Image.file(
                            // widget.imageWrapper.getSelectedImage(),
                            selectedImageFile!,
                            fit: BoxFit.cover,
                          ),
                          width: widget.circleSize,
                          height: widget.circleSize,
                        ),
                      ),
                    ),
                    Center(
                      child: Opacity(
                        opacity: 0.3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            shape: BoxShape.circle,
                          ),
                          width: widget.circleSize,
                          height: widget.circleSize,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        width: widget.circleSize,
                        height: widget.circleSize,
                        child: IconButton(
                          iconSize: widget.circleSize / 3,
                          icon: Icon(Icons.add_a_photo),
                          color: Colors.white,
                          onPressed: () {
                            _askUser();
                          },
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            size: 26,
                          ),
                          onPressed: () {
                            widget.onCancel();
                          },
                        )),
                  ]),
                ),
              ),
      ),
    );
  }

  Future _askUser() async {
    final _picker = ImagePicker();
    File pictureFile = File((await _picker.pickImage(
      source: ImageSource.gallery,
    ))!
        .path);

    widget.onNewImage(pictureFile);
    setState(() {
      selectedImageFile = pictureFile;
    });
  }
}

enum Answers { GALLERY, PHOTO }
