import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import './add_recipe.dart';
import '../../recipe.dart';
import '../../database.dart';
import '../../my_wrapper.dart';

class CategorySection extends StatefulWidget {
  final MyImageWrapper addCategoryImage;
  final List<String> recipeCategories;

  CategorySection(this.addCategoryImage, this.recipeCategories);

  @override
  State<StatefulWidget> createState() {
    return _CategorySectionState();
  }
}

class _CategorySectionState extends State<CategorySection> {
  TextEditingController categoryNameController;

  @override
  initState() {
    categoryNameController = new TextEditingController();
    super.initState();
  }

  List<Widget> _getCategoryChips() {
    List<Widget> output = new List<Widget>();
    List<String> categoryTitles = Categories.getCategories();

    print(categoryTitles.length);
    for (int i = 0; i < categoryTitles.length; i++) {
      output.add(MyCategoryFilterChip(
        chipName: "${categoryTitles[i]}",
        recipeCategories: widget.recipeCategories,
      ));
    }
    return output;
  }

  Future<void> _saveCategory() async {
    if (Categories.getCategories().contains(categoryNameController.text) ==
        false) {
      String categoryName = categoryNameController.text;
      if (widget.addCategoryImage.getSelectedImage() != null) {
        String imagePath =
            await PathProvider.pP.getCategoryPath(categoryName);
        await saveImage(
            File(widget.addCategoryImage.getSelectedImage()), imagePath, 2000);
      }
      await DBProvider.db.newCategory(categoryName);
      Categories.addCategory(categoryName);
    } else {
      // TODO: when category already exists
    }
  }

  @override
  void dispose() {
    widget.addCategoryImage.setSelectedImage(null);
    categoryNameController.dispose(); // TODO: Remove
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // heading for the subcategory selector section
        Padding(
            padding: const EdgeInsets.only(left: 56, right: 6, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // TODO: Add button to add a new category
                Text(
                  "select subcategories:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey[700]),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text("Add new Category"),
                              contentPadding:
                                  EdgeInsets.fromLTRB(15, 24, 15, 0),
                              content: DialogContent(
                                widget.addCategoryImage,
                                widget.recipeCategories,
                                categoryNameController,
                                MediaQuery.of(context).orientation,
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Dismiss'),
                                  onPressed: () {
                                    Navigator.pop(
                                        context, AnswersCategory.DISMISS);
                                    widget.addCategoryImage
                                        .setSelectedImage(null);
                                  },
                                ),
                                FlatButton(
                                  child: Text('Save'),
                                  onPressed: () {
                                    _saveCategory().then((_) {
                                      Navigator.pop(context);
                                      widget.addCategoryImage
                                          .setSelectedImage(null);
                                      setState(() {}); // TODO: Not working
                                    });
                                  },
                                ),
                              ],
                            ));
                  },
                )
              ],
            )),
        // category chips
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            child: Wrap(
              spacing: 5.0,
              runSpacing: 3.0,
              children: _getCategoryChips(),
            ),
          ),
        ),
      ],
    );
  }
}

enum AnswersCategory { SAVE, DISMISS }

class DialogContent extends StatefulWidget {
  final MyImageWrapper addCategoryImage;
  final TextEditingController categoryNameController;
  final List<String> recipeCategories;
  final Orientation firstOrientation;

  DialogContent(this.addCategoryImage, this.recipeCategories,
      this.categoryNameController, this.firstOrientation);

  @override
  State<StatefulWidget> createState() {
    return _DialogContentState();
  }
}

// TODO: Maybe fix orientation, when in add category screen OR fix crash when changing orientation
class _DialogContentState extends State<DialogContent> {
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
            widget.addCategoryImage.setSelectedImage(pictureFile.path);
            print("You selected gallery image : " + pictureFile.path);
            setState(() {});
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
            widget.addCategoryImage.setSelectedImage(pictureFile.path);
            print("You selected gallery image : " + pictureFile.path);
            setState(() {});
          }
          break;
        }
    }
  }

  @override
  void didUpdateWidget(DialogContent oldWidget) {
    if (oldWidget.firstOrientation != widget.firstOrientation) {
      Navigator.of(context).pop();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Center(
          child: widget.addCategoryImage.getSelectedImage() == null
              ? Container(
                  child: Center(
                      child: IconButton(
                    onPressed: () {
                      _askUser();
                    },
                    color: Colors.white,
                    icon: Icon(Icons.add_a_photo),
                    iconSize: 24,
                  )),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFF790604),
                  ),
                )
              : Stack(children: <Widget>[
                  Container(
                      child: Container(
                    child: Image.asset(
                      widget.addCategoryImage.getSelectedImage(),
                      fit: BoxFit.cover,
                    ),
                    width: 80,
                    height: 80,
                  )),
                  Opacity(
                    opacity: 0.3,
                    child: Container(
                      color: Colors.black87,
                      width: 80,
                      height: 80,
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    child: IconButton(
                      icon: Icon(Icons.add_a_photo),
                      color: Colors.white,
                      onPressed: () {
                        _askUser();
                      },
                    ),
                  ),
                ]),
        ), // TODO: when orientation changes, pop navigator
        SimpleDialogOption(
            child: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: TextFormField(
            controller: widget.categoryNameController,
            autovalidate: true,
            validator: (value) {
              if (Categories.getCategories().contains(value))
                return "category already exists";

              if (value == "") return "field must not be empty";
            },
            decoration: InputDecoration(
              filled: true,
              hintText: "name",
            ),
          ),
        )),
      ],
    );
  }
}

// creates a filterClip with the given name
class MyCategoryFilterChip extends StatefulWidget {
  final String chipName;
  final List<String> recipeCategories;

  MyCategoryFilterChip({Key key, this.chipName, this.recipeCategories});

  @override
  State<StatefulWidget> createState() {
    return _MyCategoryFilterChipState();
  }
}

class _MyCategoryFilterChipState extends State<MyCategoryFilterChip> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();

    widget.recipeCategories.contains(widget.chipName)
        ? _isSelected = true
        : _isSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      selected: _isSelected,
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
          if (isSelected == true) {
            widget.recipeCategories.add(widget.chipName);
          } else {
            widget.recipeCategories.remove(widget.chipName);
          }
        });
      },
    );
  }
}
