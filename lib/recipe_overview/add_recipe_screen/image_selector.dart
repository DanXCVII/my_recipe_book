import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../io/io_operations.dart' as IO;
import '../../my_wrapper.dart';

class ImageSelector extends StatefulWidget {
  final MyImageWrapper imageWrapper;
  final double circleSize;
  final Color color;
  final String recipeName;

  ImageSelector({
    @required this.imageWrapper,
    @required this.circleSize,
    @required this.color,
    this.recipeName = 'tmp',
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
    if (widget.imageWrapper.selectedImage != null) {
      selectedImageFile = File(widget.imageWrapper.selectedImage);
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
      await IO.saveRecipeImage(pictureFile, widget.recipeName);

      widget.imageWrapper.selectedImage = pictureFile.path;
      setState(() {
        selectedImageFile = pictureFile;
      });
    }
  }
}

enum Answers { GALLERY, PHOTO }
