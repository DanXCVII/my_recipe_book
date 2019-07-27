import 'package:flutter/material.dart';
import 'package:my_recipe_book/my_wrapper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatefulWidget {
  final MyImageWrapper imageWrapper;
  final double circleSize;
  final Color color;

  ImageSelector(this.imageWrapper, this.circleSize, this.color);

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
          File pictureFile = await ImagePicker.pickImage(
            source: ImageSource.gallery,
            // maxHeight: 50.0,
            // maxWidth: 50.0,
          );
          if (pictureFile != null) {
            widget.imageWrapper.selectedImage = pictureFile.path;
            print("You selected gallery image : " + pictureFile.path);
            setState(() {
              selectedImageFile = pictureFile;
            });
          }
          break;
        }
      case Answers.PHOTO:
        {
          File pictureFile = await ImagePicker.pickImage(
            source: ImageSource.camera,
            //maxHeight: 50.0,
            //maxWidth: 50.0,
          );

          if (pictureFile != null) {
            widget.imageWrapper.selectedImage = pictureFile.path;
            print("You selected gallery image : " + pictureFile.path);
            setState(() {
              selectedImageFile = pictureFile;
            });
          }
          break;
        }
    }
  }
}

enum Answers { GALLERY, PHOTO }
