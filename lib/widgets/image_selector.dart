import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/global_constants.dart' as Constants;

class ImageSelector extends StatefulWidget {
  final String prefilledImage;
  final double circleSize;
  final void Function(File imageFile) onNewImage;
  final Color color;

  ImageSelector({
    @required this.prefilledImage,
    @required this.onNewImage,
    @required this.circleSize,
    @required this.color,
  });

  @override
  createState() {
    return _ImageSelectorState();
  }
}

class _ImageSelectorState extends State<ImageSelector> {
  File selectedImageFile;

  @override
  void initState() {
    super.initState();
    if (widget.prefilledImage != null &&
        widget.prefilledImage != Constants.noRecipeImage) {
      selectedImageFile = File(widget.prefilledImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return selectedImageFile == null
        ? Container(
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
          )
        : Center(
            child: Stack(children: <Widget>[
              ClipOval(
                child: Container(
                  child: Image.file(
                    // widget.imageWrapper.getSelectedImage(),
                    selectedImageFile,
                    fit: BoxFit.cover,
                  ),
                  width: widget.circleSize,
                  height: widget.circleSize,
                ),
              ),
              Opacity(
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
              Container(
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
            ]),
          );
  }

  Future _askUser() async {
    File pictureFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pictureFile != null) {
      widget.onNewImage(pictureFile);
      setState(() {
        selectedImageFile = pictureFile;
      });
    }
  }
}

enum Answers { GALLERY, PHOTO }
